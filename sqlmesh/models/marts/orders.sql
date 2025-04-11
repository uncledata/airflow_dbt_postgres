MODEL (
  name jaffle_shop.marts.orders,
  kind FULL,
  cron '@daily',
  description 'Order overview data mart, offering key details for each order including if it is a customer''s first order and a food vs. drink item breakdown. One row per order',
  columns (
    order_id STRING COMMENT 'The unique key of the orders mart',
    customer_id STRING COMMENT 'The foreign key relating to the customer who placed the order',
    location_id STRING COMMENT 'The location where the order was placed',
    order_total FLOAT COMMENT 'The total amount of the order in USD including tax',
    subtotal FLOAT COMMENT 'The subtotal amount of the order in USD excluding tax',
    tax_paid FLOAT COMMENT 'The tax amount paid for the order in USD',
    ordered_at TIMESTAMP COMMENT 'The timestamp the order was placed at',
    order_cost FLOAT COMMENT 'The sum of supply expenses to fulfill the order',
    order_items_subtotal FLOAT COMMENT 'The sum of item prices in the order',
    count_food_items INTEGER COMMENT 'The number of food items in the order',
    count_drink_items INTEGER COMMENT 'The number of drink items in the order',
    count_order_items INTEGER COMMENT 'The total number of items in the order',
    is_food_order BOOLEAN COMMENT 'A boolean indicating if this order included any food items',
    is_drink_order BOOLEAN COMMENT 'A boolean indicating if this order included any drink items',
    customer_order_number INTEGER COMMENT 'The chronological order number for this customer'
  ),

);

WITH order_items_summary AS (
  SELECT
    order_id,
    SUM(supply_cost) AS order_cost,
    SUM(product_price) AS order_items_subtotal,
    COUNT(order_item_id) AS count_order_items,
    SUM(CASE WHEN is_food_item THEN 1 ELSE 0 END) AS count_food_items,
    SUM(CASE WHEN is_drink_item THEN 1 ELSE 0 END) AS count_drink_items
  FROM jaffle_shop.marts.order_items
  GROUP BY 1
),

compute_booleans AS (
  SELECT
    o.*,
    ois.order_cost,
    ois.order_items_subtotal,
    ois.count_food_items,
    ois.count_drink_items,
    ois.count_order_items,
    ois.count_food_items > 0 AS is_food_order,
    ois.count_drink_items > 0 AS is_drink_order
  FROM jaffle_shop.staging.stg_orders o
  LEFT JOIN order_items_summary ois ON o.order_id = ois.order_id
)

SELECT
  *,
  ROW_NUMBER() OVER (
    PARTITION BY customer_id
    ORDER BY ordered_at ASC
  ) AS customer_order_number
FROM compute_booleans