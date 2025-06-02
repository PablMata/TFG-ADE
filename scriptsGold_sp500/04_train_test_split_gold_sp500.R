
library(readr)

data <- read_csv("data/features_gold_sp500.csv")

features <- data %>%
  select(
    sp500_lag1, sp500_lag2, sp500_lag5, sp500_diff,
    sp500_volume_z,
    gold_lag1, gold_lag2, gold_lag5, gold_diff,
    gold_volume_z,
    rsi_sp500, sma_sp500,
    rsi_gold, sma_gold
  )

target <- data$gold_return_5d

train_size <- floor(0.8 * nrow(data))
train_x <- features[1:train_size, ]
train_y <- target[1:train_size]
test_x <- features[(train_size + 1):nrow(data), ]
test_y <- target[(train_size + 1):nrow(data)]

save(train_x, train_y, test_x, test_y, data, train_size, file = "data/split_data_gold_sp500.RData")
