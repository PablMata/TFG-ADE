
library(readr)
library(dplyr)
library(TTR)

data <- read_csv("data/merged_data.csv")

data <- data %>%
  mutate(
    stoxx50_return = log(stoxx50_close / lag(stoxx50_close)),
    stoxx50_return_5d = log(stoxx50_close / lag(stoxx50_close, 5)),
    
    gold_return = log(gold_close / lag(gold_close)),
    
    stoxx50_lag1 = lag(stoxx50_return, 1),
    stoxx50_lag2 = lag(stoxx50_return, 2),
    stoxx50_lag5 = lag(stoxx50_return, 5),
    stoxx50_diff = stoxx50_close - lag(stoxx50_close, 1),
    
    gold_lag1 = lag(gold_return, 1),
    gold_lag5 = lag(gold_return, 5),
    gold_diff = gold_close - lag(gold_close, 1),
    
    gold_volume_z = as.numeric(scale(gold_volume)),
    rsi_stoxx = RSI(stoxx50_close, n = 14),
    sma_stoxx = SMA(stoxx50_close, n = 20)
  ) %>%
  drop_na()

write_csv(data, "data/features_stoxx50_sin_sp500.csv")
