MODEL (
  name jaffle_shop.marts.products,
  kind FULL,
  cron '@daily',
  description 'Product dimension table. The grain of the table is one row per product',
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

SELECT * FROM jaffle_shop.staging.stg_products