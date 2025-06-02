# Pipeline para predecir log del precio del oro con SP500 + Stoxx50

# 1. Crear carpetas necesarias si no existen
dirs <- c("data", "models", "results", "scriptsGold_logprice_ambos")
for (d in dirs) if (!dir.exists(d)) dir.create(d)

# 2. Cargar librerías clave
packages <- c("tidyquant", "tidyverse", "lubridate", "xgboost", "TTR", "caret", "Metrics", "janitor", "data.table")
new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if (length(new_packages)) install.packages(new_packages)
lapply(packages, library, character.only = TRUE)

# 3. Ejecutar scripts en orden
scripts <- list.files("scriptsGold_logprice_ambos", pattern = "\\.R$", full.names = TRUE)
scripts <- sort(scripts)

cat("\n--- INICIANDO PIPELINE PARA PREDICCIÓN DEL LOG-PRECIO DEL ORO (SP500 + STOXX50) ---\n")
for (script in scripts) {
  cat("\n>> Ejecutando:", basename(script), "...\n")
  source(script)
}
cat("\n--- PIPELINE COMPLETADO ---\n")
