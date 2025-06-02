
library(readr)
library(dplyr)
library(TTR)

data <- read_csv("data/merged_data.csv")

data <- data %>%
  mutate(
    sp500_return = log(sp500_close / lag(sp500_close)),
    sp500_return_5d = log(sp500_close / lag(sp500_close, 5)),
    
    gold_return = log(gold_close / lag(gold_close)),
    gold_lag1 = lag(gold_return, 1),
    gold_lag5 = lag(gold_return, 5),
    gold_diff = gold_close - lag(gold_close, 1),
    
    sp500_lag1 = lag(sp500_return, 1),
    sp500_lag2 = lag(sp500_return, 2),
    
    rsi_sp500 = RSI(sp500_close, n = 14),
    sma_sp500 = SMA(sp500_close, n = 20),
    
    sp500_volume_z = as.numeric(scale(sp500_volume)),
    gold_volume_z = as.numeric(scale(gold_volume))
  ) %>%
  drop_na()

write_csv(data, "data/features_sin_stoxx50.csv")
