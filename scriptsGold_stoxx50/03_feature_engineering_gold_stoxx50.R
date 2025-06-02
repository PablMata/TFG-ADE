
library(readr)
library(dplyr)
library(TTR)

data <- read_csv("data/merged_data.csv")

data <- data %>%
  mutate(
    gold_return = log(gold_close / lag(gold_close)),
    gold_return_5d = log(gold_close / lag(gold_close, 5)),
    stoxx50_return = log(stoxx50_close / lag(stoxx50_close)),
    
    # Lags del Stoxx50
    stoxx50_lag1 = lag(stoxx50_return, 1),
    stoxx50_lag2 = lag(stoxx50_return, 2),
    stoxx50_lag5 = lag(stoxx50_return, 5),
    stoxx50_diff = stoxx50_close - lag(stoxx50_close, 1),
    
    # Lags del oro
    gold_lag1 = lag(gold_return, 1),
    gold_lag2 = lag(gold_return, 2),
    gold_lag5 = lag(gold_return, 5),
    gold_diff = gold_close - lag(gold_close, 1),
    
    gold_volume_z = as.numeric(scale(gold_volume)),
    
    rsi_stoxx = RSI(stoxx50_close, n = 14),
    sma_stoxx = SMA(stoxx50_close, n = 20),
    rsi_gold = RSI(gold_close, n = 14),
    sma_gold = SMA(gold_close, n = 20)
  ) %>%
  drop_na()

write_csv(data, "data/features_gold_stoxx50.csv")
