library(ggplot2)
library(tidyr)

# Crear carpeta results si no existe
if (!dir.exists("results")) dir.create("results")

# Cargar datos
load("data/split_data_gold_logprice_ambos.RData")
preds <- readRDS("data/preds_gold_logprice_ambos.rds")

# Crear data frame para graficar
df <- data.frame(
  date = data$date[(train_size + 1):nrow(data)],
  Real = data$gold_close[(train_size + 1):nrow(data)],
  Predicción = preds
)

df_long <- pivot_longer(df, cols = c("Real", "Predicción"),
                        names_to = "Tipo", values_to = "Precio")

# Crear gráfico
grafico <- ggplot(df_long, aes(x = date, y = Precio, color = Tipo)) +
  geom_line(size = 0.6) +
  labs(
    title = "Precio real vs predicho - Oro (SP500 + Stoxx50, log-precio)",
    y = "Precio del oro",
    x = "Fecha",
    color = "Serie"
  ) +
  theme_minimal()

# Mostrar gráfico
print(grafico)

# Guardar gráfico como archivo PNG
ggsave("results/grafico_precio_gold_logprice_ambos.png", plot = grafico, width = 9, height = 5)
