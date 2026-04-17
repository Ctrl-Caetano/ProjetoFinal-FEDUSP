-- Dimensões para dados de dengue

CREATE TABLE IF NOT EXISTS dim_time (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,
    week INT NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_location (
    id SERIAL PRIMARY KEY,
    sg_uf_not TEXT,
    id_municip TEXT,
    id_regiona TEXT,
    sg_uf TEXT,
    id_mn_resi TEXT,
    id_rg_resi TEXT,
    id_pais TEXT,
    UNIQUE (sg_uf_not, id_municip, id_regiona, sg_uf, id_mn_resi, id_rg_resi, id_pais)
);

CREATE TABLE IF NOT EXISTS dim_patient (
    id SERIAL PRIMARY KEY,
    ano_nasc INT,
    nu_idade_n INT,
    cs_sexo TEXT,
    cs_gestant TEXT,
    cs_raca TEXT,
    cs_escol_n TEXT,
    UNIQUE (ano_nasc, nu_idade_n, cs_sexo, cs_gestant, cs_raca, cs_escol_n)
);

CREATE TABLE IF NOT EXISTS dim_unidade (
    id SERIAL PRIMARY KEY,
    id_unidade TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS dim_agravo (
    id SERIAL PRIMARY KEY,
    id_agravo TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS dim_symptom (
    id SERIAL PRIMARY KEY,
    symptom_name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS dim_classificacao (
    id SERIAL PRIMARY KEY,
    classi_fin TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS dim_criterio (
    id SERIAL PRIMARY KEY,
    criterio TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS dim_evolucao (
    id SERIAL PRIMARY KEY,
    evolucao TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS dim_tp_not (
    id SERIAL PRIMARY KEY,
    tp_not TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS dim_tp_sistema (
    id SERIAL PRIMARY KEY,
    tp_sistema TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS dim_tp_autoctonia (
    id SERIAL PRIMARY KEY,
    tpautocto TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS dim_causa_inf (
    id SERIAL PRIMARY KEY,
    coufinf TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS dim_pais_inf (
    id SERIAL PRIMARY KEY,
    copaisinf TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS dim_comun_inf (
    id SERIAL PRIMARY KEY,
    comuninf TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS fact_notifications (
    id SERIAL PRIMARY KEY,
    tp_not_id INT REFERENCES dim_tp_not(id),
    id_agravo_id INT REFERENCES dim_agravo(id),
    dt_notific_id INT REFERENCES dim_time(id),
    sem_not INT,
    nu_ano INT,
    location_id INT REFERENCES dim_location(id),
    unidade_id INT REFERENCES dim_unidade(id),
    dt_sin_pri_id INT REFERENCES dim_time(id),
    sem_pri INT,
    patient_id INT REFERENCES dim_patient(id),
    dt_invest_id INT REFERENCES dim_time(id),
    resul_soro TEXT,
    resul_ns1 TEXT,
    resul_vi_n TEXT,
    resul_pcr_ TEXT,
    hospitaliz TEXT,
    tpautocto_id INT REFERENCES dim_tp_autoctonia(id),
    coufinf_id INT REFERENCES dim_causa_inf(id),
    copaisinf_id INT REFERENCES dim_pais_inf(id),
    comuninf_id INT REFERENCES dim_comun_inf(id),
    classi_fin_id INT REFERENCES dim_classificacao(id),
    criterio_id INT REFERENCES dim_criterio(id),
    evolucao_id INT REFERENCES dim_evolucao(id),
    dt_obito_id INT REFERENCES dim_time(id),
    dt_encerra_id INT REFERENCES dim_time(id),
    tp_sistema_id INT REFERENCES dim_tp_sistema(id),
    dt_digita_id INT REFERENCES dim_time(id),
    cs_flxret TEXT,
    target_obito INT
);

-- Tabela bridge para sintomas (muitos-para-muitos)
CREATE TABLE IF NOT EXISTS bridge_notification_symptom (
    notification_id INT NOT NULL REFERENCES fact_notifications(id),
    symptom_id INT NOT NULL REFERENCES dim_symptom(id),
    PRIMARY KEY (notification_id, symptom_id)
);