# Script para ver las variables con más importancia

library(xgboost)
library(ggplot2)

# Cargar datos y modelo
load("data/split_data_gold_logprice_ambos.RData")
model <- xgb.load("models/gold_logprice_ambos.model")

# Convertir test/train en matrices
dtrain <- xgb.DMatrix(data = as.matrix(train_x), label = train_y)

# Obtener importancia
importance <- xgb.importance(model = model, feature_names = colnames(train_x))

# Mostrar en consola
print(importance)

# Guardar en CSV
write.csv(importance, "results/feature_importance_gold_logprice_ambos.csv", row.names = FALSE)

# Visualización
xgb.plot.importance(importance_matrix = importance, top_n = 20, rel_to_first = TRUE, main = "Importancia de variables - Gold log price (SP500 + Stoxx50)")
