with unique_patients as (
    select distinct
        "NU_IDADE_N",
        "CS_SEXO",
        "CS_RACA"
    from {{ ref('stg_dengue') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['"NU_IDADE_N"', '"CS_SEXO"', '"CS_RACA"']) }} as patient_sk,
    "NU_IDADE_N" as idade,
    "CS_SEXO" as sexo,
    "CS_RACA" as raca
from unique_patients
