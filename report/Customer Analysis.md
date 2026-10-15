# SQL 3 — Customer Analysis Report

## 1. Overview

This report summarizes the outputs of the Customer Analysis queries. The analysis examines repeat purchasing, new and returning customers, cohort retention, RFM customer segmentation, purchase intervals, customer spending segments, acquisition-month performance, and customer recency.

The dataset contains **4,327 distinct customers** and 10,000 orders. Revenue in this report is calculated as `quantity × unit_price`, consistent with the preceding sales analysis.

> **Interpretation note:** The calculated revenue includes all order statuses in the dataset. It should not be interpreted as net realized revenue unless cancelled and returned orders are treated according to a documented business rule.

## 2. Key Findings

### 2.1 Repeat-purchase behavior

| Customer type | Customers | Customer share | Orders | Revenue | Revenue share |
|---|---:|---:|---:|---:|---:|
| Repeat customer | 2,987 | 69.03% | 8,660 | 6,442,662 | 86.47% |
| One-time customer | 1,340 | 30.97% | 1,340 | 1,008,101 | 13.53% |
| **Total** | **4,327** | **100.00%** | **10,000** | **7,450,763** | **100.00%** |

Most customers in the dataset are repeat customers: **69.03% have placed more than one order**. They account for 86.47% of calculated revenue. The 30.97% of customers who purchased once account for 13.53% of calculated revenue.

This indicates that repeat customers are an important part of the observed sales base. It does not, by itself, explain why they return or establish future customer lifetime value.

### 2.2 Monthly new versus returning customers

The share of returning customers generally rises as the dataset progresses. For example, returning customers represented **1.23% of active customers in September 2022**, compared with approximately **77%–85% in many months during 2024 and 2025**.

The output shows 202 active customers in August 2025, of whom 178 were returning customers (88.12%). However, August 2025 is a partial month because the dataset ends on August 24, 2025. This percentage should not be compared directly with complete months without accounting for the partial observation period.

A returning customer is defined in the query as someone whose first purchase occurred before the month being analyzed and who also purchased in that month. The monthly measure is therefore a count of active customers, not the total number of orders.

### 2.3 Customer cohort retention

The cohort analysis tracks the share of customers acquired in a given month who purchased again in subsequent months. Month 0 is the acquisition month and is set to 100% by definition.

Across the cohorts shown, average month-1 retention is approximately **5.73%** (unweighted average across cohorts with an observed month 1). The cohort-level month-1 values range from **1.23% to 9.76%** in the output.

This suggests that only a relatively small proportion of customers in a cohort made another purchase in the following month. The result should be interpreted with care: the cohort sizes and observation windows differ, and newer cohorts do not have as many subsequent months available as older cohorts. Cohort retention is not the same as overall repeat-customer share.

### 2.4 RFM customer segmentation

RFM stands for **Recency, Frequency, and Monetary value**:
- **Recency:** days since the customer's most recent order, measured relative to the latest order date in the dataset.
- **Frequency:** number of orders.
- **Monetary value:** total calculated revenue per customer.
- Scores use quartiles (`NTILE(4)`); a score of 4 is treated as the most favorable score for each metric, with recency direction reversed so fewer days is better.

The customer-level output identifies five segments:

| Customer segment | Customers | Total calculated revenue | Average orders per customer |
|---|---:|---:|---:|
| Needs further engagement | 1,387 | 1,020,741 | 1.31 |
| High-value active customer | 1,203 | 3,664,634 | 3.45 |
| Previously frequent customer | 777 | 2,087,062 | 2.92 |
| Recently acquired or occasional customer | 777 | 539,731 | 1.51 |
| Loyal active customer | 183 | 138,595 | 3.22 |
| **Total** | **4,327** | **7,450,763** | — |

The **High-value active customer** segment has the largest total calculated revenue (3,664,634) and an average of 3.45 orders per customer. The **Needs further engagement** segment is the largest by customer count (1,387), but its average order frequency is 1.31.

These labels describe the rules used in this project's RFM scoring. They are not externally validated customer types or predictive classifications. In particular, segment labels should be interpreted together with their recency, frequency, and monetary definitions.

### 2.5 Time between purchases

The query includes **2,987 repeat customers** and reports an average customer purchase interval of **295.47 days**. The average shortest interval reported is 222.16 days, and the average longest interval is 381.69 days.

These figures suggest that the observed gaps between purchases can be long. They are summary statistics from the query's interval calculation, not a universal expected repurchase cycle for every customer. The observation period is limited, and customers have different numbers of purchases and different opportunities to make another purchase.

### 2.6 Customer revenue segments using quartiles

Customers were divided into four groups based on lifetime spending within the observed dataset. The groups are relative quartiles, not fixed monetary thresholds.

| Spending segment | Customers | Total revenue | Revenue share | Average revenue per customer | Average orders per customer |
|---|---:|---:|---:|---:|---:|
| Q1 — Lowest spending | 1,082 | 289,740 | 3.89% | 267.78 | 1.32 |
| Q2 — Lower-middle spending | 1,082 | 823,069 | 11.05% | 760.69 | 1.96 |
| Q3 — Upper-middle spending | 1,082 | 1,685,700 | 22.62% | 1,557.95 | 2.81 |
| Q4 — Highest spending | 1,081 | 4,652,254 | 62.44% | 4,303.66 | 3.15 |
| **Total** | **4,327** | **7,450,763** | **100.00%** | — | — |

The highest-spending quartile contributes **62.44% of total calculated revenue**, while the lowest-spending quartile contributes 3.89%. Average orders per customer also increase across the spending groups, from 1.32 in Q1 to 3.15 in Q4.

This indicates that customer spending is concentrated in the highest-spending group. The result is descriptive and does not establish whether the same customers will remain high-spending in the future.

### 2.7 Customer acquisition by first-purchase cohort

The acquisition-month query counts customers according to the month of their first purchase and measures the revenue generated by those customers during that acquisition month. This is **acquisition-month revenue, not lifetime revenue**.

The largest acquisition cohort in the output is **October 2022, with 270 new customers**. The largest acquisition-month revenue per new customer is reported in **February 2025 (1,119.95)**, based on 41 new customers and acquisition-month revenue of 45,918.

The number of new customers per month declines in later periods compared with the largest acquisition cohorts in 2022. However, the dataset alone does not explain the cause of this pattern. August 2022 and August 2025 are partial months, so those months should be interpreted cautiously.

### 2.8 Customer recency status snapshot

The query classifies customers using the number of days since their most recent order, relative to the dataset's latest order date.

| Recency status | Customers | Customer share | Historical revenue | Average orders per customer |
|---|---:|---:|---:|---:|
| Active in last 30 days | 258 | 5.96% | 586,363 | 3.05 |
| Inactive for 31–90 days | 494 | 11.42% | 1,004,160 | 2.82 |
| Inactive for over 90 days | 3,575 | 82.62% | 5,860,240 | 2.19 |
| **Total** | **4,327** | **100.00%** | **7,450,763** | — |

Most customers (82.62%) had not placed an order in the 90 days preceding the dataset's latest order date. This is a descriptive recency snapshot, **not a validated churn prediction**. The dataset ends in August 2025, so these recency labels describe activity relative to that historical endpoint, not current customer activity.

## 3. Overall Assessment

The SQL 3 results point to four main patterns:

1. **Repeat customers are central to the observed sales base:** 69.03% of customers purchased more than once and contributed 86.47% of calculated revenue.
2. **Customer spending is concentrated:** the highest-spending quartile accounts for 62.44% of calculated revenue.
3. **Next-month cohort retention is low:** average month-1 retention is approximately 5.73% across cohorts with an observed month 1, although cohort sizes and observation windows differ.
4. **Most customers are historically inactive at the dataset endpoint:** 82.62% fall into the over-90-day recency group, which should be treated as a descriptive flag rather than proof of churn.

Together, these findings show why customer analysis should consider repeat purchasing, retention, spending concentration, and recency rather than relying on a single customer metric.

## 4. Business Implications and Further Analysis

The findings suggest several follow-up questions for a business or analytics team:

- **Customer retention:** investigate why next-month cohort retention is low and whether repeat purchases tend to occur after longer intervals.
- **Customer engagement:** examine the large “Needs further engagement” segment and the over-90-day recency group, while avoiding treating the recency rule as a confirmed churn label.
- **High-value customers:** profile the products, categories, and purchasing patterns associated with the highest-spending quartile.
- **Acquisition quality:** compare acquisition-month revenue with later-month behavior to determine whether larger acquisition cohorts also develop into repeat customers.
- **Measurement:** define how Cancelled and Returned orders should be treated before interpreting customer monetary value as net sales.

These are proposed analyses, not proven explanations or finalized business actions. Further evidence is required before attributing causes or recommending specific interventions.

## 5. Scope and Limitations

- Revenue is calculated as `quantity × unit_price` and includes all order statuses in the output.
- The dataset spans August 2022 through August 2025; the first and last months are partial.
- Cohort retention is only observable for subsequent months present in the dataset. Newer cohorts have shorter observation windows.
- RFM segment names depend on this project's scoring rules and are descriptive, not predictive.
- Recency status is measured against the latest order date in the dataset, not the current date.
- Customer spending and RFM metrics describe the observed period; they should not be presented as validated lifetime value or future behavior predictions.
