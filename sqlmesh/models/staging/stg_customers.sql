MODEL (
  name jaffle_shop.staging.stg_customers,
  kind FULL,
  cron '@daily',
  description 'Customer data with basic cleaning and transformation applied, one row per customer',
  columns (
    customer_id STRING COMMENT 'The unique key for each customer',
    customer_name STRING COMMENT 'Customer full name'
  )
);

SELECT
  -- ids
  id AS customer_id,
  -- text
  name AS customer_name
FROM 
  jaffle_shop.raw.raw_customers
