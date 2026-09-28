/* ============================================================
   RETAILPULSE BI — SQL ANALYSIS
   Database: retailpulse.db (SQLite)
   Table   : orders   (cleaned data — see Data_Audit sheet for what was removed/fixed)
   ============================================================
   How to run this file:
   1. Install "DB Browser for SQLite" (free) -> https://sqlitebrowser.org
   2. Open retailpulse.db in DB Browser
   3. Go to the "Execute SQL" tab, paste a query below, click the Run (▶) button
   ============================================================ */


/* ------------------------------------------------------------
   CORE QUERIES (1–6, as required by the project brief)
   ------------------------------------------------------------ */

-- Query 1: Total Revenue
SELECT
    ROUND(SUM(quantity * unit_price * (1 - discount)), 2) AS total_revenue
FROM orders;


-- Query 2: Total Profit
-- (cost column already stores the TOTAL cost for that order line)
SELECT
    ROUND(SUM(
        (quantity * unit_price * (1 - discount)) - cost
    ), 2) AS total_profit
FROM orders;


-- Query 3: Revenue by Category
SELECT
    category,
    ROUND(SUM(quantity * unit_price * (1 - discount)), 2) AS revenue
FROM orders
GROUP BY category
ORDER BY revenue DESC;


-- Query 4: Profit by Region
SELECT
    region,
    ROUND(SUM(
        (quantity * unit_price * (1 - discount)) - cost
    ), 2) AS profit
FROM orders
GROUP BY region
ORDER BY profit DESC;


-- Query 5: Top 10 Products by Revenue
SELECT
    product_name,
    SUM(quantity) AS units_sold,
    ROUND(SUM(quantity * unit_price * (1 - discount)), 2) AS revenue
FROM orders
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 10;


-- Query 6: Monthly Revenue Trend
SELECT
    strftime('%Y-%m', order_date) AS month,
    ROUND(SUM(quantity * unit_price * (1 - discount)), 2) AS revenue
FROM orders
GROUP BY month
ORDER BY month;


/* ------------------------------------------------------------
   ADDITIONAL REQUIRED QUERIES (7–10, to round out the KPI set)
   ------------------------------------------------------------ */

-- Query 7: Average Order Value
SELECT
    ROUND(SUM(quantity * unit_price * (1 - discount)) / COUNT(*), 2) AS avg_order_value
FROM orders;


-- Query 8: Top 10 Customers by Revenue
SELECT
    customer_id,
    ROUND(SUM(quantity * unit_price * (1 - discount)), 2) AS revenue,
    COUNT(*) AS orders
FROM orders
GROUP BY customer_id
ORDER BY revenue DESC
LIMIT 10;


-- Query 9: Sales Channel Comparison (Online vs Store)
SELECT
    sales_channel,
    ROUND(SUM(quantity * unit_price * (1 - discount)), 2) AS revenue,
    ROUND(SUM((quantity * unit_price * (1 - discount)) - cost), 2) AS profit,
    COUNT(*) AS orders
FROM orders
GROUP BY sales_channel
ORDER BY revenue DESC;


-- Query 10: Profit Margin by Category (lowest margin first = needs attention)
SELECT
    category,
    ROUND(SUM(quantity * unit_price * (1 - discount)), 2) AS revenue,
    ROUND(SUM((quantity * unit_price * (1 - discount)) - cost), 2) AS profit,
    ROUND(
        SUM((quantity * unit_price * (1 - discount)) - cost) * 100.0
        / SUM(quantity * unit_price * (1 - discount)), 2
    ) AS profit_margin_pct
FROM orders
GROUP BY category
ORDER BY profit_margin_pct ASC;


/* ------------------------------------------------------------
   INTERMEDIATE / ADVANCED QUERIES (3 independently designed queries,
   using CASE, subqueries/CTE, JOIN-style logic, HAVING)
   ------------------------------------------------------------ */

-- Advanced Query 1: Products with HIGH sales but WEAK profitability
-- (high revenue, but margin below the overall average margin)
WITH product_stats AS (
    SELECT
        product_name,
        SUM(quantity * unit_price * (1 - discount)) AS revenue,
        SUM((quantity * unit_price * (1 - discount)) - cost) AS profit
    FROM orders
    GROUP BY product_name
),
overall AS (
    SELECT
        SUM((quantity * unit_price * (1 - discount)) - cost) * 1.0
        / SUM(quantity * unit_price * (1 - discount)) AS overall_margin
    FROM orders
)
SELECT
    p.product_name,
    ROUND(p.revenue, 2) AS revenue,
    ROUND(p.profit, 2) AS profit,
    ROUND(p.profit / p.revenue, 4) AS margin,
    ROUND(o.overall_margin, 4) AS company_avg_margin
FROM product_stats p, overall o
WHERE p.profit / p.revenue < o.overall_margin
ORDER BY p.revenue DESC
LIMIT 10;


-- Advanced Query 2: Classify every order into a revenue tier using CASE,
-- then see how many orders and how much revenue fall in each tier
SELECT
    CASE
        WHEN quantity * unit_price * (1 - discount) < 2000  THEN '1. Low (< 2,000)'
        WHEN quantity * unit_price * (1 - discount) < 6000  THEN '2. Medium (2,000-6,000)'
        WHEN quantity * unit_price * (1 - discount) < 12000 THEN '3. High (6,000-12,000)'
        ELSE '4. Premium (12,000+)'
    END AS order_value_tier,
    COUNT(*) AS number_of_orders,
    ROUND(SUM(quantity * unit_price * (1 - discount)), 2) AS total_revenue
FROM orders
GROUP BY order_value_tier
ORDER BY order_value_tier;


-- Advanced Query 3: Customers who ordered more than once AND whose
-- average order value is above the company-wide average order value
-- (subquery in HAVING + subquery in WHERE)
SELECT
    customer_id,
    COUNT(*) AS orders,
    ROUND(AVG(quantity * unit_price * (1 - discount)), 2) AS avg_order_value
FROM orders
WHERE customer_id <> 'Unknown Customer'
GROUP BY customer_id
HAVING COUNT(*) > 1
   AND AVG(quantity * unit_price * (1 - discount)) > (
        SELECT AVG(quantity * unit_price * (1 - discount)) FROM orders
   )
ORDER BY avg_order_value DESC;
