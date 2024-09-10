library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)  # For pivot_longer function
library(viridis)  # For color scales
library(caret)  # For model evaluation (confusionMatrix)
library(pROC)  # For ROC curves
library(corrplot)  # For correlation matrix plots

# Ensure all required data and objects are loaded and available
# Load or define `data_predict`, `roc_rf`, `roc_dt`, `compare_model`, `miss_data`, `data_factor`, and `data_numeric` here

# UI
ui <- fluidPage(
  titlePanel("Predicting Patient Readmission Rates"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("model", "Select Model", choices = c("Decision Tree", "Random Forest")),
      actionButton("predict", "Run Prediction")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Overview", 
                 plotOutput("barPlot"),
                 plotOutput("rocPlot")
        ),
        tabPanel("Model Comparison", 
                 tableOutput("modelComparison")
        ),
        tabPanel("Data Exploration", 
                 plotOutput("missingDataPlot"),
                 plotOutput("factorHistograms"),
                 plotOutput("numericHistograms"),
                 plotOutput("correlationPlot")  # Add a new plot output for the correlation matrix
        )
      )
    )
  )
)

# Server
server <- function(input, output) {
  
  # Render bar plot for imbalanced and balanced data
  output$barPlot <- renderPlot({
    ggplot(data_predict, aes(x = readmitted)) +
      geom_bar(fill = "skyblue") +
      labs(title = "Imbalanced Data Distribution of Readmission",
           x = "Readmission Status",
           y = "Count") +
      theme_minimal()
  })
  
  # Render ROC plot based on the selected model
  output$rocPlot <- renderPlot({
    if (input$model == "Random Forest") {
      plot(roc_rf, col = "green", main = "ROC Curve for Random Forest")
    } else {
      plot(roc_dt, col = "red", main = "ROC Curve for Decision Tree")
    }
  })
  
  # Render model comparison table
  output$modelComparison <- renderTable({
    compare_model
  })
  
  # Render missing data plot
  output$missingDataPlot <- renderPlot({
    ggplot(miss_data, aes(features, missing_rates, fill = missing_rates)) +
      geom_bar(stat = "identity") +
      ggtitle("Missing Value Rates of Features") +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
  })
  
  # Render histograms for factor variables
  output$factorHistograms <- renderPlot({
    # Set the number of subplots per page
    num_subplots <- 8
    
    # Loop through columns in chunks to create subplots
    for (col_start in seq(1, ncol(data_factor), num_subplots)) {
      # Pivot the data for ggplot
      long <- pivot_longer(
        data_factor[, col_start:min(col_start + num_subplots - 1, ncol(data_factor))], 
        everything(),
        names_to = "features",
        values_to = "categories"
      )
      
      # Create the plot
      g <- ggplot(long, aes(x = categories, fill = features)) +
        geom_histogram(stat = "count", color = "black", alpha = 0.8) +  # Add black borders and adjust transparency
        facet_wrap(~features, scales = "free", ncol = 3) +  # Arrange in 3 columns for compactness
        scale_fill_viridis_d(option = "D", end = 0.8) +  # Use viridis color scale
        coord_flip() +  # Flip coordinates for horizontal bars
        labs(
          title = "Distribution of Factor Variables",
          x = "Categories",
          y = "Count"
        ) +  # Custom labels
        theme_bw() +  # Use theme_bw for a clean look
        theme(
          plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),  # Centered and bold title
          axis.text.x = element_text(angle = 0, vjust = 0.5, hjust = 1, size = 10),  # Improve readability of x-axis text
          axis.text.y = element_text(size = 10),  # Improve readability of y-axis text
          strip.text = element_text(size = 12, face = "bold"),  # Facet label styling
          legend.position = "none",  # Hide the legend for clarity
          panel.grid.major = element_line(color = "gray90")  # Light grid lines for clarity
        )
      
      # Print the plot
      print(g)
    }
  })
  
  # Render histograms for numeric variables
  output$numericHistograms <- renderPlot({
    # Set the number of subplots per page
    num_subplots <- 8
    
    # Loop through columns in chunks to create subplots
    for (col_start in seq(1, ncol(data_numeric), num_subplots)) {
      # Pivot the data for ggplot
      long <- pivot_longer(
        data_numeric[, col_start:min(col_start + num_subplots - 1, ncol(data_numeric))], 
        everything(),
        names_to = "features",
        values_to = "values"
      )
      
      # Create the plot
      g <- ggplot(long, aes(x = values, fill = features)) +
        geom_histogram(binwidth = 10, color = "black", alpha = 0.7) +  # Adjust binwidth, add black borders, and set transparency
        facet_wrap(~features, scales = "free", ncol = 3) +  # Arrange in 3 columns for compactness
        scale_fill_viridis_d(option = "C", end = 0.8) +  # Use viridis color scale
        labs(
          title = "Distribution of Numeric Variables",
          x = "Values",
          y = "Count"
        ) +  # Custom labels
        theme_bw() +  # Use theme_bw for a clean look
        theme(
          plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),  # Centered and bold title
          axis.text.x = element_text(angle = 0, vjust = 0.5, size = 10),  # Improve readability of x-axis text
          axis.text.y = element_text(size = 10),  # Improve readability of y-axis text
          strip.text = element_text(size = 12, face = "bold"),  # Facet label styling
          legend.position = "none",  # Hide the legend for clarity
          panel.grid.major = element_line(color = "gray90")  # Light grid lines for clarity
        )
      
      # Print the plot
      print(g)
    }
  })
  
  # Render correlation matrix plot
  output$correlationPlot <- renderPlot({
    # Compute the correlation matrix for numeric variables
    data_numeric_cor <- cor(data_numeric, use = "pairwise.complete.obs")
    
    # Plot the correlation matrix
    corrplot(data_numeric_cor, method = "color", type = "upper", tl.cex = 0.8, mar = c(0, 0, 1, 0),
             tl.pos = 'd', tl.offset = 1)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
