with unique_locations as (
    select distinct
        "SG_UF_NOT",
        "ID_MUNICIP"
    from {{ ref('stg_dengue') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['"SG_UF_NOT"', '"ID_MUNICIP"']) }} as location_sk,
    "SG_UF_NOT" as uf_notificacao,
    "ID_MUNICIP" as codigo_municipio
from unique_locations
