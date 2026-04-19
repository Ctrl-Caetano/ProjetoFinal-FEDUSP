select
    {{ dbt_utils.generate_surrogate_key(['"TP_NOT"']) }} as tp_not_sk,
    "TP_NOT" as tp_not
from (select distinct "TP_NOT" from {{ ref('stg_dengue') }} where "TP_NOT" is not null) t
