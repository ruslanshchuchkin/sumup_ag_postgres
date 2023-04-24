{{ config(materialized='view') }}

-- show transacted amount per typology and country
SELECT
    ds.typology,
    ds.country,
    avg(ft.amount) as avg_amount
FROM {{ ref('dim_stores') }} ds
LEFT JOIN {{ ref('fct_transactions') }}  ft
    ON ds.id = ft.device_id
WHERE ft.status = 'accepted'
GROUP BY 1, 2
ORDER BY 3 DESC
