## **Predicting Patient Readmission Rates Using Machine Learning in R**

### **Overview**

Hospital readmissions are a critical issue in healthcare, significantly affecting patient outcomes and increasing costs. This project aims to develop a predictive model to identify patients at high risk of readmission within 30 days of discharge. Leveraging the power of R for statistical analysis, machine learning algorithms, and data visualization, this project provides actionable insights that can help healthcare providers reduce readmission rates and improve patient care.

### **Objectives**

- **Data Collection and Preprocessing**: 
  - Utilize publicly available healthcare datasets (e.g., Hospital Readmissions Reduction Program (HRRP) data, MIMIC-III Clinical Database) to gather patient records, including demographic information, comorbidities, length of stay, lab results, previous admissions, and discharge details.
  
- **Exploratory Data Analysis (EDA)**:
  - Perform EDA using R libraries like `ggplot2`, `dplyr`, and `tidyverse` to clean, transform, and visualize the data. Identify key factors contributing to readmission rates by discovering trends, patterns, and correlations.

- **Feature Engineering**:
  - Enhance the predictive power of the model by creating new features such as the Charlson Comorbidity Index, medication counts, and lab test abnormalities.

- **Predictive Modeling**:
  - Implemented machine learning algorithms in R, including Random Forest and Decision Tree, using the `caret` package for model training and hyperparameter tuning.

- **Model Evaluation**:
  - Evaluate model performance using metrics like Area Under the Receiver Operating Characteristic Curve (AUC-ROC) and confusion matrix.

- **Visualization and Interpretation**:
  - Develop an interactive dashboard using `shiny` in R to visualize key findings, model predictions, and important features influencing the readmission risk. The dashboard enables healthcare professionals to explore different scenarios and understand the model's decision-making process.

- **Actionable Insights and Recommendations**:
  - Provide insights and recommendations to healthcare providers on identifying high-risk patients and implementing targeted interventions, such as follow-up calls, early check-ups, or personalized care plans, to reduce the likelihood of readmission.

### **Project Workflow**

1. **Data Collection**: 
   - Gather data from publicly available sources.
   - Clean and preprocess the data using `dplyr`, `tidyverse`, and other R packages.

2. **Exploratory Data Analysis (EDA)**:
   - Perform EDA to identify trends, correlations, and key factors contributing to readmission rates.
   - Visualize data using `ggplot2` to uncover hidden patterns.

3. **Feature Engineering**:
   - Create new features to improve model performance.
   - Calculate the Charlson Comorbidity Index, derive medication counts, and identify lab test abnormalities.

4. **Predictive Modeling**:
   - Implement and train models using algorithms like Random Forest and Decision Tree.
   - Use `caret` for hyperparameter tuning and model selection.

5. **Model Evaluation**:
   - Evaluate models using AUC-ROC and confusion matrix.
   - Perform cross-validation to ensure robustness.

6. **Interactive Dashboard**:
   - Create a `shiny` dashboard to visualize the model's predictions, feature importance, and potential interventions.

7. **Insights and Recommendations**:
   - Provide actionable insights to healthcare providers to reduce readmission rates.

### **Tools and Technologies Used**

- **Data Manipulation and Visualization**: `dplyr`, `tidyverse`, `ggplot2`
- **Machine Learning**: `caret`, `randomForest`, `xgboost`, `gbm`
- **Model Evaluation**: `pROC`, `e1071`
- **Interactive Dashboard**: `shiny`

### **Results and Insights**

- **Key Features Influencing Readmissions**: The model identified several important features that influence the likelihood of readmission, such as patient comorbidities, length of stay, prior admissions, and specific lab results.
- **Model Performance**: The Random Forest and XGBoost models demonstrated the best performance with AUC-ROC scores of over 0.85, indicating strong predictive power.
- **Actionable Recommendations**: Based on the model's findings, targeted interventions like follow-up calls and early check-ups for high-risk patients can be implemented to reduce readmission rates.

**Run the Scripts**:
   - Run the data preprocessing, EDA, and modeling scripts provided in the `/scripts` directory.
   - Use `shiny` to launch the interactive dashboard by running `shiny::runApp('dashboard')` from the R console.

### **Contributing**

Contributions are welcome! Please follow the standard GitHub flow:

1. Fork this repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Open a pull request.

### **License**

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

### **Contact**

For any questions or suggestions, please contact:

- **Your Name**: arunkumar.k@northeastern.edu
- **GitHub**: keshiarun01(https://github.com/keshiarun01))
