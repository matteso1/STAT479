############################################################
## Neymanian Inference in an A/B Test: Notification Timing
##
## Example:
##  - Units: users
##  - Treatment Z = 1: notification at 8am
##  - Control   Z = 0: notification at 6pm
##  - Outcome: app opened within 24 hours (binary: 0/1)
##
## Neyman setup:
##  - Potential outcomes Y_i(1), Y_i(0) are fixed for i = 1,...,N
##  - Randomness comes ONLY from Z (treatment assignment)
##  - Estimand: finite-population ATE = (1/N) * sum_i [Y_i(1) - Y_i(0)]
##  - Estimator: difference in means between treated and control
############################################################

set.seed(123)

############################################################
## 1. Construct a finite population of users and potential outcomes
############################################################

N  <- 10000              # number of users in the experiment
p0 <- 0.20               # baseline open rate under control (6pm)
tau_true <- 0.05         # true average treatment effect (ATE): +5 p.p. at 8am

# Heterogeneous treatment effects: some users respond more, some less
# Draw individual treatment effects around tau_true
tau_i <- rnorm(N, mean = tau_true, sd = 0.03)

# Potential outcomes:
# Y_i(0): Bernoulli with probability p0
# Y_i(1): Bernoulli with probability p0 + tau_i, truncated to [0,1]
p1_i <- pmin(pmax(p0 + tau_i, 0), 1)

Y0 <- rbinom(N, size = 1, prob = p0)
Y1 <- rbinom(N, size = 1, prob = p1_i)

# Finite-population estimand (PATE)
tau_fp <- mean(Y1 - Y0)
tau_fp
# This is the "truth" in Neyman's sense: fixed, unknown in practice.

############################################################
## 2. One randomized experiment: completely randomized design
############################################################

n1 <- N/2                 # treated
n0 <- N - n1              # control

# Random assignment: choose n1 treated users uniformly at random
Z <- rep(0, N)
Z[sample(1:N, n1, replace = FALSE)] <- 1

# Observed outcomes
Y_obs <- Z * Y1 + (1 - Z) * Y0

# Difference-in-means estimator
Y_T <- mean(Y_obs[Z == 1])
Y_C <- mean(Y_obs[Z == 0])
tau_hat <- Y_T - Y_C

tau_fp      # true finite-population ATE
tau_hat     # one realization of the Neyman estimator

############################################################
## 3. Neyman variance: conservative estimator
##
## True randomization variance (unobservable in practice):
##   Var(tau_hat) = S1^2 / n1 + S0^2 / n0 - S_tau^2 / N
## We estimate conservatively:
##   Var_hat = s1^2 / n1 + s0^2 / n0
############################################################

# Sample variances in treated and control groups
s1_sq <- var(Y_obs[Z == 1])
s0_sq <- var(Y_obs[Z == 0])

# Neyman's conservative variance estimator
var_hat <- s1_sq / n1 + s0_sq / n0
se_hat  <- sqrt(var_hat)

# 95% Wald-type confidence interval (design-based)
alpha <- 0.05
z_crit <- qnorm(1 - alpha/2)

ci_lower <- tau_hat - z_crit * se_hat
ci_upper <- tau_hat + z_crit * se_hat

c(tau_hat = tau_hat,
  se_hat  = se_hat,
  ci_lower = ci_lower,
  ci_upper = ci_upper)

# Check whether the true finite-population ATE is inside the CI
(tau_fp >= ci_lower) && (tau_fp <= ci_upper)

############################################################
## 4. Unbiasedness via repeated randomization
##
## We fix the potential outcomes (Y0, Y1) and repeatedly
## re-randomize Z. Under Neyman, E[tau_hat] = tau_fp.
############################################################

B <- 2000  # number of randomizations
tau_hats <- numeric(B)

for (b in 1:B) {
  Zb <- rep(0, N)
  Zb[sample(1:N, n1, replace = FALSE)] <- 1
  Y_obs_b <- Zb * Y1 + (1 - Zb) * Y0
  tau_hats[b] <- mean(Y_obs_b[Zb == 1]) - mean(Y_obs_b[Zb == 0])
}

mean(tau_hats)   # should be close to tau_fp (unbiasedness)
tau_fp

############################################################
## 5. Asymptotic normality: histogram + normal overlay
##
## We look at the distribution of tau_hat over repeated
## randomizations and compare it to a normal curve.
############################################################

# Empirical mean and variance of tau_hat over randomizations
mean_tau <- mean(tau_hats)
var_tau  <- var(tau_hats)

mean_tau
var_tau

# Plot histogram with normal density overlay
hist(tau_hats,
     breaks = 40,
     freq   = FALSE,
     main   = "Randomization Distribution of Neyman Estimator",
     xlab   = expression(hat(tau)))

curve(dnorm(x, mean = mean_tau, sd = sqrt(var_tau)),
      add = TRUE, col = "red", lwd = 2)

legend("topright",
       legend = c("Empirical distribution", "Normal approximation"),
       lty = c(NA, 1), lwd = c(NA, 2),
       pch = c(15, NA),
       col = c("gray", "red"),
       bty = "n")

############################################################
## 6. Coverage of Neyman confidence intervals
##
## For each randomization, compute tau_hat and its Neyman CI,
## and check whether the true finite-population ATE is covered.
############################################################

cover <- logical(B)

for (b in 1:B) {
  Zb <- rep(0, N)
  Zb[sample(1:N, n1, replace = FALSE)] <- 1
  Y_obs_b <- Zb * Y1 + (1 - Zb) * Y0
  
  Y_T_b <- mean(Y_obs_b[Zb == 1])
  Y_C_b <- mean(Y_obs_b[Zb == 0])
  tau_hat_b <- Y_T_b - Y_C_b
  
  s1_sq_b <- var(Y_obs_b[Zb == 1])
  s0_sq_b <- var(Y_obs_b[Zb == 0])
  var_hat_b <- s1_sq_b / n1 + s0_sq_b / n0
  se_hat_b  <- sqrt(var_hat_b)
  
  ci_lower_b <- tau_hat_b - z_crit * se_hat_b
  ci_upper_b <- tau_hat_b + z_crit * se_hat_b
  
  cover[b] <- (tau_fp >= ci_lower_b) && (tau_fp <= ci_upper_b)
}

mean(cover)
# This is the empirical coverage probability of the Neyman CI.
# It should be close to (or slightly above) the nominal level (e.g., 0.95),
# reflecting the conservativeness of the variance estimator.
############################################################
## End of script
############################################################