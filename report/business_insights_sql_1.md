# SQL 1 — Data Exploration Report

## 1. Overview

This report summarizes the results of the initial data exploration queries for the E-Commerce SQL Analytics project. The goal is to understand the dataset's size, completeness, time coverage, and distribution before conducting deeper sales, customer, and operational analyses.

- **Dataset records:** 10,000
- **Order date range:** August 25, 2022 – August 24, 2025
- **Product categories:** 6
- **Countries represented:** 10
- **Order statuses:** 5

## 2. Key Findings

### 2.1 Dataset size and sample records

The dataset contains **10,000 records**. A sample of 10 records was reviewed to inspect the structure and example values across customer, product, order, and other transaction-related fields.

The sample preview is a structural check; it does not by itself establish the quality or representativeness of every field.

### 2.2 Completeness of selected key fields

The missing-value check reported the following filled counts:

| Field | Filled records | Missing records |
|---|---:|---:|
| `customer_id` | 10,000 | 0 |
| `product_id` | 10,000 | 0 |
| `order_id` | 10,000 | 0 |
| `order_date` | 10,000 | 0 |
| `unit_price` | 10,000 | 0 |
| `quantity` | 10,000 | 0 |

No missing values were found in these six checked fields. This result should not be generalized to every column because the query checked only the fields listed above.

### 2.3 Duplicate order IDs

The duplicate `order_id` check returned no rows, indicating that **no repeated order IDs were found** in the dataset. This is consistent with the dataset's expected one-record-per-order structure.

### 2.4 Time coverage and annual distribution

The recorded order dates range from **August 25, 2022, to August 24, 2025**.

| Order year | Records | Share of dataset |
|---|---:|---:|
| 2022 | 1,167 | 11.67% |
| 2023 | 3,363 | 33.63% |
| 2024 | 3,315 | 33.15% |
| 2025 | 2,155 | 21.55% |
| **Total** | **10,000** | **100.00%** |

The largest number of records falls in **2023 (3,363 records)**, followed closely by **2024 (3,315 records)**. The counts for 2022 and 2025 cover partial calendar years because the dataset starts in August 2022 and ends in August 2025. Therefore, the annual counts should not be interpreted as a like-for-like comparison of full-year performance.

### 2.5 Distribution by order status

| Order status | Records | Share |
|---|---:|---:|
| Shipped | 2,063 | 20.63% |
| Delivered | 2,037 | 20.37% |
| Cancelled | 1,970 | 19.70% |
| Pending | 1,968 | 19.68% |
| Returned | 1,962 | 19.62% |
| **Total** | **10,000** | **100.00%** |

The five order statuses are distributed relatively evenly, each representing approximately 19.62%–20.63% of records. Shipped is the most frequent status (2,063 records), while Returned is the least frequent (1,962 records). These are record counts, not revenue amounts.

### 2.6 Distribution by product category

| Product category | Records | Share |
|---|---:|---:|
| Electronics | 2,616 | 26.16% |
| Apparel | 2,047 | 20.47% |
| Home & Kitchen | 1,391 | 13.91% |
| Books | 1,334 | 13.34% |
| Toys | 1,314 | 13.14% |
| Sports | 1,298 | 12.98% |
| **Total** | **10,000** | **100.00%** |

Electronics is the most represented category, accounting for **26.16%** of records, followed by Apparel at **20.47%**. Sports has the fewest records, at **12.98%**. This distribution describes transaction-record frequency only; it does not indicate which category generates the most revenue or profit.

### 2.7 Distribution by country

| Country | Records | Share |
|---|---:|---:|
| France | 1,060 | 10.60% |
| China | 1,054 | 10.54% |
| Australia | 1,043 | 10.43% |
| India | 1,036 | 10.36% |
| Brazil | 1,019 | 10.19% |
| Canada | 997 | 9.97% |
| USA | 987 | 9.87% |
| Japan | 976 | 9.76% |
| UK | 943 | 9.43% |
| Germany | 885 | 8.85% |
| **Total** | **10,000** | **100.00%** |

France has the highest number of records (1,060; 10.60%), while Germany has the lowest (885; 8.85%). The distribution across countries is relatively balanced, with each country accounting for 8.85%–10.60% of records. This does not necessarily mean that revenue or customer value is equally distributed across countries.

## 3. Overall Assessment

The initial exploration suggests that the dataset is structurally suitable for further analysis in the following respects:

- It contains 10,000 records and spans nearly three years of order dates.
- The six checked identifier, date, and transaction fields have no missing values.
- No duplicate `order_id` values were returned by the duplicate check.
- Records are distributed across five statuses, six product categories, and ten countries.

These checks are an initial assessment, not a complete data-quality audit. Further checks may still be needed for invalid values, inconsistent categories, date logic, outliers, and the completeness of other columns.

## 4. Recommended Next Steps

1. Use **SQL 2 — Sales Analysis** to examine revenue, average order value, trends, and product/category/country performance.
2. Use **SQL 3 — Customer Analysis** to investigate repeat purchases, customer value, and customer segments.
3. Use **SQL 4 and SQL 5** to explore advanced product patterns and operational indicators.
4. Validate the findings across query outputs before turning them into final business recommendations or dashboard claims.

## 5. Scope and Interpretation Notes

- The annual distribution is based on record counts. The first and last calendar years are partial years in this dataset.
- Order-status, category, and country distributions show the number of records and their share of the 10,000-record dataset. They are not revenue or profit measures.
- The missing-value check covers only `customer_id`, `product_id`, `order_id`, `order_date`, `unit_price`, and `quantity`.
- No business recommendations about causes or performance are made from these descriptive counts alone.
