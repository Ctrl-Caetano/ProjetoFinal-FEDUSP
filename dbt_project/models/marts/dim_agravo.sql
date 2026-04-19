select
    {{ dbt_utils.generate_surrogate_key(['"ID_AGRAVO"']) }} as agravo_sk,
    "ID_AGRAVO" as id_agravo
from (select distinct "ID_AGRAVO" from {{ ref('stg_dengue') }} where "ID_AGRAVO" is not null) t
