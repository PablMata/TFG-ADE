library(ggplot2)
library(tidyr)

# Cargar datos
load("data/split_data_gold_ambos.RData")
pred_sp500 <- readRDS("data/preds_gold_sp500.rds")
pred_stoxx50 <- readRDS("data/preds_gold_stoxx50.rds")

dates <- data$date[(train_size + 1):nrow(data)]
start_price <- data$gold_close[train_size]

# Función para reconstruir precios desde retornos
reconstruir_precio <- function(retornos, start_price) {
  serie <- numeric(length(retornos) + 1)
  serie[1] <- start_price
  for (i in 2:length(serie)) {
    serie[i] <- serie[i - 1] * exp(retornos[i - 1])
  }
  return(serie)
}

# Reconstruir precios
real_price <- reconstruir_precio(test_y, start_price)[-1]
pred_sp500 <- reconstruir_precio(pred_sp500, start_price)[-1]
pred_stoxx50 <- pred_stoxx50  # Este ya está bien

# Calibrar predicciones al mismo nivel
pred_sp500 <- pred_sp500 * mean(real_price) / mean(pred_sp500)
pred_stoxx50 <- pred_stoxx50 * mean(real_price) / mean(pred_stoxx50)

# Crear dataframe
df <- data.frame(
  Fecha = dates,
  Real = real_price,
  SP500 = pred_sp500,
  Stoxx50 = pred_stoxx50
)

df_long <- pivot_longer(df, cols = c("Real", "SP500", "Stoxx50"),
                        names_to = "Modelo", values_to = "Precio")

# Graficar
ggplot(df_long, aes(x = Fecha, y = Precio, color = Modelo)) +
  geom_line(size = 0.6) +
  labs(
    title = "Comparación de precios reconstruidos - Oro (solo SP500 vs Stoxx50)",
    y = "Precio reconstruido",
    x = "Fecha",
    color = "Serie"
  ) +
  theme_minimal()
