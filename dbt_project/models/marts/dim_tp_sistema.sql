select
    {{ dbt_utils.generate_surrogate_key(['"TP_SISTEMA"']) }} as tp_sistema_sk,
    "TP_SISTEMA" as tp_sistema
from (select distinct "TP_SISTEMA" from {{ ref('stg_dengue') }} where "TP_SISTEMA" is not null) t
