{{ config(materialized='incremental') }}

SELECT
    t.id,
    t.device_id,
    d.store_id, --store_id was missing originally, but I add it to fact table for easier queries
    t.product_sku,
    t.amount,
    t.status,
    t.card_number,
    t.cvv,
    t.created_at,
    t.happened_at
FROM {{ ref('transaction') }} t
LEFT JOIN {{ ref('device') }} d
    ON t.device_id = d.id
WHERE happened_at >= created_at -- I assume the transaction is only valid if it happened (aka concluded) after it was created
{% if is_incremental() %}
    AND happened_at > (SELECT max(happened_at) FROM {{ this }} ) --I incrementally add rows to this table based on the last existing date
{% endif %}

