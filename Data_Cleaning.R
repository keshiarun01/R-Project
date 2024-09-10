#Load required libraries
library(tidyverse)
library(dplyr)
library(ggplot2)

# Load the dataset
data_main <- read.csv("diabetic_data.csv")

library(dplyr)
# List of columns that might contain "?" and need to be converted to character
columns_with_question_marks <- c("race", "payer_code", "weight", "medical_specialty")

# Convert specific columns to character, replace "?" with NA, and handle specific cases
data_main <- data_main %>%
  # Convert specified columns to character to safely handle "?"
  mutate(across(all_of(columns_with_question_marks), as.character)) %>%
  # Replace "?" with NA in all relevant columns
  mutate(across(all_of(columns_with_question_marks), ~ na_if(., "?"))) %>%
  # Convert specific values to NA in numeric columns
  mutate(
    admission_type_id = replace(admission_type_id, admission_type_id %in% c(5, 6, 8), NA),
    discharge_disposition_id = replace(discharge_disposition_id, discharge_disposition_id %in% c(18, 25, 26), NA),
    admission_source_id = replace(admission_source_id, admission_source_id %in% c(9, 15, 17, 20, 21), NA)
  )

data_main$race <- as.factor(data_main$race)
data_main$gender <- as.factor(data_main$gender)
data_main$age <- as.factor(data_main$age)
data_main$payer_code <- as.factor(data_main$payer_code)
data_main$max_glu_serum <- as.factor(data_main$max_glu_serum)
data_main$A1Cresult <- as.factor(data_main$A1Cresult)
data_main$admission_type_id <- as.factor(data_main$admission_type_id)
data_main$admission_source_id <- as.factor(data_main$admission_source_id)
data_main$discharge_disposition_id <- as.factor(data_main$discharge_disposition_id)

for (i in 25:50){
  data_main[,i] <- as.factor(data_main[,i])
}

# Convert diagnosis columns to categorized groups
convert_diag <- function(feature, data_main) {
  val_name <- paste(feature, "_group", sep = '')
  
  # Initialize the new group column with "Other"
  data_main[[val_name]] <- "Other"
  
  # Convert the feature column to numeric, keeping track of NAs
  cur_vals <- as.numeric(data_main[[feature]])
  
  # Assign categories based on value ranges
  data_main[[val_name]][!is.na(cur_vals) & cur_vals %in% c(390:459, 785)] <- "Circulatory"
  data_main[[val_name]][!is.na(cur_vals) & cur_vals %in% c(460:519, 786)] <- "Respiratory"
  data_main[[val_name]][!is.na(cur_vals) & cur_vals %in% c(520:579, 787)] <- "Digestive"
  data_main[[val_name]][!is.na(cur_vals) & cur_vals %in% c(800:999)] <- "Injury"
  data_main[[val_name]][!is.na(cur_vals) & cur_vals %in% c(710:739)] <- "Musculoskeletal"
  data_main[[val_name]][!is.na(cur_vals) & cur_vals %in% c(580:629, 788)] <- "Genitourinary"
  data_main[[val_name]][!is.na(cur_vals) & cur_vals %in% c(140:239)] <- "Neoplasms"
  data_main[[val_name]][!is.na(cur_vals) & cur_vals >= 250 & cur_vals < 251] <- "Diabetes"
  
  return(data_main)
}

# Apply the function to multiple diagnosis columns
for (i in c("diag_1", "diag_2", "diag_3")) {
  data_main <- convert_diag(i, data_main)
}

# Convert new diagnosis groups to factors
data_main <- data_main %>%
  mutate(
    diag_1_group = as.factor(diag_1_group),
    diag_2_group = as.factor(diag_2_group),
    diag_3_group = as.factor(diag_3_group)
  )

# Remove original diagnosis columns
data_main <- subset(data_main, select = -c(diag_1, diag_2, diag_3))

hospiceORdeathORnull_id <- c(11,13,14,19,20,21,18,25,26)
data_main <- group_by(data_main, patient_nbr) %>% slice(1) %>% 
  filter(!discharge_disposition_id %in% hospiceORdeathORnull_id)
data_main <- as.data.frame(data_main)
#length(unique(data_main$patient_nbr))/length(data_main$patient_nbr)

miss_data <- data.frame(features = colnames(data_main),
                        missing_rates = round(colSums(is.na(data_main))/nrow(data_main),3))
miss_data <- miss_data[order(-miss_data$missing_rates),]
# datatable(miss_data)
miss_data$features = factor(miss_data$features, levels = unique(miss_data$features))
ggplot(miss_data, aes(features,missing_rates,fill=missing_rates))+
  geom_bar(stat="identity")+
  ggtitle("Missing value rates of 50 features") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

data_main <- subset(data_main, select = -c(medical_specialty,encounter_id,weight,patient_nbr,payer_code))

