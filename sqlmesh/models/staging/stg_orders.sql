MODEL (
  name jaffle_shop.staging.stg_orders,
  kind FULL,
  cron '@daily',
  description 'Order data with basic cleaning and transformation applied, one row per order',
  columns (
    order_id STRING COMMENT 'The unique key for each order',
    location_id STRING COMMENT 'The location where the order was placed',
    customer_id STRING COMMENT 'The customer who placed the order',
    subtotal_cents INTEGER COMMENT 'Subtotal in cents',
    tax_paid_cents INTEGER COMMENT 'Tax paid in cents',
    order_total_cents INTEGER COMMENT 'Order total in cents',
    subtotal FLOAT COMMENT 'Subtotal in dollars',
    tax_paid FLOAT COMMENT 'Tax paid in dollars',
    order_total FLOAT COMMENT 'Order total in dollars',
    ordered_at TIMESTAMP COMMENT 'Date the order was placed'
  )
);

SELECT
  -- ids
  id AS order_id,
  store_id AS location_id,
  customer AS customer_id,

  -- numerics
  subtotal AS subtotal_cents,
  tax_paid AS tax_paid_cents,
  order_total AS order_total_cents,
  @cents_to_dollars(subtotal) AS subtotal,
  @cents_to_dollars(tax_paid) AS tax_paid,
  @cents_to_dollars(order_total) AS order_total,

  -- timestamps
  ordered_at::date AS ordered_at
FROM 
  jaffle_shop.raw.raw_orders
