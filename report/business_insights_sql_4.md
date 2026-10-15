# SQL 4 — Advanced Business Analysis Report

## 1. Overview

This report summarizes six advanced analyses: product-level revenue contribution, order-value segmentation, sales performance by weekday, time from customer signup to first purchase, product sales efficiency, and a customer-date consistency check.

The analysis uses the `ecommerce_orders` dataset. Calculated revenue is defined as `quantity × unit_price`, consistent with the previous reports. The dataset contains 10,000 orders and total calculated revenue of 7,450,763.

> **Interpretation note:** The revenue calculation includes all order statuses. It should not be interpreted as net realized revenue without a documented treatment of Cancelled and Returned orders.

## 2. Key Findings

### 2.1 Product revenue contribution and cumulative Pareto analysis

The query ranks products by calculated revenue and measures their cumulative share of total revenue.

| Rank | Product | Revenue | Revenue share | Cumulative revenue share |
|---:|---|---:|---:|---:|
| 1 | iPhone 14 | 1,881,117 | 25.25% | 25.25% |
| 2 | Samsung Galaxy S23 | 1,780,919 | 23.90% | 49.15% |
| 3 | Dyson Vacuum | 876,204 | 11.76% | 60.91% |
| 4 | Fitbit Versa 3 | 442,886 | 5.94% | 66.85% |
| 5 | Sony Headphones | 425,064 | 5.70% | 72.56% |
| 6 | Barbie Dreamhouse | 384,667 | 5.16% | 77.72% |
| 7 | Wilson Tennis Racket | 290,550 | 3.90% | 81.62% |

The iPhone 14 and Samsung Galaxy S23 together account for **49.15% of total calculated revenue**. The top six products contribute 77.72%; the top seven contribute 81.62%. Therefore, seven of the 15 products account for approximately 80% of calculated revenue in this dataset.

This is a Pareto-style observation, not proof that the 80/20 rule holds. The result is based on calculated revenue, not profit or margin.

### 2.2 Order value segmentation

Orders were divided into four equal-sized quartiles using their order values. Each group contains 2,500 orders.

| Order value segment | Orders | Revenue | Average order value | Revenue share |
|---|---:|---:|---:|---:|
| Q1 — Lowest order value | 2,500 | 276,536 | 110.61 | 3.71% |
| Q2 — Lower-middle order value | 2,500 | 706,448 | 282.58 | 9.48% |
| Q3 — Upper-middle order value | 2,500 | 1,364,460 | 545.78 | 18.31% |
| Q4 — Highest order value | 2,500 | 5,103,319 | 2,041.33 | 68.49% |
| **Total** | **10,000** | **7,450,763** | — | **100.00%** |

The highest-value quartile contributes **68.49% of total calculated revenue**, while the lowest-value quartile contributes 3.71%. Average order value in Q4 (2,041.33) is substantially higher than in Q1 (110.61).

This indicates strong concentration of calculated revenue among the highest-value orders. These are relative quartiles based on this dataset; the thresholds may change if the data changes. This does not establish profitability or explain why some orders have higher values.

### 2.3 Sales performance by day of week

| Day | Orders | Quantity sold | Revenue | Average order value |
|---|---:|---:|---:|---:|
| Sunday | 1,468 | 4,371 | 1,026,066 | 698.96 |
| Monday | 1,378 | 4,079 | 1,061,423 | 770.26 |
| Tuesday | 1,391 | 4,210 | 1,050,702 | 755.36 |
| Wednesday | 1,424 | 4,293 | 1,051,045 | 738.09 |
| Thursday | 1,457 | 4,367 | 1,079,802 | 741.11 |
| Friday | 1,435 | 4,362 | 1,111,444 | 774.53 |
| Saturday | 1,447 | 4,326 | 1,070,281 | 739.66 |

Friday has the highest total calculated revenue (1,111,444) and highest average order value (774.53). Sunday has the highest order count (1,468), while Monday has the lowest order count (1,378).

The difference between the highest and lowest weekday revenue is 85,378. The pattern suggests some variation by weekday, but order counts are relatively similar. The output does not establish that the weekday itself causes higher revenue, and other factors such as product mix or promotions were not analyzed.

### 2.4 Time from signup to first purchase

Among records with valid signup and first-purchase dates after excluding customers whose first order predates signup, the output reports:

| Metric | Result |
|---|---:|
| Customers with valid dates for the delay summary | 2,567 |
| Average days from signup to first purchase | 580.22 days |
| Minimum days | 0 |
| Maximum days | 1,811 |
| Customers purchasing on signup date | 3 |
| Same-day purchase percentage | 0.12% |

For the 2,567 customers included in the delay summary, the average time to first purchase is approximately 580 days. Only three customers in this group purchased on their signup date.

However, this result must be interpreted alongside the data-quality check in Section 2.6. The delay calculation excludes records with a first order before signup. A large number of such records exists in the output, so the average delay describes only the subset that passed the date-order condition and may not represent all customers.

### 2.5 Product sales efficiency profile

The query compares total quantity sold, calculated revenue, and revenue per unit. Its performance labels are based on dataset-relative median values and do **not** represent profit margins.

Examples from the output:

| Product | Quantity sold | Revenue | Revenue per unit | Segment |
|---|---:|---:|---:|---|
| iPhone 14 | 1,883 | 1,881,117 | 999 | Lower volume / high revenue |
| Samsung Galaxy S23 | 1,981 | 1,780,919 | 899 | High volume / high revenue |
| Dyson Vacuum | 2,196 | 876,204 | 399 | High volume / high revenue |
| Sony Headphones | 2,136 | 425,064 | 199 | High volume / high revenue |
| Nike Air Max | 2,042 | 245,040 | 120 | High volume / lower revenue |
| Adidas Running Shoes | 2,093 | 230,230 | 110 | High volume / lower revenue |
| Yoga Mat | 1,890 | 47,250 | 25 | Lower volume / lower revenue |

The iPhone 14 generates the highest revenue in the product list despite its quantity sold being below several other products. The Dyson Vacuum has the highest quantity sold (2,196) and is classified as high volume / high revenue by the query's relative-median rules. The Yoga Mat has the lowest revenue (47,250) and lowest revenue per unit (25) in the displayed output.

These categories are descriptive sales profiles only. Cost and margin data would be needed to evaluate product profitability.

### 2.6 Data-quality check: first purchase before signup

The data-quality query returns **1,760 customers** whose recorded first purchase date is earlier than their signup date. Examples include customers with signup dates in 2025 but first-order dates in 2022.

The query's delay summary includes 2,567 customers with valid date order, while the data-quality query identifies 1,760 customers with a first purchase before signup. These groups sum to the 4,327 distinct customers reported elsewhere in the project.

This is a significant timeline inconsistency in the supplied data. Possible explanations cannot be determined from the query output alone. The signup and order dates should be checked against the original dataset's definitions and data-generation process before using signup-to-purchase delay as a reliable business metric.

## 3. Overall Assessment

The SQL 4 outputs highlight three major patterns:

1. **Revenue concentration:** seven of the 15 products account for 81.62% of calculated revenue, and the two leading products account for 49.15%.
2. **High-value order concentration:** the highest order-value quartile contributes 68.49% of calculated revenue.
3. **Signup-date quality issue:** 1,760 customers have a recorded first purchase before their signup date, which limits confidence in signup-to-first-purchase analysis.

Weekday revenue varies, with Friday leading in total revenue, but the weekday differences are modest relative to the overall total and do not establish causation. Product performance segments should not be interpreted as profit segments because the dataset output does not include product costs.

## 4. Business Implications and Further Analysis

- **Product concentration:** examine the business's dependence on the iPhone 14 and Samsung Galaxy S23 and determine whether the concentration remains when using net sales or margin data.
- **Order-value mix:** profile the products and categories that appear in the highest-value quartile to understand what drives large orders.
- **Weekday planning:** compare weekday patterns across months, categories, and countries before making staffing or campaign decisions.
- **Signup-date integrity:** investigate the 1,760 date inconsistencies with the source-data definitions. Recalculate signup-to-first-purchase metrics after resolving or documenting these records.
- **Profitability:** add product cost and other relevant cost fields before drawing conclusions about product efficiency or profit.

These are proposed follow-up analyses, not confirmed explanations or finalized business actions.

## 5. Scope and Limitations

- Revenue is calculated as `quantity × unit_price` and includes all order statuses.
- The output does not specify currency, product costs, discounts, refunds, or profit margins.
- Pareto-style percentages describe the observed revenue distribution; they do not assume the 80/20 rule must hold.
- Order value groups are relative quartiles, not fixed business thresholds.
- Product sales efficiency segments use relative median values and do not measure profitability.
- Signup-to-first-purchase delay is calculated only for customers whose date records pass the query's validity conditions.
- The 1,760 first-purchase-before-signup records should be investigated before relying on signup-related metrics.
