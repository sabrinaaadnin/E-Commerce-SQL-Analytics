# SQL 5 — Operational Analysis Report

## 1. Overview

This report summarizes six operational analyses covering monthly order-status patterns, cancellation and return rates by payment method, product category and country, review availability by order status, and the time gap between order and review dates.

The purpose is to describe operational patterns in the supplied e-commerce dataset and identify areas where the data may need further validation. The report describes associations and distributions; it does not establish causal explanations.

## 2. Key Findings

### 2.1 Monthly order-status trend

The monthly status query counts orders in each status and calculates each status's share of that month's transactions.

Examples from the output include:

- **August 2022:** Delivered and Returned each account for 22.95% of the month's 61 records (14 records each). This is a partial month.
- **October 2022:** Pending is the most frequent status, at 24.91% (73 records).
- **April 2023:** Cancelled is the most frequent status, at 26.57% (76 records).
- **October 2023:** Shipped is the most frequent status, at 25.27% (71 records).
- **February 2024:** Returned is the most frequent status, at 25.96% (61 records).
- **October 2024:** Delivered is the most frequent status, at 25.67% (77 records).
- **May 2025:** Cancelled is the most frequent status, at 25.98% (73 records).
- **August 2025:** Cancelled accounts for 24.64% (51 records), while Pending accounts for 14.49% (30 records). August 2025 is a partial month because the dataset ends on August 24, 2025.

The most frequent status varies by month rather than one status consistently leading throughout the entire period. The results may help identify months for deeper investigation, but month-to-month differences alone do not explain why a status occurred.

### 2.2 Cancellation and return rates by payment method

| Payment method | Transactions | Cancelled | Cancellation rate | Returned | Return rate |
|---|---:|---:|---:|---:|---:|
| Cash on Delivery | 3,409 | 684 | 20.06% | 652 | 19.13% |
| Credit Card | 3,290 | 653 | 19.85% | 658 | 20.00% |
| PayPal | 3,301 | 633 | 19.18% | 652 | 19.75% |

Cash on Delivery has the highest cancellation rate (20.06%) and lowest return rate (19.13%) among the three methods. Credit Card has the highest return rate (20.00%). The differences are relatively small: cancellation rates range from 19.18% to 20.06%, and return rates from 19.13% to 20.00%.

The output does not explain the reasons for cancellation or return. Payment method should not be treated as the cause based on these descriptive comparisons alone.

### 2.3 Cancellation and return rates by product category

| Category | Transactions | Cancelled | Cancellation rate | Returned | Return rate |
|---|---:|---:|---:|---:|---:|
| Books | 1,334 | 281 | 21.06% | 254 | 19.04% |
| Sports | 1,298 | 263 | 20.26% | 260 | 20.03% |
| Electronics | 2,616 | 515 | 19.69% | 485 | 18.54% |
| Toys | 1,314 | 258 | 19.63% | 260 | 19.79% |
| Home & Kitchen | 1,391 | 269 | 19.34% | 289 | 20.78% |
| Apparel | 2,047 | 384 | 18.76% | 414 | 20.22% |

Books has the highest cancellation rate (21.06%), while Apparel has the lowest (18.76%). Home & Kitchen has the highest return rate (20.78%), followed by Apparel (20.22%). Electronics has the lowest return rate (18.54%).

These differences can help prioritize further investigation of category-level order outcomes. The rates do not establish the reasons behind cancellations or returns, and they are not measures of revenue loss.

### 2.4 Cancellation and return rates by country

| Country | Transactions | Cancellation rate | Return rate |
|---|---:|---:|---:|
| Brazil | 1,019 | 21.00% | 18.25% |
| Japan | 976 | 20.90% | 20.29% |
| Australia | 1,043 | 20.90% | 19.46% |
| India | 1,036 | 20.75% | 20.56% |
| USA | 987 | 19.66% | 19.45% |
| UK | 943 | 19.62% | 20.68% |
| China | 1,054 | 19.26% | 19.26% |
| Canada | 997 | 18.46% | 20.26% |
| Germany | 885 | 18.42% | 18.42% |
| France | 1,060 | 17.92% | 19.53% |

Brazil has the highest cancellation rate (21.00%), while France has the lowest (17.92%). The UK has the highest return rate (20.68%), narrowly ahead of India (20.56%). Germany has the lowest return rate (18.42%).

The country-level rates are generally within a relatively narrow range. Differences may warrant additional analysis, but the output alone does not identify whether they relate to logistics, product mix, customer behavior, or other factors.

### 2.5 Review availability by order status

| Order status | Transactions | With rating | Rating availability | With review text | Review-text availability |
|---|---:|---:|---:|---:|---:|
| Shipped | 2,063 | 2,063 | 100% | 2,063 | 100% |
| Delivered | 2,037 | 2,037 | 100% | 2,037 | 100% |
| Cancelled | 1,970 | 1,970 | 100% | 1,970 | 100% |
| Pending | 1,968 | 1,968 | 100% | 1,968 | 100% |
| Returned | 1,962 | 1,962 | 100% | 1,962 | 100% |

All records in every order-status group have both a rating and non-empty review text in the output. Therefore, this query does **not** show a difference in review availability by order status; availability is 100% for all five statuses.

The uniform completeness may reflect how the dataset was constructed. It should not be interpreted as evidence that real-world customers always submit reviews for cancelled, pending, shipped, delivered, and returned orders.

### 2.6 Order-to-review time lag: date-quality concern

The query calculates the difference between `review_date` and `order_date`. The output contains a large number of negative differences and very wide ranges:

| Order status | Records with both dates | Average days to review | Minimum days | Maximum days | Reviews before order date |
|---|---:|---:|---:|---:|---:|
| Delivered | 2,037 | -24.95 | -1,053 | 1,053 | 1,055 |
| Cancelled | 1,970 | -6.16 | -1,071 | 1,071 | 995 |
| Shipped | 2,063 | -3.23 | -1,066 | 1,074 | 1,022 |
| Returned | 1,962 | 4.49 | -1,076 | 1,084 | 961 |
| Pending | 1,968 | 22.15 | -1,064 | 1,054 | 927 |

Across the five statuses, **4,960 records** are flagged by the query as having a review date before the order date. The minimum and maximum differences also extend to roughly three years in either direction. Such results are not plausible for a conventional order-to-review interval without further explanation.

This is a significant data-quality warning. Possible explanations include the source data's date definitions, synthetic data generation, or date-field issues, but the output alone cannot determine the cause. The average time-to-review figures should **not** be used as a reliable operational KPI until the date fields and business definitions are validated.

## 3. Overall Assessment

The SQL 5 results identify three main points:

1. **Operational rates vary slightly across groups:** Books has the highest cancellation rate by category, Home & Kitchen the highest return rate by category, Brazil the highest cancellation rate by country, and the UK the highest return rate by country.
2. **Review availability is uniformly complete in this dataset:** all records show both a rating and review text, regardless of order status. This may reflect dataset construction rather than real-world review behavior.
3. **Order and review dates need validation:** 4,960 records have review dates before order dates according to the query. This prevents reliable interpretation of the current order-to-review time-lag results.

Monthly status patterns also vary over time, but partial months (August 2022 and August 2025) should not be compared directly with complete months.

## 4. Business Implications and Further Analysis

- **Category operations:** investigate why Books has a higher cancellation rate and why Home & Kitchen has a higher return rate, using additional fields or supporting operational data if available.
- **Country operations:** review the order journey in Brazil, the UK, and other countries with comparatively higher cancellation or return rates before drawing conclusions about regional performance.
- **Date validation:** verify the definitions and values of `order_date` and `review_date`; then rerun the time-lag analysis after resolving or documenting records where review dates precede order dates.
- **Review data interpretation:** confirm whether ratings and review text are genuinely expected for all order statuses in the source dataset.
- **Partial periods:** use complete months for fairer comparisons of monthly order-status patterns.

These are proposed areas for further investigation, not confirmed explanations or finalized business actions.

## 5. Scope and Limitations

- Rates are calculated using transaction counts within each payment method, category, or country.
- The outputs do not provide causes for cancellations or returns.
- All records show ratings and review text in the provided output; this may be a property of the dataset.
- The order-to-review lag query reports many negative date differences. Its average, minimum, and maximum values should not be treated as valid service-performance measures until date quality is checked.
- August 2022 and August 2025 are partial months in the observed date range.
- The report describes the supplied query results and does not infer causality.
