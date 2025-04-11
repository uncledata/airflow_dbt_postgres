MODEL (
  name jaffle_shop.marts.order_items,
  kind FULL,
  cron '@daily',
  description 'Items contained in each order. The grain of the table is one row per order item',
  columns (
    order_item_id STRING COMMENT 'The unique key for each order item',
    order_id STRING COMMENT 'The corresponding order ID',
    product_id STRING COMMENT 'The product ID',
    ordered_at TIMESTAMP COMMENT 'Date the order was placed',
    product_name STRING COMMENT 'Product name',
    product_price FLOAT COMMENT 'Product price in dollars',
    is_food_item BOOLEAN COMMENT 'Whether the product is a food item',
    is_drink_item BOOLEAN COMMENT 'Whether the product is a drink item',
    supply_cost FLOAT COMMENT 'Supply cost in dollars'
  ),

);

WITH order_supplies_summary AS (
  SELECT
    product_id,
    SUM(supply_cost) AS supply_cost
  FROM jaffle_shop.marts.supplies
  GROUP BY 1
)

SELECT
  oi.order_item_id,
  oi.order_id,
  oi.product_id,
  o.ordered_at,
  p.product_name,
  p.product_price,
  p.is_food_item,
  p.is_drink_item,
  oss.supply_cost
FROM 
  jaffle_shop.staging.stg_order_items oi
  LEFT JOIN jaffle_shop.staging.stg_orders o ON oi.order_id = o.order_id
  LEFT JOIN jaffle_shop.staging.stg_products p ON oi.product_id = p.product_id
  LEFT JOIN order_supplies_summary oss ON oi.product_id = oss.product_id