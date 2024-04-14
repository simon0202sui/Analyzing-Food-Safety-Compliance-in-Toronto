#### Preamble ####
# Purpose: Cleans the raw data 
# Author: Pengyu Sui
# Date: March 29, 2024
# Contact: pengyu.sui@mail.utoronto.ca
# License: MIT
# Pre-requisites: download the data in the "data" folder
library(readr)
library(dplyr)

# Load the dataset
data <- read_csv("Data/raw_data/raw_data.csv", show_col_types = FALSE)

# Define the valid statuses based on the test results and previous knowledge
valid_statuses <- c("Pass", "Pending", "Conviction - Fined", "Conviction - Suspended Sentence")

# Select relevant columns and handle missing data by dropping rows with any missing values
cleaned_data <- data %>%
  select(`Establishment Type`, Severity, `Establishment Status`, `Min. Inspections Per Year`, `Outcome`) %>%
  drop_na()

# Convert Establishment Type and Severity to factors as before
# Additionally, filter out invalid Establishment Status values or correct them
cleaned_data <- cleaned_data %>%
  mutate(`Establishment Type` = as.factor(`Establishment Type`),
         Severity = as.factor(Severity),
         `Establishment Status` = as.factor(`Establishment Status`),
         # Correct or remove unexpected Establishment Status values
         `Establishment Status` = if_else(`Establishment Status` %in% valid_statuses, `Establishment Status`, NA_character_)) %>%
  drop_na(`Establishment Status`)  # Drop rows where Establishment Status was not valid

# View the first few rows to confirm the changes
head(cleaned_data)

# Get a summary of the cleaned data
summary(cleaned_data)

# Save the cleaned data
write_csv(cleaned_data, "cleaned_data.csv")

