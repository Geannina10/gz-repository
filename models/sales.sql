{{ config(schema='transaction') }}

WITH 
sales AS (SELECT * FROM {{ ref('stg_sales') }} )
 -- sales AS (SELECT * FROM `gz_raw_data.raw_gz_sales`)--

  ,product AS (SELECT * FROM {{ ref('stg_product') }} )

SELECT
  s.date_date
  ### Key ###
  ,s.orders_id
  ,s.products_id
  ###########
	-- qty --
	,qty
  -- revenue --
  ,turnover
  -- cost --
  ,CAST(p.purchase_price AS FLOAT64) AS purchase_price
	,ROUND(s.qty*CAST(p.purchase_price AS FLOAT64),2) AS product_margin
	-- margin --
    ,{{ margin('s.turnover', 's.qty*CAST(p.purchase_price AS FLOAT64)') }} as margin
	--,s.revenue - s.quantity*CAST(p.purchSE_PRICE AS FLOAT64) AS margin--
    ,{{ margin_percent('s.turnover', 's.qty*CAST(p.purchase_price AS FLOAT64)') }} as margin_percent
FROM sales s
INNER JOIN product p ON s.products_id = p.products_id


