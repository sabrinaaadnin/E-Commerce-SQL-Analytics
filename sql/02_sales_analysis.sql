-- ============================================================
-- E-Commerce Sales & Customer Analytics
-- File: 02_sales_analysis.sql
-- Purpose: Analyze sales performance, revenue trends, product and
--          country performance, payment methods, and customer reviews.
-- Database: SQLite
-- Source table: ecommerce_orders
-- ============================================================

-- 1. Overall Sales Performance
-- Business question:
-- What are the overall revenue, quantity sold, number of orders,
-- and number of customers in the dataset?
-- Purpose:
-- Establish baseline sales and customer metrics.
SELECT
    SUM(quantity * unit_price) AS total_revenue,
    SUM(quantity) AS total_quantity_sold,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers
FROM ecommerce_orders;

-- 2. Average Order Value (AOV)
-- Business question:
-- How much revenue does an order generate on average?
-- Purpose:
-- Calculate overall revenue per distinct order.
SELECT
    ROUND(
        SUM(quantity * unit_price) * 1.0
        / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM ecommerce_orders;

-- 3. Revenue Breakdown by Order Status
-- Business question:
-- How do order volume and revenue differ across order statuses?
-- Purpose:
-- Compare order counts, revenue, and each status's contribution
-- to total revenue.
SELECT
    order_status,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity * unit_price) AS total_revenue,
    ROUND(
        SUM(quantity * unit_price) * 100.0
        / (SELECT SUM(quantity * unit_price)
           FROM ecommerce_orders),
        2
    ) AS revenue_percentage
FROM ecommerce_orders
GROUP BY order_status
ORDER BY total_revenue DESC;

-- 4. Monthly Revenue Trend
-- Business question:
-- How do revenue and order volume change from month to month?
-- Purpose:
-- Summarize revenue and distinct orders by calendar month.
SELECT
    strftime('%Y-%m', order_date) AS order_month,
    SUM(quantity * unit_price) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders
FROM ecommerce_orders
GROUP BY order_month
ORDER BY order_month;

-- 5. Highest and Lowest Revenue Months
-- Business question:
-- Which months generated the highest and lowest revenue?
-- Purpose:
-- Identify the monthly revenue extremes across the observed period.
WITH monthly_sales AS (
    SELECT
        strftime('%Y-%m', order_date) AS order_month,
        SUM(quantity * unit_price) AS total_revenue
    FROM ecommerce_orders
    GROUP BY order_month
)
SELECT
    order_month,
    total_revenue,
    CASE
        WHEN total_revenue = (SELECT MAX(total_revenue)
                              FROM monthly_sales)
            THEN 'Highest Revenue'
        WHEN total_revenue = (SELECT MIN(total_revenue)
                              FROM monthly_sales)
            THEN 'Lowest Revenue'
    END AS revenue_performance
FROM monthly_sales
WHERE total_revenue = (SELECT MAX(total_revenue)
                       FROM monthly_sales)
   OR total_revenue = (SELECT MIN(total_revenue)
                       FROM monthly_sales)
ORDER BY total_revenue DESC;

-- 6. Month-over-Month (MoM) Revenue Growth
-- Business question:
-- What is the percentage change in revenue compared with the previous month?
-- Purpose:
-- Use LAG() to compare each month's revenue with the preceding month.
WITH monthly_sales AS (
    SELECT
        strftime('%Y-%m', order_date) AS order_month,
        SUM(quantity * unit_price) AS total_revenue
    FROM ecommerce_orders
    GROUP BY order_month
),
revenue_comparison AS (
    SELECT
        order_month,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY order_month
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    order_month,
    total_revenue,
    previous_month_revenue,
    ROUND(
        (total_revenue - previous_month_revenue) * 100.0
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS mom_growth_percentage
FROM revenue_comparison
ORDER BY order_month;

-- 7. Revenue Performance by Product Category
-- Business question:
-- Which product categories contribute the most revenue and units sold?
-- Purpose:
-- Compare category revenue, quantity sold, order volume, and revenue share.
SELECT
    category,
    SUM(quantity * unit_price) AS total_revenue,
    SUM(quantity) AS total_quantity_sold,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(quantity * unit_price) * 100.0
        / (SELECT SUM(quantity * unit_price)
           FROM ecommerce_orders),
        2
    ) AS revenue_percentage
FROM ecommerce_orders
GROUP BY category
ORDER BY total_revenue DESC;

-- 8. Revenue Performance by Country
-- Business question:
-- Which countries generate the most revenue and sales volume?
-- Purpose:
-- Compare revenue, quantity sold, order volume, and revenue share by country.
SELECT
    country,
    SUM(quantity * unit_price) AS total_revenue,
    SUM(quantity) AS total_quantity_sold,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(quantity * unit_price) * 100.0
        / (SELECT SUM(quantity * unit_price)
           FROM ecommerce_orders),
        2
    ) AS revenue_percentage
FROM ecommerce_orders
GROUP BY country
ORDER BY total_revenue DESC;

-- 9. Top 10 Products by Revenue
-- Business question:
-- Which ten products generate the highest total revenue?
-- Purpose:
-- Rank products by revenue and include their category and sales volume.
SELECT
    product_id,
    product_name,
    category,
    SUM(quantity * unit_price) AS total_revenue,
    SUM(quantity) AS total_quantity_sold,
    COUNT(DISTINCT order_id) AS total_orders
FROM ecommerce_orders
GROUP BY
    product_id,
    product_name,
    category
ORDER BY total_revenue DESC
LIMIT 10;

-- 10. Top 10 Customers by Revenue
-- Business question:
-- Which customers contribute the highest total revenue?
-- Purpose:
-- Rank customers by revenue and summarize their order and purchase volume.
SELECT
    customer_id,
    first_name || ' ' || last_name AS customer_name,
    country,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity_purchased,
    SUM(quantity * unit_price) AS total_revenue
FROM ecommerce_orders
GROUP BY
    customer_id,
    first_name,
    last_name,
    country
ORDER BY total_revenue DESC
LIMIT 10;

-- 11. Payment Method Analysis
-- Business question:
-- Which payment methods are used most often, and how much revenue
-- is associated with each method?
-- Purpose:
-- Compare distinct order volume, revenue, and share of all orders by payment method.
SELECT
    payment_method,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity * unit_price) AS total_revenue,
    ROUND(
        COUNT(DISTINCT order_id) * 100.0
        / (SELECT COUNT(DISTINCT order_id)
           FROM ecommerce_orders),
        2
    ) AS order_percentage
FROM ecommerce_orders
GROUP BY payment_method
ORDER BY total_orders DESC;

-- 12. Customer Rating Distribution
-- Business question:
-- How are available customer ratings distributed?
-- Purpose:
-- Count non-null ratings and calculate each rating's share of all available ratings.
SELECT
    rating,
    COUNT(*) AS total_reviews,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM ecommerce_orders
         WHERE rating IS NOT NULL),
        2
    ) AS review_percentage
FROM ecommerce_orders
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY rating DESC;

-- 13. Average Rating by Product Category
-- Business question:
-- Which categories have the highest average customer rating?
-- Purpose:
-- Compare category averages with the overall average rating.
SELECT
    category,
    COUNT(rating) AS total_reviews,
    ROUND(AVG(rating), 2) AS average_rating,
    ROUND(
        AVG(rating) - (
            SELECT AVG(rating)
            FROM ecommerce_orders
            WHERE rating IS NOT NULL
        ),
        2
    ) AS difference_from_overall
FROM ecommerce_orders
WHERE rating IS NOT NULL
GROUP BY category
ORDER BY average_rating DESC;

-- 14. Review Rating Segmentation
-- Business question:
-- What proportion of reviews are low, medium, or high rated?
-- Purpose:
-- Group ratings into interpretable segments and calculate each segment's share.
SELECT
    CASE
        WHEN rating <= 2 THEN 'Low Rating (1-2)'
        WHEN rating = 3 THEN 'Medium Rating (3)'
        WHEN rating >= 4 THEN 'High Rating (4-5)'
    END AS rating_segment,
    COUNT(*) AS total_reviews,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*)
         FROM ecommerce_orders
         WHERE rating IS NOT NULL),
        2
    ) AS review_percentage
FROM ecommerce_orders
WHERE rating IS NOT NULL
GROUP BY rating_segment
ORDER BY
    CASE rating_segment
        WHEN 'High Rating (4-5)' THEN 1
        WHEN 'Medium Rating (3)' THEN 2
        WHEN 'Low Rating (1-2)' THEN 3
    END;

-- 15. Sample Low-Rating Customer Reviews
-- Business question:
-- What written feedback is available for low-rated products?
-- Purpose:
-- Inspect a sample of reviews with ratings of 1 or 2 for potential issues.
SELECT
    product_name,
    category,
    rating,
    review_text,
    review_date
FROM ecommerce_orders
WHERE rating <= 2
  AND review_text IS NOT NULL
  AND TRIM(review_text) <> ''
ORDER BY rating ASC, review_date DESC
LIMIT 20;

-- 16. Rating and Review Text Check
-- Business question:
-- Which rating and review-text combinations appear most frequently?
-- Purpose:
-- Inspect repeated rating-text combinations as a preliminary consistency check.
-- Note: Repeated text alone does not prove that a review is invalid or duplicated.
SELECT
    rating,
    review_text,
    COUNT(*) AS total_reviews
FROM ecommerce_orders
WHERE rating IS NOT NULL
  AND review_text IS NOT NULL
  AND TRIM(review_text) <> ''
GROUP BY rating, review_text
ORDER BY rating ASC, total_reviews DESC
LIMIT 30;

-- 17. Annual Revenue Performance
-- Business question:
-- How do revenue, order volume, and average order value vary by year?
-- Purpose:
-- Compare annual sales performance using consistent metrics.
SELECT
    strftime('%Y', order_date) AS order_year,
    SUM(quantity * unit_price) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(quantity * unit_price) * 1.0
        / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM ecommerce_orders
GROUP BY order_year
ORDER BY order_year;

-- 18. Year-over-Year (YoY) Revenue Growth
-- Business question:
-- What is the percentage change in revenue compared with the previous year?
-- Purpose:
-- Use LAG() to compare each year's revenue with the preceding year.
WITH annual_sales AS (
    SELECT
        strftime('%Y', order_date) AS order_year,
        SUM(quantity * unit_price) AS total_revenue
    FROM ecommerce_orders
    GROUP BY order_year
),
revenue_growth AS (
    SELECT
        order_year,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY order_year
        ) AS previous_year_revenue
    FROM annual_sales
)
SELECT
    order_year,
    total_revenue,
    previous_year_revenue,
    ROUND(
        (total_revenue - previous_year_revenue) * 100.0
        / NULLIF(previous_year_revenue, 0),
        2
    ) AS yoy_growth_percentage
FROM revenue_growth
ORDER BY order_year;

-- 19. Top 5 Months by Revenue Growth
-- Business question:
-- Which months recorded the strongest positive month-over-month revenue growth?
-- Purpose:
-- Rank months by percentage revenue growth compared with the previous month.
WITH monthly_sales AS (
    SELECT
        strftime('%Y-%m', order_date) AS order_month,
        SUM(quantity * unit_price) AS total_revenue
    FROM ecommerce_orders
    GROUP BY order_month
),
revenue_growth AS (
    SELECT
        order_month,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY order_month
        ) AS previous_month_revenue
    FROM monthly_sales
),
monthly_growth AS (
    SELECT
        order_month,
        total_revenue,
        previous_month_revenue,
        ROUND(
            (total_revenue - previous_month_revenue) * 100.0
            / NULLIF(previous_month_revenue, 0),
            2
        ) AS mom_growth_percentage
    FROM revenue_growth
)
SELECT *
FROM monthly_growth
WHERE mom_growth_percentage IS NOT NULL
ORDER BY mom_growth_percentage DESC
LIMIT 5;

-- 20. Top 5 Months by Revenue Decline
-- Business question:
-- Which months recorded the steepest month-over-month revenue declines?
-- Purpose:
-- Identify the five largest negative percentage changes in monthly revenue.
WITH monthly_sales AS (
    SELECT
        strftime('%Y-%m', order_date) AS order_month,
        SUM(quantity * unit_price) AS total_revenue
    FROM ecommerce_orders
    GROUP BY order_month
),
revenue_growth AS (
    SELECT
        order_month,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY order_month
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    order_month,
    total_revenue,
    previous_month_revenue,
    ROUND(
        (total_revenue - previous_month_revenue) * 100.0
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS mom_growth_percentage
FROM revenue_growth
WHERE previous_month_revenue IS NOT NULL
ORDER BY mom_growth_percentage ASC
LIMIT 5;

-- 21. Monthly Sales Performance Summary
-- Business question:
-- What are the monthly revenue, order volume, units sold, and AOV?
-- Purpose:
-- Provide a consolidated monthly sales summary for further analysis.
SELECT
    strftime('%Y-%m', order_date) AS order_month,
    SUM(quantity * unit_price) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity_sold,
    ROUND(
        SUM(quantity * unit_price) * 1.0
        / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM ecommerce_orders
GROUP BY order_month
ORDER BY order_month;

-- 22. Top 10 Products by Quantity Sold
-- Business question:
-- Which ten products have the highest sales quantity?
-- Purpose:
-- Rank products by units sold and show their revenue for comparison.
SELECT
    product_id,
    product_name,
    category,
    SUM(quantity) AS total_quantity_sold,
    SUM(quantity * unit_price) AS total_revenue
FROM ecommerce_orders
GROUP BY
    product_id,
    product_name,
    category
ORDER BY total_quantity_sold DESC
LIMIT 10;

-- 23. Revenue per Unit by Product
-- Business question:
-- Which products generate the highest revenue per unit sold?
-- Purpose:
-- Calculate revenue divided by quantity for each product.
-- Note: This is average realized revenue per unit, not profit or margin.
SELECT
    product_id,
    product_name,
    category,
    SUM(quantity) AS total_quantity_sold,
    SUM(quantity * unit_price) AS total_revenue,
    ROUND(
        SUM(quantity * unit_price) * 1.0
        / NULLIF(SUM(quantity), 0),
        2
    ) AS revenue_per_unit
FROM ecommerce_orders
GROUP BY
    product_id,
    product_name,
    category
ORDER BY revenue_per_unit DESC
LIMIT 10;

-- 24. Customer Purchase Frequency
-- Business question:
-- Which customers place the most orders?
-- Purpose:
-- Rank customers by distinct order count, using revenue as a tie-breaker.
SELECT
    customer_id,
    first_name || ' ' || last_name AS customer_name,
    country,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity_purchased,
    SUM(quantity * unit_price) AS total_revenue
FROM ecommerce_orders
GROUP BY
    customer_id,
    first_name,
    last_name,
    country
ORDER BY total_orders DESC, total_revenue DESC
LIMIT 10;

-- 25. Customer Average Order Value
-- Business question:
-- Which customers have the highest average revenue per order?
-- Purpose:
-- Rank customers by their individual average order value.
SELECT
    customer_id,
    first_name || ' ' || last_name AS customer_name,
    country,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity * unit_price) AS total_revenue,
    ROUND(
        SUM(quantity * unit_price) * 1.0
        / NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS average_order_value
FROM ecommerce_orders
GROUP BY
    customer_id,
    first_name,
    last_name,
    country
ORDER BY average_order_value DESC
LIMIT 10;

-- 26. Highest-Value Customers with Purchase Frequency
-- Business question:
-- Which customers combine high total revenue with frequent ordering?
-- Purpose:
-- Rank customers by revenue, using order frequency as a secondary criterion.
SELECT
    customer_id,
    first_name || ' ' || last_name AS customer_name,
    country,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity * unit_price) AS total_revenue,
    ROUND(
        SUM(quantity * unit_price) * 1.0
        / NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS average_order_value
FROM ecommerce_orders
GROUP BY
    customer_id,
    first_name,
    last_name,
    country
ORDER BY
    total_revenue DESC,
    total_orders DESC
LIMIT 10;

-- 27. Revenue and Customer Distribution by Country
-- Business question:
-- How do customer count, order volume, revenue, and revenue per customer
-- vary across countries?
-- Purpose:
-- Provide a broad country-level performance comparison.
SELECT
    country,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity * unit_price) AS total_revenue,
    ROUND(
        SUM(quantity * unit_price) * 1.0
        / NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS revenue_per_customer
FROM ecommerce_orders
GROUP BY country
ORDER BY total_revenue DESC;

-- 28. Country Ranking by Revenue per Customer
-- Business question:
-- Which countries generate the highest revenue per distinct customer?
-- Purpose:
-- Rank countries by revenue per customer rather than total revenue.
SELECT
    country,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(quantity * unit_price) AS total_revenue,
    ROUND(
        SUM(quantity * unit_price) * 1.0
        / NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS revenue_per_customer
FROM ecommerce_orders
GROUP BY country
ORDER BY revenue_per_customer DESC;

-- 29. Revenue by Country and Product Category
-- Business question:
-- How does each product category contribute to revenue within each country?
-- Purpose:
-- Compare category revenue and category share of each country's revenue.
SELECT
    country,
    category,
    SUM(quantity * unit_price) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(quantity * unit_price) * 100.0
        / SUM(SUM(quantity * unit_price)) OVER (
            PARTITION BY country
        ),
        2
    ) AS category_revenue_percentage
FROM ecommerce_orders
GROUP BY country, category
ORDER BY country, total_revenue DESC;

-- 30. Top Product Category in Each Country
-- Business question:
-- Which product category generates the most revenue in each country?
-- Purpose:
-- Rank categories within each country and return the leading category.
WITH category_revenue AS (
    SELECT
        country,
        category,
        SUM(quantity * unit_price) AS total_revenue,
        ROUND(
            SUM(quantity * unit_price) * 100.0
            / SUM(SUM(quantity * unit_price)) OVER (
                PARTITION BY country
            ),
            2
        ) AS revenue_percentage
    FROM ecommerce_orders
    GROUP BY country, category
),
ranked_categories AS (
    SELECT
        country,
        category,
        total_revenue,
        revenue_percentage,
        ROW_NUMBER() OVER (
            PARTITION BY country
            ORDER BY total_revenue DESC
        ) AS category_rank
    FROM category_revenue
)
SELECT
    country,
    category,
    total_revenue,
    revenue_percentage
FROM ranked_categories
WHERE category_rank = 1
ORDER BY total_revenue DESC;