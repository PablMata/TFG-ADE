
library(readr)
library(dplyr)
library(TTR)

data <- read_csv("data/merged_data.csv")

data <- data %>%
  mutate(
    sp500_return = log(sp500_close / lag(sp500_close)),
    sp500_return_5d = log(sp500_close / lag(sp500_close, 5)),
    
    gold_return = log(gold_close / lag(gold_close)),
    stoxx50_return = log(stoxx50_close / lag(stoxx50_close)),
    stoxx50_return_5d = log(stoxx50_close / lag(stoxx50_close, 5)),
    
    sp500_lag1 = lag(sp500_return, 1),
    sp500_lag2 = lag(sp500_return, 2),
    gold_lag1 = lag(gold_return, 1),
    gold_lag5 = lag(gold_return, 5),
    stoxx50_lag1 = lag(stoxx50_return, 1),
    stoxx50_lag2 = lag(stoxx50_return, 2),
    stoxx50_lag5 = lag(stoxx50_return, 5),
    
    sp500_volume_z = as.numeric(scale(sp500_volume)),
    gold_volume_z = as.numeric(scale(gold_volume)),
    
    rsi_sp500 = RSI(sp500_close, n = 14),
    sma_sp500 = SMA(sp500_close, n = 20),
    
    rsi_stoxx = RSI(stoxx50_close, n = 14),
    sma_stoxx = SMA(stoxx50_close, n = 20),
    
    gold_diff = gold_close - lag(gold_close, 1),
    stoxx50_diff = stoxx50_close - lag(stoxx50_close, 1),
    sp500_stoxx_ratio = sp500_close / stoxx50_close
  ) %>%
  drop_na()

write_csv(data, "data/features_con_stoxx50.csv")
