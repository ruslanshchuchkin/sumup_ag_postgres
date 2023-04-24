{{ config(materialized='table') }}

SELECT
    id,
    type
FROM {{ ref('device') }}
