library(brms)
library(readr)
library(dplyr)

# Load the dataset
data <- read_csv("C:/Users/User/Desktop/Final paper/data/cleaned_data.csv", show_col_types = FALSE)

# Check column names
colnames(data)

# Rename columns
data <- data %>%
  rename(Establishment_Type = `Establishment Type`,
         Min_Inspections_Per_Year = `Min. Inspections Per Year`)


# Filter out statuses that are not "Pass" or "Conditional Pass" and recode
data <- data %>%
  filter(`Establishment Status` %in% c("Pass", "Conditional Pass")) %>%
  mutate(StatusBinary = as.numeric(`Establishment Status` == "Pass"),
         Establishment_Type = as.factor(Establishment_Type),
         Severity = as.factor(Severity))

# Fit the Bayesian logistic regression model
model <- brm(formula = StatusBinary ~ Establishment_Type + Severity + Min_Inspections_Per_Year,
                   data = data, 
                   family = bernoulli("logit"), 
                   prior = c(set_prior("normal(0, 10)", class = "b")),
                   seed = 1234, 
                   chains = 4, 
                   iter = 4000)


# Save the model
saveRDS(model, file = "C:/Users/User/Desktop/Final paper/model/model.rds")

