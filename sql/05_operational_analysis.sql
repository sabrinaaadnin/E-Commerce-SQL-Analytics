-- ============================================================
-- PROJECT: E-Commerce SQL Analytics
-- FILE: 05_operational_analysis.sql
-- DATABASE: SQLite / DB Browser for SQLite
-- TABLE: ecommerce_orders
-- PURPOSE:
-- Analyze order operations and potential friction points without
-- repeating the overall sales, product, or customer analyses.
-- ============================================================


-- ------------------------------------------------------------
-- QUERY 1: Monthly Order Status Trend
-- Business Question:
-- How does the composition of order statuses change over time?
-- Purpose:
-- Track monthly counts and percentages of each status to identify
-- periods with unusual increases in cancellations, returns, or pending orders.
-- ------------------------------------------------------------
WITH monthly_status AS (
    SELECT
        strftime('%Y-%m', date(order_date)) AS order_month,
        order_status,
        COUNT(*) AS transaction_count
    FROM ecommerce_orders
    WHERE order_date IS NOT NULL
    GROUP BY strftime('%Y-%m', date(order_date)), order_status
)
SELECT
    order_month,
    order_status,
    transaction_count,
    ROUND(
        100.0 * transaction_count
        / SUM(transaction_count) OVER (PARTITION BY order_month),
        2
    ) AS status_percentage
FROM monthly_status
ORDER BY order_month, transaction_count DESC;


-- ------------------------------------------------------------
-- QUERY 2: Cancellation and Return Rate by Payment Method
-- Business Question:
-- Do cancellation and return rates differ across payment methods?
-- Purpose:
-- Compare operational issue rates by payment method. Rates are based
-- on the number of transactions within each payment method.
-- ------------------------------------------------------------
SELECT
    payment_method,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END)
        AS cancelled_transactions,
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS cancellation_rate_pct,
    SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END)
        AS returned_transactions,
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS return_rate_pct
FROM ecommerce_orders
GROUP BY payment_method
ORDER BY cancellation_rate_pct DESC, return_rate_pct DESC;


-- ------------------------------------------------------------
-- QUERY 3: Cancellation and Return Rate by Product Category
-- Business Question:
-- Which product categories have the highest cancellation or return rates?
-- Purpose:
-- Identify categories that may warrant further investigation.
-- This measures transaction rates, not revenue contribution.
-- ------------------------------------------------------------
SELECT
    category,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END)
        AS cancelled_transactions,
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS cancellation_rate_pct,
    SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END)
        AS returned_transactions,
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS return_rate_pct
FROM ecommerce_orders
GROUP BY category
ORDER BY cancellation_rate_pct DESC, return_rate_pct DESC;


-- ------------------------------------------------------------
-- QUERY 4: Cancellation and Return Rate by Country
-- Business Question:
-- Are cancellation and return rates concentrated in particular countries?
-- Purpose:
-- Compare the share of cancelled and returned transactions across countries
-- to highlight locations for deeper operational review.
-- ------------------------------------------------------------
SELECT
    country,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END)
        AS cancelled_transactions,
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS cancellation_rate_pct,
    SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END)
        AS returned_transactions,
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS return_rate_pct
FROM ecommerce_orders
GROUP BY country
ORDER BY cancellation_rate_pct DESC, return_rate_pct DESC;


-- ------------------------------------------------------------
-- QUERY 5: Review Availability by Order Status
-- Business Question:
-- Does the availability of customer ratings and written reviews vary by status?
-- Purpose:
-- Compare the proportion of transactions with a rating and with review text
-- for each order status. This describes review availability; it does not
-- establish that order status caused customers to leave reviews.
-- ------------------------------------------------------------
SELECT
    order_status,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN rating IS NOT NULL THEN 1 ELSE 0 END)
        AS transactions_with_rating,
    ROUND(
        100.0 * SUM(CASE WHEN rating IS NOT NULL THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS rating_availability_pct,
    SUM(
        CASE
            WHEN review_text IS NOT NULL
             AND TRIM(review_text) <> ''
            THEN 1 ELSE 0
        END
    ) AS transactions_with_review_text,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN review_text IS NOT NULL
                 AND TRIM(review_text) <> ''
                THEN 1 ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS review_text_availability_pct
FROM ecommerce_orders
GROUP BY order_status
ORDER BY total_transactions DESC;


-- ------------------------------------------------------------
-- QUERY 6: Order-to-Review Time Lag
-- Business Question:
-- How long after an order date is a review recorded?
-- Purpose:
-- Summarize the time gap between order_date and review_date for records
-- with valid dates, including median-like quartile groups. This can help
-- describe review timing, but should be interpreted cautiously because
-- the dataset may not document the exact review-collection process.
-- ------------------------------------------------------------
WITH review_lag AS (
    SELECT
        order_id,
        order_status,
        date(order_date) AS order_date_clean,
        date(review_date) AS review_date_clean,
        CAST(
            julianday(date(review_date)) - julianday(date(order_date))
            AS INTEGER
        ) AS days_to_review
    FROM ecommerce_orders
    WHERE order_date IS NOT NULL
      AND review_date IS NOT NULL
      AND date(order_date) IS NOT NULL
      AND date(review_date) IS NOT NULL
)
SELECT
    order_status,
    COUNT(*) AS records_with_both_dates,
    ROUND(AVG(days_to_review), 2) AS average_days_to_review,
    MIN(days_to_review) AS minimum_days_to_review,
    MAX(days_to_review) AS maximum_days_to_review,
    SUM(CASE WHEN days_to_review < 0 THEN 1 ELSE 0 END)
        AS reviews_before_order_date
FROM review_lag
GROUP BY order_status
ORDER BY average_days_to_review;
