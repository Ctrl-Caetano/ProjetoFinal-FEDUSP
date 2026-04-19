with unique_values as (
    select distinct "CLASSI_FIN" as classificacao
    from {{ ref('stg_dengue') }}
    where "CLASSI_FIN" is not null
)

select
    {{ dbt_utils.generate_surrogate_key(['classificacao']) }} as classificacao_sk,
    classificacao
from unique_values
