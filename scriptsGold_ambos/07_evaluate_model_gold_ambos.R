
library(Metrics)
library(caret)

load("data/split_data_gold_ambos.RData")
preds <- readRDS("data/preds_gold_ambos.rds")

# Métricas sobre retornos
rmse_val <- rmse(test_y, preds)
mae_val <- mae(test_y, preds)
r2_val <- R2(preds, test_y)

cat("Evaluación del modelo Gold con SP500 + Stoxx50 (retornos):\n")
cat("RMSE:", rmse_val, "\n")
cat("MAE :", mae_val, "\n")
cat("R²  :", r2_val, "\n")

# Reconstrucción de precios
start_price <- data$gold_close[train_size]
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

# Calibrar
factor <- mean(real_prices) / mean(pred_prices)
pred_prices_calibrated <- pred_prices * factor

# Métricas sobre precios
rmse_precio <- rmse(real_prices, pred_prices_calibrated)
mae_precio <- mae(real_prices, pred_prices_calibrated)
r2_precio <- R2(pred_prices_calibrated, real_prices)

cat("\nEvaluación del modelo Gold con SP500 + Stoxx50 (precios):\n")
cat("RMSE:", rmse_precio, "\n")
cat("MAE :", mae_precio, "\n")
cat("R²  :", r2_precio, "\n")
