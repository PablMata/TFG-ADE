
library(readr)
library(dplyr)
library(TTR)

data <- read_csv("data/merged_data.csv")

data <- data %>%
  mutate(
    gold_return = log(gold_close / lag(gold_close)),
    gold_return_5d = log(gold_close / lag(gold_close, 5)),
    sp500_return = log(sp500_close / lag(sp500_close)),
    
    # Lags del SP500
    sp500_lag1 = lag(sp500_return, 1),
    sp500_lag2 = lag(sp500_return, 2),
    sp500_lag5 = lag(sp500_return, 5),
    sp500_diff = sp500_close - lag(sp500_close, 1),
    
    # Lags del oro (añadidos ahora)
    gold_lag1 = lag(gold_return, 1),
    gold_lag2 = lag(gold_return, 2),
    gold_lag5 = lag(gold_return, 5),
    gold_diff = gold_close - lag(gold_close, 1),
    
    sp500_volume_z = as.numeric(scale(sp500_volume)),
    gold_volume_z = as.numeric(scale(gold_volume)),
    
    rsi_sp500 = RSI(sp500_close, n = 14),
    sma_sp500 = SMA(sp500_close, n = 20),
    rsi_gold = RSI(gold_close, n = 14),
    sma_gold = SMA(gold_close, n = 20)
  ) %>%
  drop_na()

write_csv(data, "data/features_gold_sp500.csv")
