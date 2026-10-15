-- ============================================================
-- E-Commerce Sales & Customer Analytics
-- File: 01_data_exploration.sql
-- Purpose: Explore the dataset structure and assess basic data
--          quality before performing business analysis.
-- Database: SQLite
-- Source table: ecommerce_orders
-- ============================================================

-- 1. Total Record Count
-- Business question:
-- How many records are available in the dataset?
-- Purpose:
-- Establish the size of the dataset before further analysis.
SELECT COUNT(*) AS total_rows
FROM ecommerce_orders;

-- 2. Sample Data Preview
-- Business question:
-- What does a typical record in the dataset look like?
-- Purpose:
-- Inspect sample rows and understand the available columns and values.
SELECT *
FROM ecommerce_orders
LIMIT 10;

-- 3. Missing-Value Check
-- Business question:
-- Are key fields populated across the dataset?
-- Purpose:
-- Count non-null values in important identifier, date, and transaction
-- columns. A lower filled count than total_rows indicates missing values.
SELECT
    COUNT(*) AS total_rows,
    COUNT(customer_id) AS customer_id_filled,
    COUNT(product_id) AS product_id_filled,
    COUNT(order_id) AS order_id_filled,
    COUNT(order_date) AS order_date_filled,
    COUNT(unit_price) AS unit_price_filled,
    COUNT(quantity) AS quantity_filled
FROM ecommerce_orders;

-- 4. Duplicate Order ID Check
-- Business question:
-- Does any order_id appear more than once in the dataset?
-- Purpose:
-- Identify repeated order IDs for data-quality review. Repeated IDs are
-- not automatically errors in every e-commerce schema, but this dataset
-- has been checked and each order_id is expected to appear once.
SELECT
    order_id,
    COUNT(*) AS order_count
FROM ecommerce_orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- 5. Order Date Range
-- Business question:
-- What are the earliest and latest order dates in the dataset?
-- Purpose:
-- Establish the time period covered by the data.
SELECT
    MIN(order_date) AS earliest_order_date,
    MAX(order_date) AS latest_order_date
FROM ecommerce_orders;

-- 6. Order Distribution by Year
-- Business question:
-- How many records are present for each calendar year?
-- Purpose:
-- Understand the annual distribution of records as an initial view
-- of the dataset's time coverage.
SELECT
    strftime('%Y', order_date) AS order_year,
    COUNT(*) AS total_orders
FROM ecommerce_orders
GROUP BY order_year
ORDER BY order_year;

-- 7. Order Status Distribution with Percentage
-- Business question:
-- What percentage of all records belongs to each order status?
-- Purpose:
-- Show both status volume and its share of the full dataset.
-- Note: This percentage is based on row counts, not distinct order IDs.
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ecommerce_orders),
        2
    ) AS order_percentage
FROM ecommerce_orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- 8. Record Distribution by Product Category
-- Business question:
-- How many records are associated with each product category?
-- Purpose:
-- Identify which categories appear most frequently in the dataset.
SELECT
    category,
    COUNT(*) AS total_orders
FROM ecommerce_orders
GROUP BY category
ORDER BY total_orders DESC;

-- 9. Record Distribution by Country
-- Business question:
-- How many records are associated with each country?
-- Purpose:
-- Understand how records are distributed geographically.
SELECT
    country,
    COUNT(*) AS total_orders
FROM ecommerce_orders
GROUP BY country
ORDER BY total_orders DESC;