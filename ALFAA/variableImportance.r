#Extract variable importance from features
#In terms of mean decrease accuracy and mean decrease Gini

library(randomForest)

load(file = "rfmodelsC.RData")
importance(rfC1[[1]])
