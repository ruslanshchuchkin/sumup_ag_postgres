{{ config(materialized='table') }}

SELECT
    DISTINCT product_sku AS sku,
    --I assume both columns have some value, so I'm keeping both
    product_name AS product_name_1,
    product_name AS product_name_2
FROM {{ ref('transaction') }}
