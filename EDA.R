library(corrplot)
library(reshape2)
library(ggcorrplot)
library(gridExtra)
library(VIM)
library(tidyr)

# EDA: Code for Factor Variables
data_factor <- data_main[, unlist(lapply(data_main, is.factor))]
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
      axis.text.x = element_text(angle = 0, vjust = 0.5, size = 10),  # Improve readability of x-axis text
      axis.text.y = element_text(size = 10),  # Improve readability of y-axis text
      strip.text = element_text(size = 12, face = "bold"),  # Facet label styling
      legend.position = "none",  # Hide the legend for clarity
      panel.grid.major = element_line(color = "gray90")  # Light grid lines for clarity
    )
  
  # Print the plot
  print(g)
}

# EDA:Code for Numeric Variables
data_numeric <- data_main[, unlist(lapply(data_main, is.numeric))]
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


#Corelation Matrix
data_numeric_cor <- cor(data_numeric,use="pairwise.complete.obs")
corrplot(data_numeric_cor, method="color", type="upper", tl.cex = 0.8, mar=c(0,0,1,0), 
         tl.pos='d',tl.offset = 1)


