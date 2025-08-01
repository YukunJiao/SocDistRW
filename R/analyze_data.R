# Set random seed
set.seed(1175410547)
# Set simulation parameters
n <- 100
# Simulate exogenous nodes
needs <- rnorm(n = n)
# Simulate endogenous nodes
intrinsic_motivation <- -(0.29 * needs) + rnorm(n = n)
wellbeing <- 0.11 * intrinsic_motivation + 0.28 * needs + rnorm(n = n)
df <- data.frame(
intrinsic_motivation = intrinsic_motivation,
needs = needs,
wellbeing = wellbeing
)
