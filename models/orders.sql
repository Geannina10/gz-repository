{{ config(
  schema='transaction'
) }}


WITH

  sales AS (SELECT * FROM `gz_dev_1_transaction.sales`)

  ,ship AS (SELECT * FROM `gz_raw_data.raw_gz_ship`)

   -- Aggregation --
  ,orders_from_sales AS (
    SELECT
      orders_id
			,date_date
      ,SUM(turnover) AS turnover
      ,SUM(purchase_price) AS purchase_price
      ,SUM(product_margin) AS product_margin
    FROM sales
    GROUP BY
      orders_id
			, date_date
  )

  -- Join --
  ,orders_join AS (
    SELECT
      orders_id
			,date_date
      -- revenue metrics --
      ,turnover
      ,purchase_price
      ,product_margin
      -- log & ship metrics --
      ,shipping_fee
      ,ship_cost
      ,logCost as log_cost
    FROM orders_from_sales
    LEFT JOIN ship USING (orders_id))

  -- enrichment --
  ,operational_margin AS (
    SELECT
      *
      , IFNULL(CAST(product_margin AS FLOAT64), 0) + IFNULL(shipping_fee, 0) - IFNULL(CAST(logCost AS FLOAT64), 0) AS operational_margin
    FROM orders_from_sales
    LEFT JOIN ship USING (orders_id)
  )

SELECT * FROM operational_margin
