MODEL (
  name jaffle_shop.staging.stg_locations,
  kind FULL,
  cron '@daily',
  description 'List of open locations with basic cleaning and transformation applied, one row per location',
  columns (
    location_id STRING COMMENT 'The unique key for each location',
    location_name STRING COMMENT 'Location name',
    tax_rate FLOAT COMMENT 'Tax rate for the location',
    opened_date DATE COMMENT 'Date the location opened'
  )
);

SELECT
  -- ids
  id AS location_id,
  -- text
  name AS location_name,
  -- numerics
  tax_rate,
  -- timestamps
  opened_at::date AS opened_date
FROM 
 jaffle_shop.raw.raw_stores