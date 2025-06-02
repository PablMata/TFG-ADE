library(ggplot2)
library(tidyr)

# Cargar datos de ambos modelos
load("data/split_data_stoxx50_con_sp500.RData")
pred_con <- readRDS("data/preds_stoxx50_con_sp500.rds")
pred_sin <- readRDS("data/preds_stoxx50_sin_sp500.rds")

# Fechas y precio inicial
dates <- data$date[(train_size + 1):nrow(data)]
start_price <- data$stoxx50_close[train_size]

# Función de reconstrucción
reconstruir <- function(retornos, start_price) {
  serie <- numeric(length(retornos) + 1)
  serie[1] <- start_price
  for (i in 2:length(serie)) {
    serie[i] <- serie[i - 1] * exp(retornos[i - 1])
  }
  return(serie[-1])
}

# Reconstrucción de precios
real_prices <- reconstruir(test_y, start_price)
pred_con_p <- reconstruir(pred_con, start_price)
pred_sin_p <- reconstruir(pred_sin, start_price)

# Calibrar al nivel real
pred_con_p <- pred_con_p * mean(real_prices) / mean(pred_con_p)
pred_sin_p <- pred_sin_p * mean(real_prices) / mean(pred_sin_p)

# Crear dataframe largo para graficar
df <- data.frame(
  date = dates,
  Real = real_prices,
  Con_SP500 = pred_con_p,
  Sin_SP500 = pred_sin_p
)

df_long <- pivot_longer(df, cols = c("Real", "Con_SP500", "Sin_SP500"),
                        names_to = "Serie", values_to = "Precio")

# Crear gráfico
grafico <- ggplot(df_long, aes(x = date, y = Precio, color = Serie)) +
  geom_line(size = 0.6) +
  labs(
    title = "Comparación de precios reconstruidos - Stoxx50 (CON vs SIN SP500)",
    y = "Precio reconstruido",
    x = "Fecha",
    color = "Serie"
  ) +
  theme_minimal()

# Mostrar gráfico
print(grafico)

# Guardar gráfico como PNG
if (!dir.exists("results")) dir.create("results")
ggsave("results/compare_stoxx50_con_vs_sin_sp500.png", plot = grafico, width = 9, height = 5)
