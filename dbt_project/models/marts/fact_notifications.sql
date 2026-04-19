select
    {{ dbt_utils.generate_surrogate_key(['"TP_NOT"', '"DT_NOTIFIC"', '"SG_UF_NOT"', '"ID_MUNICIP"']) }} as notification_sk,
    {{ dbt_utils.generate_surrogate_key(['"DT_NOTIFIC"']) }} as time_sk,
    {{ dbt_utils.generate_surrogate_key(['"SG_UF_NOT"', '"ID_MUNICIP"']) }} as location_sk,
    {{ dbt_utils.generate_surrogate_key(['"NU_IDADE_N"', '"CS_SEXO"', '"CS_RACA"']) }} as patient_sk,
    "TP_NOT" as tipo_notificacao,
    "CLASSI_FIN" as classificacao,
    "EVOLUCAO" as evolucao,
    "HOSPITALIZ" as hospitalizado,
    case when "DT_OBITO" is not null then 1 else 0 end as flag_obito
from {{ ref('stg_dengue') }}
