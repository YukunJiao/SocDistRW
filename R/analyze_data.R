# Set random seed
set.seed(1230444440)
# Set simulation parameters
n <- 100
# Simulate exogenous nodes
needs <- rnorm(n = n)
# Simulate endogenous nodes
intrinsic_motivation <- 0.56 * needs + rnorm(n = n)
wellbeing <- 0.1 * intrinsic_motivation - 0.43 * needs + rnorm(n = n)
df <- data.frame(
intrinsic_motivation = intrinsic_motivation,
needs = needs,
wellbeing = wellbeing
)
