{{ config(materialized='view') }}

-- show top 10 products sold (assuming number of products)
SELECT
    product_sku as product_sku,
    count(product_sku) as count_sold
FROM {{ ref('fct_transactions') }} 
WHERE status = 'accepted'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
