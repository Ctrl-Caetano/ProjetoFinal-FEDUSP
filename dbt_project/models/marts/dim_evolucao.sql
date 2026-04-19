with unique_values as (
    select distinct "EVOLUCAO" as evolucao
    from {{ ref('stg_dengue') }}
    where "EVOLUCAO" is not null
)

select
    {{ dbt_utils.generate_surrogate_key(['evolucao']) }} as evolucao_sk,
    evolucao
from unique_values
