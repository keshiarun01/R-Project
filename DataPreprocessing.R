data_predict <- drop_na(data_main, readmitted) %>%
  mutate(readmitted = as.factor(if_else(readmitted == "<30", 1, 0)))


# Assuming you already have 'data_predict' prepared as in your original code

set.seed(53)
percOver <- (sum(data_predict$readmitted == 0) - sum(data_predict$readmitted == 1)) / sum(data_predict$readmitted == 1) * 100
percUnder <- sum(data_predict$readmitted == 0) / (sum(data_predict$readmitted == 0) - sum(data_predict$readmitted == 1)) * 100

balanced <- ubBalance(X = data_predict[, -which(names(data_predict) %in% c("readmitted"))],
                      Y = data_predict$readmitted,
                      type = "ubSMOTE",
                      percOver = percOver,
                      percUnder = percUnder,
                      verbose = TRUE)

# Create a bar plot for the imbalanced data
ggplot(data_predict, aes(x = readmitted)) +
  geom_bar(fill = "skyblue") +
  labs(title = "Imbalanced Data Distribution of Readmission",
       x = "Readmission Status",
       y = "Count") +
  theme_minimal()

# Combine the balanced features and target variable into one data frame
balanced_data <- data.frame(balanced$X, readmitted = balanced$Y)

# Create a bar plot for the balanced data
ggplot(balanced_data, aes(x = readmitted)) +
  geom_bar(fill = "lightgreen") +
  labs(title = "Balanced Data Distribution of Readmission",
       x = "Readmission Status",
       y = "Count") +
  theme_minimal()

