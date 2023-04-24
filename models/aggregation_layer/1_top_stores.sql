{{ config(materialized='view') }}

-- show top 10 stores per transacted amount
SELECT
    ds.id as store_id,
    ds.name as store_name,
    sum(ft.amount) as transacted_amount
FROM {{ ref('dim_stores') }} ds
LEFT JOIN {{ ref('fct_transactions') }}  ft
    ON ds.id = ft.device_id
WHERE ft.status = 'accepted'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10
