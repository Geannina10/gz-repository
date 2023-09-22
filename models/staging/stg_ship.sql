SELECT
orders_id
,shipping_fee
,logCost as log_cost
,CAST(ship_cost AS FLOAT64) as ship_cost
FROM `gz_raw_data.raw_gz_ship`