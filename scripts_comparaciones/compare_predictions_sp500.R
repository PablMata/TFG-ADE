library(ggplot2)
library(tidyr)

# Cargar conjuntos de datos
load("data/split_data_con_stoxx50.RData")
preds_con <- readRDS("data/preds_con_stoxx50.rds")
preds_sin <- readRDS("data/preds_sin_stoxx50.rds")

# Fechas y precio inicial
dates <- data$date[(train_size + 1):nrow(data)]
start_price <- data$sp500_close[train_size]

# Función para reconstruir precios desde retornos
reconstruir_precio <- function(retornos, start_price) {
  serie <- numeric(length(retornos) + 1)
  serie[1] <- start_price
  for (i in 2:length(serie)) {
    serie[i] <- serie[i - 1] * exp(retornos[i - 1])
  }
  return(serie[-1])
}

# Reconstrucción
real_prices <- reconstruir_precio(test_y, start_price)
pred_con <- reconstruir_precio(preds_con, start_price)
pred_sin <- reconstruir_precio(preds_sin, start_price)

# Calibrar predicciones
pred_con_cal <- pred_con * mean(real_prices) / mean(pred_con)
pred_sin_cal <- pred_sin * mean(real_prices) / mean(pred_sin)

# Crear dataframe
df <- data.frame(
  date = dates,
  Real = real_prices,
  Con_Stoxx50 = pred_con_cal,
  Sin_Stoxx50 = pred_sin_cal
)

df_long <- pivot_longer(df, cols = c("Real", "Con_Stoxx50", "Sin_Stoxx50"),
                        names_to = "Serie", values_to = "Precio")

# Crear gráfico
grafico <- ggplot(df_long, aes(x = date, y = Precio, color = Serie)) +
  geom_line(size = 0.6) +
  labs(
    title = "Comparación de precios reconstruidos - SP500 (CON vs SIN Stoxx50)",
    y = "Precio reconstruido (calibrado)",
    x = "Fecha",
    color = "Serie"
  ) +
  theme_minimal()

# Mostrar en consola
print(grafico)

# Guardar gráfico como PNG
if (!dir.exists("results")) dir.create("results")
ggsave("results/compare_sp500_con_vs_sin_stoxx50.png", plot = grafico, width = 9, height = 5)
