MODEL (
  name jaffle_shop.staging.stg_order_items,
  kind FULL,
  cron '@daily',
  description 'Individual food and drink items that make up our orders, one row per item',
  columns (
    order_item_id STRING COMMENT 'The unique key for each order item',
    order_id STRING COMMENT 'The corresponding order each order item belongs to',
    product_id STRING COMMENT 'The product identifier'
  )
);

SELECT
  -- ids
  id AS order_item_id,
  order_id,
  sku AS product_id
FROM 
  jaffle_shop.raw.raw_items