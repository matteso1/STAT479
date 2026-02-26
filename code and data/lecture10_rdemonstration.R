############################################################
# Matching Designs Using approxmatch
# Week 5 — Observational Studies and Matching
#
# This script consolidates and expands all R code from the
# Week 5 lecture notes. It includes:
#   - distance structure construction
#   - 1:1 and 1:k matching
#   - exact and near-fine balance
#   - covariate balance diagnostics
#   - treatment effect estimation
#   - intro to propensity score
#
############################################################

# ----------------------------------------------------------
# 0. Setup: Load packages and prepare data
# ----------------------------------------------------------
drat::addRepo("rrelaxiv", "https://errickson.net/rrelaxiv")
install.packages("rrelaxiv")
library(optmatch)      # required by approxmatch
library(approxmatch)   # main matching engine

## Use the latest, unreleased version of the matching code
source('approxmatch/R/covbalance.R')
source('approxmatch/R/kwaymatching.R')
source('approxmatch/R/multigrp_dist_struc.R')
source('approxmatch/R/nrbalancematch.R')
source('approxmatch/R/tripletmatching.R')


# Assume df is already loaded and contains:
# load data and set up treatment groups

# Create group label required by approxmatch
df <- read.csv('nswdata_clean.csv')
names(df)
df$trainning = df$trainning+1	# Start with 1 


############################################################
# 1. Building a Distance Structure
############################################################

# The distance structure determines how "close" units are.
# It is the backbone of all matching designs.

vars <- c("age", "married", "nodegree", "education")

components <- list(
  mahal = vars   # Mahalanobis distance on selected covariates
)

wgts <- 1        # weight for the Mahalanobis component

dist_str <- multigrp_dist_struc(
  .data       = df,
  grouplabel  = 'trainning',
  components  = components,
  wgts        = wgts
)

#   Changing 'components' or 'wgts' changes the geometry of the design.
#   For example, adding a propensity score component:
#   components <- list(mahal = vars[1:2], mahal = vars[3:4]); wgts = c(1,1)
#   compare to 
#   components <- list(mahal = vars); wgts <- 1

############################################################
# 2. 1:1 Matching (Basic Matched-Pair Design)
############################################################

design <- c(1, 1)       
indexgroup <- 2       # The smaller group

res_11 <- kwaymatching(
  distmat     = dist_str,
  grouplabel  = 'trainning',
  indexgroup  = indexgroup,
  design      = design,
  .data       = df
)

matches_11 <- res_11$matches
head(matches_11)

#   Each row of 'matches_11' is a matched pair.
#   This is the simplest matched design.


############################################################
# 3. 1:k Matching (Variable Ratio Design)
############################################################

design <- c(2, 1)       

res_12 <- kwaymatching(
  distmat     = dist_str,
  grouplabel  = 'trainning',
  indexgroup  = indexgroup,
  design      = design,
  .data       = df
)

matches_12 <- res_12$matches
head(matches_12)

# Teaching note:
#   1:k matching increases precision when controls are plentiful.
#   Students can compare balance and sample size across 1:1 and 1:2.


############################################################
# 4. Exact Matching on a Key Covariate
############################################################

design <- c(1, 1)

res_exact <- kwaymatching(
  distmat       = dist_str,
  grouplabel    = 'trainning',
  indexgroup    = indexgroup,
  design        = design,
  .data         = df,
  exactmatchon  = "race"
)

matches_exact <- res_exact$matches

#   Exact matching enforces perfect balance on a nominal covariate.
#   Students can inspect strata to verify device types match exactly.


############################################################
# 5. Near-Fine Balance on a Categorical Covariate
############################################################

design <- c(1, 1)

res_fine <- kwaymatching(
  distmat         = dist_str,
  grouplabel      = 'trainning',
  indexgroup      = indexgroup,
  design          = design,
  .data           = df,
  finebalanceVars = "race"
)

matches_fine <- res_fine$matches

#   Near-fine balance ensures the *marginal distribution* of race
#   is similar across groups, even if individual strata are not
#   perfectly matched on race.


############################################################
# 6. Covariate Balance Diagnostics
############################################################


details <- c(
  'std_diff',
  'mean',
  'function(x) diff(range(x))'
)
names(details) <- c('std_diff', 'mean', 'range')

cb <- covbalance(
  .data      = df,
  grouplabel = 'trainning',
  matches    = matches_11,
  vars       = vars,
  details    = details
)

cb$std_diff

#   Compare across
#     - 1:1 vs 1:2 balance
#     - exact vs near-fine balance
#     - how distance structure affects balance




############################################################
# Love Plot Directly from covbalance() Output
############################################################

bal_table <- data.frame(cb$std_diff[[1]])

# Extract before/after
smd_before <- bal_table$std_diff_before
smd_after  <- bal_table$std_diff_after
covs       <- rownames(bal_table)

# Sort covariates by AFTER-matching imbalance
ord <- order(abs(smd_after))

par(mar=c(4,6,2,2))
# Set up empty plot with correct limits
plot(
  smd_before[ord],
  seq_along(ord),
  pch = 1,
  col = "darkred",
  xlab = "Standardized Mean Difference (SMD)",
  ylab = "",
  yaxt = "n",
  main = "Love Plot: Before vs After Matching"
)

# Add AFTER-matching points
points(
  smd_after[ord],
  seq_along(ord),
  pch = 19,
  col = "steelblue"
)

# Add vertical reference lines
abline(v = 0, lwd = 2)
abline(v = c(-0.1, 0.1), lty = 2, col = "gray40")

# Add covariate labels
axis(2, at = seq_along(ord), labels = covs[ord], las = 1)

# Add legend
legend(
  "topright",
  legend = c("Before Matching", "After Matching"),
  pch = c(1, 19),
  col = c("darkred", "steelblue"),
  bty = "n"
)


#   Love plots visually summarize SMDs before and after matching.




#######################################################
############################################################
# 7. (Priliminary) Treatment Effect Estimation in Matched Samples
############################################################

matched_ids <- as.vector(matches_fine)
matched_df  <- df[matched_ids, ]

Y = matched_df$earning75
Z = matched_df$trainning-1
  
# Simple difference in means
tau_hat <- mean(Y[Z==1]) - mean(Y[Z==0])
  
tau_hat

#   Matching is a design tool; estimation is done afterward.
#   Students can compare estimates across designs.

## Next week we shall introducce what is the propensity score
# ----------------------------------------------------------
# 8A. Propensity Score Estimation + Matching
# ----------------------------------------------------------

components_ps <- list(
  mahal = vars,
  prop  = vars
)

dist_str_ps <- multigrp_dist_struc(
  .data      = df,
  grouplabel = 'trainning',
  components = components_ps,
  wgts       = c(1, 1)
)

res_ps <- kwaymatching(
  distmat     = dist_str_ps,
  grouplabel  = 'trainning',
  indexgroup  = 2,
  design      = c(1, 1),
  .data       = df
)

matches_ps <- res_ps$matches

#   Adding a propensity score component often improves balance
#   when covariates are high-dimensional.


############################################################
# End of Lecture Script
############################################################