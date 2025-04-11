MODEL (
  name jaffle_shop.marts.locations,
  kind FULL,
  cron '@daily',
  description 'Location dimension table. The grain of the table is one row per location',
  columns (
    location_id STRING COMMENT 'The unique key for each location',
    location_name STRING COMMENT 'Location name',
    tax_rate FLOAT COMMENT 'Tax rate for the location',
    opened_date DATE COMMENT 'Date the location opened'
  )
);

SELECT * FROM jaffle_shop.staging.stg_locations