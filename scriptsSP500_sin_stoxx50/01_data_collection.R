
library(tidyquant)
library(tidyverse)
library(xgboost)
library(TTR)
library(caret)
library(Metrics)
library(lubridate)

# Crear carpeta data si no existe
if (!dir.exists("data")) dir.create("data")

# Fechas
start_date <- "2010-01-01"
end_date <- Sys.Date()

# Descargar datos
# Descargar precios y volumen
sp500 <- tq_get("^GSPC", from = start_date, to = end_date) %>%
  select(date, sp500_close = adjusted, sp500_volume = volume)

stoxx50 <- tq_get("^STOXX50E", from = start_date, to = end_date) %>%
  select(date, stoxx50_close = adjusted)

gold <- tq_get("GC=F", from = start_date, to = end_date) %>%
  select(date, gold_close = adjusted, gold_volume = volume)

# Guardar CSVs
write.csv(sp500, "data/sp500.csv", row.names = FALSE)
write.csv(stoxx50, "data/stoxx50.csv", row.names = FALSE)
write.csv(gold, "data/gold.csv", row.names = FALSE)
