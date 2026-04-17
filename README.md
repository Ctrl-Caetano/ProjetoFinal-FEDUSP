# 🦟 Projeto de Engenharia de Dados  
## Monitoramento Epidemiológico de Dengue no Brasil (2021–2024)

---

# 📌 1. Storytelling (Problema de Negócio)

Nos últimos anos, o Brasil enfrentou sucessivos surtos de dengue, pressionando o sistema de saúde pública e exigindo respostas rápidas das autoridades.

A área de Vigilância Epidemiológica precisa monitorar, em tempo quase real, a evolução dos casos para:
- antecipar surtos  
- alocar recursos hospitalares  
- identificar grupos de risco  
- reduzir mortalidade  

Diante disso, foi solicitado o desenvolvimento de um pipeline de dados automatizado para alimentar dashboards atualizados diariamente.

---

# 🎯 Problema de Negócio

Como monitorar e prever a evolução da dengue no Brasil, identificando regiões críticas, perfis de risco e possíveis agravamentos dos casos?

---

# ❓ 2. Perguntas de Negócio

### 📈 Monitoramento de Casos
- Quantos casos foram notificados por dia, semana e mês?
- Quais períodos apresentam crescimento acelerado?
- Qual a taxa de variação semanal (%)?

### 🌎 Análise Geográfica
- Quais estados e municípios têm mais casos?
- Quais regiões têm maior incidência?
- Existem regiões com crescimento anormal?

### 🏥 Gravidade
- Qual o percentual de hospitalização?
- Quais perfis têm maior risco?
- Quais sintomas indicam maior gravidade?

### ☠️ Mortalidade
- Qual a taxa de óbitos por região?
- Quais perfis têm maior risco de morte?
- A letalidade está aumentando?

### 🧑 Perfil
- Faixa etária mais afetada?
- Diferença entre sexos?
- Gestantes têm maior risco?

### ⚠️ Qualidade
- Datas inconsistentes?
- Idade inválida?
- Campos nulos?

### ⏱️ Eficiência
- Tempo entre sintomas e notificação?
- Tempo até encerramento?
- Atrasos por região?

---

# 🏗️ 3. Arquitetura

Fonte → Python → PostgreSQL (raw) → Great Expectations → dbt (silver/gold) → Dashboard  
Orquestração: Airflow

---

# ⚙️ 4. Pipeline

- EL: Python → raw
- Validação: Great Expectations
- Transformação: dbt
- Orquestração: Airflow

---

# 🗄️ 5. Modelagem

## Tabela Fato
- **fact_notifications**: Contém as notificações de dengue com chaves estrangeiras para dimensões.

## Dimensões
- **dim_time**: Datas (notificação, sintomas, investigação, óbito, etc.), ano, mês, dia, semana.
- **dim_location**: Localizações (UF notificação, município, região, UF residência, país).
- **dim_patient**: Dados do paciente (ano nascimento, idade, sexo, gestante, raça, escolaridade).
- **dim_unidade**: Identificador da unidade de saúde.
- **dim_agravo**: Identificador do agravo.
- **dim_symptom**: Tipos de sintomas (febre, mialgia, etc.).
- **dim_classificacao**: Classificação final do caso.
- **dim_criterio**: Critério de classificação.
- **dim_evolucao**: Evolução do caso.
- **dim_tp_not**: Tipo de notificação.
- **dim_tp_sistema**: Tipo de sistema de registro.
- **dim_tp_autoctonia**: Tipo de autoctonia.
- **dim_causa_inf**: Causa de infecção.
- **dim_pais_inf**: País de origem da infecção.
- **dim_comun_inf**: Comunidade infectada.

## Tabela Bridge
- **bridge_notification_symptom**: Relaciona notificações com sintomas (muitos-para-muitos).

---

# 🧪 6. Qualidade

- not_null  
- range (idade)  
- consistência de datas  

---

# 🚀 7. Execução Local

## Pré-requisitos
- Python 3.12+
- uv (gerenciador de pacotes)
- PostgreSQL (local ou via Docker)
- Dados CSV em `worker/archive/`

## Instalação
1. Clone o repositório.
2. Instale dependências: `uv sync`

## Com Docker
- `docker-compose up` para executar tudo (DB, worker, Grafana).

---

# 🔧 7. dbt

- stg_dengue  
- fact + dimensões  
- testes + macros  

---