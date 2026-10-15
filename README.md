# E-Commerce SQL Analytics

## Project Overview
This project explores e-commerce transaction data using SQL to identify sales performance, customer purchasing behavior, and operational patterns. The analysis aims to translate transactional data into actionable business insights.

## Objectives
- Analyze overall sales performance and revenue trends.
- Identify top-performing products and categories.
- Understand customer purchasing behavior and value.
- Evaluate order status patterns and operational indicators.
- Develop data-driven insights to support business decisions.

## Dataset
This project uses an e-commerce dataset containing 10,000 transactions across multiple customers, products, categories, and countries.

**Dataset Source:** [E-Commerce Dataset for SQL Analysis — Kaggle](https://www.kaggle.com/datasets/nabihazahid/ecommerce-dataset-for-sql-analysis)

The dataset is used to explore sales performance, customer purchasing behavior, and order operations through SQL queries.

Please refer to the original Kaggle page for dataset details and licensing information.

## Tools
- SQLite
- DB Browser for SQLite
- SQL

## Project Structure
- `data/` — Source dataset
- `database/` — SQLite database
- `sql/` — SQL scripts for analysis
- `report/` — Business insights and supporting reports

## SQL Analysis
1. Data Exploration
2. Sales Analysis
3. Customer Analysis
4. Advanced Business Analysis
5. Operational Analysis

## Key Findings
Based on the SQL analysis, the following key findings were identified:

- **Revenue Concentration:** Electronics accounted for 60.80% of total calculated revenue, while the iPhone 14 and Samsung Galaxy S23 together contributed 49.15%.
- **Customer Retention:** Repeat customers represented 69.03% of all customers and contributed 86.47% of total calculated revenue.
- **Customer Spending:** The highest-spending customer quartile contributed 62.44% of total calculated revenue, indicating a concentration of spending among high-value customers.
- **Customer Ratings:** Low ratings (1–2) accounted for 40.07% of records, slightly exceeding high ratings (4–5) at 39.68%.
- **Data Quality:** The analysis identified inconsistencies in signup and review dates, highlighting the importance of data validation before interpreting time-based business metrics.

*Note: Revenue is calculated as quantity multiplied by unit price across all order statuses, including Cancelled and Returned orders. It should not be interpreted as net revenue. Findings are descriptive and do not establish causality.*
