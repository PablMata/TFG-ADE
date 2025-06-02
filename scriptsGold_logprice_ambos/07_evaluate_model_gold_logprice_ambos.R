
library(Metrics)
library(caret)

load("data/split_data_gold_logprice_ambos.RData")
preds <- readRDS("data/preds_gold_logprice_ambos.rds")

# Valores reales
real_prices <- data$gold_close[(train_size + 1):nrow(data)]

# Métricas sobre precios
rmse_precio <- rmse(real_prices, preds)
mae_precio <- mae(real_prices, preds)
r2_precio <- R2(preds, real_prices)

cat("Evaluación del modelo Gold con SP500 + Stoxx50 (log-precio):\n")
cat("RMSE:", rmse_precio, "\n")
cat("MAE :", mae_precio, "\n")
cat("R²  :", r2_precio, "\n")
