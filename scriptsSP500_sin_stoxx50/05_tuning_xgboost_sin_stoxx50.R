
library(xgboost)
library(dplyr)

load("data/split_data_sin_stoxx50.RData")
dtrain <- xgb.DMatrix(data = as.matrix(train_x), label = train_y)

max_depths <- c(3, 4, 6)
etas <- c(0.01, 0.05, 0.1)
subsamples <- c(0.7, 0.8)
colsamples <- c(0.7, 0.8)

results <- data.frame()
set.seed(123)

for (md in max_depths) {
  for (lr in etas) {
    for (ss in subsamples) {
      for (cs in colsamples) {
        cv <- xgb.cv(
          data = dtrain,
          nrounds = 200,
          nfold = 5,
          metrics = "rmse",
          early_stopping_rounds = 10,
          objective = "reg:squarederror",
          verbose = 0,
          params = list(
            max_depth = md,
            eta = lr,
            subsample = ss,
            colsample_bytree = cs
          )
        )
        
        results <- rbind(results, data.frame(
          max_depth = md,
          eta = lr,
          subsample = ss,
          colsample_bytree = cs,
          best_iteration = cv$best_iteration,
          rmse = min(cv$evaluation_log$test_rmse_mean)
        ))
      }
    }
  }
}

write.csv(results, "results/tuning_results_sin_stoxx50.csv", row.names = FALSE)
