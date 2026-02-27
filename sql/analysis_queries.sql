/* ============================================================
   E-COMMERCE DELIVERY ANALYSIS
   Author: Daniel Rangmyr

   Goal:
   Investigate whether delivery performance affects
   customer satisfaction and order value.

   Data source:
   Olist Brazilian E-commerce dataset

   Database:
   Microsoft SQL Server
   ============================================================ */

USE OlistDB;
GO

/* ------------------------------------------------------------
   STEP 1 — Create analysis table (delivered orders only)
   ------------------------------------------------------------ */

IF OBJECT_ID('orders_clean', 'U') IS NOT NULL
DROP TABLE orders_clean;
GO

SELECT *
INTO orders_clean
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;
GO


/* ------------------------------------------------------------
   STEP 2 — Convert timestamps to real datetime columns
   (raw data imported as text)
   ------------------------------------------------------------ */

ALTER TABLE orders_clean
ADD purchase_date DATETIME2,
    delivered_date DATETIME2;
GO

UPDATE orders_clean
SET
    purchase_date = TRY_CONVERT(datetime2, order_purchase_timestamp),
    delivered_date = TRY_CONVERT(datetime2, order_delivered_customer_date);
GO


/* ------------------------------------------------------------
   STEP 3 — Feature engineering: delivery time
   ------------------------------------------------------------ */

ALTER TABLE orders_clean
ADD delivery_days INT;
GO

UPDATE orders_clean
SET delivery_days = DATEDIFF(day, purchase_date, delivered_date);
GO


/* ------------------------------------------------------------
   STEP 4 — Delivery performance vs customer satisfaction
   ------------------------------------------------------------ */

SELECT
    r.review_score,
    AVG(o.delivery_days) AS avg_delivery_days,
    COUNT(*) AS number_of_orders
FROM orders_clean o
JOIN order_reviews r ON o.order_id = r.order_id
GROUP BY r.review_score
ORDER BY r.review_score;
GO


/* ------------------------------------------------------------
   STEP 5 — Calculate order value
   ------------------------------------------------------------ */

IF OBJECT_ID('order_value', 'U') IS NOT NULL
DROP TABLE order_value;
GO

SELECT
    order_id,
    SUM(price + freight_value) AS order_value
INTO order_value
FROM order_items
GROUP BY order_id;
GO


/* ------------------------------------------------------------
   STEP 6 — Satisfaction, delivery and revenue relationship
   ------------------------------------------------------------ */

SELECT
    r.review_score,
    AVG(o.delivery_days) AS avg_delivery_days,
    AVG(v.order_value) AS avg_order_value
FROM orders_clean o
JOIN order_value v ON o.order_id = v.order_id
JOIN order_reviews r ON o.order_id = r.order_id
GROUP BY r.review_score
ORDER BY r.review_score;
GO


/* ------------------------------------------------------------
   STEP 7 — Dataset for Power BI dashboard
   ------------------------------------------------------------ */

SELECT
    o.order_id,
    r.review_score,
    o.delivery_days,
    v.order_value,
    FORMAT(o.purchase_date, 'yyyy-MM') AS order_month
FROM orders_clean o
JOIN order_value v ON o.order_id = v.order_id
JOIN order_reviews r ON o.order_id = r.order_id;
GO