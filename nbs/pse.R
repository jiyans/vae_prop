# Set seed for reproducibility
set.seed(789)

# Generate sample data with clear selection bias
n <- 1000

# Create covariates with different distributions
X1 <- rnorm(n, mean = 2, sd = 1)
X2 <- rbinom(n, 1, 0.4)  # binary covariate
X3 <- rexp(n, rate = 1)  # right-skewed covariate

# Treatment assignment with clear selection bias
ps_true <- plogis(-1 + 0.5*X1 + 1.5*X2 + 0.3*X3)
treatment <- rbinom(n, 1, ps_true)

# Outcome with parallel treatment effect
# Making treatment more likely for certain groups
Y <- 5 + 3*treatment + 0.8*X1 + 2*X2 + 0.5*X3 + rnorm(n, 0, 1)

# Create dataset
data <- data.frame(X1=X1, X2=X2, X3=X3, treatment=treatment, Y=Y)

# Simple linear regression
lm_simple <- lm(Y ~ treatment + X1 + X2 + X3, data=data)

# Propensity score matching
library(MatchIt)
ps_model <- matchit(treatment ~ X1 + X2 + X3, data = data, method = "nearest", caliper = 0.2)  # adding caliper for better matching quality

matched_data <- match.data(ps_model)

# Analysis on matched data
lm_matched <- lm(Y ~ treatment, data=matched_data)

# Print results
cat("True treatment effect: 3\n")
cat("Linear regression estimate:", round(coef(lm_simple)["treatment"], 3), "\n")
cat("Propensity score matching estimate:", round(coef(lm_matched)["treatment"], 3), "\n")

# Compare standard errors
cat("\nStandard Errors:\n")
cat("Linear regression SE:", round(summary(lm_simple)$coefficients["treatment", "Std. Error"], 3), "\n")
cat("PS matching SE:", round(summary(lm_matched)$coefficients["treatment", "Std. Error"], 3), "\n")

# Check balance
summary(ps_model)

# Visual check of covariate balance
plot(summary(ps_model))
