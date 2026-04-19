select
    {{ dbt_utils.generate_surrogate_key(['"ID_UNIDADE"']) }} as unidade_sk,
    "ID_UNIDADE" as id_unidade
from (select distinct "ID_UNIDADE" from {{ ref('stg_dengue') }} where "ID_UNIDADE" is not null) t
