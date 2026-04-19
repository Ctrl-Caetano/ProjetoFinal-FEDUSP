select * from {{ ref('fact_notifications') }}
where flag_obito = 1 and time_sk is null
