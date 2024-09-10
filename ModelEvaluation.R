# Decision Tree
library(rpart)

set.seed(53)
control <- rpart.control(cp = 0.000, xxval = 1000, minsplit = 1, maxdepth = 5)

rpart_model <- rpart(readmitted~., 
                     data = trainData,
                     method = "class",
                     control = control)

printcp(rpart_model)

rattle::fancyRpartPlot(rpart_model, sub = "")

rpart_test_pred <- predict(rpart_model, testData)
rpart_test_pred <- factor(colnames(rpart_test_pred)[max.col(rpart_test_pred)])
rpart_test_cfm <- caret::confusionMatrix(rpart_test_pred, testData$readmitted)
rpart_test_cfm

test_prob <- predict(rpart_model, testData, type = "prob")
par(pty="s")
roc_dt <- roc(testData$readmitted ~ test_prob[,2], plot = TRUE, print.auc = TRUE, main="ROC curve of decision tree")

# RandomForest
library(randomForest)
library(pROC)

# Set seed for reproducibility
set.seed(53)

# Train a Random Forest model
rf_model <- randomForest(readmitted ~ ., 
                         data = trainData, 
                         ntree = 50,   # Number of trees
                         mtry = 3,      # Number of variables tried at each split
                         importance = TRUE)  # Calculate variable importance

# Print the Random Forest model summary
print(rf_model)

# Plot Variable Importance
varImpPlot(rf_model, main = "Variable Importance Plot")

# Make predictions on the test set
rf_test_pred <- predict(rf_model, testData)

# Evaluate the model using Confusion Matrix
rf_test_cfm <- caret::confusionMatrix(rf_test_pred, testData$readmitted)
print(rf_test_cfm)

# Predict probabilities for the test set
rf_test_prob <- predict(rf_model, testData, type = "prob")

# Plot ROC curve
par(pty = "s")
roc_rf <- roc(testData$readmitted, rf_test_prob[, 2], plot = TRUE, print.auc = TRUE, main = "ROC Curve for Random Forest")

compare_model <- data.frame(Model=c("Random Forest", "Decision Tree"),
                            Accuracy = c(0.895,0.7666),
                            Kappa = c(0.789,0.5275),
                            Sensitivity = c(0.9149,0.7310),
                            Specificity = c(0.8788,0.7956),
                            AUC = c(0.951, 0.817))
knitr::kable(compare_model)

par(pty="s")
plot(roc_rf, col = "green", main = "ROC for three models")
lines(roc_dt, col = "red")
legend("bottomright", c("Random Forest (0.978)","Decision Tree (0.811)"), fill=c("green","red"),bty = "n")
