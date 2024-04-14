#### Preamble ####
# Purpose: Download data
# Author: Pengyu Sui
# Date: 29 March 2024
# Contact: pengyu.sui@mail.utoronto.ca
# License: MIT
# Prerequisites: none

#### Workplace setup ####
library(tidyverse)
#### Load data ####
raw_data <- read_csv("C:/Users/User/Desktop/Final paper/Data/Dinesafe.csv", show_col_types = FALSE)

# Save a New file
write_csv(raw_data, "raw_data.csv")
