-- ============================================================
-- E-COMMERCE SQL PRACTICE ENVIRONMENT
-- Scott Bamford | 2026
-- Run with: sqlite3 ecommerce.db < challenges.sql
-- Or open interactively: sqlite3 ecommerce.db
-- ============================================================
--
-- SCHEMA REFERENCE
-- ----------------
-- categories  (category_id, category_name)
-- products    (product_id, product_name, category_id, price, cost)
-- customers   (customer_id, first_name, last_name, email, city, state, signup_date)
-- orders      (order_id, customer_id, order_date, status, shipping_cost)
-- order_items (item_id, order_id, product_id, quantity, unit_price)
-- ============================================================


-- ============================================================
-- LEVEL 1 — WARM UP (Aggregations + GROUP BY)
-- ============================================================

-- L1-1: How many orders does each customer have?
--       Show customer full name, email, and order count.
--       Order by order count descending.
-- CONCEPTS: JOIN, GROUP BY, COUNT, ORDER BY


-- L1-2: What is the total revenue per product category?
--       Revenue = quantity * unit_price (from order_items).
--       Only include completed orders.
--       Show category name and total revenue, highest first.
-- CONCEPTS: Multi-table JOIN, WHERE, GROUP BY, SUM


-- L1-3: Which 5 products have the highest profit margin?
--       Margin % = ((price - cost) / price) * 100
--       Show product name, price, cost, and margin %.
--       Round margin to 2 decimal places.
-- CONCEPTS: Calculated columns, ROUND, ORDER BY, LIMIT


-- L1-4: How many customers signed up each month in 2023?
--       Show year-month (e.g. "2023-01") and customer count.
-- CONCEPTS: strftime() for date formatting, GROUP BY


-- ============================================================
-- LEVEL 2 — INTERMEDIATE (CTEs + Subqueries)
-- ============================================================

-- L2-1: Find customers who have placed more than 3 orders
--       AND whose average order value exceeds $100.
--       Average order value = sum of (quantity * unit_price) per order,
--       then averaged across that customer's orders.
--       Show full name, order count, and avg order value.
-- CONCEPTS: CTE, GROUP BY, HAVING


-- L2-2: For each category, show the most expensive product
--       and the least expensive product on the same row.
-- CONCEPTS: CTE or subquery, GROUP BY with MIN/MAX join back


-- L2-3: Find the month with the highest total revenue in 2024.
--       Show month, total revenue, and number of orders that month.
-- CONCEPTS: CTE, strftime, GROUP BY, ORDER BY + LIMIT


-- L2-4: Which customers have NEVER placed an order?
--       Show their full name, email, signup date, and city.
-- CONCEPTS: LEFT JOIN + IS NULL, or NOT EXISTS


-- L2-5: What percentage of orders were returned or cancelled
--       for each product category?
--       Show category, total orders, cancelled/returned count, and pct.
--       Round pct to 1 decimal place.
-- CONCEPTS: CTE, CASE WHEN, GROUP BY, calculated pct


-- ============================================================
-- LEVEL 3 — WINDOW FUNCTIONS (The interview bread and butter)
-- ============================================================

-- L3-1: Rank customers by total spend (completed orders only).
--       Show rank, full name, and total spend.
--       Use RANK() — tied customers should share a rank.
-- CONCEPTS: RANK() OVER (ORDER BY ...)


-- L3-2: For each order, show the running total revenue
--       (cumulative sum) ordered by order date.
--       Show order_id, order_date, order_revenue, and running_total.
-- CONCEPTS: SUM() OVER (ORDER BY ... ROWS UNBOUNDED PRECEDING)


-- L3-3: For each customer, show their orders with:
--         - order number (1st, 2nd, 3rd, etc. chronologically)
--         - days since their previous order (NULL for first order)
--       Show customer_id, order_id, order_date, order_num, days_since_prev.
-- CONCEPTS: ROW_NUMBER(), LAG(), julianday() for date diff


-- L3-4: For each product, show its monthly revenue AND
--       the revenue from the previous month side by side.
--       Include month-over-month change ($) and change (%).
-- CONCEPTS: LAG() OVER (PARTITION BY ... ORDER BY ...)


-- L3-5: Segment customers into 4 equal quartiles by total spend.
--       Show customer name, total spend, and quartile (1=lowest, 4=highest).
--       Label quartiles: 1=Bronze, 2=Silver, 3=Gold, 4=Platinum.
-- CONCEPTS: NTILE(4) OVER (ORDER BY ...), CASE WHEN


-- L3-6: For each category, rank products by revenue within that category.
--       Show category, product name, revenue, and rank within category.
--       Only show the top 3 products per category.
-- CONCEPTS: RANK() OVER (PARTITION BY ... ORDER BY ...), filter on rank


-- ============================================================
-- LEVEL 4 — HARD (Multi-step analysis, real interview style)
-- ============================================================

-- L4-1: COHORT RETENTION
--       Group customers by the quarter they first ordered (their cohort).
--       For each cohort, show how many customers also ordered in the
--       following quarter (retained).
--       Show cohort_quarter, cohort_size, retained_count, retention_pct.
-- CONCEPTS: CTE chain, date truncation, self-join or conditional aggregation


-- L4-2: REPEAT PURCHASE RATE
--       What % of customers who made their first purchase in 2023
--       came back to make a second purchase within 90 days?
--       Show total first-time buyers, how many returned, and the rate.
-- CONCEPTS: CTE, ROW_NUMBER(), date arithmetic with julianday()


-- L4-3: PRODUCT AFFINITY
--       Which pairs of products are most frequently bought together
--       in the same order?
--       Show product_1, product_2, and times_bought_together.
--       Top 10 pairs only.
-- CONCEPTS: Self-join on order_items, GROUP BY two product columns


-- L4-4: REVENUE CONTRIBUTION
--       For each completed order, calculate what % of that customer's
--       total lifetime revenue that order represents.
--       Show order_id, customer name, order_revenue, lifetime_revenue, pct.
-- CONCEPTS: Window function SUM() OVER (PARTITION BY customer)


-- L4-5: CHURN INDICATOR
--       A customer is considered "churned" if they haven't placed
--       an order in the last 180 days (relative to the most recent
--       order date in the dataset).
--       Show each customer's name, last order date, days since last order,
--       and a status column: 'Active', 'At Risk' (90-179 days), or 'Churned'.
-- CONCEPTS: MAX() OVER or subquery, julianday(), CASE WHEN


-- ============================================================
-- ANSWER KEY
-- (Try yourself first — answers in answers.sql)
-- ============================================================
