#### Preamble ####
# Purpose: Running tests on the clean data
# Author: Pengyu Sui
# Date: March 29, 2024
# Contact: pengyu.sui@mail.utoronto.ca
# License: MIT
# Pre-requisites: Clean the data 

# Load necessary libraries
library(readr)
library(dplyr)
library(testthat)
library(lubridate) # Only load if date manipulations are required

# Load the dataset
data <- read_csv("cleaned_data.csv", show_col_types = FALSE)

#### Testing Phase ####

# Test 1
valid_severity_levels <- c("S - Significant", "M - Minor", "C - Crucial", "NA - Not Applicable")
test_that("Severity Levels are Valid", {
  expect_true(all(cleaned_data$Severity %in% valid_severity_levels))
})

# Test 2
valid_statuses <- c("Pass", "Pending", "Conviction - Fined", "Conviction - Suspended Sentence")
test_that("Establishment Statuses are Valid", {
  expect_true(all(cleaned_data$`Establishment Status` %in% valid_statuses))
})

# Test 3
test_that("Inspections Per Year are Non-Negative", {
  expect_true(all(cleaned_data$`Min. Inspections Per Year` >= 0))
})

# Test 4
test_that("Outcomes are Consistent with Statuses", {
  expect_true(all((cleaned_data$`Establishment Status` == "Conviction - Fined") == (cleaned_data$Outcome == "Fined")))
})


# Test 5
test_that("Inspections Per Year is Within Range", {
  expect_true(all(cleaned_data$`Min. Inspections Per Year` %in% 1:3))
})





