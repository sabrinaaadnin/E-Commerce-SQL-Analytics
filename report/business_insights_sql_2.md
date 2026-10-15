# SQL 2 — Sales Analysis Report

## 1. Overview

This report summarizes the results of the Sales Analysis queries for the E-Commerce SQL Analytics project. It establishes baseline sales metrics and examines revenue trends, product and country performance, payment methods, customer ratings, and customer-level sales indicators.

### Overall metrics

| Metric | Result |
|---|---:|
| Total revenue (`quantity × unit_price`) | 7,450,763 |
| Total quantity sold | 30,008 |
| Total orders | 10,000 |
| Distinct customers | 4,327 |
| Average order value (AOV) | 745.08 |

**Interpretation:** The dataset contains 10,000 orders from 4,327 customers. The calculated AOV is 745.08 revenue units per order. The dataset does not specify a currency in these query outputs, so no currency symbol is assigned here.

**Important definition note:** Total revenue is calculated as `SUM(quantity * unit_price)` across all records, including orders marked Cancelled or Returned. Unless the dataset's business rules specify otherwise, this should be treated as gross calculated transaction value, not confirmed realized or net revenue.

## 2. Key Findings

### 2.1 Revenue by order status

| Order status | Orders | Revenue | Share of total revenue |
|---|---:|---:|---:|
| Delivered | 2,037 | 1,582,371 | 21.24% |
| Shipped | 2,063 | 1,560,090 | 20.94% |
| Cancelled | 1,970 | 1,499,341 | 20.12% |
| Pending | 1,968 | 1,414,807 | 18.99% |
| Returned | 1,962 | 1,394,154 | 18.71% |

The status groups have relatively similar order counts. Delivered has the largest calculated revenue contribution (21.24%), while Returned has the smallest (18.71%). Because the revenue calculation includes every status, revenue associated with Cancelled and Returned orders should not be interpreted as retained sales without additional business rules.

### 2.2 Monthly revenue trend

- **Highest-revenue month:** August 2024 — 247,751.
- **Lowest-revenue month:** August 2022 — 59,094.

August 2022 is only a partial month in the observed dataset, so it is not directly comparable with full months. August 2025 is also partial because the dataset ends on August 24, 2025.

The largest positive month-over-month (MoM) percentage change in the output is **September 2022 (+173.36%)**, increasing from 59,094 to 161,540. This comparison is affected by August 2022 being a partial month.

The largest negative MoM change is **August 2025 (-31.37%)**, from 215,346 in July 2025 to 147,797 in August 2025. Since August 2025 is partial, this decline should not be interpreted as a full-month downturn without additional context.

Other large changes include:
- March 2023: +41.20% MoM.
- October 2022: +40.44% MoM.
- December 2023: -18.09% MoM.
- February 2023: -17.81% MoM.

### 2.3 Annual revenue performance

| Year | Revenue | Orders | Average order value |
|---|---:|---:|---:|
| 2022 | 847,031 | 1,167 | 725.82 |
| 2023 | 2,490,025 | 3,363 | 740.42 |
| 2024 | 2,506,001 | 3,315 | 755.96 |
| 2025 | 1,607,706 | 2,155 | 746.04 |

Revenue increased by **193.97% in 2023** compared with 2022, followed by a **0.64% increase in 2024**. The output reports a **35.85% decrease in 2025** compared with 2024.

However, 2022 and 2025 are partial years in this dataset (August 2022–August 2025). Therefore, the reported year-over-year (YoY) rates involving these years are not full-year, like-for-like comparisons. The 2025 decline should not be interpreted as a confirmed annual business decline.

### 2.4 Revenue by product category

| Category | Revenue | Quantity sold | Orders | Revenue share |
|---|---:|---:|---:|---:|
| Electronics | 4,529,986 | 7,934 | 2,616 | 60.80% |
| Home & Kitchen | 1,069,650 | 4,150 | 1,391 | 14.36% |
| Apparel | 597,636 | 6,209 | 2,047 | 8.02% |
| Toys | 499,894 | 3,886 | 1,314 | 6.71% |
| Books | 415,797 | 3,989 | 1,334 | 5.58% |
| Sports | 337,800 | 3,840 | 1,298 | 4.53% |

Electronics is the largest category by a substantial margin, contributing **60.80% of total calculated revenue**. Home & Kitchen is second at 14.36%. Sports contributes the smallest share, at 4.53%.

This concentration suggests that Electronics is a key category to investigate further. Revenue share alone does not indicate profitability, margin, or future demand.

### 2.5 Revenue by country

| Country | Revenue | Orders | Revenue share |
|---|---:|---:|---:|
| China | 815,789 | 1,054 | 10.95% |
| France | 810,303 | 1,060 | 10.88% |
| Japan | 777,673 | 976 | 10.44% |
| USA | 767,017 | 987 | 10.29% |
| India | 759,619 | 1,036 | 10.20% |
| Australia | 745,407 | 1,043 | 10.00% |
| Brazil | 743,066 | 1,019 | 9.97% |
| Canada | 719,928 | 997 | 9.66% |
| UK | 676,570 | 943 | 9.08% |
| Germany | 635,391 | 885 | 8.53% |

China has the highest total revenue (815,789; 10.95%), followed by France (810,303; 10.88%). Germany has the lowest total revenue (635,391; 8.53%). Revenue shares are fairly spread across the ten countries; the largest share is 10.95% and the smallest is 8.53%.

In the country-level output, France has the highest revenue per customer (1,833.26), followed by the USA (1,817.58). Germany has the lowest revenue per customer (1,616.77). Revenue per customer is an average and does not explain differences in customer acquisition, purchasing frequency, or profitability.

### 2.6 Top products by revenue

| Product | Category | Revenue | Quantity sold |
|---|---|---:|---:|
| iPhone 14 | Electronics | 1,881,117 | 1,883 |
| Samsung Galaxy S23 | Electronics | 1,780,919 | 1,981 |
| Dyson Vacuum | Home & Kitchen | 876,204 | 2,196 |
| Fitbit Versa 3 | Electronics | 442,886 | 1,934 |
| Sony Headphones | Electronics | 425,064 | 2,136 |
| Barbie Dreamhouse | Toys | 384,667 | 1,933 |
| Wilson Tennis Racket | Sports | 290,550 | 1,950 |
| Kindle Paperwhite | Books | 254,517 | 1,973 |
| Nike Air Max | Apparel | 245,040 | 2,042 |
| Adidas Running Shoes | Apparel | 230,230 | 2,093 |

The iPhone 14 and Samsung Galaxy S23 are the two highest-revenue products, with combined calculated revenue of 3,662,036. Dyson Vacuum ranks third by revenue and has the highest quantity sold among the top ten products shown (2,196 units).

The results indicate that revenue leadership and quantity leadership are not identical: a product can sell more units without generating the highest total revenue. These figures do not include product costs, so they should not be treated as profit rankings.

### 2.7 Payment method distribution

| Payment method | Orders | Revenue |
|---|---:|---:|
| Cash on Delivery | 3,409 | 2,451,402 |
| PayPal | 3,301 | 2,515,054 |
| Credit Card | 3,290 | 2,484,307 |

Cash on Delivery has the largest order count (3,409; 34.09%). PayPal has the highest calculated revenue (2,515,054), despite having fewer orders than Cash on Delivery. This difference may reflect order-value differences, but additional analysis would be required to confirm that interpretation.

### 2.8 Customer ratings and review distribution

The rating distribution is relatively even across the five rating values:

| Rating | Count | Share of all records |
|---|---:|---:|
| 5 | 1,972 | 19.72% |
| 4 | 1,996 | 19.96% |
| 3 | 2,025 | 20.25% |
| 2 | 2,005 | 20.05% |
| 1 | 2,002 | 20.02% |

The report classifies ratings 4–5 as high, 3 as medium, and 1–2 as low:
- **High rating (4–5):** 3,968 records (39.68%).
- **Medium rating (3):** 2,025 records (20.25%).
- **Low rating (1–2):** 4,007 records (40.07%).

The low-rating segment (40.07%) is slightly larger than the high-rating segment (39.68%). This is a descriptive signal worth investigating, but it does not by itself identify the cause of low ratings.

Average ratings by category range from 2.94 to 3.02:
- Electronics: 3.02 (highest in the output).
- Toys and Books: 3.01 each.
- Apparel: 2.98.
- Home & Kitchen: 2.97.
- Sports: 2.94 (lowest in the output).

The difference between the highest and lowest category averages is small (0.08 points). Further review-text analysis would be needed to understand what customers are dissatisfied with.

### 2.9 Customer-level indicators

The customer purchase-frequency output shows one customer with nine orders and the next with eight orders; the other customers in the top-ten table have seven orders each. This demonstrates repeat purchasing in the dataset, but the top-ten list alone does not describe repeat purchasing across the full customer base.

The customer AOV ranking includes customers with only one order and revenue of 4,995. A high average order value based on one order should be interpreted cautiously. Customer comparisons are stronger when AOV is considered together with order count and total revenue.

The highest-value-customer output identifies customers who combine relatively high total revenue with multiple orders. These records can be used as a starting point for further customer segmentation, but they do not establish customer lifetime value unless the observation window and cost/margin assumptions are defined.

### 2.10 Category performance across countries

Electronics is the highest-revenue category in all ten countries in the output. Its share of each country's revenue ranges from **58.27% in Australia** to **63.64% in Japan**. This consistent pattern reinforces the importance of Electronics in the current dataset.

This finding describes the supplied records only; it does not establish whether the same category mix would hold in other time periods or markets.

## 3. Overall Assessment

The SQL 2 outputs show three main patterns:

1. **Revenue concentration by category:** Electronics contributes 60.80% of calculated revenue and leads in every country.
2. **Variation over time:** Revenue varies month to month. The extreme MoM changes occur in partial months, so they require careful interpretation.
3. **Customer experience signal:** Low ratings (1–2) account for 40.07% of records, slightly exceeding high ratings (4–5) at 39.68%. Review text and product-level context should be examined before recommending corrective actions.

Country revenue is comparatively distributed across ten markets, with China and France at the top by total revenue. Payment methods have similar order shares, although PayPal has the highest calculated revenue.

## 4. Recommended Follow-up Analysis

- Examine whether the Electronics revenue concentration is driven mainly by iPhone 14 and Samsung Galaxy S23.
- Analyze low-rating review text to identify recurring complaint themes, if the review text is reliable and available.
- Compare cancellation and return rates by category, country, and payment method using SQL 5.
- Interpret monthly trends using complete months and avoid comparing partial months directly with full months.
- When possible, calculate net revenue using a documented rule for Cancelled and Returned orders, and add cost data before drawing conclusions about profit.
- Use customer purchase frequency, total revenue, and average order value together rather than relying on a single metric.

## 5. Scope and Limitations

- Revenue is calculated as `quantity * unit_price` and includes all order statuses in the provided output.
- The output does not specify currency, product costs, discounts, refunds, or profit margins.
- The dataset covers August 25, 2022–August 24, 2025. The first and last calendar years are partial years.
- The 2025 annual revenue and August 2025 monthly results are incomplete for the full calendar periods.
- Customer AOV rankings can be dominated by one-order customers; order count should be considered alongside AOV.
- The findings are descriptive and do not establish causal explanations.
