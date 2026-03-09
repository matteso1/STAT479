# STAT 479 MIDTERM CHEAT SHEET (1 page, front & back)

## ====== SIDE 1: FORMULAS + FRAMEWORK ======

### POTENTIAL OUTCOMES & ESTIMANDS
- $Y_i(1)$ = outcome if treated, $Y_i(0)$ = outcome if not. Fixed numbers, NOT random.
- $\tau_i = Y_i(1) - Y_i(0)$ (individual effect). NEVER observable (fundamental problem).
- $Y_i^{obs} = Z_i Y_i(1) + (1-Z_i)Y_i(0)$ (you see one, never both)
- $\tau = \frac{1}{N}\sum[Y_i(1) - Y_i(0)]$ (ATE -- finite population, fixed number)
- $\hat{\tau} = \bar{Y}_T - \bar{Y}_C$ (difference in means estimator)
- Under CRD: $\mathbb{E}[\hat{\tau}] = \tau$ (unbiased, from randomization alone)

### NEYMAN VARIANCE (CRITICAL)
- $S_z^2 = \frac{1}{N-1}\sum(Y_i(z) - \bar{Y}(z))^2$ for $z=0,1$ (spread of potential outcomes over ALL N people)
- $S_\tau^2 = \frac{1}{N-1}\sum(\tau_i - \tau)^2$ (treatment effect heterogeneity)
- **Exact variance:** $\text{Var}(\hat{\tau}) = \frac{S_1^2}{n_1} + \frac{S_0^2}{n_0} - \frac{S_\tau^2}{N}$
- **KEY IDENTITY:** $S_\tau^2 = S_1^2 + S_0^2 - 2S_{10}$
  - $S_{10}$ = cov between $Y_i(1)$ and $Y_i(0)$ -- UNIDENTIFIABLE (need both for same person, never have it)
  - So $S_\tau^2$ is also unidentifiable --> can't compute exact variance
- **Conservative estimator:** $\widehat{Var}(\hat{\tau}) = \frac{s_1^2}{n_1} + \frac{s_0^2}{n_0}$ where $s_z^2$ = sample variance in observed group $z$
  - Overestimates because drops $-S_\tau^2/N$ (and $S_\tau^2 \ge 0$ always -- sum of squares)
- **Exact when:** $\tau_i = \tau$ for all $i$ (constant effect). Then $S_\tau^2 = 0$.
  - Under constant effects: $S_1^2 = S_0^2$ and $S_{10} = S_1^2$, so $S_\tau^2 = S_1^2 + S_1^2 - 2S_1^2 = 0$

### ALTERNATE VARIANCE FORM
$$\text{Var}(\hat{\tau}) = \frac{n_0}{n_1 N}S_1^2 + \frac{n_1}{n_0 N}S_0^2 + \frac{2}{N}S_{10}$$
Same formula, rearranged. Shows $S_{10}$ directly. Both forms equivalent via algebra.

### 95% CI (WHY IT WORKS)
$$\hat{\tau} \pm 1.96\sqrt{s_1^2/n_1 + s_0^2/n_0}$$
1. Unbiasedness centers $\hat{\tau}$ around $\tau$
2. Finite-pop CLT: distribution across randomizations is approx Normal (from randomization, NOT normality of outcomes)
3. $\pm 1.96$ SD covers 95% of Normal
4. Our SE is too big (dropped $S_\tau^2/N \ge 0$) so interval is wider --> coverage $\ge$ 95%

### FWL THEOREM (WEEK 1)
- $\tilde{Z}_i = Z_i - \hat{E}[Z|X_i]$ (residual from regressing $Z$ on $X$)
- $\hat{\tau} = \frac{\sum \tilde{Z}_i Y_i}{\sum \tilde{Z}_i^2}$ -- same as regression coefficient on $Z$
- Weights: $w_i = \tilde{Z}_i / \sum \tilde{Z}_j^2$
- **Balances:** $\sum w_i X_i = 0$ (weighted covariate means equal)
- **Misspecification bias:** $\text{Bias} = \sum w_i g(X_i)$ where $g(X)$ = omitted nonlinear part
  - Balances $X$ but NOT $X^2$, $\log(X)$, interactions, unobserved vars
- **Extrapolation:** If treated/control occupy different $X$ regions, $\tilde{Z}_i$ is large at extremes --> extreme weights --> extrapolation into no-data regions

### FISHER'S FRAMEWORK
- Sharp null: $H_0: Y_i(1) = Y_i(0)$ for ALL $i$ (zero effect on everyone)
- Under $H_0$: all potential outcomes known ($= Y_i^{obs}$)
- p-value = fraction of $\binom{N}{n_1}$ randomizations with $|T| \ge |T_{obs}|$
- **Exact** (no asymptotics), valid from randomization alone
- One-sided p = count/total. Doubling for two-sided NOT always valid (distribution may not be symmetric)
- **CI by inversion:** Adjust $Y_i^{adj} = Y_i^{obs} - Z_i \cdot \tau_0$. Test each $\tau_0$. Keep non-rejected values: $C = \{\tau_0 : p(\tau_0) > \alpha\}$
- **Diff-in-means** vs **Wilcoxon**: same procedure, different test statistic. Wilcoxon uses ranks --> robust to outliers. Can give different p-values under same null.

### RANDOMIZATION vs. REGRESSION
| Randomization | Regression |
|---|---|
| Balances EVERYTHING (incl. unobserved) | Only balances what you include (linearly) |
| No model needed | Needs correct functional form |
| Design-based inference | Model-based inference |

### REGRESSION INSIDE EXPERIMENTS
- Still unbiased even if model is wrong (because randomization)
- **Why:** $Z$ is mean-independent of $X$ under randomization, so $\tilde{Z}_i \perp g(X_i)$ --> bias $= \sum w_i g(X_i) = 0$ even if $g$ is wrong
- Reduces variance (noise-canceling) -- does NOT change estimand
- Refines a good design, doesn't rescue a bad one

---

## ====== SIDE 2: OBS STUDIES + METHODS ======

### THREE ASSUMPTIONS FOR OBS STUDIES
1. **SUTVA:** (a) No interference (my outcome doesn't depend on your treatment) (b) No hidden versions of treatment
2. **Ignorability:** $(Y(1),Y(0)) \perp\!\!\!\perp Z \mid X$ -- all confounders measured. UNTESTABLE.
3. **Overlap:** $0 < Pr(Z=1|X=x) < 1$ for all $x$ -- everyone has a chance of being in either group

### IDENTIFICATION (KNOW THIS PROOF)
$\mathbb{E}[Y(1)] = \mathbb{E}[\mathbb{E}[Y(1)|X]]$ (tower property)
$= \mathbb{E}[\mathbb{E}[Y(1)|Z\!=\!1,X]]$ (ignorability)
$= \mathbb{E}[\mathbb{E}[Y|Z\!=\!1,X]]$ (consistency + overlap)
Same for $Y(0)$. Subtract: $\tau = \mathbb{E}[\mathbb{E}[Y|Z\!=\!1,X] - \mathbb{E}[Y|Z\!=\!0,X]]$

### SELECTION BIAS DECOMPOSITION
$$\mathbb{E}[Y|Z\!=\!1] - \mathbb{E}[Y|Z\!=\!0] = \underbrace{ATT}_{\text{causal}} + \underbrace{\mathbb{E}[Y(0)|Z\!=\!1] - \mathbb{E}[Y(0)|Z\!=\!0]}_{\text{selection bias}}$$
Vanishes under randomization or conditional ignorability.

### PROPENSITY SCORE $e(X) = Pr(Z=1|X)$
- **Balancing property:** $(Y(1),Y(0)) \perp\!\!\!\perp Z \mid e(X)$ -- match on 1 number instead of all $X$
- Coarsest balancing score (simplest sufficient summary)
- Estimated via logistic regression; coefficients describe SELECTION, not causal effects
- Goal = balance, NOT prediction accuracy
- Don't include instruments (affect $Z$ but not $Y$) -- increases variance without reducing bias

### SMD (STANDARDIZED MEAN DIFFERENCE)
$$SMD = \frac{\bar{X}_T - \bar{X}_C}{\sqrt{(s_T^2 + s_C^2)/2}}$$
$< 0.1$ = good | $\approx 0.2$ = marginal | $> 0.25$ = bad. Use SMD not t-tests (t-test is sample-size dependent).

### MATCHING
- **Design tool** (no outcomes!) -- creates balanced dataset, then simple analysis
- Types: exact, nearest-neighbor, Mahalanobis, PS, optimal
- **Bias bound:** $|Bias| \le L(|\Delta_X^M| + 2s_D)$ where $L$ = Lipschitz (max steepness of $g$)
- **Mahalanobis:** $d_M = \sqrt{(X_i-X_j)^T \hat{\Sigma}^{-1} (X_i-X_j)}$ -- normalizes scale + correlation
  - Breaks in high dimensions (curse of dimensionality) --> add PS caliper
- **Exact matching** on categorical var can worsen balance on others (forces within-category matches when categories are sparse). **Near-fine balance** relaxes this: enforces marginal distribution balance while allowing cross-category matches.
- **Distance weights** c(w1,w2): higher w2 on PS = closer PS matches but maybe worse raw covariate matches. Trade-off.
- **1:1 vs 1:k**: 1:k uses $k$ controls per treated --> lower variance (more data), but match quality degrades (further matches). `design = c(1,k)` in R.

### SUBCLASSIFICATION (STRATIFICATION)
$$\hat{\tau}_{strat} = \sum_{k=1}^{K} \frac{N_k}{N}(\bar{Y}_{T,k} - \bar{Y}_{C,k})$$
- 5 strata removes ~90% of bias (Cochran). More strata = less bias but noisier.
- If one stratum has very few treated (e.g., $n_1=1$): high variance. Merge with neighbor.

### IPW (INVERSE PROBABILITY WEIGHTING)
$$\hat{\tau}_{IPW} = \frac{1}{N}\sum\left[\frac{Z_i Y_i}{\hat{e}(X_i)} - \frac{(1-Z_i)Y_i}{1-\hat{e}(X_i)}\right]$$
- **Why unbiased:** $\mathbb{E}\left[\frac{Z_i Y_i}{e(X_i)}\right] = \mathbb{E}[Y_i(1)]$ (tower prop + ignorability: $e(X)$ cancels)
- **Balancing property (PROOF):** $\mathbb{E}\left[\frac{Z}{e(X)}g(X)\right] = \mathbb{E}\left[\frac{E[Z|X]}{e(X)}g(X)\right] = \mathbb{E}[g(X)]$
  - IPW MUST balance all $g(X)$ if PS correct. If balance is bad --> PS model is wrong.
- **Extreme weights problem:** $e(X) \approx 0$ or $1$ --> weights blow up --> one person dominates --> high variance, instability. This = overlap violation.
- **Stabilized weights:** $w_i^{stab} = Z_i \cdot \hat{p}/\hat{e}(X_i) + (1-Z_i)(1-\hat{p})/(1-\hat{e}(X_i))$ where $\hat{p} = n_1/N$. Multiplies by marginal prob of actual treatment received.
- **Hajek estimator:** Uses stabilized weights in a ratio form: $\frac{\sum w_i^T Y_i}{\sum w_i^T} - \frac{\sum w_i^C Y_i}{\sum w_i^C}$. Slightly biased but much lower variance.
- Matching stable when PS near 0.5 for most; IPW unstable when any PS extreme.

### AIPW (DOUBLY ROBUST)
$$\hat{\tau}_{AIPW} = \frac{1}{N}\sum\left[\hat{\mu}_1(X_i) - \hat{\mu}_0(X_i) + \frac{Z_i(Y_i - \hat{\mu}_1(X_i))}{\hat{e}(X_i)} - \frac{(1-Z_i)(Y_i - \hat{\mu}_0(X_i))}{1-\hat{e}(X_i)}\right]$$
**4 terms:** (1) predicted outcome under trt (2) minus predicted under ctrl = regression estimate. (3) IPW correction for treated residuals (4) IPW correction for control residuals.
- If outcome model perfect: residuals = 0, correction vanishes, just get regression estimate
- If PS model perfect: IPW correction fixes bad regression
- **Doubly robust:** consistent if EITHER model correct. Fails if BOTH wrong.
- Best efficiency when both correct (achieves semiparametric bound)
- Can still fail in finite samples: extreme weights, poor outcome fit, limited overlap

### DESIGN VS. ANALYSIS (KEY PRINCIPLE)
- **Design phase (NO outcomes):** estimate PS, match/weight, check balance (SMDs, Love plots, overlap). Iterate until balance good.
- **Analysis phase (NOW use Y):** estimate $\hat{\tau}$, build CI.
- Never peek at $Y$ during design -- prevents fishing/specification searching.
- Like pre-registering a clinical trial.

### OVERLAP / TRIMMING
- If PS near 0 or 1 somewhere: no good comparisons there. ALL methods fail (not just IPW).
- **Trim** to e.g. $[0.1, 0.9]$ -- changes estimand to overlap subpopulation ATE.
- Check with PS histograms for treated vs control.

### R CODE PATTERNS (EXAM)
- `glm(Z ~ age + edu, family=binomial)` = logistic regression for PS. Coefficients = what predicts SELECTION into treatment (not causal)
- `multigrp_dist_struc(df,"Z",list(mahal=c("age"),ps="ps"),c(1,2))` = distance combining Mahalanobis (wt 1) + PS (wt 2)
- `kwaymatching(dist,"Z",indexgroup="treated",design=c(1,2))` = 1:2 matching (each treated gets 2 controls)
- `tau_ipw = mean(Z*Y/ps - (1-Z)*Y/(1-ps))` = Horvitz-Thompson IPW
- `tau_aipw = mean(mu1-mu0 + Z*(Y-mu1)/ps - (1-Z)*(Y-mu0)/(1-ps))` = AIPW

### WHEN ALL METHODS FAIL
Regression, matching, stratification, IPW, AIPW ALL require assumptions (mainly ignorability). If there is strong **unobserved confounding** (something affects both $Z$ and $Y$ that you didn't measure), all methods give wrong answers. Example: unmeasured disease severity drives both treatment choice and outcome.
