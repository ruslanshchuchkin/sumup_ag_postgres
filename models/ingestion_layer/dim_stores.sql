{{ config(materialized='table') }}

SELECT
    id,
    customer_id,
    name,
    address,
    city,
    country,
    typology,
    created_at
FROM {{ ref('store') }}
