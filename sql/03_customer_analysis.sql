-- ============================================================
-- E-Commerce Sales & Customer Analytics
-- File: 03_customer_analysis.sql
-- Purpose: Analyze repeat purchasing, customer retention,
--          customer cohorts, and customer-value segments.
-- Database: SQLite
-- Source table: ecommerce_orders
-- ============================================================


-- 1. Repeat-purchase behavior
-- Business question:
-- How many customers purchase once versus more than once?
-- Note: Each order_id was checked and appears once in this dataset.
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(quantity * unit_price) AS total_revenue
    FROM ecommerce_orders
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-time customer'
        ELSE 'Repeat customer'
    END AS customer_type,
    COUNT(*) AS total_customers,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customer_orders),
        2
    ) AS customer_percentage,
    SUM(total_orders) AS total_orders,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(
        SUM(total_revenue) * 100.0
        / (SELECT SUM(total_revenue) FROM customer_orders),
        2
    ) AS revenue_percentage
FROM customer_orders
GROUP BY customer_type
ORDER BY total_customers DESC;


-- 2. Monthly new versus returning customers
-- Business question:
-- How does the number of new and returning customers change over time?
-- A returning customer is someone whose first purchase occurred before
-- the month being analyzed and who also purchased in that month.
WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(date(order_date)) AS first_order_date,
        strftime('%Y-%m', MIN(date(order_date))) AS first_order_month
    FROM ecommerce_orders
    WHERE customer_id IS NOT NULL
      AND order_date IS NOT NULL
    GROUP BY customer_id
),
customer_months AS (
    SELECT DISTINCT
        customer_id,
        strftime('%Y-%m', date(order_date)) AS order_month
    FROM ecommerce_orders
    WHERE customer_id IS NOT NULL
      AND order_date IS NOT NULL
)
SELECT
    cm.order_month,
    COUNT(DISTINCT cm.customer_id) AS active_customers,
    COUNT(DISTINCT CASE
        WHEN cm.order_month = cfp.first_order_month
        THEN cm.customer_id
    END) AS new_customers,
    COUNT(DISTINCT CASE
        WHEN cm.order_month > cfp.first_order_month
        THEN cm.customer_id
    END) AS returning_customers,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN cm.order_month > cfp.first_order_month
            THEN cm.customer_id
        END) * 100.0
        / NULLIF(COUNT(DISTINCT cm.customer_id), 0),
        2
    ) AS returning_customer_percentage
FROM customer_months AS cm
JOIN customer_first_purchase AS cfp
    ON cm.customer_id = cfp.customer_id
GROUP BY cm.order_month
ORDER BY cm.order_month;


-- 3. Customer cohort retention
-- Business question:
-- Of customers acquired in a given month, what percentage purchased
-- again in each subsequent month?
-- Month 0 is the acquisition month; retention in month 0 is 100%.
WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(date(order_date)) AS first_order_date,
        date(
            strftime('%Y-%m-01', MIN(date(order_date)))
        ) AS cohort_month
    FROM ecommerce_orders
    WHERE customer_id IS NOT NULL
      AND order_date IS NOT NULL
    GROUP BY customer_id
),
customer_activity AS (
    SELECT DISTINCT
        customer_id,
        date(strftime('%Y-%m-01', date(order_date))) AS activity_month
    FROM ecommerce_orders
    WHERE customer_id IS NOT NULL
      AND order_date IS NOT NULL
),
cohort_activity AS (
    SELECT
        cfp.cohort_month,
        ca.activity_month,
        CAST(
            (CAST(strftime('%Y', ca.activity_month) AS INTEGER)
             - CAST(strftime('%Y', cfp.cohort_month) AS INTEGER)) * 12
            + (CAST(strftime('%m', ca.activity_month) AS INTEGER)
             - CAST(strftime('%m', cfp.cohort_month) AS INTEGER))
            AS INTEGER
        ) AS months_since_first_purchase,
        ca.customer_id
    FROM customer_activity AS ca
    JOIN customer_first_purchase AS cfp
        ON ca.customer_id = cfp.customer_id
    WHERE ca.activity_month >= cfp.cohort_month
),
cohort_sizes AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_id) AS cohort_size
    FROM customer_first_purchase
    GROUP BY cohort_month
)
SELECT
    ca.cohort_month,
    ca.months_since_first_purchase,
    cs.cohort_size,
    COUNT(DISTINCT ca.customer_id) AS retained_customers,
    ROUND(
        COUNT(DISTINCT ca.customer_id) * 100.0
        / NULLIF(cs.cohort_size, 0),
        2
    ) AS retention_percentage
FROM cohort_activity AS ca
JOIN cohort_sizes AS cs
    ON ca.cohort_month = cs.cohort_month
GROUP BY
    ca.cohort_month,
    ca.months_since_first_purchase,
    cs.cohort_size
ORDER BY
    ca.cohort_month,
    ca.months_since_first_purchase;


-- 4. Recency, frequency, and monetary (RFM) customer segmentation
-- Business question:
-- Which customers are most recently active, purchase most frequently,
-- and contribute the most revenue?
-- Recency is measured against the latest order date in the dataset.
-- RFM scores use NTILE(4); a score of 4 is the most favorable for each
-- metric after accounting for recency's inverse direction.
WITH customer_rfm AS (
    SELECT
        customer_id,
        MIN(first_name || ' ' || last_name) AS customer_name,
        MIN(country) AS country,
        MAX(date(order_date)) AS last_order_date,
        COUNT(DISTINCT order_id) AS frequency,
        SUM(quantity * unit_price) AS monetary_value,
        CAST(
            julianday((SELECT MAX(date(order_date))
                       FROM ecommerce_orders))
            - julianday(MAX(date(order_date)))
            AS INTEGER
        ) AS recency_days
    FROM ecommerce_orders
    WHERE customer_id IS NOT NULL
      AND order_date IS NOT NULL
    GROUP BY customer_id
),
rfm_scores AS (
    SELECT
        *,
        NTILE(4) OVER (ORDER BY recency_days DESC) AS recency_score,
        NTILE(4) OVER (ORDER BY frequency ASC) AS frequency_score,
        NTILE(4) OVER (ORDER BY monetary_value ASC) AS monetary_score
    FROM customer_rfm
)
SELECT
    customer_id,
    customer_name,
    country,
    last_order_date,
    recency_days,
    frequency,
    ROUND(monetary_value, 2) AS monetary_value,
    recency_score,
    frequency_score,
    monetary_score,
    recency_score + frequency_score + monetary_score AS rfm_total_score,
    CASE
        WHEN recency_score >= 3
         AND frequency_score >= 3
         AND monetary_score >= 3
            THEN 'High-value active customer'
        WHEN recency_score >= 3
         AND frequency_score >= 3
            THEN 'Loyal active customer'
        WHEN recency_score <= 2
         AND frequency_score >= 3
            THEN 'Previously frequent customer'
        WHEN recency_score >= 3
         AND frequency_score <= 2
            THEN 'Recently acquired or occasional customer'
        ELSE 'Needs further engagement'
    END AS customer_segment
FROM rfm_scores
ORDER BY rfm_total_score DESC, monetary_value DESC;


-- 5. Time between purchases for repeat customers
-- Business question:
-- How long does it typically take repeat customers to place another order?
-- Customers with only one order are excluded.
WITH customer_order_dates AS (
    SELECT DISTINCT
        customer_id,
        date(order_date) AS order_date
    FROM ecommerce_orders
    WHERE customer_id IS NOT NULL
      AND order_date IS NOT NULL
),
purchase_gaps AS (
    SELECT
        customer_id,
        order_date,
        julianday(order_date)
          - julianday(LAG(order_date) OVER (
                PARTITION BY customer_id
                ORDER BY order_date
            )) AS days_since_previous_order
    FROM customer_order_dates
),
customer_gap_summary AS (
    SELECT
        customer_id,
        COUNT(days_since_previous_order) AS repeat_purchase_intervals,
        AVG(days_since_previous_order) AS average_days_between_orders,
        MIN(days_since_previous_order) AS shortest_days_between_orders,
        MAX(days_since_previous_order) AS longest_days_between_orders
    FROM purchase_gaps
    WHERE days_since_previous_order IS NOT NULL
    GROUP BY customer_id
)
SELECT
    COUNT(*) AS repeat_customers_with_intervals,
    ROUND(AVG(average_days_between_orders), 2)
        AS average_customer_purchase_interval_days,
    ROUND(AVG(shortest_days_between_orders), 2)
        AS average_shortest_interval_days,
    ROUND(AVG(longest_days_between_orders), 2)
        AS average_longest_interval_days
FROM customer_gap_summary;


-- 6. Customer revenue segments using quartiles
-- Business question:
-- How is revenue distributed across customers with different lifetime
-- spending levels? This uses relative quartiles rather than arbitrary
-- fixed currency thresholds.
WITH customer_spending AS (
    SELECT
        customer_id,
        SUM(quantity * unit_price) AS total_revenue,
        COUNT(DISTINCT order_id) AS total_orders
    FROM ecommerce_orders
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
),
customer_quartiles AS (
    SELECT
        *,
        NTILE(4) OVER (ORDER BY total_revenue) AS revenue_quartile
    FROM customer_spending
)
SELECT
    CASE revenue_quartile
        WHEN 1 THEN 'Q1 - Lowest spending'
        WHEN 2 THEN 'Q2 - Lower-middle spending'
        WHEN 3 THEN 'Q3 - Upper-middle spending'
        WHEN 4 THEN 'Q4 - Highest spending'
    END AS customer_spending_segment,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(
        SUM(total_revenue) * 100.0
        / (SELECT SUM(total_revenue) FROM customer_spending),
        2
    ) AS revenue_percentage,
    ROUND(AVG(total_revenue), 2) AS average_revenue_per_customer,
    ROUND(AVG(total_orders), 2) AS average_orders_per_customer
FROM customer_quartiles
GROUP BY revenue_quartile
ORDER BY revenue_quartile;


-- 7. Customer acquisition by first-purchase cohort
-- Business question:
-- How many new customers were acquired each month, and what revenue
-- did those customers generate during their acquisition month?
-- This is acquisition-month revenue, not lifetime revenue.
WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(date(order_date)) AS first_order_date,
        strftime('%Y-%m', MIN(date(order_date))) AS acquisition_month
    FROM ecommerce_orders
    WHERE customer_id IS NOT NULL
      AND order_date IS NOT NULL
    GROUP BY customer_id
),
acquisition_month_orders AS (
    SELECT
        e.customer_id,
        cfp.acquisition_month,
        e.order_id,
        e.quantity * e.unit_price AS line_revenue
    FROM ecommerce_orders AS e
    JOIN customer_first_purchase AS cfp
        ON e.customer_id = cfp.customer_id
       AND date(e.order_date) = cfp.first_order_date
)
SELECT
    acquisition_month,
    COUNT(DISTINCT customer_id) AS new_customers,
    COUNT(DISTINCT order_id) AS orders_on_first_purchase_date,
    ROUND(SUM(line_revenue), 2) AS acquisition_date_revenue,
    ROUND(
        SUM(line_revenue) * 1.0
        / NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS acquisition_date_revenue_per_new_customer
FROM acquisition_month_orders
GROUP BY acquisition_month
ORDER BY acquisition_month;


-- 8. Customer status snapshot
-- Business question:
-- Based on the dataset's latest order date, how many customers are
-- recently active, moderately inactive, or long inactive?
-- These are descriptive recency bands, not validated churn predictions.
WITH customer_last_order AS (
    SELECT
        customer_id,
        MAX(date(order_date)) AS last_order_date,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(quantity * unit_price) AS total_revenue
    FROM ecommerce_orders
    WHERE customer_id IS NOT NULL
      AND order_date IS NOT NULL
    GROUP BY customer_id
),
customer_recency AS (
    SELECT
        *,
        CAST(
            julianday((SELECT MAX(date(order_date))
                       FROM ecommerce_orders))
            - julianday(last_order_date)
            AS INTEGER
        ) AS recency_days
    FROM customer_last_order
)
SELECT
    CASE
        WHEN recency_days <= 30 THEN 'Active in last 30 days'
        WHEN recency_days <= 90 THEN 'Inactive for 31-90 days'
        ELSE 'Inactive for over 90 days'
    END AS customer_recency_status,
    COUNT(*) AS total_customers,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customer_recency),
        2
    ) AS customer_percentage,
    ROUND(SUM(total_revenue), 2) AS historical_revenue,
    ROUND(AVG(total_orders), 2) AS average_orders_per_customer
FROM customer_recency
GROUP BY customer_recency_status
ORDER BY
    CASE customer_recency_status
        WHEN 'Active in last 30 days' THEN 1
        WHEN 'Inactive for 31-90 days' THEN 2
        WHEN 'Inactive for over 90 days' THEN 3
    END;
