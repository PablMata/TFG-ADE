library(ggplot2)
library(tidyr)

# Crear carpeta results si no existe
if (!dir.exists("results")) dir.create("results")

# Cargar datos
load("data/split_data_stoxx50_sin_sp500.RData")
preds <- readRDS("data/preds_stoxx50_sin_sp500.rds")

# Preparar series de fechas y precios
dates <- data$date[(train_size + 1):nrow(data)]
start_price <- data$stoxx50_close[train_size]

real_price <- numeric(length(test_y) + 1)
pred_price <- numeric(length(preds) + 1)
real_price[1] <- start_price
pred_price[1] <- start_price

for (i in 2:length(real_price)) {
  real_price[i] <- real_price[i - 1] * exp(test_y[i - 1])
  pred_price[i] <- pred_price[i - 1] * exp(preds[i - 1])
}

real_prices <- real_price[-1]
pred_prices <- pred_price[-1]

# Calibrar predicciones
factor <- mean(real_prices) / mean(pred_prices)
pred_prices_calibrated <- pred_prices * factor

# Crear dataframe para graficar
df <- data.frame(
  date = dates,
  Real = real_prices,
  Predicción = pred_prices_calibrated
)

df_long <- pivot_longer(df, cols = c("Real", "Predicción"),
                        names_to = "Tipo", values_to = "Precio")

# Crear gráfico
grafico <- ggplot(df_long, aes(x = date, y = Precio, color = Tipo)) +
  geom_line(size = 0.6) +
  labs(
    title = "Precio real vs predicho - Stoxx50 (SIN SP500)",
    y = "Precio reconstruido",
    x = "Fecha",
    color = "Serie"
  ) +
  theme_minimal()

# Mostrar gráfico
print(grafico)

# Guardar gráfico como PNG
ggsave("results/grafico_precio_stoxx50_sin_sp500.png", plot = grafico, width = 9, height = 5)
