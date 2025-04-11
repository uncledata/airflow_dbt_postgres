MODEL (
  name jaffle_shop.marts.customers,
  kind FULL,
  cron '@daily',
  description 'Customer overview data mart, offering key details for each unique customer. One row per customer',
  columns (
    customer_id STRING COMMENT 'The unique key of the customers mart',
    customer_name STRING COMMENT 'Customers full name',
    count_lifetime_orders INTEGER COMMENT 'Total number of orders a customer has ever placed',
    is_repeat_buyer BOOLEAN COMMENT 'Whether the customer has placed more than one order',
    first_ordered_at TIMESTAMP COMMENT 'The timestamp when a customer placed their first order',
    last_ordered_at TIMESTAMP COMMENT 'The timestamp of a customer most recent order',
    lifetime_spend_pretax FLOAT COMMENT 'The sum of all the pre-tax subtotals of every order a customer has placed',
    lifetime_tax_paid FLOAT COMMENT 'The sum of all the tax portion of every order a customer has placed',
    lifetime_spend FLOAT COMMENT 'The sum of all the order totals (including tax) that a customer has ever placed',
    customer_type STRING COMMENT 'Options are new or returning, indicating if a customer has ordered more than once or has only placed their first order to date'
  ),
  audits (
    /* Primary key validation */
    not_null(columns := (customer_id)),
    unique_values(columns := (customer_id)),
    
    /* Data integrity checks */
    forall(criteria := (
      ABS(lifetime_spend_pretax + lifetime_tax_paid - lifetime_spend) < 0.01
    )),
    
    /* Categorical values validation */
    accepted_values(column := customer_type, is_in := ('new', 'returning')),
    
    /* Logical consistency checks */
    forall(criteria := (
      (customer_type = 'returning' AND count_lifetime_orders > 1) OR 
      (customer_type = 'new' AND count_lifetime_orders <= 1)
    )),
    
    /* Temporal logic checks */
    forall(criteria := (
      (first_ordered_at IS NULL) OR (last_ordered_at IS NULL) OR (first_ordered_at <= last_ordered_at)
    )),
    
    /* Non-negative values for monetary fields */
    forall(criteria := (
      lifetime_spend_pretax >= 0
    )),
    forall(criteria := (
      lifetime_tax_paid >= 0
    )),
    forall(criteria := (
      lifetime_spend >= 0
    )),
    
    /* Check repeat buyer flag consistency */
    forall(criteria := (
      (is_repeat_buyer = TRUE AND count_lifetime_orders > 1) OR
      (is_repeat_buyer = FALSE AND count_lifetime_orders <= 1)
    ))
  )
);

WITH 
customer_orders_summary AS (
  SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS count_lifetime_orders,
    COUNT(DISTINCT order_id) > 1 AS is_repeat_buyer,
    MIN(ordered_at) AS first_ordered_at,
    MAX(ordered_at) AS last_ordered_at,
    SUM(subtotal) AS lifetime_spend_pretax,
    SUM(tax_paid) AS lifetime_tax_paid,
    SUM(order_total) AS lifetime_spend
  FROM jaffle_shop.marts.orders
  GROUP BY 1
)

SELECT
  c.*,
  COALESCE(cos.count_lifetime_orders, 0) AS count_lifetime_orders,
  COALESCE(cos.is_repeat_buyer, FALSE) AS is_repeat_buyer,
  cos.first_ordered_at,
  cos.last_ordered_at,
  COALESCE(cos.lifetime_spend_pretax, 0) AS lifetime_spend_pretax,
  COALESCE(cos.lifetime_tax_paid, 0) AS lifetime_tax_paid,
  COALESCE(cos.lifetime_spend, 0) AS lifetime_spend,
  CASE
    WHEN cos.is_repeat_buyer THEN 'returning'
    ELSE 'new'
  END AS customer_type
FROM jaffle_shop.staging.stg_customers c
LEFT JOIN customer_orders_summary cos
  ON c.customer_id = cos.customer_id