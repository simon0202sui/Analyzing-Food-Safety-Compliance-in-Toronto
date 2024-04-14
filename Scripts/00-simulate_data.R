#### Preamble ####
# Purpose: Simulate data
# Author: Pengyu Sui
# Date: 29 March 2024
# Contact: pengyu.sui@mail.utoronto.ca
# License: MIT
# Prerequisites: none

## Work space set up ##
# Load necessary libraries

library(dplyr)
library(tidyr)
library(ggplot2)
library(purrr)

# Define Establishment Types and their associated minimum inspection frequencies
establishment_types <- c("Restaurant", "Food Depot", "Food Take Out", "Hot Dog Cart")
inspection_frequencies <- c(3, 2, 2, 0.5)  # Low risk inspected once every two years, hence 0.5 per year

# Mapping types to their inspection frequencies
type_inspection_map <- setNames(inspection_frequencies, establishment_types)

# Establishment status probabilities based on the type (hypothetical)
status_probabilities <- list(
  Restaurant = c(Pass = 0.70, Conditional_Pass = 0.25, Closed = 0.05),
  Food_Depot = c(Pass = 0.60, Conditional_Pass = 0.30, Closed = 0.10),
  Food_Take_Out = c(Pass = 0.75, Conditional_Pass = 0.20, Closed = 0.05),
  Hot_Dog_Cart = c(Pass = 0.85, Conditional_Pass = 0.10, Closed = 0.05)
)

# Simulate data for 1000 establishments
set.seed(123)  # For reproducibility
simulated_data <- tibble(
  Establishment_Type = sample(establishment_types, 1000, replace = TRUE, prob = c(0.3, 0.2, 0.4, 0.1)),
  Min_Inspections_Per_Year = map_dbl(Establishment_Type, ~ type_inspection_map[.])
)

# Assigning establishment status with custom probabilities
simulated_data <- simulated_data %>%
  mutate(Establishment_Status = map2_chr(Establishment_Type, runif(n()), ~ {
    probs <- status_probabilities[[gsub(" ", "_", .x)]]
    sample(names(probs), 1, prob = probs)
  }))

# Display the first few rows of the data
head(simulated_data)

# Plot minimum inspections per year by establishment type
ggplot(simulated_data, aes(x = Establishment_Type, y = Min_Inspections_Per_Year)) +
  geom_boxplot() +
  labs(title = "Inspection Frequency by Establishment Type", x = "Establishment Type", y = "Minimum Inspections Per Year")

# Plot proportion of establishment statuses by type
ggplot(simulated_data, aes(x = Establishment_Type, fill = Establishment_Status)) +
  geom_bar(position = "fill") +
  labs(title = "Establishment Status by Type", x = "Establishment Type", y = "Proportion of Status") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
