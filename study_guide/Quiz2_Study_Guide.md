# STAT 479 -- Quiz 2 Study Guide

**Quiz:** Makeup this week (originally Week 6, Thursday Feb 26)
**Coverage:** Weeks 3--5 + Addendum (material since Quiz 1)
**Format:** Same as Quiz 1 -- short free-response / conceptual + some math, written on blank paper

---

## What to Expect Based on Quiz 1

Quiz 1 had **2 questions**, both conceptual-with-math:

1. **Explain a concept** (design-based inference vs. random sampling) -- required understanding the philosophy, not just reciting a formula
2. **A setup with math** (regression + misspecification) -- required knowing when a result holds and explaining *why* in terms of covariate balance

Expect Quiz 2 to follow the same pattern: 2--3 questions mixing conceptual understanding with some formulas or short derivations. You need to **explain ideas clearly in your own words** and **know the key math well enough to write it on paper**.

---

## The Three Big Topics for Quiz 2

### Topic A: Potential Outcomes & Fisher's Randomization Inference (Weeks 3--4)
### Topic B: Neyman's Estimation Framework (Weeks 3--4)
### Topic C: Observational Studies & Matching (Week 5)
### Bonus: Covariate Adjustment in Experiments (Addendum)

---

# Topic A: Potential Outcomes & Fisher's Randomization Inference

## A.1 The Framework: Science vs. Assignment

This is the most important conceptual distinction in the entire course. If you understand this, everything else follows.

There are two separate things going on in any experiment:

**The Science** ($\mathcal{S}$): The collection of all potential outcomes for all people.

$$\mathcal{S} = \{Y_i(1), Y_i(0) : i = 1, \ldots, N\}$$

These are **fixed numbers**. They are not random. They are attributes of each person, like their height. $Y_i(1)$ is what would happen to person $i$ under treatment. $Y_i(0)$ is what would happen under control. Both exist simultaneously as facts about the world -- you just can't see both.

**The Assignment** ($\mathbf{Z}$): The random mechanism that decides who gets treated. This is the **only source of randomness** in the entire framework.

**Why this matters:** All probability statements (expectations, variances, p-values) come from the randomization of $\mathbf{Z}$, not from any model about how outcomes behave. The outcomes are just fixed numbers sitting there. The randomness is in which ones we get to observe.

This is what makes this framework "design-based" -- probability comes from the design of the experiment, not from modeling the outcomes.

## A.2 Potential Outcomes and Observed Data

Each person $i$ has two potential outcomes: $Y_i(1)$ and $Y_i(0)$.

The **individual causal effect** is:

$$\tau_i = Y_i(1) - Y_i(0)$$

The **fundamental problem of causal inference**: you only observe one potential outcome per person. The observed outcome is:

$$Y_i^{\text{obs}} = Z_i Y_i(1) + (1 - Z_i)Y_i(0)$$

If $Z_i = 1$: you see $Y_i(1)$. If $Z_i = 0$: you see $Y_i(0)$. The other one is gone forever.

So observed data is a **deterministic function** of two things: the fixed science $\mathcal{S}$ and the realized assignment $\mathbf{Z}$.

## A.3 Fisher's Sharp Null Hypothesis

Fisher asked: "Can we prove the treatment did anything at all?"

**Fisher's sharp null:**

$$H_0: Y_i(1) = Y_i(0) \quad \text{for all } i$$

In words: treatment has **zero effect on every single person**.

Why is this called "sharp"? Because it **completely determines all missing potential outcomes**. Under $H_0$, since $Y_i(1) = Y_i(0)$, every person's outcome is the same regardless of treatment. So $Y_i(1) = Y_i(0) = Y_i^{\text{obs}}$ for everyone. You now know the full science table.

## A.4 The Exact Randomization Test (know this cold)

This is the procedure. Be able to write it step by step.

1. **State the null:** $H_0: Y_i(1) = Y_i(0)$ for all $i$ (no effect on anyone)

2. **Under $H_0$, all potential outcomes are known:** Every person's outcome equals their observed outcome regardless of group assignment.

3. **Choose a test statistic** $T(\mathbf{Z}, \mathbf{Y})$ (e.g., difference in means)

4. **Compute the observed value** $T_{\text{obs}}$ from the actual data

5. **Enumerate all $\binom{N}{n_1}$ possible assignments.** For each one, compute $T$ using the same outcomes (outcomes don't change under $H_0$ -- the same people have the same values, you're just reshuffling who is "treated" and "control")

6. **p-value** = fraction of assignments where $|T| \ge |T_{\text{obs}}|$

$$p = \Pr\big(|T(\mathbf{Z}, \mathcal{S})| \ge |T_{\text{obs}}| \mid H_0\big)$$

**Properties you should be able to state:**
- Exact in finite samples (no large-$N$ approximation needed)
- No distributional assumptions on outcomes (works even if outcomes are skewed, heavy-tailed, weird)
- Validity depends ONLY on the randomization being real
- This is NOT a permutation test (permutation tests assume exchangeability of outcomes; randomization tests rely on the physical act of randomization)

## A.5 Numerical Example (from HW Problem 5 -- know this type)

$N = 10$ users, 5 treated, 5 control. Outcomes:

| Treatment | 8 | 6 | 7 | 9 | 5 |
|-----------|---|---|---|---|---|
| Control   | 4 | 6 | 5 | 3 | 4 |

**Step 1:** $\hat{\tau} = \bar{Y}_T - \bar{Y}_C = 7 - 4.4 = 2.6$

**Step 2:** Under sharp null, outcomes are fixed at $\{8, 6, 7, 9, 5, 4, 6, 5, 3, 4\}$. There are $\binom{10}{5} = 252$ ways to assign 5 of 10 to treatment.

**Step 3:** For each of the 252 assignments, compute the difference in means. Count how many give $|T| \ge 2.6$.

**Step 4:** The exact p-value $= 11/252 \approx 0.0437$.

At $\alpha = 0.05$, we reject the sharp null. At $\alpha = 0.01$, we do not.

## A.6 Constant Additive Treatment Effects

A more useful model than "zero effect on everyone":

$$Y_i(1) = Y_i(0) + \tau \quad \text{for all } i$$

Treatment shifts everyone's outcome by the **exact same amount** $\tau$.

**Testing $H_0: \tau = \tau_0$:** Create adjusted outcomes:

$$Y_i^{(\tau_0)} = Y_i^{\text{obs}} - Z_i \cdot \tau_0$$

If the true effect is $\tau_0$, then $Y_i^{(\tau_0)} = Y_i(0)$ for everyone, and the adjusted data satisfy Fisher's sharp null. Run the randomization test on the adjusted data.

## A.7 Confidence Sets by Inversion (important concept)

Try many values of $\tau_0$. For each, test $H_0: \tau = \tau_0$. Keep the ones you can't reject:

$$\mathcal{C}_{1-\alpha} = \{\tau_0 : p(\tau_0) > \alpha\}$$

**Properties:**
- Exact finite-sample coverage: $\Pr(\tau \in \mathcal{C}_{1-\alpha}) \ge 1 - \alpha$
- No normality required
- For difference-in-means, this set is typically an interval $[\tau_L, \tau_U]$
- Comes from the design, not from modeling assumptions

**The logic:** If the true effect is $\tau$, then the test at $\tau_0 = \tau$ should fail to reject (most of the time). So the true value will be inside the confidence set with probability $\ge 1 - \alpha$.

## A.8 Choice of Test Statistics

Different test statistics detect different kinds of effects:

**Difference in means:** $T_{\text{DM}} = \bar{Y}_T - \bar{Y}_C$. Natural, intuitive, optimal when outcomes are well-behaved.

**Rank statistics:** Use ranks of outcomes instead of raw values. Replace each outcome with its position in the sorted list (1st smallest, 2nd smallest, ...). Robust to outliers and skewness.

$$T_{\text{rank}} = \sum_{i=1}^{N} Z_i \, a(R_i)$$

where $a(\cdot)$ is a score function (e.g., Wilcoxon).

**Attributable effect:** $A = \sum_{i=1}^{N} Z_i (Y_i(1) - Y_i(0))$. Useful for binary outcomes -- counts events *caused* by treatment.

**Paired/blocked designs:** $T_{\text{pair}} = \sum_{b=1}^{B} (Y_{bT} - Y_{bC})$. Must respect the design structure.

**Key point:** The test statistic encodes your scientific beliefs about what kind of effect to look for. The randomization distribution makes this choice transparent.

---

# Topic B: Neyman's Estimation Framework

## B.1 How Neyman Differs from Fisher

| | Fisher | Neyman |
|---|--------|--------|
| **Goal** | Test whether $\tau = 0$ (give a p-value) | Estimate $\tau$ (give a number + CI) |
| **Key assumption** | Sharp null (constant effect for CI) | None on individual effects |
| **Key output** | p-value | $\hat{\tau} \pm \text{margin of error}$ |
| **Type of inference** | Exact (enumerate all assignments) | Asymptotic (CLT-based) |
| **Handles heterogeneous effects?** | Not naturally (sharp null = same effect) | Yes, targets the average |

They are **complementary**: Fisher tells you "is there evidence of any effect?" Neyman tells you "how big is the average effect, and how uncertain are we?"

## B.2 The Target: Finite-Population ATE

$$\tau = \frac{1}{N}\sum_{i=1}^{N}\big[Y_i(1) - Y_i(0)\big]$$

This is a **fixed number** -- not random. It's just the average of everyone's individual treatment effect. The potential outcomes are fixed, so their average is fixed.

## B.3 The Estimator: Difference in Means

$$\hat{\tau} = \bar{Y}_T - \bar{Y}_C = \frac{1}{n_1}\sum_{i:Z_i=1} Y_i^{\text{obs}} - \frac{1}{n_0}\sum_{i:Z_i=0} Y_i^{\text{obs}}$$

**Unbiased under complete randomization:** $\mathbb{E}[\hat{\tau}] = \tau$

**Why?** Each person is equally likely to be in the treated group. So $\bar{Y}_T$ is an unbiased estimate of $\frac{1}{N}\sum Y_i(1)$, and $\bar{Y}_C$ is unbiased for $\frac{1}{N}\sum Y_i(0)$. Subtract and you get $\tau$.

No modeling required. Unbiasedness is a consequence of randomization alone.

## B.4 Neyman's Exact Variance Formula (know this)

Define the finite-population variances:

$$S_1^2 = \frac{1}{N-1}\sum_{i=1}^{N}\big(Y_i(1) - \bar{Y}(1)\big)^2 \qquad \text{(spread of treated potential outcomes)}$$

$$S_0^2 = \frac{1}{N-1}\sum_{i=1}^{N}\big(Y_i(0) - \bar{Y}(0)\big)^2 \qquad \text{(spread of control potential outcomes)}$$

$$S_\tau^2 = \frac{1}{N-1}\sum_{i=1}^{N}(\tau_i - \tau)^2 \qquad \text{(how much the effect varies across people)}$$

**The exact variance:**

$$\text{Var}(\hat{\tau}) = \frac{S_1^2}{n_1} + \frac{S_0^2}{n_0} - \frac{S_\tau^2}{N}$$

**Reading this formula:**
- More spread in potential outcomes ($S_1^2$, $S_0^2$) = more variance = noisier
- Bigger groups ($n_1$, $n_0$) = less variance = more precise
- More variation in treatment effects ($S_\tau^2$) = actually *less* variance (the surprising part)

## B.5 The Problem with $S_\tau^2$ and the Conservative Fix

$S_\tau^2$ requires knowing both $Y_i(1)$ and $Y_i(0)$ for every person. You never have both. So you can't compute the exact variance.

Since $S_\tau^2 \ge 0$, dropping it gives an **upper bound**:

$$\text{Var}(\hat{\tau}) \le \frac{S_1^2}{n_1} + \frac{S_0^2}{n_0}$$

Estimate using sample variances from the observed data:

$$s_1^2 = \frac{1}{n_1-1}\sum_{i:Z_i=1}(Y_i^{\text{obs}} - \bar{Y}_T)^2, \qquad s_0^2 = \frac{1}{n_0-1}\sum_{i:Z_i=0}(Y_i^{\text{obs}} - \bar{Y}_C)^2$$

**Neyman's conservative variance estimator:**

$$\widehat{\text{Var}}(\hat{\tau}) = \frac{s_1^2}{n_1} + \frac{s_0^2}{n_0}$$

"Conservative" = overestimates the true variance = confidence intervals are wider than they need to be, but still valid.

**When is it exact?** When effects are constant: $\tau_i = \tau$ for all $i$, so $S_\tau^2 = 0$.

## B.6 Confidence Intervals

For large $N$, by a finite-population CLT:

$$\hat{\tau} \pm z_{1-\alpha/2}\sqrt{\widehat{\text{Var}}(\hat{\tau})}$$

For 95% CI: $\hat{\tau} \pm 1.96 \times \text{SE}$

**Key difference from intro stats:** The CLT here comes from the **randomization** (shuffling who is treated), not from assuming outcomes are drawn from a normal distribution.

## B.7 Neyman vs. Classical t-test (likely exam topic based on HW 7)

| | Neyman | Classical t-test |
|---|--------|-----------------|
| What is random? | Only the assignment $\mathbf{Z}$ | The outcomes themselves |
| Potential outcomes | Fixed numbers | Random draws from populations |
| Where does variance come from? | The randomization mechanism | A probability model for outcomes |
| Pools variances? | No | Often yes |
| Needs normality? | No | Yes (or large sample) |
| Needs equal variance? | No | Often assumed |

**When do they give similar results?** When $n_1 \approx n_0$ and variances are similar across groups, the formulas are numerically close. But the *justification* is completely different.

**When does the t-test mislead?** When variances differ between treated and control, or when outcomes are non-normal with small samples. The t-test's standard errors can be wrong because they rely on a model that may not hold. Neyman's approach is valid because you actually randomized.

**Rosenbaum's argument for randomization-based inference:** It is conceptually primary because the probability comes from a known, physical mechanism (the randomization). Model-based inference adds unverifiable assumptions. When you have randomization, use it -- it's the strongest foundation for causal claims.

---

# Topic C: Observational Studies & Matching

## C.1 Why This Topic Exists

You can't always randomize:
- Ethics: can't randomly assign smoking
- Logistics: can't randomly assign school districts
- History: the data already happened

But you still want causal answers. The solution: **try to reconstruct the balance that randomization would have created.**

## C.2 The Core Philosophy (3 Principles -- know these)

1. **Separate design from analysis.** Figure out how to make groups comparable **before** looking at outcomes. Don't let results influence your comparison strategy.

2. **Construct comparable groups.** Use matching/stratification/trimming to make treated and control groups look similar on covariates.

3. **Covariates refine, not rescue.** Covariate adjustment can improve a decent comparison. It cannot save a fundamentally flawed one.

An observational study is **not a failed experiment** -- it is an attempt to reconstruct the conditions of an experiment using observed data.

## C.3 Matching: What It Is and Why It's a Design Tool

**Matching** = find pairs (or sets) of people, one treated and one control, who have similar background characteristics. Then compare outcomes within matched pairs.

It is a **design tool**, not an analysis tool. Matching creates a new, better dataset. After matching, the analysis is simple (usually difference in means on the matched sample).

### Types of matching:

| Type | How it works | Strength | Weakness |
|------|-------------|----------|----------|
| **Exact** | Only match identical covariates | Perfect balance | Impossible with continuous $X$ |
| **Nearest-neighbor** | Match to closest control (Euclidean/Mahalanobis) | Simple | Greedy; can waste good matches |
| **Mahalanobis** | Distances scaled by covariance matrix | Handles correlated covariates | Still curse of dimensionality |
| **Propensity score** | Match on $\hat{e}(X) = \hat{\Pr}(Z=1 \mid X)$ | Reduces to 1D | Depends on PS model |
| **Optimal** | Minimizes total distance across ALL pairs | Best overall pairing | Computationally harder |

## C.4 Checking Balance: SMD, Variance Ratios, Love Plots

After matching, you must verify the groups are actually comparable. This is done **before** looking at outcomes.

### Standardized Mean Difference (know the formula and thresholds)

$$\text{SMD}(X) = \frac{\bar{X}_T - \bar{X}_C}{s_X}, \qquad s_X = \sqrt{\frac{s_T^2 + s_C^2}{2}}$$

**Interpretation:** Difference in group means, scaled by variability. Unitless, so you can compare across covariates.

**Thresholds:**
- $|\text{SMD}| < 0.1$: excellent balance
- $|\text{SMD}| \approx 0.2$: moderate imbalance
- $|\text{SMD}| > 0.25$: unacceptable

**Why SMD instead of a t-test?** Because t-test p-values depend on sample size. In huge samples, a meaningless difference is "significant." In small samples, a large difference is "not significant." SMD measures the **actual size** of the imbalance, not whether a statistical test can detect it.

### Variance Ratios

$$\text{VR}(X) = \frac{\text{Var}(X_T)}{\text{Var}(X_C)}$$

Should be close to 1. Checks whether the **spread** is similar, not just the average.

### Love Plots

Plot SMDs for each covariate before and after matching. You want all dots to move toward zero.

## C.5 The Matched Estimator and Where Bias Comes From

After matching, you estimate the treatment effect by comparing outcomes within matched pairs:

$$\hat{\tau}^M = \frac{1}{n_M}\sum_{i=1}^{n_M}\big(Y_i - Y_{j(i)}\big)$$

where $i$ is a treated person and $j(i)$ is their matched control. This is just: take each pair, subtract the control outcome from the treated outcome, and average.

### When is this estimator biased?

Suppose the outcome depends on both treatment and covariates:

$$Y_i = \tau Z_i + g(X_i) + \varepsilon_i$$

Here $g(X_i)$ is the part of the outcome that comes from the person's background -- not from the treatment. For a matched pair:

- Treated person's outcome: $\tau + g(X_i) + \varepsilon_i$
- Control person's outcome: $g(X_{j(i)}) + \varepsilon_{j(i)}$
- Difference: $\tau + \big(g(X_i) - g(X_{j(i)})\big) + (\varepsilon_i - \varepsilon_{j(i)})$

The bias in one pair is $g(X_i) - g(X_{j(i)})$ -- the difference in background effects between the two people. Average over all pairs:

$$\text{Bias}(\hat{\tau}^M) = \frac{1}{n_M}\sum_{i=1}^{n_M}\big(g(X_i) - g(X_{j(i)})\big)$$

**The punchline:** If you match well (each treated person is paired with a similar control), then $X_i \approx X_{j(i)}$, which means $g(X_i) \approx g(X_{j(i)})$, which means the bias is small.

If you match badly (pairs are dissimilar), then $g(X_i)$ and $g(X_{j(i)})$ can be very different, and you get large bias.

## C.6 What "Smooth" Means and Why It Matters (the Lipschitz Condition)

You might ask: if the matched covariates are *close* ($X_i \approx X_{j(i)}$), does that guarantee $g(X_i) \approx g(X_{j(i)})$?

It depends on how $g$ behaves. If $g$ is a smooth, gentle function (like a straight line or a gentle curve), then two people with similar $X$ values will have similar $g(X)$ values. But if $g$ is wild and jagged (like a function that jumps around erratically), then even people with very similar $X$ could have very different $g(X)$.

The **Lipschitz condition** is just a formal way of saying "$g$ is not too wild." It says:

$$|g(a) - g(b)| \le L \cdot |a - b| \quad \text{for all } a, b$$

**Translation:** The difference in outputs can't be more than $L$ times the difference in inputs. The number $L$ (called the Lipschitz constant) measures the **maximum steepness** of $g$.

- Small $L$ = $g$ is gentle, changes slowly. Even mediocre matching gives small bias.
- Large $L$ = $g$ is steep, changes fast. You need very close matches to keep bias small.
- $L = 0$ = $g$ is flat (constant). Background doesn't affect outcomes. No bias regardless of matching quality.

**Example:** Suppose income affects health outcomes, and $g(\text{income}) = 0.001 \times \text{income}$. Then $L = 0.001$ -- even if matched pairs differ by $\$5000$ in income, the bias contribution from one pair is only $0.001 \times 5000 = 5$ units. Now if $g$ were steeper, say $g(\text{income}) = 0.1 \times \text{income}$, then $L = 0.1$ and the same $\$5000$ gap creates a bias of $500$ units. Steep $g$ demands tighter matching.

**You do NOT need to know the exact value of $L$.** The point is conceptual: the bias from matching depends on two things -- (1) how close the matches are and (2) how steeply the outcome depends on covariates. You control (1) through better matching. You can't control (2), but knowing it exists tells you *why* close matching matters.

### Using the Lipschitz condition on the bias formula

Since $|g(X_i) - g(X_{j(i)})| \le L \cdot |D_i|$ where $D_i = X_i - X_{j(i)}$ is the covariate gap in pair $i$:

$$|\text{Bias}(\hat{\tau}^M)| \le L \cdot \frac{1}{n_M}\sum_{i=1}^{n_M}|D_i|$$

Bias $\le$ (steepness of outcome function) $\times$ (average covariate gap in matched pairs).

Make the average gap small by matching well, and the bias shrinks.

## C.7 The Chebyshev Argument: From Matching Quality to Bias Bounds

Now we need to figure out: how small is the average covariate gap $\frac{1}{n_M}\sum|D_i|$?

### What Chebyshev's inequality says (in plain English)

Chebyshev's inequality is a basic probability/statistics result that says:

> If a bunch of numbers have a small variance, then most of them must be close to their average.

Formally, for any collection of numbers $D_1, \ldots, D_{n_M}$ with mean $\mu_D$ and variance $s_D^2$:

$$\text{fraction of } D_i \text{ that are more than } t \text{ away from the mean} \le \frac{s_D^2}{t^2}$$

This requires **zero assumptions** about the shape of the distribution. It works for any data, always.

### Applying it to matching

The pairwise covariate differences $D_i = X_i - X_{j(i)}$ have:
- Mean: $\mu_D = \Delta_X^M$ (the average covariate difference between matched groups)
- Variance: $s_D^2$ (how spread out the pairwise gaps are)

Chebyshev tells us: if $s_D^2$ is small, then most $D_i$ values are close to $\mu_D$. So the average absolute gap satisfies:

$$\frac{1}{n_M}\sum|D_i| \le |\mu_D| + 2s_D$$

(This comes from optimizing the Chebyshev bound -- don't worry about the derivation, just know the result.)

### The final bias bound

Plugging this into the Lipschitz bound:

$$|\text{Bias}(\hat{\tau}^M)| \le L\big(|\Delta_X^M| + 2s_D\big)$$

**Reading this formula in English:**

$$\text{Bias} \le \underbrace{L}_{\substack{\text{how steeply outcome} \\ \text{depends on covariates}}} \times \Big(\underbrace{|\Delta_X^M|}_{\substack{\text{average covariate} \\ \text{gap between groups}}} + \underbrace{2s_D}_{\substack{\text{spread of} \\ \text{pairwise gaps}}}\Big)$$

To make bias small, you need:
- **Small $|\Delta_X^M|$:** The average covariate difference between matched treated and control groups should be small. This is what SMDs measure.
- **Small $s_D$:** The pairwise gaps shouldn't be all over the place -- you want consistently close matches, not a mix of great matches and terrible ones.
- **$L$ you can't control** -- it's a property of nature. But everything in the parentheses is under your control through better matching.

### The connection to everything else

This result ties the whole course together:

- **Week 1:** Regression bias came from imbalance in $g(X)$. Matching reduces this imbalance by construction.
- **SMDs:** When you check $|\text{SMD}| < 0.1$, you are checking that $|\Delta_X^M|$ is small relative to the spread of $X$. Small SMD = small first term in the bias bound.
- **Variance ratios and Love plots:** These check whether balance is consistent across all covariates and whether $s_D$ is small. If your Love plot shows all dots near zero after matching, you have small $|\Delta_X^M|$ across all variables.
- **Chebyshev's inequality** is the mathematical backbone: it guarantees that small variance in pairwise gaps means most individual pairs are well-matched, not just the average.

**Bottom line for the exam:** Good covariate balance (small SMDs, variance ratios near 1) implies small bias under mild smoothness assumptions. This is why we obsess over balance diagnostics -- they are directly checking the conditions that make the bias bound small.

---

# Bonus: Covariate Adjustment in Experiments (Addendum)

This is likely testable since it bridges Weeks 1 and 3-4.

## Key Question: Why use regression in an experiment when the difference-in-means is already unbiased?

**Answer: Precision.** Regression doesn't change what you're estimating. It makes the estimate less noisy.

## The Key Facts (be able to state all three)

1. **Still unbiased**, even if the regression model is wrong. Under randomization, $\hat{\tau}_{\text{reg}}$ is unbiased for $\tau$ regardless of whether $Y = \alpha + \tau Z + \beta^\top X + \varepsilon$ is correctly specified. Randomization makes $\tilde{Z}$ independent of potential outcomes, so the FWL residualization preserves unbiasedness.

2. **Variance is smaller** (or at worst, the same). The better covariates predict the outcome, the bigger the improvement. If covariates are irrelevant, regression adjustment behaves like the simple difference in means.

3. **Does not change the estimand.** You are still estimating $\tau$ -- the same finite-population ATE. Regression is just a more efficient route.

## The Intuition

Randomization balances covariates in expectation, but any particular randomization has chance imbalances (maybe the treated group happens to be slightly older). These imbalances add noise to the estimate.

Regression strips out the part of the outcome predictable from covariates, leaving a cleaner comparison. It's like **noise-cancelling headphones** for your estimator.

Equivalently: regression adjustment is **post-randomization blocking**. Blocking forces groups to be similar within blocks; regression does the same after the fact.

---

# Quick Reference: Formulas You Should Know

**Potential outcomes and treatment effects:**

$$\tau_i = Y_i(1) - Y_i(0) \qquad \text{(individual treatment effect)}$$

$$Y_i^{\text{obs}} = Z_i \, Y_i(1) + (1-Z_i) \, Y_i(0) \qquad \text{(observed outcome)}$$

$$\tau = \frac{1}{N}\sum_{i=1}^{N}\big[Y_i(1) - Y_i(0)\big] \qquad \text{(finite-population ATE)}$$

**Estimation:**

$$\hat{\tau} = \bar{Y}_T - \bar{Y}_C \qquad \text{(difference-in-means estimator)}$$

$$\text{Var}(\hat{\tau}) = \frac{S_1^2}{n_1} + \frac{S_0^2}{n_0} - \frac{S_\tau^2}{N} \qquad \text{(Neyman's exact variance)}$$

$$\widehat{\text{Var}}(\hat{\tau}) = \frac{s_1^2}{n_1} + \frac{s_0^2}{n_0} \qquad \text{(conservative variance estimator)}$$

$$\text{95\% CI:} \quad \hat{\tau} \pm 1.96\sqrt{\widehat{\text{Var}}(\hat{\tau})}$$

**Fisher's testing framework:**

$$H_0: Y_i(1) = Y_i(0) \;\; \forall \, i \qquad \text{(Fisher's sharp null)}$$

$$p = \Pr\!\Big(\!\left|T\right| \ge \left|T_{\text{obs}}\right| \;\Big|\; H_0\Big) \qquad \text{(randomization p-value)}$$

$$Y_i^{(\tau_0)} = Y_i^{\text{obs}} - Z_i \, \tau_0 \qquad \text{(adjusted outcomes for testing } \tau = \tau_0\text{)}$$

$$\mathcal{C}_{1-\alpha} = \{\tau_0 : p(\tau_0) > \alpha\} \qquad \text{(confidence set by inversion)}$$

**Balance and matching:**

$$\text{SMD}(X) = \frac{\bar{X}_T - \bar{X}_C}{\sqrt{(s_T^2 + s_C^2)\,/\,2}} \qquad \text{(standardized mean difference)}$$

$$\text{VR}(X) = \frac{\text{Var}(X_T)}{\text{Var}(X_C)} \qquad \text{(variance ratio; should be near 1)}$$

$$\text{Bias}(\hat{\tau}^M) \le L\,\big(\left|\Delta_X^M\right| + 2\,s_D\big) \qquad \text{(matching bias bound)}$$

---

# Practice Questions (Quiz-Style)

These are formatted like Quiz 1: conceptual explanation required, with math where appropriate.

---

## Practice Q1: Science vs. Assignment

**Question:** In the potential outcomes framework, explain the distinction between "the science" and "the assignment." Where does probability enter, and why does this matter for causal inference?

**Answer:** The science $\mathcal{S} = \{Y_i(1), Y_i(0)\}$ is the full table of potential outcomes. These are fixed, unknown quantities -- not random. They describe what would happen to each person under each treatment condition. The assignment $\mathbf{Z}$ is the random mechanism determining who actually gets treated.

All probability in this framework comes from the assignment, not from the science. Expectations, variances, and p-values are computed over different possible assignments, holding the potential outcomes fixed.

This matters because it means causal inference does not rely on modeling how outcomes are generated. The only thing we need to know is how treatment was assigned. In a randomized experiment, we know this exactly, which is why randomization enables clean causal conclusions without distributional assumptions.

---

## Practice Q2: Fisher's Randomization Test

**Question:** You conduct a completely randomized experiment with $N = 8$ people, assigning 4 to treatment and 4 to control. Explain step-by-step how you would conduct Fisher's exact test of the sharp null hypothesis.

**Answer:**

1. State $H_0: Y_i(1) = Y_i(0)$ for all $i$. Under this null, every person's outcome is the same regardless of assignment.

2. Since all potential outcomes equal the observed outcomes under $H_0$, the science table is fully known.

3. Choose a test statistic (e.g., $T = \bar{Y}_T - \bar{Y}_C$). Compute $T_{\text{obs}}$ from the actual data.

4. There are $\binom{8}{4} = 70$ equally likely assignments. For each of the 70 possible ways to assign 4 of 8 people to treatment, compute $T$ using the same fixed outcomes.

5. The p-value is the proportion of these 70 assignments for which $|T| \ge |T_{\text{obs}}|$.

This test is exact (no approximation), requires no distributional assumptions, and is valid because randomization was physically performed.

---

## Practice Q3: Confidence Sets by Inversion

**Question:** Under a constant additive treatment effect model $Y_i(1) = Y_i(0) + \tau$, explain how to construct a confidence interval for $\tau$ using the randomization test. Why does this have exact finite-sample coverage?

**Answer:** For any candidate value $\tau_0$, compute adjusted outcomes $Y_i^{(\tau_0)} = Y_i^{\text{obs}} - Z_i \tau_0$. If the true effect is $\tau_0$, these adjusted outcomes equal $Y_i(0)$ and satisfy Fisher's sharp null. Run the randomization test on the adjusted data to get p-value $p(\tau_0)$.

The confidence set is $\mathcal{C}_{1-\alpha} = \{\tau_0 : p(\tau_0) > \alpha\}$ -- all values we fail to reject.

**Exact coverage:** If the true effect is $\tau$, then $H_0(\tau)$ is true. By validity of the randomization test, $\Pr(p(\tau) \le \alpha) \le \alpha$. Equivalently, $\Pr(\tau \in \mathcal{C}_{1-\alpha}) \ge 1 - \alpha$. The true value is included with at least $1-\alpha$ probability, for any sample size, without assuming normality.

---

## Practice Q4: Neyman's Variance -- Why Conservative?

**Question:** Write Neyman's exact variance formula for $\hat{\tau}$ under complete randomization. Explain why the standard variance estimator is conservative, and state when it is exact.

**Answer:** The exact variance is:

$$\text{Var}(\hat{\tau}) = \frac{S_1^2}{n_1} + \frac{S_0^2}{n_0} - \frac{S_\tau^2}{N}$$

$S_\tau^2$ measures variation in individual treatment effects. It requires knowing both potential outcomes for every person, which is impossible. Since $S_\tau^2 \ge 0$, dropping it gives an upper bound. The standard estimator $\widehat{\text{Var}} = s_1^2/n_1 + s_0^2/n_0$ estimates this upper bound.

It is conservative because it overestimates the true variance -- confidence intervals are wider than necessary but still valid. It is exact when treatment effects are constant ($\tau_i = \tau$ for all $i$), because then $S_\tau^2 = 0$ and the bound is tight.

---

## Practice Q5: Matching -- Design Tool

**Question:** Explain why matching is described as a "design tool" rather than an "analysis tool." What are the three guiding principles for observational studies discussed in class?

**Answer:** Matching is a design tool because it prepares the data -- constructing comparable groups -- before any outcome is examined. The actual analysis after matching is simple (often just difference in means). The hard work is in the design stage: choosing who to compare.

Three principles:

1. **Separate design from analysis:** Construct the comparison without looking at outcomes. This prevents specification searching.

2. **Construct comparable groups:** Use matching, stratification, or trimming to make treated and control groups similar on covariates.

3. **Covariates refine, not rescue:** Good covariate adjustment improves a reasonable comparison. It cannot fix a fundamentally flawed one (e.g., no overlap, or critical unmeasured confounders).

---

## Practice Q6: SMD and Balance

**Question:** Define the standardized mean difference. Why is it preferred over a t-test for assessing covariate balance? What are the standard thresholds?

**Answer:** $\text{SMD}(X) = (\bar{X}_T - \bar{X}_C) / s_X$ where $s_X = \sqrt{(s_T^2 + s_C^2)/2}$.

The SMD measures the actual size of the imbalance in standardized units. It is preferred over t-tests because t-test p-values depend on sample size: in large samples, trivial differences are "significant"; in small samples, large differences are "not significant." SMD measures substantive imbalance regardless of $N$.

Thresholds: $|\text{SMD}| < 0.1$ = excellent; $\approx 0.2$ = moderate; $> 0.25$ = unacceptable.

---

## Practice Q7: Covariate Adjustment in Experiments

**Question:** In a completely randomized experiment, the simple difference in means is already unbiased for $\tau$. What does regression adjustment add? Is it still unbiased if the regression model is misspecified?

**Answer:** Regression adjustment adds **precision** (lower variance), not unbiasedness. It removes the portion of outcome variation explained by covariates, reducing noise from chance covariate imbalances in any particular randomization.

Yes, $\hat{\tau}_{\text{reg}}$ remains unbiased even if the linear model $Y = \alpha + \tau Z + \beta^\top X + \varepsilon$ is wrong. The key reason: under randomization, the FWL residual $\tilde{Z}_i$ is independent of the potential outcomes, so the residualization preserves the design-based unbiasedness. The regression model is not assumed correct -- it is just a device for removing noise. It refines an already valid design; it does not rescue a bad one.

---

## Practice Q8: The Bias Bound for Matching

**Question:** Under the model $Y_i = \tau Z_i + g(X_i) + \varepsilon_i$ with $g$ Lipschitz-$L$, state and explain the bias bound for a matched estimator. How does this connect to the Chebyshev inequality and to SMDs?

**Answer:** The bias is:

$$|\text{Bias}(\hat{\tau}^M)| \le L\big(|\Delta_X^M| + 2s_D\big)$$

where $\Delta_X^M$ is the mean covariate difference in matched pairs, $s_D$ is the standard deviation of pairwise differences, and $L$ is the Lipschitz constant of $g$.

The Chebyshev inequality guarantees that if $s_D$ is small, only a small fraction of pairs can have large covariate differences. This means the average absolute pairwise difference is bounded by $|\mu_D| + 2s_D$.

SMDs summarize this pairwise balance: small pairwise differences imply small mean differences, which imply small SMDs. So checking SMDs after matching is effectively checking the conditions that make this bias bound small. Good balance (small SMDs) implies small bias under mild smoothness.
