
library(xgboost)

load("data/split_data_stoxx50_sin_sp500.RData")
results <- read.csv("results/tuning_results_stoxx50_sin_sp500.csv")
best_params <- results[which.min(results$rmse), ]

dtrain <- xgb.DMatrix(data = as.matrix(train_x), label = train_y)

final_model <- xgboost(
  data = dtrain,
  nrounds = best_params$best_iteration,
  max_depth = best_params$max_depth,
  eta = best_params$eta,
  subsample = best_params$subsample,
  colsample_bytree = best_params$colsample_bytree,
  objective = "reg:squarederror",
  verbose = 0
)

xgb.save(final_model, "models/stoxx50_sin_sp500.model")

dtest <- xgb.DMatrix(data = as.matrix(test_x))
preds <- predict(final_model, dtest)

saveRDS(preds, "data/preds_stoxx50_sin_sp500.rds")
