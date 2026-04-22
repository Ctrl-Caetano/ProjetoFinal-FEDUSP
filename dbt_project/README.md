# DBT - Projeto Dengue

Transformação de dados do SINAN (notificações de dengue 2021-2024).

## Como executar

```bash
# Instalar dependências
dbt deps

# Rodar transformações
dbt run

# Executar testes
dbt test

# Gerar documentação
dbt docs generate
dbt docs serve
```

## Estrutura

- `models/staging/` - Dados limpos da camada raw
- `models/marts/` - Star schema (1 fato + 10 dimensões)
- `macros/` - Funções reutilizáveis
- `tests/` - Validações customizadas

## Requisitos

- Dados carregados em `raw.dengue_notifications`
- PostgreSQL rodando em `localhost:5432`
- dbt-core e dbt-postgres instalados

## Modelos criados

**Staging:**
- stg_dengue

**Dimensões:**
- dim_time, dim_location, dim_patient
- dim_classificacao, dim_evolucao, dim_criterio
- dim_tp_not, dim_tp_sistema
- dim_agravo, dim_unidade

**Fato:**
- fact_notifications
