
library(readr)
library(dplyr)
library(TTR)
library(tidyr)

data <- read_csv("data/merged_data.csv")

data <- data %>%
  mutate(
    log_gold_close = log(gold_close),
    
    # RSI y medias móviles (principales variables)
    rsi_gold = RSI(gold_close, n = 14),
    sma_gold = SMA(gold_close, n = 20),
    
    rsi_sp500 = RSI(sp500_close, n = 14),
    sma_sp500 = SMA(sp500_close, n = 20),
    
    rsi_stoxx = RSI(stoxx50_close, n = 14),
    sma_stoxx = SMA(stoxx50_close, n = 20)
  ) %>%
  drop_na()

write_csv(data, "data/features_gold_logprice_ambos_v2.csv")
