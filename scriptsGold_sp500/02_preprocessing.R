
library(readr)
library(dplyr)
library(janitor)

sp500 <- read_csv("data/sp500.csv")
stoxx50 <- read_csv("data/stoxx50.csv")
gold <- read_csv("data/gold.csv")

# Unión de series por fecha
merged_data <- sp500 %>%
  full_join(stoxx50, by = "date") %>%
  full_join(gold, by = "date") %>%
  arrange(date) %>%
  drop_na()

write_csv(merged_data, "data/merged_data.csv")
