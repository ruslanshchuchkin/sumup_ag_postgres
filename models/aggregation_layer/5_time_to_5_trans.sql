{{ config(materialized='view') }}

-- show average time for a store to get first 5 transactions
WITH time_ranked_transactions AS (
    SELECT
        store_id,
        created_at, -- I assume created_at would be a better indicator than happened_at
        ROW_NUMBER() OVER (PARTITION BY store_id ORDER BY created_at ASC) AS transaction_rank
    FROM {{ ref('fct_transactions') }} --I don't filter to only accepted transactions because it i assume it's not relevant here
),
first_five_transactions AS (
    SELECT
        store_id,
        created_at
    FROM time_ranked_transactions
    WHERE transaction_rank <= 5
),
store_first_and_last_transaction AS (
    SELECT
        store_id,
        MIN(created_at) AS first_transaction_time,
        MAX(created_at) AS fifth_transaction_time
    FROM first_five_transactions
    GROUP BY store_id
),
store_time_to_5_transactions AS (
    SELECT 
        store_id,
        --calculate the difference in seconds so we can take the average
        (EXTRACT(EPOCH FROM (first_transaction_time::timestamp - fifth_transaction_time::timestamp))) AS time_to_5_trans
    FROM store_first_and_last_transaction
)
SELECT 
    ROUND(AVG(time_to_5_trans) / 3600.0, 2) AS avg_to_5_trans_in_hours --convert to hours for readability
FROM store_time_to_5_transactions
