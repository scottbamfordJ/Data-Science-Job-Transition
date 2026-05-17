# E-Commerce SQL Practice Environment

A local SQLite practice environment with realistic e-commerce data, built for learning window functions, CTEs, and multi-table joins.

## Setup

```bash
# 1. Generate the database
python setup.py

# 2. Open interactive SQLite shell
sqlite3 ecommerce.db

# 3. Run a specific challenge to test your answer
sqlite3 ecommerce.db "SELECT ..."
```

## Schema

```
categories  (category_id, category_name)
     |
products    (product_id, product_name, category_id, price, cost)
                                           |
customers   (customer_id, first_name, last_name, email, city, state, signup_date)
     |
orders      (order_id, customer_id, order_date, status, shipping_cost)
     |
order_items (item_id, order_id, product_id, quantity, unit_price)
```

## Dataset

- 200 customers across 15 US cities
- ~734 orders (2023–2024)
- ~1,300 order items
- 15 products across 5 categories
- Order statuses: completed, returned, cancelled

## Challenge Levels

| Level | Focus | Count |
|---|---|---|
| 1 — Warm Up | Aggregations, GROUP BY, JOINs | 4 |
| 2 — Intermediate | CTEs, subqueries, HAVING | 5 |
| 3 — Window Functions | RANK, LAG, NTILE, running totals | 6 |
| 4 — Hard | Cohorts, affinity, churn, real interview style | 5 |

## Useful SQLite Commands

```sql
-- See all tables
.tables

-- See schema for a table
.schema orders

-- Pretty print output
.mode column
.headers on

-- Export results to CSV
.mode csv
.output results.csv
SELECT * FROM orders LIMIT 10;
.output stdout
```

## Key Concepts Covered

- `RANK()`, `ROW_NUMBER()`, `NTILE()` — ranking functions
- `LAG()`, `LEAD()` — accessing previous/next rows
- `SUM() OVER (...)` — running totals and partitioned aggregations
- `PARTITION BY` — window functions scoped to a group
- CTEs (`WITH` clauses) — breaking complex queries into steps
- `LEFT JOIN + IS NULL` — finding records with no match
- `julianday()` — SQLite date arithmetic
- `strftime()` — date formatting and truncation
- `CASE WHEN` — conditional logic inline
