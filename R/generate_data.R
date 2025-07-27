# Set random seed
set.seed(378383713)
# Set simulation parameters
n <- 100
# Simulate exogenous nodes
needs <- rnorm(n = n)
# Simulate endogenous nodes
intrinsic_motivation <- -(0.14 * needs) + rnorm(n = n)
wellbeing <- 0.18 * intrinsic_motivation + 0.53 * needs + rnorm(n = n)
df <- data.frame(
intrinsic_motivation = intrinsic_motivation,
needs = needs,
wellbeing = wellbeing
)
