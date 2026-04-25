# STAT 479 CHEAT SHEET -- HANDWRITING VERSION
# Print this or copy it by hand. Organized into clear blocks.

---

## PAGE 1 FRONT -- POTENTIAL OUTCOMES + VARIANCE

---

POTENTIAL OUTCOMES

    Y_i(1) = outcome if treated       (FIXED number, not random)
    Y_i(0) = outcome if not treated    (FIXED number, not random)
    tau_i  = Y_i(1) - Y_i(0)          (individual effect -- NEVER observable)

    Y_obs  = Z * Y(1) + (1-Z) * Y(0)  (you only see one)

    ATE    = (1/N) * SUM[ Y_i(1) - Y_i(0) ]    (average over everyone)
    ATT    = E[ Y(1)-Y(0) | Z=1 ]              (effect on the treated)
    ATC    = E[ Y(1)-Y(0) | Z=0 ]              (effect on the untreated)
    In a randomized experiment: ATE = ATT = ATC

    Estimator:  tau_hat = Y_bar_T - Y_bar_C     (unbiased under CRD)

---

NEYMAN VARIANCE

    S1^2 = (1/(N-1)) SUM( Y_i(1) - Ybar(1) )^2     (spread of treated outcomes, ALL N)
    S0^2 = (1/(N-1)) SUM( Y_i(0) - Ybar(0) )^2     (spread of control outcomes, ALL N)
    S_tau^2 = (1/(N-1)) SUM( tau_i - tau )^2         (how much effects vary across people)

    EXACT VARIANCE:
    +-------------------------------------------------+
    | Var(tau_hat) = S1^2/n1 + S0^2/n0 - S_tau^2/N   |
    +-------------------------------------------------+

    ALTERNATE FORM:
    Var(tau_hat) = (n0/n1*N)*S1^2 + (n1/n0*N)*S0^2 + (2/N)*S10

    KEY IDENTITY:  S_tau^2 = S1^2 + S0^2 - 2*S10
        S10 = cov(Y_i(1), Y_i(0)) -- need both for same person --> UNIDENTIFIABLE
        So S_tau^2 is also unidentifiable --> can't compute exact variance

    CONSERVATIVE ESTIMATOR (what we actually use):
    +---------------------------------------------+
    | Var_hat = s1^2/n1 + s0^2/n0                 |
    +---------------------------------------------+
    s1^2, s0^2 = sample variances from OBSERVED groups
    Overestimates because it drops -S_tau^2/N (which is <= 0)
    So CIs are wider than needed --> coverage >= 95%

    EXACT WHEN: constant effects (tau_i = tau for all i, so S_tau^2 = 0)
        Why: constant shift --> S1^2 = S0^2, S10 = S1^2
        --> S_tau^2 = S1^2 + S1^2 - 2*S1^2 = 0

---

95% CONFIDENCE INTERVAL

    +---------------------------------------------+
    | tau_hat +/- 1.96 * sqrt(s1^2/n1 + s0^2/n0) |
    +---------------------------------------------+

    WHY THIS WORKS (4 steps):
    1. Unbiasedness centers tau_hat at tau
    2. FP-CLT: distribution is approx Normal (from RANDOMIZATION, not outcome normality)
    3. +/- 1.96 SD covers 95% of a Normal
    4. Our SE is too big (dropped S_tau^2/N >= 0) --> coverage >= 95%

---

FP-CLT vs i.i.d. CLT

    FP-CLT (this class)              |  i.i.d. CLT (intro stats)
    -------------------------------- | --------------------------------
    Only Z_i is random               |  Everything random (Y, X, Z)
    Potential outcomes are FIXED      |  Outcomes are random draws
    Finite population of N people     |  Infinite superpopulation
    Variance from assignment          |  Variance from sampling
    No distributional assumptions     |  Needs probability model

---

## PAGE 1 BACK -- FWL + FISHER + EXPERIMENTS

---

FWL THEOREM (how regression adjusts for covariates)

    Step 1: Regress Z on X. Get residuals Z_tilde = Z - E_hat[Z|X]
    Step 2: tau_hat = SUM(Z_tilde * Y) / SUM(Z_tilde^2)
            This equals the coefficient on Z in the full regression Y ~ Z + X

    Weights: w_i = Z_tilde_i / SUM(Z_tilde_j^2)

    BALANCING: SUM(w_i * X_i) = 0   (weighted covariate means are equal)
    Weights sum to 1 in each group:  SUM(w_i, Z=1) = 1

    MISSPECIFICATION BIAS:
    +---------------------------------------------+
    | Bias = SUM( w_i * g(X_i) )                  |
    +---------------------------------------------+
    g(X) = the nonlinear part you left out (X^2, log(X), etc.)
    Balances X but NOT X^2, log(X), interactions, unobserved vars

    EXTRAPOLATION: groups in different X regions --> regression guesses in the gap

    WHEN MISSPECIFICATION DOESN'T MATTER:
    If E[Z|X] = E[Z]  (treatment independent of X, e.g., randomized experiment)
    then Z_tilde ~ Z - Zbar, uncorrelated with any g(X) --> bias = 0

---

FISHER'S FRAMEWORK

    SHARP NULL: H0: Y_i(1) = Y_i(0) for ALL i
        --> specifies every missing outcome (all = Y_obs)
        --> required for Fisher's test

    WEAK NULL: H0: tau = 0 (average is zero, individuals may differ)
        --> CANNOT run randomization test (don't know individual outcomes)

    PROCEDURE:
    1. Compute T_obs (e.g., diff in means)
    2. Under H0, enumerate all C(N, n1) possible assignments
    3. For each, compute T (outcomes don't change under sharp null)
    4. p-value = fraction with |T| >= |T_obs|

    Min possible p-value = 1 / C(N, n1)
        Ex: N=6, n1=3 --> min p = 1/20 = 0.05

    EXACT, no distributional assumptions needed
    Doubling one-sided p for two-sided is NOT always valid (distribution may be asymmetric)

    TEST STATISTICS: diff-in-means (sensitive to outliers)
                     Wilcoxon/ranks (robust to outliers)

    RANDOMIZATION TEST =/= PERMUTATION TEST
        Same calculation, different reasoning
        Randomization: valid because YOU randomized
        Permutation: assumes exchangeability (model assumption)

    Type I error = reject true H0 (prob alpha)
    Type II error = fail to reject false H0
    Power = 1 - Type II error rate

---

TESTING tau = tau_0 AND CI BY INVERSION

    1. Adjust: Y_adj = Y_obs - Z * tau_0
    2. Run Fisher test on adjusted data
    3. CI = all tau_0 values that are NOT rejected:
       C = { tau_0 : p(tau_0) > alpha }
    Exact, works in any sample size, no normality needed

---

RANDOMIZATION DESIGNS

    CRD:  Fix n1 treated out of N. Pr(Z=z) = 1/C(N,n1)
          Each person: Pr(Z_i=1) = n1/N
          Assignments NOT independent (filling fixed slots)

    BLOCKED:  Randomize within blocks (e.g., age groups)
              Pr(Z) = PRODUCT[ 1/C(n_k, m_k) ]
              tau_hat = SUM[ (n_k/N) * (Ybar_T,k - Ybar_C,k) ]
              Reduces variance. K=1 block = CRD.

    PAIRED:   Strongest blocking. Match pairs, randomize within.
              Test stat: T = SUM_b (Y_bT - Y_bC)

    BERNOULLI: Each Z_i ~ Bernoulli(p) independently
               n1 is RANDOM (Binomial). Simple but can get imbalanced.

    CLUSTER:  Randomize whole clusters (schools, hospitals)
              Effective N = number of clusters, NOT individuals

---

DETERMINISTIC ASSIGNMENT BIAS

    Z_i = 1{X_i > c}   and   Y_i(0) = alpha + beta*X_i + eps

    +-------------------------------------------------------------------+
    | E[Ybar_T - Ybar_C] = tau + beta*(E[X|X>c] - E[X|X<=c])  =/= tau  |
    +-------------------------------------------------------------------+
    Biased because treated group has systematically higher X

---

## PAGE 2 FRONT -- OBS STUDIES + ASSUMPTIONS + PROPENSITY SCORE

---

THREE ASSUMPTIONS

    1. SUTVA
       (a) No interference -- my outcome depends only on MY treatment
       (b) No hidden versions of treatment (one well-defined treatment)

    2. IGNORABILITY (untestable!)
       (Y(1), Y(0))  indep  Z | X
       "Among people with same X, who gets treated is as-good-as-random"

    3. OVERLAP (positivity)
       0 < Pr(Z=1|X=x) < 1  for all x
       "Every type of person could end up in either group"

    Strong ignorability = #2 + #3 together

---

SELECTION BIAS DECOMPOSITION (know the derivation)

    +-----------------------------------------------------------------------+
    | E[Y|Z=1] - E[Y|Z=0] = ATT + { E[Y(0)|Z=1] - E[Y(0)|Z=0] }         |
    |                        ^^^     ^^^^^^^^^^^^^^^^^^^^^^^^^^             |
    |                       causal          selection bias                  |
    +-----------------------------------------------------------------------+

    Derivation:
    Start: E[Y|Z=1] - E[Y|Z=0]
    SUTVA: = E[Y(1)|Z=1] - E[Y(0)|Z=0]
    Add & subtract E[Y(0)|Z=1]:
    = { E[Y(1)|Z=1] - E[Y(0)|Z=1] } + { E[Y(0)|Z=1] - E[Y(0)|Z=0] }
    =           ATT                  +       selection bias
    Vanishes under randomization or ignorability.

---

IDENTIFICATION PROOF (know this chain!)

    Want: E[Y(1)]
    Step 1: = E[ E[Y(1) | X] ]                    (tower property)
    Step 2: = E[ E[Y(1) | Z=1, X] ]               (ignorability: can add Z=1)
    Step 3: = E[ E[Y | Z=1, X] ]                  (consistency: Y = Y(1) for treated)

    Same for Y(0). Subtract:
    +-------------------------------------------------------------+
    | tau = E[ E[Y|Z=1,X] - E[Y|Z=0,X] ]                        |
    +-------------------------------------------------------------+

    ATT version: same inner part, average over X distribution of TREATED
    ATC version: same inner part, average over X distribution of CONTROLS
    Also works with e(X) instead of X (balancing property)

---

PROPENSITY SCORE

    e(X) = Pr(Z=1 | X)

    BALANCING PROPERTY: (Y(1),Y(0)) indep Z | e(X)
        Match on 1 number instead of all covariates
        Coarsest balancing score

    PROOF SKETCH:
        Fix e(X) = p. Everyone in group has same Pr(Z=1) = p.
        Pr(X=x | Z=1, e=p) = p*Pr(X=x) / p = Pr(X=x | e=p)
        The p's cancel! Treated are a random subset within each PS stratum.

    Estimated via logistic regression
    Coefficients = what predicts SELECTION, NOT causal effects
    Goal = balance, NOT prediction accuracy
    Don't include instruments (affect Z but not Y)

---

BALANCE DIAGNOSTICS

    SMD = (Xbar_T - Xbar_C) / sqrt( (s_T^2 + s_C^2) / 2 )

        < 0.1  = good
        ~ 0.2  = marginal
        > 0.25 = bad

    VARIANCE RATIO = Var(X_T) / Var(X_C)    should be near 1

    Use SMD not t-tests (t-test depends on sample size)

    LOVE PLOT: SMDs before vs after matching. Want all dots near 0.

---

DESIGN vs ANALYSIS (sacred boundary)

    DESIGN (no outcomes):  estimate PS, match/weight, check balance, check overlap
    ANALYSIS (now use Y):  estimate tau, build CI, sensitivity analysis

    Never peek at Y during design. Like pre-registering a clinical trial.

---

## PAGE 2 BACK -- MATCHING + IPW + AIPW + R CODE

---

MATCHING (a design tool -- no outcomes!)

    Estimator: tau_hat = (1/n_M) SUM_{Z=1} [ Y_i - Y_j(i) ]
               j(i) = matched control for treated person i

    BIAS BOUND:  |Bias| <= L * (|Delta_X| + 2*s_D)
        L = steepness of outcome function
        Delta_X = avg match gap
        s_D = how inconsistent match quality is

    TYPES:
        Exact: identical covariates (impractical with continuous vars)
        Nearest-neighbor: closest on distance
        Mahalanobis: d = sqrt( (Xi-Xj)' * Sigma_inv * (Xi-Xj) )
            Normalizes scale + correlation. Breaks in high dimensions.
        PS matching: match on propensity score
        Optimal: minimizes TOTAL distance across all pairs

    COMPOSITE DISTANCE: d = (Xi-Xj)^2 + lambda * 1{Wi =/= Wj}
        Large lambda = strong preference for same-category matches

    1:1 vs 1:k: more controls = lower variance, worse match quality
    Exact matching on categories can hurt other balance.
    Near-fine balance = softer: similar marginal distributions, allows cross-category.

---

SUBCLASSIFICATION

    tau_hat = SUM_k (N_k/N) * (Ybar_T,k - Ybar_C,k)

    5 strata removes ~90% of bias (Cochran)
    Watch for sparse strata --> merge with neighbor
    If PS model wrong, can make things WORSE

---

IPW (INVERSE PROBABILITY WEIGHTING)

    +-----------------------------------------------------------+
    | tau_IPW = (1/N) SUM[ Z*Y/e(X) - (1-Z)*Y/(1-e(X)) ]      |
    +-----------------------------------------------------------+

    ATT version:
    tau_ATT = (1/n1) SUM[ Z*Y - e(X)*(1-Z)*Y / (1-e(X)) ]

    WHY UNBIASED:
        E[ Z*Y / e(X) ]  =  E[ e(X)*E[Y(1)|X] / e(X) ]  =  E[Y(1)]
        Tower property + ignorability. The e(X) cancels.

    IPW BALANCES ANY g(X):
        E[ Z*g(X)/e(X) ] = E[ g(X)/e(X) * E[Z|X] ] = E[ g(X)*e(X)/e(X) ] = E[g(X)]
        Works for g = X, X^2, sin(X), anything
        If balance is bad in data --> PS model is wrong

    E[w_i] = 2:
        w_i = Z/e(X) + (1-Z)/(1-e(X))
        E[Z/e(X) | X] = e(X)/e(X) = 1
        E[(1-Z)/(1-e(X)) | X] = (1-e(X))/(1-e(X)) = 1
        Sum = 2

    ESS = (SUM w_i)^2 / SUM(w_i^2)
        Equal weights: ESS = N.  Extreme weights: ESS collapses.

    EXTREME WEIGHTS: e(X) near 0 or 1 --> huge weights --> one person dominates

    FIXES:
        Trimming: drop e(X) outside [0.1, 0.9] (changes estimand)
        Stabilized: w_stab = Z*p_hat/e(X) + (1-Z)*(1-p_hat)/(1-e(X))
        Hajek: SUM(Z*Y/e) / SUM(Z/e) - SUM((1-Z)*Y/(1-e)) / SUM((1-Z)/(1-e))
            Forces weights to sum to 1. Tiny bias, much lower variance.

---

AIPW (DOUBLY ROBUST)

    +-------------------------------------------------------------------------+
    | tau_AIPW = (1/N) SUM[ mu1(X) - mu0(X)                                  |
    |                       + Z*(Y-mu1(X))/e(X)                               |
    |                       - (1-Z)*(Y-mu0(X))/(1-e(X)) ]                     |
    +-------------------------------------------------------------------------+

    4 TERMS:
        mu1 - mu0 = regression estimate
        Z*(Y-mu1)/e = IPW-weighted treated residual (correction)
        (1-Z)*(Y-mu0)/(1-e) = IPW-weighted control residual (correction)

    HOW IT SELF-CORRECTS:
        Outcome model perfect --> residuals = 0, corrections vanish, just regression
        PS model perfect --> IPW corrections fix bad regression
        DOUBLY ROBUST: works if EITHER model is correct. Fails only if BOTH wrong.

---

REGRESSION-BASED ATE

    Fit mu1(X) on treated only, mu0(X) on controls only
    Predict for EVERYONE
    tau_reg = (1/N) SUM[ mu1(Xi) - mu0(Xi) ]

---

R CODE PATTERNS

    PS model:       glm(Z ~ age + edu + married, family=binomial)
                    Coefficients = SELECTION, not causal

    Distance:       multigrp_dist_struc(df, "Z",
                      list(mahal=c("age","edu"), ps="ps_logit"), c(1,2))
                    c(1,2) = PS gets 2x weight of Mahalanobis

    Matching:       kwaymatching(dist, "Z", indexgroup="treated", design=c(1,2))
                    design=c(1,2) = each treated gets 2 controls
                    exactmatchon="race"     = hard: only within same race
                    finebalanceVars="race"  = soft: overall distribution similar

    Reg ATE:        m1 = lm(Y~X, subset=Z==1)
                    m0 = lm(Y~X, subset=Z==0)
                    ATE = mean(predict(m1,df) - predict(m0,df))

    IPW:            mean(Z*Y/ps - (1-Z)*Y/(1-ps))

    AIPW:           mean(mu1-mu0 + Z*(Y-mu1)/ps - (1-Z)*(Y-mu0)/(1-ps))

---

ALL METHODS NEED SAME ASSUMPTIONS

    Regression, Matching, Subclassification, IPW, AIPW
    ALL require: SUTVA + Ignorability + Overlap
    If unobserved confounding exists, ALL methods give wrong answers.
    Different tools, same requirements. AIPW preferred (two chances to be right).

---

OVERLAP / TRIMMING

    If PS near 0 or 1 --> no comparisons --> ALL methods fail
    Trim to [0.1, 0.9] --> changes estimand to overlap subpopulation
    Check with PS histograms (treated vs control side by side)
