
library(readr)

data <- read_csv("data/features_gold_logprice_ambos_v2.csv")

features <- data %>%
  select(rsi_gold, sma_gold, rsi_sp500, sma_sp500, rsi_stoxx, sma_stoxx)

target <- data$log_gold_close

train_size <- floor(0.8 * nrow(data))
train_x <- features[1:train_size, ]
train_y <- target[1:train_size]
test_x <- features[(train_size + 1):nrow(data), ]
test_y <- target[(train_size + 1):nrow(data)]

save(train_x, train_y, test_x, test_y, data, train_size, file = "data/split_data_gold_logprice_ambos_v2.RData")
