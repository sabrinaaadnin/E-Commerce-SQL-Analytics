# E-Commerce SQL Analytics — Overall Project Report

## Executive Summary

This project uses SQL and SQLite to explore a dataset of 10,000 e-commerce orders recorded between August 25, 2022, and August 24, 2025. The analysis covers data exploration, sales performance, customer behavior, advanced business patterns, and operational indicators.

The dataset contains 4,327 distinct customers across 15 products, six product categories, and ten countries. Total calculated revenue is **7,450,763**, based on `quantity × unit_price`.

The analysis identifies three prominent business patterns:

1. **Revenue is concentrated in a small number of products and orders.** Electronics contributes 60.80% of calculated revenue. The two leading products, iPhone 14 and Samsung Galaxy S23, together contribute 49.15%. The highest-value quartile of orders contributes 68.49% of calculated revenue.
2. **Repeat customers contribute a large share of observed revenue.** Customers with more than one order represent 69.03% of customers and contribute 86.47% of calculated revenue. The highest-spending customer quartile contributes 62.44%.
3. **Some source fields require validation before operational conclusions can be drawn.** The analysis flags 1,760 customers whose first purchase date precedes their signup date and 4,960 records whose review date precedes their order date. These inconsistencies limit the reliability of signup-to-purchase and order-to-review timing metrics.

These findings are descriptive. They do not establish causality, profitability, or future customer behavior.

## 1. Project Overview

### Objectives

- Explore dataset structure and selected data-quality indicators.
- Measure sales performance and revenue distribution.
- Understand repeat purchasing, retention, and customer spending patterns.
- Examine product contribution, order-value segments, and weekday sales.
- Compare cancellation and return rates across payment methods, categories, and countries.
- Identify data-quality issues that affect interpretation of business metrics.

### Dataset and Tools

| Item | Description |
|---|---|
| Dataset | E-Commerce Dataset for SQL Analysis |
| Source | [Kaggle dataset](https://www.kaggle.com/datasets/nabihazahid/ecommerce-dataset-for-sql-analysis) |
| Records | 10,000 |
| Distinct customers | 4,327 |
| Products | 15 |
| Categories | 6 |
| Countries | 10 |
| Order date range | August 25, 2022 – August 24, 2025 |
| Tools | SQLite, DB Browser for SQLite, SQL |

### Revenue definition

For consistency across the analyses, calculated revenue is defined as:

`SUM(quantity * unit_price)`

This calculation includes all order statuses, including Cancelled and Returned. Therefore, the total should be interpreted as **calculated transaction value**, not confirmed net sales or realized revenue. The dataset outputs do not provide enough information about refunds, discounts, costs, or margin to calculate profit.

## 2. Data Exploration

The initial exploration found 10,000 records and no duplicate `order_id` values in the duplicate check. The six checked fields—`customer_id`, `product_id`, `order_id`, `order_date`, `unit_price`, and `quantity`—had no missing values.

The records span five order statuses, six product categories, and ten countries. Electronics is the most represented category by record count (26.16%), while France has the largest number of records by country (10.60%). The order-status counts are relatively evenly distributed, with each status representing approximately 19.62%–20.63% of records.

The date range covers partial calendar years at both ends: the dataset begins in August 2022 and ends on August 24, 2025. Annual and monthly comparisons involving those partial periods require caution.

These checks provide an initial structural assessment, not a complete data-quality audit of every column.

## 3. Sales Analysis

### Overall performance

| Metric | Result |
|---|---:|
| Calculated revenue | 7,450,763 |
| Orders | 10,000 |
| Quantity sold | 30,008 |
| Distinct customers | 4,327 |
| Average order value | 745.08 |

No currency unit is specified in the query outputs, so the report does not assign a currency symbol.

### Revenue by category

| Category | Calculated revenue | Share of total |
|---|---:|---:|
| Electronics | 4,529,986 | 60.80% |
| Home & Kitchen | 1,069,650 | 14.36% |
| Apparel | 597,636 | 8.02% |
| Toys | 499,894 | 6.71% |
| Books | 415,797 | 5.58% |
| Sports | 337,800 | 4.53% |

Electronics dominates calculated revenue, accounting for 60.80% of the total. This is substantially higher than any other category. Revenue share alone, however, does not establish profitability or future demand.

### Product and country performance

- **iPhone 14** has the highest calculated revenue at 1,881,117.
- **Samsung Galaxy S23** ranks second at 1,780,919.
- Together, these two products contribute 49.15% of total calculated revenue.
- **China** has the highest country-level revenue at 815,789, followed by France at 810,303. The ten countries have comparatively distributed revenue shares, ranging from 8.53% to 10.95%.

### Time-based performance

August 2024 is the highest-revenue month in the output, at 247,751. August 2022 is the lowest at 59,094, but it is a partial month. Large month-over-month movements involving August 2022 and August 2025 are affected by partial-month coverage.

Annual revenue was 847,031 in 2022, 2,490,025 in 2023, 2,506,001 in 2024, and 1,607,706 in 2025. Since 2022 and 2025 are partial years, these annual values are not like-for-like full-year comparisons.

### Customer ratings

Ratings 1–2 account for 40.07% of records, while ratings 4–5 account for 39.68%. The low-rating share is slightly higher than the high-rating share. This is a signal for further review-text analysis, but the ratings alone do not explain the causes of customer dissatisfaction.

## 4. Customer Analysis

### Repeat purchasing

| Customer type | Customers | Share of customers | Calculated revenue | Revenue share |
|---|---:|---:|---:|---:|
| Repeat customers | 2,987 | 69.03% | 6,442,662 | 86.47% |
| One-time customers | 1,340 | 30.97% | 1,008,101 | 13.53% |
| **Total** | **4,327** | **100.00%** | **7,450,763** | **100.00%** |

Repeat customers represent 69.03% of customers and account for 86.47% of calculated revenue. This indicates that repeat purchasing is an important feature of the observed dataset, although the analysis does not establish why customers return or predict future customer value.

### Customer spending concentration

Customers were divided into spending quartiles based on calculated revenue per customer. The highest-spending quartile contributes 62.44% of total calculated revenue, compared with 3.89% for the lowest-spending quartile.

The RFM analysis also identifies a high-value active customer segment with 1,203 customers and calculated revenue of 3,664,634. RFM labels depend on the scoring rules used in this project and should be treated as descriptive segments, not predictive classifications.

### Retention and recency

Average month-1 cohort retention is approximately 5.73% across cohorts for which the following month is observable. Cohorts have different sizes and observation windows, so this average should be interpreted cautiously.

At the dataset endpoint, 82.62% of customers fall into the query's over-90-day recency group. This is a historical recency snapshot relative to the latest order date in August 2025, not a current churn estimate.

The customer analysis also reports an average purchase interval of 295.47 days among repeat customers, based on the query's interval calculation. This is a descriptive average and should not be treated as a universal repurchase cycle.

## 5. Advanced Business Analysis

### Product revenue concentration

A Pareto-style analysis shows that:

- The top two products contribute 49.15% of calculated revenue.
- The top six products contribute 77.72%.
- The top seven products contribute 81.62%.

Thus, seven of the 15 products account for approximately 80% of calculated revenue in this dataset. This is an observed concentration pattern, not an assumption that the 80/20 rule must always hold.

### Order-value segmentation

The highest-value quartile contains 2,500 orders and contributes 68.49% of calculated revenue. Its average order value is 2,041.33, compared with 110.61 in the lowest-value quartile.

This indicates that calculated revenue is concentrated in the highest-value orders. The quartiles are relative to this dataset and do not indicate profit or explain what causes higher order values.

### Weekday sales pattern

Friday has the highest calculated revenue by day of week (1,111,444) and the highest average order value (774.53). Sunday has the highest order count (1,468). Weekday differences are descriptive; the output does not establish that weekday causes higher revenue.

### Signup-to-first-purchase analysis

For 2,567 customers whose dates passed the query's date-order conditions, the average time from signup to first purchase is 580.22 days. However, the data-quality query flags 1,760 customers whose first purchase date is earlier than their signup date. The average delay therefore applies only to the filtered subset and should not be generalized to all customers.

## 6. Operational Analysis

### Cancellation and return rates

The operational queries compare rates by payment method, category, and country.

- **Payment method:** Cash on Delivery has the highest cancellation rate (20.06%); Credit Card has the highest return rate (20.00%). Differences among payment methods are small.
- **Category:** Books has the highest cancellation rate (21.06%), while Home & Kitchen has the highest return rate (20.78%). Apparel has the lowest cancellation rate (18.76%).
- **Country:** Brazil has the highest cancellation rate (21.00%), while the UK has the highest return rate (20.68%). France has the lowest cancellation rate (17.92%).

These comparisons can identify groups for further investigation, but they do not identify the reasons for cancellations or returns and do not quantify revenue lost.

### Monthly status patterns

The most frequent order status varies across months. The monthly pattern can guide further investigation, but partial months—August 2022 and August 2025—should not be directly compared with complete months.

### Review availability

The query reports that 100% of records in each order-status group have a rating and non-empty review text. This uniform completeness may reflect how the dataset was constructed. It should not be interpreted as evidence that real-world orders in every status would normally have reviews.

### Order-to-review date inconsistency

The date-lag query flags **4,960 records** with a review date earlier than the order date. The average, minimum, and maximum time differences are therefore not reliable measures of review timing until the date fields and their definitions are validated.

## 7. Overall Business Insights

The five SQL analyses collectively support the following observations:

1. **Revenue is concentrated.** Electronics contributes 60.80% of calculated revenue; the top two products contribute 49.15%; and the highest-value order quartile contributes 68.49%.
2. **Repeat customers are important to the observed sales base.** Repeat customers account for 69.03% of customers and 86.47% of calculated revenue.
3. **Customer spending varies substantially.** The highest-spending customer quartile contributes 62.44% of calculated revenue, while the lowest contributes 3.89%.
4. **Low ratings merit further investigation.** Ratings 1–2 account for 40.07% of records, slightly more than the 39.68% share for ratings 4–5.
5. **Operational rates differ across groups, but only modestly.** The observed cancellation and return rate differences are useful for prioritizing follow-up questions, not for assigning causes.
6. **Data quality limits some conclusions.** Signup and review dates contain inconsistencies that should be resolved or documented before using the associated time-based metrics for business decisions.

## 8. Business Implications and Further Analysis

The following are proposed next steps based on the findings, not confirmed causes or finalized business actions.

- **Understand product concentration:** investigate the products driving Electronics revenue and the high contribution of the iPhone 14 and Samsung Galaxy S23. Add cost or margin data before evaluating profitability.
- **Investigate customer experience:** analyze low-rating review text for recurring themes and compare findings across products and categories.
- **Study repeat purchasing:** explore which products, categories, and customer behaviors are associated with repeat orders, while accounting for different observation windows.
- **Review operational differences:** investigate cancellation and return patterns in Books, Home & Kitchen, Brazil, and the UK using additional supporting data where available.
- **Validate date fields:** check the definitions and records for `signup_date`, `order_date`, and `review_date` before relying on signup delay or order-to-review timing metrics.
- **Use fair time comparisons:** compare complete months and years rather than interpreting partial periods as full-period performance.
- **Define net sales:** document how Cancelled and Returned orders should be treated before reporting net revenue. Add product costs and other relevant costs before making profit claims.

## 9. Limitations

- Calculated revenue is `quantity × unit_price` and includes all order statuses.
- The query outputs do not specify currency, cost of goods, discounts, refunds, or profit margin.
- The first and last calendar years and months are partial periods.
- RFM labels and quartile groups are based on project-specific rules and are descriptive, not predictive.
- Recency is measured relative to the latest order date in the dataset, not the present date.
- The signup-to-first-purchase and order-to-review time metrics are affected by date inconsistencies.
- Descriptive differences do not establish causal relationships.

## 10. Conclusion

This SQL project demonstrates a structured workflow for exploring e-commerce transactions and analyzing sales, customers, products, and operational patterns using SQLite. The most notable findings are the concentration of calculated revenue in Electronics and a small set of products, the large revenue contribution from repeat customers, and substantial variation in customer spending.

The project also demonstrates the importance of validating data before turning query outputs into business claims. In particular, the signup-date and review-date inconsistencies should be addressed before those timing metrics are used operationally.

The overall findings can serve as the analytical foundation for the next stage of the portfolio: an interactive Power BI dashboard and a concise presentation of validated insights.
