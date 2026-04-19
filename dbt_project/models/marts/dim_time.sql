with dates as (
    select distinct "DT_NOTIFIC" as date_value from {{ ref('stg_dengue') }} where "DT_NOTIFIC" is not null
    union
    select distinct "DT_SIN_PRI" from {{ ref('stg_dengue') }} where "DT_SIN_PRI" is not null
    union
    select distinct "DT_OBITO" from {{ ref('stg_dengue') }} where "DT_OBITO" is not null
)

select
    {{ dbt_utils.generate_surrogate_key(['date_value']) }} as time_sk,
    date_value as date_str
from dates
