# Set random seed
set.seed(291138832)
# Set simulation parameters
n <- 100
# Simulate exogenous nodes
needs <- rnorm(n = n)
# Simulate endogenous nodes
intrinsic_motivation <- 0.17 * needs + rnorm(n = n)
wellbeing <- 0.02 * intrinsic_motivation + 0.57 * needs + rnorm(n = n)
df <- data.frame(
intrinsic_motivation = intrinsic_motivation,
needs = needs,
wellbeing = wellbeing
)
