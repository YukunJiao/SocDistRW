# Set random seed
set.seed(317696713)
# Set simulation parameters
n <- 100
# Simulate exogenous nodes
needs <- rnorm(n = n)
# Simulate endogenous nodes
intrinsic_motivation <- 0.3 * needs + rnorm(n = n)
wellbeing <- 0.02 * needs - 0.35 * intrinsic_motivation + rnorm(n = n)
df <- data.frame(
intrinsic_motivation = intrinsic_motivation,
needs = needs,
wellbeing = wellbeing
)
