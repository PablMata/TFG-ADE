library(ggplot2)
library(tidyr)

# Crear carpeta results si no existe
if (!dir.exists("results")) dir.create("results")

# Cargar datos
load("data/split_data_gold_stoxx50.RData")
preds <- readRDS("data/preds_gold_stoxx50.rds")

# Crear data frame
df <- data.frame(
  date = data$date[(train_size + 1):nrow(data)],
  Real = test_y,
  Predicción = preds
)

df_long <- pivot_longer(df, cols = c("Real", "Predicción"),
                        names_to = "Tipo", values_to = "Valor")

# Crear gráfico
grafico <- ggplot(df_long, aes(x = date, y = Valor, color = Tipo)) +
  geom_line(size = 0.6) +
  labs(
    title = "Retornos reales vs predichos - Oro (solo Stoxx50)",
    y = "Retorno a 5 días",
    x = "Fecha",
    color = "Serie"
  ) +
  theme_minimal()

# Mostrar gráfico
print(grafico)

# Guardar gráfico como archivo PNG
ggsave("results/grafico_retornos_gold_stoxx50.png", plot = grafico, width = 9, height = 5)
