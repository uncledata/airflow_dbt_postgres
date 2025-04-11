MODEL (
  name jaffle_shop.marts.supplies,
  kind FULL,
  cron '@daily',
  description 'Supplies dimension table. The grain of the table is one row per supply and product combination',
  columns (
    supply_uuid STRING COMMENT 'The unique key of our supplies per cost',
    supply_id STRING COMMENT 'Supply identifier',
    product_id STRING COMMENT 'Product identifier',
    supply_name STRING COMMENT 'Supply name',
    supply_cost FLOAT COMMENT 'Supply cost in dollars',
    is_perishable_supply BOOLEAN COMMENT 'Whether the supply is perishable'
  )
);

SELECT * FROM jaffle_shop.staging.stg_supplies