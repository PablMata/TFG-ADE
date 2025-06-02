library(ggplot2)
library(tidyr)
library(dplyr)
library(readr)

# Cargar datos originales
load("data/split_data_gold_logprice_ambos.RData")
preds_original <- readRDS("data/preds_gold_logprice_ambos.rds")
fechas <- data$date[(train_size + 1):nrow(data)]
precios_reales <- data$gold_close[(train_size + 1):nrow(data)]

# Cargar datos v2
load("data/split_data_gold_logprice_ambos_v2.RData")
preds_v2 <- readRDS("data/preds_gold_logprice_ambos_v2.rds")

# Unificar en un mismo dataframe
df_comp <- data.frame(
  Fecha = fechas,
  Real = precios_reales,
  Predicción_original = preds_original,
  Predicción_v2 = preds_v2
)

df_long <- df_comp %>%
  pivot_longer(cols = -Fecha, names_to = "Modelo", values_to = "Precio")

# Crear gráfico
grafico <- ggplot(df_long, aes(x = Fecha, y = Precio, color = Modelo)) +
  geom_line(size = 0.6) +
  labs(
    title = "Comparación de predicciones - Log Precio del Oro",
    y = "Precio del oro",
    x = "Fecha",
    color = "Serie"
  ) +
  theme_minimal()

# Mostrar gráfico
print(grafico)

# Guardar como archivo PNG
if (!dir.exists("results")) dir.create("results")
ggsave("results/compare_gold_logprice_v1_v2.png", plot = grafico, width = 9, height = 5)
