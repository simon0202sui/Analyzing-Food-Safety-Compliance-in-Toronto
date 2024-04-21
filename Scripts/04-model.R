library(brms)
library(readr)
library(dplyr)
library(knitr)

# Load the dataset
data <- read_csv("Data/analysis_data/cleaned_data.csv", show_col_types = FALSE)

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

# Adding interaction terms and adjusting prior settings
model_formula <- bf(StatusBinary ~ Establishment_Type * Severity + Min_Inspections_Per_Year)

# Adjusting priors to be less informative (weaker)
model_priors <- c(
  set_prior("normal(0, 3)", class = "b"),
  set_prior("cauchy(0, 2)", class = "Intercept")
)

# Fit the Bayesian logistic regression model with increased iterations
model <- brm(
  formula = model_formula,
  data = data,
  family = bernoulli("logit"),
  prior = model_priors,
  seed = 1234,
  chains = 4,
  iter = 8000,  # Increased from 4000 to 8000 to improve convergence and ESS
  control = list(adapt_delta = 0.95)  # Increase adapt_delta for better sampling accuracy
)

# Get summary of the model
model_summary <- summary(model)

# Extract coefficients and their standard errors
coefficients <- model_summary$coefficients[, c("Estimate", "Std. Error")]

# Print coefficients table
coefficients_table <- kable(coefficients)
coefficients_table

# Save the model
saveRDS(model, file = "C:/Users/User/Desktop/Food Safety/model/model.rds")
