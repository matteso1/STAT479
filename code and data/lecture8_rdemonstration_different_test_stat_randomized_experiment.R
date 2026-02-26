############################################################
## Randomization Test Functions
############################################################

# Generate all random assignments (Monte Carlo)
rand_assign <- function(N, n1, reps = 2000) {
  replicate(reps, {
    z <- rep(0, N)
    z[sample(1:N, n1)] <- 1
    z
  })
}

# Test statistics
T_diffmeans <- function(Z, Y) {
  mean(Y[Z == 1]) - mean(Y[Z == 0])
}

T_ranksum <- function(Z, Y) {
  R <- rank(Y)
  sum(R[Z == 1])
}

T_attrib <- function(Z, Y1, Y0) {
  # Only meaningful for binary outcomes
  sum(Z * (Y1 - Y0))
}

# Randomization test under sharp null
rand_test <- function(Z_obs, Y_obs, Tfun, Z_mat) {
  T_obs <- Tfun(Z_obs, Y_obs)
  T_null <- apply(Z_mat, 2, Tfun, Y = Y_obs)
  mean(abs(T_null) >= abs(T_obs))
}

############################################################
## DGP 1: Normal outcomes with constant additive effect
############################################################




set.seed(3)
  
N  <- 50
n1 <- 25
tau <- 0.5  # true effect

# Potential outcomes
Y0 <- rnorm(N, mean = 0, sd = 1)
Y1 <- Y0 + tau

Z_obs <- rep(0, N)
Z_obs[sample(1:N, n1)] <- 1
Y_obs <- Z_obs * Y1 + (1 - Z_obs) * Y0

# Randomization distribution
Z_mat <- rand_assign(N, n1, reps = 2000)

# p-values
p_dm   <- rand_test(Z_obs, Y_obs, T_diffmeans, Z_mat)
p_rank <- rand_test(Z_obs, Y_obs, T_ranksum,   Z_mat)

p_dm
p_rank

power_dm = power_rank = 0
Itr = 100
for(itr in 1:Itr){
  # Random assignment
  Z_obs <- rep(0, N)
  Z_obs[sample(1:N, n1)] <- 1
  Y_obs <- Z_obs * Y1 + (1 - Z_obs) * Y0
  
  # Randomization distribution
  Z_mat <- rand_assign(N, n1, reps = 2000)
  
  # p-values
  p_dm   <- rand_test(Z_obs, Y_obs, T_diffmeans, Z_mat)
  p_rank <- rand_test(Z_obs, Y_obs, T_ranksum,   Z_mat)
  
  p_dm
  p_rank
  
  power_dm = power_dm + (p_dm<0.05)
  power_rank = power_rank + (p_rank<0.05)
}

power_dm/Itr

power_rank/Itr
############################################################
## DGP 2: Heavy-tailed outcomes (Cauchy)
############################################################

set.seed(1)
Y0 <- rcauchy(N, location = 0, scale = 1)
Y1 <- Y0 + tau

Z_obs <- rep(0, N)
Z_obs[sample(1:N, n1)] <- 1
Y_obs <- Z_obs * Y1 + (1 - Z_obs) * Y0

Z_mat <- rand_assign(N, n1, reps = 2000)

p_dm   <- rand_test(Z_obs, Y_obs, T_diffmeans, Z_mat)
p_rank <- rand_test(Z_obs, Y_obs, T_ranksum,   Z_mat)

p_dm
p_rank


power_dm = power_rank = 0
Itr = 100
for(itr in 1:Itr){
  
  Z_obs <- rep(0, N)
  Z_obs[sample(1:N, n1)] <- 1
  Y_obs <- Z_obs * Y1 + (1 - Z_obs) * Y0
  
  Z_mat <- rand_assign(N, n1, reps = 2000)
  
  p_dm   <- rand_test(Z_obs, Y_obs, T_diffmeans, Z_mat)
  p_rank <- rand_test(Z_obs, Y_obs, T_ranksum,   Z_mat)
  
  p_dm
  p_rank
  
  power_dm = power_dm + (p_dm<0.05)
  power_rank = power_rank + (p_rank<0.05)
}

power_dm/Itr

power_rank/Itr

############################################################
## DGP 3: Binary outcomes with rare events
############################################################

set.seed(3)
p0 <- 0.05
tau <- 0.03  # additive increase in probability

Y0 <- rbinom(N, 1, p0)
Y1 <- rbinom(N, 1, p0 + tau)

Z_obs <- rep(0, N)
Z_obs[sample(1:N, n1)] <- 1
Y_obs <- Z_obs * Y1 + (1 - Z_obs) * Y0

Z_mat <- rand_assign(N, n1, reps = 2000)

# Attributable effect statistic requires both potential outcomes
T_attrib_wrapper <- function(Z, Yobs) {
  # Under sharp null, Y1 = Y0 = Yobs
  # Under alternative, we use observed Yobs but statistic is defined on potential outcomes
  # For power simulation, we plug in true Y1 and Y0
  T_attrib(Z, Y1, Y0)
}

p_dm     <- rand_test(Z_obs, Y_obs, T_diffmeans, Z_mat)
p_rank   <- rand_test(Z_obs, Y_obs, T_ranksum,   Z_mat)
p_attrib <- rand_test(Z_obs, Y_obs, T_attrib_wrapper, Z_mat)

p_dm
p_rank
p_attrib

power_dm = power_rank = p_attrib = 0
Itr = 100
for(itr in 1:Itr){
  
  Z_obs <- rep(0, N)
  Z_obs[sample(1:N, n1)] <- 1
  Y_obs <- Z_obs * Y1 + (1 - Z_obs) * Y0
  
  Z_mat <- rand_assign(N, n1, reps = 2000)
  
  # Attributable effect statistic requires both potential outcomes
  T_attrib_wrapper <- function(Z, Yobs) {
    # Under sharp null, Y1 = Y0 = Yobs
    # Under alternative, we use observed Yobs but statistic is defined on potential outcomes
    # For power simulation, we plug in true Y1 and Y0
    T_attrib(Z, Y1, Y0)
  }
  
  p_dm     <- rand_test(Z_obs, Y_obs, T_diffmeans, Z_mat)
  p_rank   <- rand_test(Z_obs, Y_obs, T_ranksum,   Z_mat)
  p_attrib <- rand_test(Z_obs, Y_obs, T_attrib_wrapper, Z_mat)
  
  power_dm = power_dm + (p_dm<0.05)
  power_rank = power_rank + (p_rank<0.05)
  power_attrib = power_attrib + (p_attrib<0.05)
}

power_dm/Itr

power_rank/Itr

power_attrib/Itr