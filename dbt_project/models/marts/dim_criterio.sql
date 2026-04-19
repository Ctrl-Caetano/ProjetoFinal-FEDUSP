select
    {{ dbt_utils.generate_surrogate_key(['"CRITERIO"']) }} as criterio_sk,
    "CRITERIO" as criterio
from (select distinct "CRITERIO" from {{ ref('stg_dengue') }} where "CRITERIO" is not null) t
