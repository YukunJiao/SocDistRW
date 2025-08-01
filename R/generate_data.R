# Set random seed
set.seed(425994774)
# Set simulation parameters
n <- 100
# Simulate exogenous nodes
needs <- rnorm(n = n)
# Simulate endogenous nodes
intrinsic_motivation <- -(0.12 * needs) + rnorm(n = n)
wellbeing <- 0.48 * needs + 0.51 * intrinsic_motivation + rnorm(n = n)
df <- data.frame(
intrinsic_motivation = intrinsic_motivation,
needs = needs,
wellbeing = wellbeing
)
