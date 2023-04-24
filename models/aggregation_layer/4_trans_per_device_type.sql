{{ config(materialized='view') }}

-- show Pctg of transactions (assuming count) per device type
SELECT
    dd.type as device_type,
    (count(ft.amount) / SUM(count(ft.amount)) OVER ()) * 100 as percentage_of_count
FROM {{ ref('dim_devices') }} dd
LEFT JOIN {{ ref('fct_transactions') }} ft
    ON dd.id = ft.device_id
WHERE ft.status = 'accepted'
GROUP BY 1
ORDER BY 2 DESC
