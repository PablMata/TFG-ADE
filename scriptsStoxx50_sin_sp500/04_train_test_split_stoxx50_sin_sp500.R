
library(readr)

data <- read_csv("data/features_stoxx50_sin_sp500.csv")

features <- data %>%
  select(
    stoxx50_lag1, stoxx50_lag2, stoxx50_lag5, stoxx50_diff,
    gold_lag1, gold_lag5, gold_diff,
    gold_volume_z,
    rsi_stoxx, sma_stoxx
  )

target <- data$stoxx50_return_5d

train_size <- floor(0.8 * nrow(data))
train_x <- features[1:train_size, ]
train_y <- target[1:train_size]
test_x <- features[(train_size + 1):nrow(data), ]
test_y <- target[(train_size + 1):nrow(data)]

save(train_x, train_y, test_x, test_y, data, train_size, file = "data/split_data_stoxx50_sin_sp500.RData")
