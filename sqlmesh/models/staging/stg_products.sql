MODEL (
  name jaffle_shop.staging.stg_products,
  kind FULL,
  cron '@daily',
  description 'Product data with basic cleaning and transformation applied, one row per product',
  columns (
    product_id STRING COMMENT 'The unique key for each product',
    product_name STRING COMMENT 'Product name',
    product_type STRING COMMENT 'Product type',
    product_description STRING COMMENT 'Product description',
    product_price FLOAT COMMENT 'Product price in dollars',
    is_food_item BOOLEAN COMMENT 'Whether the product is a food item',
    is_drink_item BOOLEAN COMMENT 'Whether the product is a drink item'
  )
);

SELECT
  -- ids
  sku AS product_id,
  
  -- text
  name AS product_name,
  type AS product_type,
  description AS product_description,
  
  -- numerics
  @cents_to_dollars(price) AS product_price,
  
  -- booleans
  COALESCE(type = 'jaffle', FALSE) AS is_food_item,
  COALESCE(type = 'beverage', FALSE) AS is_drink_item
FROM 
  jaffle_shop.raw.raw_products