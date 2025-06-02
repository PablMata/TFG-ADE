# Pipeline completo para predecir Oro con Stoxx50

# 1. Crear carpetas necesarias si no existen
dirs <- c("data", "models", "results", "scriptsGold_stoxx50")
for (d in dirs) if (!dir.exists(d)) dir.create(d)

# 2. Cargar librerías clave
packages <- c("tidyquant", "tidyverse", "lubridate", "xgboost", "TTR", "caret", "Metrics", "janitor", "data.table")
new_packages <- packages[!(packages %in% installed.packages()[, "Package"])]
if (length(new_packages)) install.packages(new_packages)
lapply(packages, library, character.only = TRUE)

# 3. Ejecutar scripts en orden
scripts <- list.files("scriptsGold_stoxx50", pattern = "\\.R$", full.names = TRUE)
scripts <- sort(scripts)

cat("\n--- INICIANDO PIPELINE PARA PREDICCIÓN DEL ORO (SOLO STOXX50) ---\n")
for (script in scripts) {
  cat("\n>> Ejecutando:", basename(script), "...\n")
  source(script)
}
cat("\n--- PIPELINE COMPLETADO ---\n")
