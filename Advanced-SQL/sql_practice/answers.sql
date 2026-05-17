-- ============================================================
-- ANSWER KEY — E-COMMERCE SQL PRACTICE
-- ============================================================
-- Try the challenges yourself before looking here!
-- ============================================================


-- ============================================================
-- LEVEL 1 ANSWERS
-- ============================================================

-- L1-1: Order count per customer
SELECT
    c.first_name || ' ' || c.last_name AS full_name,
    c.email,
    COUNT(o.order_id)                  AS order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
ORDER BY order_count DESC;


-- L1-2: Total revenue per category (completed orders only)
SELECT
    cat.category_name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM order_items oi
JOIN orders     o   ON oi.order_id    = o.order_id
JOIN products   p   ON oi.product_id  = p.product_id
JOIN categories cat ON p.category_id  = cat.category_id
WHERE o.status = 'completed'
GROUP BY cat.category_id, cat.category_name
ORDER BY total_revenue DESC;


-- L1-3: Top 5 products by profit margin
SELECT
    product_name,
    price,
    cost,
    ROUND(((price - cost) / price) * 100, 2) AS margin_pct
FROM products
ORDER BY margin_pct DESC
LIMIT 5;


-- L1-4: Customer signups per month in 2023
SELECT
    strftime('%Y-%m', signup_date) AS year_month,
    COUNT(*)                       AS signups
FROM customers
WHERE signup_date BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY year_month
ORDER BY year_month;


-- ============================================================
-- LEVEL 2 ANSWERS
-- ============================================================

-- L2-1: Customers with 3+ orders and avg order value > $100
WITH order_values AS (
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * oi.unit_price) AS order_value
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id, o.customer_id
),
customer_stats AS (
    SELECT
        customer_id,
        COUNT(order_id)       AS order_count,
        AVG(order_value)      AS avg_order_value
    FROM order_values
    GROUP BY customer_id
    HAVING order_count > 3
       AND avg_order_value > 100
)
SELECT
    c.first_name || ' ' || c.last_name AS full_name,
    cs.order_count,
    ROUND(cs.avg_order_value, 2)        AS avg_order_value
FROM customer_stats cs
JOIN customers c ON cs.customer_id = c.customer_id
ORDER BY cs.avg_order_value DESC;


-- L2-2: Most and least expensive product per category
WITH ranked AS (
    SELECT
        cat.category_name,
        p.product_name,
        p.price,
        MAX(p.price) OVER (PARTITION BY cat.category_id) AS max_price,
        MIN(p.price) OVER (PARTITION BY cat.category_id) AS min_price
    FROM products p
    JOIN categories cat ON p.category_id = cat.category_id
)
SELECT DISTINCT
    r.category_name,
    most.product_name  AS most_expensive,
    most.price         AS highest_price,
    least.product_name AS least_expensive,
    least.price        AS lowest_price
FROM ranked r
JOIN products most  ON most.price  = r.max_price  AND most.category_id  = (SELECT category_id FROM categories WHERE category_name = r.category_name)
JOIN products least ON least.price = r.min_price  AND least.category_id = (SELECT category_id FROM categories WHERE category_name = r.category_name)
ORDER BY r.category_name;

-- Simpler alternative:
WITH extremes AS (
    SELECT
        cat.category_name,
        MAX(p.price) AS max_price,
        MIN(p.price) AS min_price
    FROM products p
    JOIN categories cat ON p.category_id = cat.category_id
    GROUP BY cat.category_id, cat.category_name
)
SELECT
    e.category_name,
    pmax.product_name AS most_expensive,
    e.max_price,
    pmin.product_name AS least_expensive,
    e.min_price
FROM extremes e
JOIN products pmax ON pmax.price = e.max_price
    AND pmax.category_id = (SELECT category_id FROM categories WHERE category_name = e.category_name)
JOIN products pmin ON pmin.price = e.min_price
    AND pmin.category_id = (SELECT category_id FROM categories WHERE category_name = e.category_name)
ORDER BY e.category_name;


-- L2-3: Month with highest revenue in 2024
WITH monthly AS (
    SELECT
        strftime('%Y-%m', o.order_date)          AS month,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue,
        COUNT(DISTINCT o.order_id)               AS order_count
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
      AND o.status = 'completed'
    GROUP BY month
)
SELECT month, total_revenue, order_count
FROM monthly
ORDER BY total_revenue DESC
LIMIT 1;


-- L2-4: Customers who have never ordered
SELECT
    c.first_name || ' ' || c.last_name AS full_name,
    c.email,
    c.signup_date,
    c.city
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
ORDER BY c.signup_date;


-- L2-5: Return/cancel rate by category
WITH order_status AS (
    SELECT
        cat.category_name,
        o.order_id,
        o.status,
        CASE WHEN o.status IN ('returned', 'cancelled') THEN 1 ELSE 0 END AS is_bad
    FROM orders o
    JOIN order_items oi  ON o.order_id   = oi.order_id
    JOIN products p      ON oi.product_id = p.product_id
    JOIN categories cat  ON p.category_id = cat.category_id
)
SELECT
    category_name,
    COUNT(DISTINCT order_id)                           AS total_orders,
    SUM(is_bad)                                        AS bad_orders,
    ROUND(SUM(is_bad) * 100.0 / COUNT(DISTINCT order_id), 1) AS bad_pct
FROM order_status
GROUP BY category_name
ORDER BY bad_pct DESC;


-- ============================================================
-- LEVEL 3 ANSWERS
-- ============================================================

-- L3-1: Rank customers by total spend
WITH spend AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name          AS full_name,
        ROUND(SUM(oi.quantity * oi.unit_price), 2)   AS total_spend
    FROM customers c
    JOIN orders     o  ON c.customer_id  = o.customer_id
    JOIN order_items oi ON o.order_id    = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY c.customer_id, full_name
)
SELECT
    RANK() OVER (ORDER BY total_spend DESC) AS spend_rank,
    full_name,
    total_spend
FROM spend;


-- L3-2: Running total revenue by order date
WITH order_revenue AS (
    SELECT
        o.order_id,
        o.order_date,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS order_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY o.order_id, o.order_date
)
SELECT
    order_id,
    order_date,
    order_revenue,
    ROUND(SUM(order_revenue) OVER (
        ORDER BY order_date, order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2) AS running_total
FROM order_revenue
ORDER BY order_date, order_id;


-- L3-3: Order number and days since previous order per customer
WITH ordered AS (
    SELECT
        o.customer_id,
        o.order_id,
        o.order_date,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id
            ORDER BY o.order_date
        ) AS order_num,
        LAG(o.order_date) OVER (
            PARTITION BY o.customer_id
            ORDER BY o.order_date
        ) AS prev_order_date
    FROM orders o
    WHERE o.status = 'completed'
)
SELECT
    customer_id,
    order_id,
    order_date,
    order_num,
    CASE
        WHEN prev_order_date IS NULL THEN NULL
        ELSE CAST(julianday(order_date) - julianday(prev_order_date) AS INTEGER)
    END AS days_since_prev
FROM ordered
ORDER BY customer_id, order_num;


-- L3-4: Monthly revenue per product with MoM change
WITH monthly AS (
    SELECT
        p.product_id,
        p.product_name,
        strftime('%Y-%m', o.order_date)            AS month,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
    FROM order_items oi
    JOIN orders   o ON oi.order_id   = o.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.status = 'completed'
    GROUP BY p.product_id, p.product_name, month
)
SELECT
    product_name,
    month,
    revenue,
    LAG(revenue) OVER (PARTITION BY product_id ORDER BY month) AS prev_month_revenue,
    ROUND(revenue - LAG(revenue) OVER (PARTITION BY product_id ORDER BY month), 2) AS mom_change,
    ROUND(
        (revenue - LAG(revenue) OVER (PARTITION BY product_id ORDER BY month))
        / LAG(revenue) OVER (PARTITION BY product_id ORDER BY month) * 100
    , 1) AS mom_change_pct
FROM monthly
ORDER BY product_name, month;


-- L3-5: Customer spend quartiles (Bronze/Silver/Gold/Platinum)
WITH spend AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name        AS full_name,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_spend
    FROM customers c
    JOIN orders     o  ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id   = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY c.customer_id, full_name
)
SELECT
    full_name,
    total_spend,
    NTILE(4) OVER (ORDER BY total_spend) AS quartile,
    CASE NTILE(4) OVER (ORDER BY total_spend)
        WHEN 1 THEN 'Bronze'
        WHEN 2 THEN 'Silver'
        WHEN 3 THEN 'Gold'
        WHEN 4 THEN 'Platinum'
    END AS tier
FROM spend
ORDER BY total_spend DESC;


-- L3-6: Top 3 products by revenue within each category
WITH product_revenue AS (
    SELECT
        cat.category_name,
        p.product_name,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue,
        RANK() OVER (
            PARTITION BY cat.category_id
            ORDER BY SUM(oi.quantity * oi.unit_price) DESC
        ) AS category_rank
    FROM order_items oi
    JOIN orders     o   ON oi.order_id   = o.order_id
    JOIN products   p   ON oi.product_id = p.product_id
    JOIN categories cat ON p.category_id = cat.category_id
    WHERE o.status = 'completed'
    GROUP BY cat.category_id, cat.category_name, p.product_id, p.product_name
)
SELECT category_name, product_name, revenue, category_rank
FROM product_revenue
WHERE category_rank <= 3
ORDER BY category_name, category_rank;


-- ============================================================
-- LEVEL 4 ANSWERS
-- ============================================================

-- L4-1: Cohort retention (quarter-over-quarter)
WITH first_orders AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_order_date,
        strftime('%Y-Q', MIN(order_date)) ||
            CASE
                WHEN CAST(strftime('%m', MIN(order_date)) AS INT) BETWEEN 1  AND 3  THEN '1'
                WHEN CAST(strftime('%m', MIN(order_date)) AS INT) BETWEEN 4  AND 6  THEN '2'
                WHEN CAST(strftime('%m', MIN(order_date)) AS INT) BETWEEN 7  AND 9  THEN '3'
                ELSE '4'
            END AS cohort_quarter
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
),
next_quarter_orders AS (
    SELECT DISTINCT
        f.customer_id,
        f.cohort_quarter
    FROM first_orders f
    JOIN orders o ON f.customer_id = o.customer_id
        AND o.status = 'completed'
        AND julianday(o.order_date) > julianday(f.first_order_date)
        AND julianday(o.order_date) <= julianday(f.first_order_date) + 92
)
SELECT
    f.cohort_quarter,
    COUNT(DISTINCT f.customer_id)                        AS cohort_size,
    COUNT(DISTINCT nq.customer_id)                       AS retained_count,
    ROUND(COUNT(DISTINCT nq.customer_id) * 100.0 /
          COUNT(DISTINCT f.customer_id), 1)              AS retention_pct
FROM first_orders f
LEFT JOIN next_quarter_orders nq ON f.customer_id = nq.customer_id
GROUP BY f.cohort_quarter
ORDER BY f.cohort_quarter;


-- L4-2: Repeat purchase rate within 90 days (2023 first-time buyers)
WITH first_purchases AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_order_date
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
    HAVING first_order_date BETWEEN '2023-01-01' AND '2023-12-31'
),
second_purchases AS (
    SELECT DISTINCT
        fp.customer_id
    FROM first_purchases fp
    JOIN orders o ON fp.customer_id = o.customer_id
        AND o.status = 'completed'
        AND o.order_date > fp.first_order_date
        AND julianday(o.order_date) - julianday(fp.first_order_date) <= 90
)
SELECT
    COUNT(DISTINCT fp.customer_id)                       AS first_time_buyers,
    COUNT(DISTINCT sp.customer_id)                       AS returned_within_90d,
    ROUND(COUNT(DISTINCT sp.customer_id) * 100.0 /
          COUNT(DISTINCT fp.customer_id), 1)             AS repeat_rate_pct
FROM first_purchases fp
LEFT JOIN second_purchases sp ON fp.customer_id = sp.customer_id;


-- L4-3: Product affinity — most frequently bought together
SELECT
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    COUNT(*)        AS times_bought_together
FROM order_items oi1
JOIN order_items oi2 ON  oi1.order_id   = oi2.order_id
                     AND oi1.product_id <  oi2.product_id
JOIN products p1     ON  oi1.product_id = p1.product_id
JOIN products p2     ON  oi2.product_id = p2.product_id
GROUP BY oi1.product_id, oi2.product_id
ORDER BY times_bought_together DESC
LIMIT 10;


-- L4-4: Each order as % of customer lifetime revenue
WITH order_revenue AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_date,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS order_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY o.order_id, o.customer_id, o.order_date
)
SELECT
    or_.order_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    or_.order_date,
    or_.order_revenue,
    ROUND(SUM(or_.order_revenue) OVER (PARTITION BY or_.customer_id), 2) AS lifetime_revenue,
    ROUND(or_.order_revenue * 100.0 /
          SUM(or_.order_revenue) OVER (PARTITION BY or_.customer_id), 1) AS pct_of_lifetime
FROM order_revenue or_
JOIN customers c ON or_.customer_id = c.customer_id
ORDER BY c.customer_id, or_.order_date;


-- L4-5: Churn status per customer
WITH last_orders AS (
    SELECT
        customer_id,
        MAX(order_date) AS last_order_date
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
),
dataset_max AS (
    SELECT MAX(order_date) AS max_date FROM orders
)
SELECT
    c.first_name || ' ' || c.last_name AS customer_name,
    lo.last_order_date,
    CAST(julianday((SELECT max_date FROM dataset_max))
       - julianday(lo.last_order_date) AS INTEGER)  AS days_since_last_order,
    CASE
        WHEN julianday((SELECT max_date FROM dataset_max))
           - julianday(lo.last_order_date) < 90  THEN 'Active'
        WHEN julianday((SELECT max_date FROM dataset_max))
           - julianday(lo.last_order_date) < 180 THEN 'At Risk'
        ELSE 'Churned'
    END AS status
FROM customers c
JOIN last_orders lo ON c.customer_id = lo.customer_id
ORDER BY days_since_last_order DESC;
