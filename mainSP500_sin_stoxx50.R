# Pipeline para predecir SP500 SIN Stoxx50

# 1. Crear carpetas si no existen
dirs <- c("data", "models", "results", "scriptsSP500_sin_stoxx50")
for (d in dirs) if (!dir.exists(d)) dir.create(d)

# 2. Cargar librerías clave
packages <- c("tidyquant", "tidyverse", "lubridate", "xgboost", "TTR", "caret", "Metrics", "janitor", "data.table")
new_packages <- packages[!(packages %in% installed.packages()[, "Package"])]
if (length(new_packages)) install.packages(new_packages)
lapply(packages, library, character.only = TRUE)

# 3. Ejecutar scripts del pipeline sin Stoxx50
scripts <- list.files("scriptsSP500_sin_stoxx50", pattern = "\\.R$", full.names = TRUE)
scripts <- sort(scripts)

cat("\n--- INICIANDO PIPELINE SIN Stoxx50 ---\n")
for (script in scripts) {
  cat("\n>> Ejecutando:", basename(script), "...\n")
  source(script)
}
cat("\n--- PIPELINE SIN Stoxx50 COMPLETADO ---\n")
