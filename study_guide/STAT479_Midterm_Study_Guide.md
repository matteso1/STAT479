# STAT 479: Causal Inference -- Midterm Study Guide

**Exam Date:** March 12, 2026 (Week 8)
**Coverage:** Weeks 1--7 (not cumulative with Exam 2)
**Format:** Free response / short answer on blank paper

---

## How to Use This Guide

Read it start to finish like a story. Every concept is explained in plain English first, then the math version follows. When you see a new term, it will always be defined right there in normal words before any formula appears. The math is there so you can reproduce it on the exam, but the goal is for you to actually **understand** what is going on first.

---

## Table of Contents

1. [The Big Picture: What Even Is This Class About?](#1-the-big-picture)
2. [Key Vocabulary You Need Before Anything Else](#2-key-vocabulary)
3. [Week 1: Regression -- A Flawed But Useful First Tool](#3-week-1-regression)
4. [Week 2: Randomized Experiments -- The Gold Standard](#4-week-2-randomized-experiments)
5. [Weeks 3--4: Potential Outcomes -- The Language of Causation](#5-weeks-3-4-potential-outcomes)
6. [Addendum: Using Regression Inside an Experiment](#6-addendum-regression-in-experiments)
7. [Week 5: Observational Studies and Matching](#7-week-5-observational-studies-and-matching)
8. [Week 6: Making Observational Studies Work -- Assumptions and Propensity Scores](#8-week-6-making-observational-studies-work)
9. [Week 7: Estimating Causal Effects -- IPW, AIPW, and Diagnostics](#9-week-7-estimating-causal-effects)
10. [Key Formulas Cheat Sheet](#10-key-formulas-cheat-sheet)
11. [Practice Questions with Answers](#11-practice-questions-with-answers)

---

# 1. The Big Picture

## What is this class actually about?

This class is about one question: **"Did this thing actually cause that outcome, or is it just a coincidence?"**

That sounds simple, but it turns out to be really hard. Here is a classic example:

> People who go to college earn more money than people who don't. Does college **cause** higher earnings? Or is it that the kinds of people who go to college (wealthier families, better schools, more motivated) would have earned more anyway?

That is the core problem this class tries to solve. The naive answer ("just compare the two groups") is almost always wrong because the two groups are different in ways that have nothing to do with the treatment.

## The one sentence summary of the whole course

**To figure out if something causes something else, you need to compare apples to apples -- and this class teaches you all the ways to do that (or at least try to).**

---

# 2. Key Vocabulary

Before we go any further, let me define every important term in plain English. Refer back to this section whenever you see a word you don't recognize.

### Treatment ($Z$)

The thing whose effect you want to measure. It is binary (yes/no, 1/0) in this class.
- Examples: taking a drug vs. placebo, getting a college degree vs. not, seeing an ad vs. not seeing it
- $Z = 1$ means "treated" (got the thing), $Z = 0$ means "control" (didn't get it)

### Outcome ($Y$)

The result you are measuring. The thing you think might be affected by the treatment.
- Examples: income, test score, whether someone bought a product, health outcome

### Covariates ($X$)

**Background characteristics** of a person/unit that exist **before** the treatment happens. Think of these as "things about a person that might matter."
- Examples: age, gender, family income, education level, prior health conditions, browsing history
- These are also called "pre-treatment variables" -- they describe who someone is before any treatment is applied
- A covariate is literally just a variable that could vary together with (co-vary with) the treatment and the outcome

### Confounders

A confounder is a covariate that affects **both** the treatment and the outcome. This is the source of all problems in causal inference.

**Example:** Family wealth is a confounder for the college-earnings question. Wealthy families are more likely to send kids to college (affects treatment), AND kids from wealthy families earn more regardless of college (affects outcome). So if you just compare college grads to non-grads, part of the earnings difference is from college, and part is from family wealth.

### Treatment Effect

How much the treatment changes the outcome. If taking a drug lowers your blood pressure by 10 points, the treatment effect is -10.

### Average Treatment Effect (ATE)

The average treatment effect across a whole group of people. Some people might benefit a lot, some a little, some not at all -- the ATE is the average across everyone.

### Selection Bias

The problem that arises when the people who get treated are **systematically different** from the people who don't, even before treatment. If healthier people are more likely to exercise, then comparing exercisers to non-exercisers overestimates the effect of exercise (because exercisers were healthier to begin with).

### Potential Outcomes

The imaginary "what if" outcomes. For each person, there are two potential outcomes:
- $Y_i(1)$: what **would** happen to person $i$ if they got the treatment
- $Y_i(0)$: what **would** happen to person $i$ if they did NOT get the treatment

The problem: you only ever see ONE of these. If someone went to college, you see their income with college, but you'll never know what their income would have been without it. The one you don't see is called the **counterfactual**.

### Estimand

The thing you are trying to estimate. Your target. In this class, the main estimand is the average treatment effect.

### Estimator

The formula or method you use to try to estimate the estimand. For example, "take the average outcome of the treated group minus the average outcome of the control group" is an estimator.

### Unbiased

An estimator is unbiased if, on average (across many hypothetical repetitions of the study), it gives you the right answer. It might be a little high or a little low in any one study, but it's not systematically off in one direction.

### Variance (of an estimator)

How much the estimator bounces around from study to study. Low variance = precise, high variance = noisy. Even an unbiased estimator can be useless if the variance is huge.

### Propensity Score

The probability that a person gets treated, based on their background characteristics. If you are young, healthy, and wealthy, maybe you have a 70% chance of getting the treatment. That 70% is your propensity score. Formally: $e(X) = \Pr(Z = 1 \mid X)$.

---

# 3. Week 1: Regression -- A Flawed But Useful First Tool

## 3.1 The Problem Regression Tries to Solve

You want to know: does treatment $Z$ affect outcome $Y$? But there are confounders $X$ (background characteristics) muddying the waters.

**Example:** Does a college degree ($Z$) increase income ($Y$)? Family background ($X$) is a confounder -- it makes people more likely to go to college AND makes them earn more.

If you just compare average income of college grads vs. non-grads, you get a mix of the college effect and the family background effect. You can't tell them apart.

**Regression tries to "hold constant" the confounders** so you can isolate the treatment effect.

## 3.2 What the Regression Model Says

The model is:

$$Y = \tau Z + \beta^\top X + \varepsilon$$

In plain English:

> Your outcome ($Y$) equals the treatment effect ($\tau$) times whether you got treated ($Z$), plus the effect of your background ($\beta^\top X$), plus random noise ($\varepsilon$).

The coefficient $\tau$ is the thing you care about. It represents: **if two people had the exact same background ($X$), but one got treated and the other didn't, how much would their outcomes differ?**

**The catch:** This only works if the model is correct. If the real relationship between $X$ and $Y$ is not a straight line (it's curved, or there are interactions, etc.), then $\tau$ can be wrong.

## 3.3 The Frisch-Waugh-Lovell (FWL) Theorem

This theorem explains **what regression is actually doing under the hood**. It is the most important result from Week 1.

### Plain English version

When you run a regression of $Y$ on both $Z$ and $X$, the coefficient on $Z$ is the same thing you'd get if you:

1. First predicted $Z$ from $X$ (how well can you guess treatment status from background?)
2. Took the **leftover** part of $Z$ that $X$ can't predict (call this $\tilde{Z}$)
3. Looked at how that leftover relates to $Y$

Think of it like this: regression strips away everything about treatment assignment that can be explained by background characteristics, and then sees if the **unexplained** part of treatment is related to the outcome.

### The math

The residual from regressing $Z$ on $X$ is:

$$\tilde{Z}_i = Z_i - \hat{\mathbb{E}}[Z \mid X_i]$$

This is the "part of treatment that can't be explained by covariates."

The regression coefficient on $Z$ is then:

$$\hat{\tau} = \frac{\sum_{i=1}^{n} \tilde{Z}_i Y_i}{\sum_{i=1}^{n} \tilde{Z}_i^2}$$

## 3.4 Regression as a Reweighting/Balancing Trick

Here is the deeper insight. Regression is not just fitting a line. It is actually **reweighting** people so that the treated and control groups look the same on their background characteristics.

Define the regression weights:

$$w_i = \frac{\tilde{Z}_i}{\sum_{j=1}^{n} \tilde{Z}_j^2}$$

Then the key result is:

$$\sum_{i=1}^{n} w_i X_i = 0$$

**What this means in plain English:** After reweighting, the weighted average of the background characteristics is exactly the same between the treated and control groups. Regression has "balanced" the groups.

And you can write the estimator as:

$$\hat{\tau} = \sum_{i: Z_i=1} w_i Y_i - \sum_{i: Z_i=0} (-w_i) Y_i$$

This is just a weighted comparison of outcomes between the two groups, where the weights force the groups to look the same on $X$.

## 3.5 When Regression Fails

Here is the critical limitation.

Suppose the **real** relationship between $X$ and $Y$ is nonlinear (say $Y$ depends on $X^2$, or $\log(X)$, or some other curvy function), but you just put $X$ in your regression as a straight line.

Regression balances $X$ perfectly ($\sum w_i X_i = 0$), but it does **not** balance $X^2$ or $\log(X)$ or any other nonlinear function you didn't include.

**The bias from misspecification is:**

$$\text{Bias} = \frac{\sum_{i=1}^{n} \tilde{Z}_i \, g(X_i)}{\sum_{i=1}^{n} \tilde{Z}_i^2}$$

where $g(X)$ is the nonlinear part you left out.

**Takeaway:** Regression only balances what you put into the model. If you miss something (a nonlinear relationship, an interaction, or -- worst of all -- an unobserved confounder), the estimate of $\tau$ will be biased.

## 3.6 Key Limitations Summary

Regression assumes:
- **Linearity:** the relationship between background and outcome is a straight line
- **Constant effects:** the treatment has the same effect on everyone
- **No extrapolation:** there is enough overlap between treated and control groups
- **No omitted variables:** all confounders are in the model

If any of these fail, your treatment effect estimate can be wrong.

---

# 4. Week 2: Randomized Experiments -- The Gold Standard

## 4.1 Why Randomization Fixes Everything

In Week 1, we saw that regression can only balance what you put in the model. If you miss something, you are in trouble.

Randomization takes a completely different approach: **instead of trying to statistically adjust for confounders, you make them irrelevant by randomly deciding who gets treated.**

Think of it like shuffling a deck of cards and dealing to two piles. The piles will be roughly the same -- not because you carefully sorted them, but because the random process doesn't favor any particular card.

When you randomly assign treatment:
- The treated and control groups will be similar in age, gender, income, health, motivation, genetics, and **literally everything else** -- including things you didn't even think to measure
- Any differences between the groups are just due to luck, and they get smaller as the sample gets bigger
- You can make strong causal claims because the ONLY difference between the groups is the treatment

## 4.2 The Completely Randomized Design

**Setup:** You have $N$ people. You randomly pick $n_1$ of them to get the treatment. The remaining $n_0 = N - n_1$ are the control group.

Every possible way of choosing $n_1$ people out of $N$ is equally likely. There are $\binom{N}{n_1}$ possible assignments, and each has the same probability:

$$\Pr(\mathbf{Z} = \mathbf{z}) = \binom{N}{n_1}^{-1}$$

Each person has a $n_1/N$ chance of being treated.

**Important detail:** The assignments are NOT independent across people. If I tell you person 1 got treated, that slightly lowers the chance person 2 got treated (because there are now fewer treatment "slots" left). This is because the total number treated is fixed at $n_1$.

## 4.3 What Randomization Balances

This is the key section. Randomization balances **everything**.

### Balances averages of background characteristics

For any background characteristic $X$ (age, income, whatever):

$$\mathbb{E}[\bar{X}_T - \bar{X}_C] = 0$$

The average age (or income, or anything) in the treated group equals the average in the control group **in expectation** (meaning "on average across all possible randomizations").

### Balances ANY function of background characteristics

Here is where it gets powerful. For **any** function $g(X)$ -- could be $X^2$, could be $\log(X)$, could be some crazy nonlinear thing you have never heard of:

$$\mathbb{E}[\bar{g}_T - \bar{g}_C] = 0$$

Remember, regression could only balance the linear functions you put in the model. Randomization balances **everything** -- including functions you didn't know about.

### Balances entire distributions

Not just the averages, but the entire shape of the distribution of any covariate is the same (in expectation) across treated and control groups.

### Balances things you can't even see

Let $U$ be some unmeasured characteristic (like genetic predisposition, or personality, or anything you didn't collect data on):

$$\mathbb{E}[\bar{U}_T - \bar{U}_C] = 0$$

This is the killer feature. Randomization handles confounders **you don't even know about**. No other method can do this.

### Balance gets tighter with bigger samples

Hoeffding's inequality says the probability of a big imbalance drops exponentially as $N$ grows:

$$\Pr\left(|\bar{X}_T - \bar{X}_C| > \epsilon\right) \le 2\exp\left(-\frac{2n_1 n_0}{N} \cdot \frac{\epsilon^2}{(b-a)^2}\right)$$

Translation: in large experiments, big accidental imbalances are astronomically unlikely.

## 4.4 Regression vs. Randomization Comparison

| | Regression | Randomization |
|---|-----------|---------------|
| Balances the covariates you include | Yes | Yes |
| Balances nonlinear functions of covariates | **No** | Yes |
| Balances stuff you can't observe | **No** | Yes |
| Requires a model to be correct | Yes | **No** |
| Requires assumptions about the outcome | Yes | **No** |

This is why randomized experiments are called the **gold standard** -- they handle everything regression can't.

---

# 5. Weeks 3--4: Potential Outcomes -- The Language of Causation

This is the theoretical backbone of the course. Once you understand this framework, everything else clicks into place.

## 5.1 The Two Imaginary Worlds

For every person $i$ in your study, imagine two parallel universes:

- **Universe 1:** Person $i$ gets the treatment. Their outcome in this universe is $Y_i(1)$.
- **Universe 0:** Person $i$ does NOT get the treatment. Their outcome is $Y_i(0)$.

These are called **potential outcomes**. They are fixed numbers -- not random. They are attributes of the person, like their height or birthday. They just describe what **would** happen in each scenario.

**The causal effect of treatment on person $i$:**

$$\tau_i = Y_i(1) - Y_i(0)$$

This is just: "how much better (or worse) off is this person with the treatment vs. without?"

## 5.2 The Fundamental Problem

Here is the catch: **you only get to live in one universe.** Each person either gets the treatment or doesn't. You observe $Y_i(1)$ if they got treated, or $Y_i(0)$ if they didn't. **Never both.**

The outcome you actually observe is:

$$Y_i^{\text{obs}} = Z_i \cdot Y_i(1) + (1 - Z_i) \cdot Y_i(0)$$

If $Z_i = 1$: you see $Y_i(1)$. If $Z_i = 0$: you see $Y_i(0)$.

This means **you can never compute the treatment effect for any single person**, because you are always missing one of the two numbers.

This is called the **fundamental problem of causal inference**, and it is why the entire field exists.

## 5.3 The "Science" vs. the "Assignment"

A key concept in this class is the strict separation between:

1. **The Science** ($\mathcal{S}$): All the potential outcomes $\{Y_i(1), Y_i(0)\}$ for every person. These are **fixed, unknown numbers**. They are not random. They just describe how each person would respond.

2. **The Assignment** ($\mathbf{Z}$): The random process that determines who gets treated. This is the **only thing that is random** in the whole setup.

All the probability and statistics in this framework come from the randomization of who gets treated, NOT from any randomness in the outcomes themselves. The outcomes are fixed; the randomness is in which ones we get to see.

## 5.4 The Target: Finite-Population Average Treatment Effect (PATE)

Since we can't get individual treatment effects, we aim for the **average** across everyone:

$$\tau = \frac{1}{N}\sum_{i=1}^{N}\big[Y_i(1) - Y_i(0)\big]$$

This is just: add up everyone's treatment effect and divide by $N$. It is a fixed number (not random) because the potential outcomes are fixed.

In plain English: **on average, across all people in the study, how much does the treatment change the outcome?**

## 5.5 The Estimator: Difference in Means

The natural way to estimate $\tau$:

$$\hat{\tau} = \bar{Y}_T - \bar{Y}_C = \frac{1}{n_1}\sum_{i: Z_i=1} Y_i^{\text{obs}} - \frac{1}{n_0}\sum_{i: Z_i=0} Y_i^{\text{obs}}$$

In plain English: take the average outcome of the treated people, subtract the average outcome of the control people.

## 5.6 Neyman's Framework -- The Estimation Approach

Jerzy Neyman developed a framework focused on **estimating** the average treatment effect and quantifying uncertainty.

### Unbiasedness

Under a completely randomized design:

$$\mathbb{E}[\hat{\tau}] = \tau$$

**Translation:** If you could repeat the experiment many times (re-randomizing each time), the average of all your estimates would be the true treatment effect. The estimator is not systematically off in any direction.

**Why?** Because randomization makes each person equally likely to be in the treated group. So the treated group mean is an unbiased estimate of $\bar{Y}(1)$ (the average outcome if everyone were treated), and the control group mean is an unbiased estimate of $\bar{Y}(0)$.

No modeling assumptions needed. Unbiasedness follows purely from the randomization.

### How much does the estimate bounce around? (Neyman's Exact Variance)

First, some building blocks. Define these **finite-population variances** (these just measure how spread out the potential outcomes are):

$$S_1^2 = \frac{1}{N-1}\sum_{i=1}^{N}\big(Y_i(1) - \bar{Y}(1)\big)^2$$

This measures how spread out the treated potential outcomes are.

$$S_0^2 = \frac{1}{N-1}\sum_{i=1}^{N}\big(Y_i(0) - \bar{Y}(0)\big)^2$$

Same thing for control potential outcomes.

$$S_\tau^2 = \frac{1}{N-1}\sum_{i=1}^{N}(\tau_i - \tau)^2$$

This measures how much the treatment effect **varies across people**. If the treatment helps everyone by exactly the same amount, this is zero. If some people benefit a lot and others not at all, this is large.

**Neyman's exact variance formula:**

$$\text{Var}(\hat{\tau}) = \frac{S_1^2}{n_1} + \frac{S_0^2}{n_0} - \frac{S_\tau^2}{N}$$

In English:
- More spread in the potential outcomes ($S_1^2$, $S_0^2$) means more variance (noisier estimate)
- Larger groups ($n_1$, $n_0$) means less variance (more precise)
- More heterogeneous treatment effects ($S_\tau^2$) actually **decreases** variance (this is the subtle part)

### The problem with $S_\tau^2$

$S_\tau^2$ requires knowing both $Y_i(1)$ and $Y_i(0)$ for every person -- which we never have. So we can't compute the exact variance.

### The conservative workaround

Since $S_\tau^2 \ge 0$, we know:

$$\text{Var}(\hat{\tau}) \le \frac{S_1^2}{n_1} + \frac{S_0^2}{n_0}$$

We can estimate $S_1^2$ and $S_0^2$ using the sample variances from the observed data:

$$s_1^2 = \frac{1}{n_1-1}\sum_{i:Z_i=1}(Y_i^{\text{obs}} - \bar{Y}_T)^2, \quad s_0^2 = \frac{1}{n_0-1}\sum_{i:Z_i=0}(Y_i^{\text{obs}} - \bar{Y}_C)^2$$

**Neyman's conservative variance estimator:**

$$\widehat{\text{Var}}(\hat{\tau}) = \frac{s_1^2}{n_1} + \frac{s_0^2}{n_0}$$

"Conservative" means it **overestimates** the true variance (because it ignores the $-S_\tau^2/N$ term). This means your confidence intervals will be a bit wider than they need to be, but they are still valid.

### When is the conservative estimator exact?

When the treatment effect is the **same for everyone**: $Y_i(1) = Y_i(0) + \tau$ for all $i$.

Then $S_\tau^2 = 0$ (no variation in treatment effects), and the conservative bound equals the true variance.

### Confidence Intervals

For large samples, the estimator is approximately normally distributed (by a central limit theorem that comes from the randomization, NOT from assuming outcomes are normal):

$$\hat{\tau} \pm z_{1-\alpha/2}\sqrt{\widehat{\text{Var}}(\hat{\tau})}$$

For a 95% CI, $z_{0.975} \approx 1.96$, so this is roughly $\hat{\tau} \pm 1.96 \times \text{SE}$.

### Neyman vs. the classical two-sample t-test

You might have seen the two-sample t-test in intro stats. It looks similar but comes from a completely different philosophy:

| | Neyman's approach | Classical t-test |
|---|---------|-----------------|
| What is random? | Only the treatment **assignment** | The **outcomes** themselves (modeled as random draws from populations) |
| Are outcomes fixed or random? | Fixed (potential outcomes are just numbers) | Random (drawn from distributions) |
| Where does the variance formula come from? | The randomization mechanism | A probability model for outcomes |
| Does it pool variances? | No | Often yes (assumes equal variance in both groups) |
| Does it need normality? | No | Yes (or large sample) |

The key point: Neyman's approach is valid because **you randomized**. The t-test's validity depends on **modeling assumptions** about the outcomes.

## 5.7 Fisher's Framework -- The Testing Approach

R.A. Fisher had a different approach. Instead of trying to estimate the treatment effect, he asked: **"Can I prove that the treatment did anything at all?"**

### Fisher's Sharp Null Hypothesis

$$H_0: Y_i(1) = Y_i(0) \quad \text{for ALL } i$$

In English: the treatment has **absolutely zero effect on every single person**. Nobody is affected at all.

This is called "sharp" because it pins down every single missing potential outcome. If the null is true, then $Y_i(1) = Y_i(0) = Y_i^{\text{obs}}$ for everyone, regardless of which group they are in. You know all the potential outcomes completely.

### The Randomization Test

Here is the beautiful idea. Under the sharp null:

1. You know all potential outcomes (they all equal the observed outcomes)
2. You know the assignment mechanism (the randomization)
3. So for every possible way you **could have** randomized, you can compute exactly what the test statistic would have been

**Algorithm:**
1. Pick a test statistic $T$ (e.g., difference in means)
2. Compute the observed value $T_{\text{obs}}$ from your actual data
3. List all $\binom{N}{n_1}$ possible assignments
4. For each one, compute $T$ (using the same outcomes, since under $H_0$ they don't change)
5. The p-value = fraction of assignments where $|T| \ge |T_{\text{obs}}|$

**Why this is amazing:**
- It is **exact** -- no approximations, no "large sample" needed
- It requires **zero assumptions** about the distribution of outcomes
- It works in any sample size, even tiny ones
- Its validity depends ONLY on the randomization being real

### Randomization tests are NOT the same as permutation tests

They look similar computationally, but the logic is different. Permutation tests assume the data are exchangeable (a distributional assumption). Randomization tests rely on the physical act of randomization. The randomization test is valid even if outcomes are weird (skewed, heavy-tailed, etc.).

## 5.8 Constant Additive Treatment Effects

Fisher's sharp null ($H_0$: treatment does nothing to anyone) is pretty extreme. A more useful assumption:

$$Y_i(1) = Y_i(0) + \tau \quad \text{for all } i$$

This says the treatment adds exactly $\tau$ to everyone's outcome. The same amount for every person. (This is a strong assumption, but useful for testing.)

### Testing a specific value of $\tau$

Want to test $H_0: \tau = \tau_0$ (the treatment effect is exactly $\tau_0$)?

Create adjusted outcomes: $Y_i^{(\tau_0)} = Y_i^{\text{obs}} - Z_i \cdot \tau_0$

If $\tau = \tau_0$, then $Y_i^{(\tau_0)} = Y_i(0)$ for everyone, and the adjusted data satisfy Fisher's sharp null. So run the randomization test on the adjusted data.

### Confidence Intervals by Inversion

This is clever. Try a bunch of values of $\tau_0$. For each one, run the test above. Keep all the values you can't reject:

$$\mathcal{C}_{1-\alpha} = \{\tau_0 : p(\tau_0) > \alpha\}$$

This set has exact coverage: $\Pr(\tau \in \mathcal{C}_{1-\alpha}) \ge 1 - \alpha$.

For statistics like the difference in means, this set is an interval $[\tau_L, \tau_U]$.

**Properties:**
- Exact in finite samples (not asymptotic)
- No normality assumptions
- Comes from the design of the experiment, not a model for outcomes

## 5.9 Choice of Test Statistics

In a randomization test, you need to pick a test statistic. Different choices have different strengths:

**Difference in means:** $T = \bar{Y}_T - \bar{Y}_C$. The most natural choice. Best when outcomes are well-behaved (not too skewed or outlier-heavy).

**Rank-based statistics:** Instead of using the raw outcome values, use their ranks (1st smallest, 2nd smallest, etc.). More robust to outliers and skewed data. Example: Wilcoxon rank sum.

**For paired/blocked designs:** $T = \sum_{b=1}^{B}(Y_{bT} - Y_{bC})$ -- sum the within-pair differences. Use this when the experiment has blocks or pairs.

## 5.10 Neyman vs. Fisher: Summary

| | Neyman | Fisher |
|---|--------|--------|
| Goal | **Estimate** $\tau$ (give a number and a confidence interval) | **Test** whether $\tau = 0$ (give a p-value) |
| Assumes constant effects? | No -- handles heterogeneous effects | Sharp null or constant effects |
| Key output | $\hat{\tau} \pm \text{margin of error}$ | p-value |
| Type of inference | Asymptotic (CLT-based) | Exact (enumerate all assignments) |

Both are valid under randomization. They answer slightly different questions but are complementary.

---

# 6. Addendum: Using Regression Inside an Experiment

## 6.1 The Puzzle

We just showed that the difference in means $\hat{\tau} = \bar{Y}_T - \bar{Y}_C$ is already unbiased for $\tau$ in a randomized experiment. So why would you bother running a regression?

**Answer: Precision.** Regression doesn't change WHAT you are estimating -- it makes the estimate **less noisy**.

## 6.2 How It Helps

In any particular randomization, there will be some accidental imbalances (maybe the treated group happens to be slightly older, for example). These imbalances add noise.

Regression strips out the part of the outcome that is predictable from covariates, leaving a cleaner comparison. Think of it like noise-cancelling headphones for your estimate.

## 6.3 Key Facts

1. **Still unbiased**, even if the regression model is wrong. In a randomized experiment, $\hat{\tau}_{\text{reg}}$ is unbiased for $\tau$ regardless of whether the linear model is correctly specified. (This is because the randomization makes $\tilde{Z}$ independent of potential outcomes.)

2. **Variance is smaller** (or at worst, the same) compared to the simple difference in means. The better covariates predict the outcome, the bigger the improvement.

3. **Does not change the estimand.** You are still estimating the same $\tau$. Regression is just a more efficient way to get at it.

## 6.4 The Bottom Line

> In an experiment, regression adjustment is like blocking after the fact. It removes noise by accounting for covariate imbalances that arose by chance. It **refines** an already valid design -- it does not rescue a bad one.

---

# 7. Week 5: Observational Studies and Matching

## 7.1 When You Can't Randomize

Often you just can't randomly assign treatment:
- You can't randomly make people smoke to study lung cancer (ethics)
- You can't randomly assign kids to rich vs. poor families (impossible)
- You can't randomize past events (the data already exists)

But you still want to know the causal effect. What do you do?

## 7.2 The Core Idea

> An observational study is an attempt to **reconstruct the balance** that randomization would have created.

Since you can't randomize, you try to find treated and control people who **look the same** on their background characteristics. If you do a good enough job, the comparison is almost as credible as an experiment.

**Three principles:**

1. **Separate design from analysis.** Figure out how to make the groups comparable **before** you look at the outcomes. Don't let the results influence how you set up the comparison.

2. **Construct comparable groups.** Use matching (or other techniques) to make the treated and control groups similar.

3. **Covariates refine, not rescue.** Covariates can improve a decent comparison, but they can't save a fundamentally flawed one.

## 7.3 Matching

**What it is:** Find pairs (or sets) of people -- one treated, one control -- who have similar background characteristics. Discard everyone who doesn't have a good match. Then compare outcomes within the matched sample.

**It is a design tool, not an analysis tool.** Matching creates a new, better dataset. The analysis is then simple (usually just difference in means on the matched sample).

### Types of Matching

**Exact matching:** Only match people with identical covariates. Perfect balance, but impossible in practice if you have continuous covariates (no two people have exactly the same age, income, etc.).

**Nearest-neighbor matching:** For each treated person, find the control person who is closest (in terms of their covariates). "Closest" needs a definition of distance.

**Mahalanobis distance matching:** A smart way to measure "closest" that accounts for the fact that some covariates vary more than others, and covariates might be correlated.

**Propensity score matching:** Instead of matching on all covariates at once (which is hard in high dimensions), match on the propensity score -- a single number summarizing the probability of being treated. More on this in Week 6.

**Optimal matching:** Instead of greedily matching one pair at a time (which can "waste" good matches early), find the matching that minimizes the total distance across ALL pairs simultaneously. Better results, but harder to compute.

## 7.4 How Do You Know If Matching Worked?

After matching, you need to check: **are the groups actually similar now?**

### Standardized Mean Difference (SMD)

For each covariate, compute:

$$\text{SMD}(X) = \frac{\bar{X}_T - \bar{X}_C}{s_X}$$

where $s_X = \sqrt{(s_T^2 + s_C^2)/2}$ is the pooled standard deviation.

**What this measures:** The difference in average covariate values between groups, scaled by how spread out the covariate is. It puts all covariates on the same scale so you can compare across variables with different units.

**Rules of thumb:**
- $|\text{SMD}| < 0.1$: great balance
- $|\text{SMD}| \approx 0.2$: okay but not great
- $|\text{SMD}| > 0.25$: bad, matching probably didn't work well enough

**Why not use a t-test?** Because t-test p-values depend on sample size. With a huge sample, even a tiny, meaningless difference will be "statistically significant." SMD measures the **actual size** of the imbalance.

### Variance Ratios

$$\text{VR}(X) = \frac{\text{Var}(X_T)}{\text{Var}(X_C)}$$

Should be close to 1. This checks whether the **spread** of a covariate is similar across groups, not just the average.

### Love Plots

A visual tool. Plot SMDs before and after matching for each covariate. You want to see all the dots move close to zero.

## 7.5 Why Matching Reduces Bias

Under a model where $Y_i = \tau Z_i + g(X_i) + \varepsilon_i$ (outcome depends on treatment plus some function of covariates plus noise):

If you match each treated person $i$ to a control person $j(i)$ with similar covariates, the bias is:

$$\text{Bias} = \frac{1}{n_M}\sum_{i=1}^{n_M}\big(g(X_i) - g(X_{j(i)})\big)$$

If $g$ is smooth (doesn't jump around wildly) and the matched pairs have similar covariates ($X_i \approx X_{j(i)}$), then each term $g(X_i) - g(X_{j(i)})$ is small, so the bias is small.

**Bottom line:** Better matching (more similar pairs) = less bias. This is formalized by Chebyshev-type bounds:

$$|\text{Bias}| \le L\big(|\Delta_X^M| + 2s_D\big)$$

where $L$ measures how "curvy" $g$ is, $\Delta_X^M$ is the average covariate difference in matched pairs, and $s_D$ is the standard deviation of pairwise differences. Shrink these, and the bias shrinks.

---

# 8. Week 6: Making Observational Studies Work -- Assumptions and Propensity Scores

## 8.1 The Problem: Selection Bias

In observational data, if you just compare treated and untreated groups:

$$\mathbb{E}[Y \mid Z=1] - \mathbb{E}[Y \mid Z=0]$$

This is NOT the causal effect. It can be broken down as:

$$= \underbrace{\mathbb{E}[Y(1) - Y(0) \mid Z=1]}_{\text{causal effect on the treated}} + \underbrace{\mathbb{E}[Y(0) \mid Z=1] - \mathbb{E}[Y(0) \mid Z=0]}_{\text{selection bias}}$$

The **selection bias** is the difference in baseline outcomes between the treated and control groups. It exists because people who choose (or are chosen for) treatment are different from those who don't, **even before treatment**.

**Example:** If healthier people are more likely to exercise, then $\mathbb{E}[Y(0) \mid Z=1] > \mathbb{E}[Y(0) \mid Z=0]$ -- exercisers would have been healthier even without exercise. Comparing exercisers to non-exercisers overestimates the effect of exercise.

## 8.2 SUTVA -- Making Sure the Question Even Makes Sense

Before we can talk about identifying causal effects, we need to make sure the potential outcomes are well-defined. SUTVA (Stable Unit Treatment Value Assumption) has two parts:

### Part 1: No interference between people

Person $i$'s outcome depends only on whether **they** were treated, not on whether **anyone else** was treated.

$$Y_i(z_1, z_2, \ldots, z_N) = Y_i(z_i)$$

**When this fails:** Vaccination (if your neighbor is vaccinated, you're safer even without the vaccine -- herd immunity). Social networks (if your friend joins a platform, that changes your experience). Classroom interventions (a tutored student might help their untutored friends).

### Part 2: No hidden versions of treatment

"Treatment" means one specific thing, not a grab bag of different things lumped together.

**When this fails:** A "job training program" where some people get 40 hours of intensive coaching and others get a 2-hour webinar, but they're all coded as "treated." A drug where different patients get different dosages.

**Why SUTVA matters:** If these assumptions fail, then $Y_i(1)$ doesn't have a clear meaning -- "what happens if person $i$ is treated" depends on who else is treated, or on which version of treatment they get. You can't define the causal effect if you can't define the potential outcomes.

## 8.3 The Three Assumptions You Need

To identify causal effects from observational data, you need **all three** of these:

### Assumption 1: Ignorability (a.k.a. Unconfoundedness, "No Unmeasured Confounders")

$$(Y(1), Y(0)) \perp\!\!\!\perp Z \mid X$$

**Plain English:** Once you account for the background characteristics $X$, the treatment assignment $Z$ is essentially random. There is no hidden variable that affects both who gets treated and what their outcome would be.

This does NOT mean treatment is randomly assigned. It means that **all the reasons** why some people get treated and others don't are captured in $X$. After conditioning on $X$, the remaining variation in treatment is "as good as random."

**Example:** Suppose the only reason some patients get Drug A instead of Drug B is their age and disease severity (both observable). Then conditional on age and severity, treatment assignment is ignorable.

**The catch:** This is **impossible to verify from data**. You can never prove there isn't some unmeasured confounder lurking. This assumption must be justified by your understanding of **how treatment decisions are actually made** in the real world.

### Assumption 2: Overlap (a.k.a. Common Support, Positivity)

$$0 < \Pr(Z = 1 \mid X = x) < 1 \quad \text{for all } x$$

**Plain English:** For every type of person (every combination of background characteristics), there is a nonzero chance of being in either group. Nobody is **guaranteed** to be treated or guaranteed to be in the control.

**Why it matters:** If all 30-year-old women always get the treatment and never end up in control, there are no control people to compare them to. You'd have to **extrapolate** (guess what their control outcome would be), which is unreliable.

**When it fails:** If there are regions of covariate space where you only see treated people or only see control people, you cannot estimate the treatment effect there. Solutions include trimming the sample to the region of overlap.

### Assumption 3: SUTVA

(Covered above -- no interference, no hidden versions of treatment.)

## 8.4 Identification: How These Assumptions Let You Estimate Causal Effects

Under these three assumptions, the average treatment effect is:

$$\tau = \mathbb{E}\Big[\mathbb{E}[Y \mid Z=1, X] - \mathbb{E}[Y \mid Z=0, X]\Big]$$

**In plain English:** Compare the average outcome of treated people to the average outcome of untreated people **who have the same background characteristics $X$**, then average that comparison over all possible values of $X$.

**The logic (important to know for the exam):**

1. $\mathbb{E}[Y(1)] = \mathbb{E}\big[\mathbb{E}[Y(1) \mid X]\big]$ -- (law of iterated expectations / tower property: you can compute an overall average by first averaging within groups of $X$, then averaging over groups)
2. $= \mathbb{E}\big[\mathbb{E}[Y(1) \mid Z=1, X]\big]$ -- (by ignorability: conditional on $X$, the potential outcome under treatment is the same regardless of whether the person was actually treated)
3. $= \mathbb{E}\big[\mathbb{E}[Y \mid Z=1, X]\big]$ -- (by consistency: for treated people, $Y = Y(1)$, so the observed outcome IS the potential outcome under treatment)

Same logic gives $\mathbb{E}[Y(0)] = \mathbb{E}\big[\mathbb{E}[Y \mid Z=0, X]\big]$.

Subtracting: $\tau = \mathbb{E}\big[\mathbb{E}[Y \mid Z=1, X] - \mathbb{E}[Y \mid Z=0, X]\big]$.

**The key insight:** Under these assumptions, you can replace **unobservable** potential outcomes with **observable** conditional means. The causal effect is identified from the data.

## 8.5 The Propensity Score

### What is it?

The propensity score is just the probability of getting treated, given your background:

$$e(X) = \Pr(Z = 1 \mid X)$$

If you are a 25-year-old male with high income, and 40% of people like you receive the treatment, your propensity score is 0.4.

### Why is it useful?

**The Rosenbaum-Rubin Balancing Property:**

If ignorability holds (conditional on $X$, treatment is as-if-random), then:

$$(Y(1), Y(0)) \perp\!\!\!\perp Z \mid e(X)$$

**Translation:** You don't need to match on all the covariates simultaneously. You just need to match on this single number -- the propensity score. Within groups of people who have the **same propensity score**, the background characteristics are balanced between treated and control groups.

This is a massive practical simplification. Instead of matching on age AND income AND education AND health AND ... (which gets really hard when you have many covariates), you match on one number.

### Proof intuition

Fix a propensity score value, say $e(X) = 0.6$. Among all people with $e(X) = 0.6$:

- Each has a 60% chance of being treated
- Which ones actually end up treated is (conditional on $X$) essentially random
- So within this group, treated and untreated people have similar covariates

This is exactly the same logic as a randomized experiment, except the "randomization probability" varies from person to person (it's $e(X)$ instead of a fixed $n_1/N$).

### The propensity score is the "coarsest balancing score"

A "balancing score" is any function $b(X)$ such that, conditional on $b(X)$, covariates are balanced. The full covariate vector $X$ is trivially a balancing score (condition on everything = perfect balance). The propensity score $e(X)$ is the **simplest possible** balancing score -- it compresses all the information in $X$ down to a single number, and that single number is sufficient for balance.

### Estimating the propensity score

In practice, you don't know $e(X)$, so you estimate it. Common approach:

**Logistic regression:** Model $\Pr(Z = 1 \mid X)$ as a logistic function of $X$:

$$\Pr(Z = 1 \mid X) = \frac{\exp(\alpha + \beta^\top X)}{1 + \exp(\alpha + \beta^\top X)}$$

You can also use more flexible methods (random forests, boosting, etc.).

**Important:** The goal is NOT to predict treatment assignment as accurately as possible. The goal is to get good **covariate balance** after matching or weighting. A model that predicts well but produces poor balance is useless.

**After estimating, always check:**
- **Overlap:** Plot histograms of the estimated propensity scores for treated vs. control. They should overlap substantially. If they don't, you have a common support problem.
- **Balance:** Compute SMDs after matching/weighting on the propensity score. If covariates are still imbalanced, the propensity score model needs improvement.

---

# 9. Week 7: Estimating Causal Effects -- IPW, AIPW, and Diagnostics

Now we have the setup from Week 6: we know the assumptions (SUTVA, ignorability, overlap), we know the propensity score, and we know that under these assumptions the causal effect is **identified**. The question becomes: **how do we actually compute an estimate from data?**

Week 7 covers the main estimation strategies and how to check if they are working.

## 9.1 Design vs. Analysis: A Two-Phase Approach

A critical idea throughout this course is separating the **design phase** from the **analysis phase**.

**Design phase:** Before you even look at outcomes, construct a comparison that is as close to a randomized experiment as possible. This means:
- Estimate propensity scores
- Match or weight to create balanced groups
- Check covariate balance (SMDs, variance ratios, overlap plots)
- If balance is bad, go back and try a different matching/weighting strategy

**Analysis phase:** Only after you have achieved good balance, plug in the outcomes and estimate the treatment effect. At this point, you can use simple methods (like difference in means within matched pairs, or weighted means).

**Why separate?** Because if you look at outcomes first, you might (consciously or not) choose the method that gives you the answer you want. By committing to a design before seeing outcomes, you protect yourself from this bias. This mirrors how clinical trials work: the analysis plan is locked in before unblinding the data.

## 9.2 Matching on Covariates vs. Matching on the Propensity Score

We covered matching in Week 5. Now we can use the propensity score to make matching practical in high dimensions.

### Matching directly on covariates ($X$)

For each treated person, find a control person with similar values of $X$. Works great when you have a few covariates, but becomes increasingly difficult as the number of covariates grows (the "curse of dimensionality" -- the space of possible covariate combinations explodes).

### Matching on the propensity score ($e(X)$)

Instead of matching on all covariates simultaneously, match on the single number $e(X)$. By the Rosenbaum-Rubin balancing property (Section 8.5), this achieves covariate balance automatically.

**Procedure:**
1. Estimate propensity scores $\hat{e}(X_i)$ (e.g., via logistic regression)
2. For each treated person, find the control person with the closest $\hat{e}(X)$
3. Compute the treatment effect estimate as the average within-pair difference

**Trade-off:** Matching on $e(X)$ is easier than matching on all of $X$, but may produce worse balance on individual covariates. Combining Mahalanobis distance matching (on important covariates) with propensity score calipers often works well in practice.

### Subclassification (Stratification)

Instead of forming exact pairs, divide the sample into **strata** (subgroups) based on the propensity score. A common choice is quintiles (5 groups).

**How it works:**
1. Estimate propensity scores
2. Divide the sample into $K$ strata based on $\hat{e}(X)$ (e.g., quintiles)
3. Within each stratum, compute the difference in mean outcomes between treated and control
4. Average across strata (weighted by stratum size):

$$\hat{\tau}_{\text{strat}} = \sum_{k=1}^{K} \frac{N_k}{N} \left(\bar{Y}_{T,k} - \bar{Y}_{C,k}\right)$$

**Intuition:** Within each stratum, treated and control people have similar propensity scores, so they should have similar covariates. This approximates comparing "apples to apples" within each stratum.

**Classic result:** Cochran (1968) showed that 5 subclasses remove approximately 90% of the bias from a single confounding covariate. More strata = less bias, but also noisier within-stratum estimates (fewer people per stratum).

## 9.3 Inverse Probability Weighting (IPW)

This is a fundamentally different approach from matching. Instead of finding similar people, IPW **reweights** every person in the sample so that the weighted groups look like a randomized experiment.

### The intuition

Imagine a treated person with a propensity score of $e(X) = 0.2$. Only 20% of people like them get treated. So this one treated person "represents" $1/0.2 = 5$ people in the population. We should upweight them.

Conversely, a treated person with $e(X) = 0.9$ is very typical of the treated group -- 90% of people like them get treated. They only represent $1/0.9 \approx 1.1$ people. We give them a small weight.

The same logic applies to the control group: a control person with $e(X) = 0.8$ (meaning 80% of similar people get treated, so only 20% end up in control) should be upweighted by $1/(1-0.8) = 5$.

### The IPW estimator

$$\hat{\tau}_{\text{IPW}} = \frac{1}{N}\sum_{i=1}^{N}\left[\frac{Z_i Y_i}{\hat{e}(X_i)} - \frac{(1-Z_i)Y_i}{1-\hat{e}(X_i)}\right]$$

In plain English: take each treated person's outcome, weight it up by $1/\hat{e}(X_i)$, then subtract each control person's outcome weighted up by $1/(1-\hat{e}(X_i))$, and divide by $N$.

You can also write this as estimating each mean separately:

$$\hat{\mu}_1^{\text{IPW}} = \frac{1}{N}\sum_{i=1}^{N}\frac{Z_i Y_i}{\hat{e}(X_i)}, \qquad \hat{\mu}_0^{\text{IPW}} = \frac{1}{N}\sum_{i=1}^{N}\frac{(1-Z_i)Y_i}{1-\hat{e}(X_i)}$$

$$\hat{\tau}_{\text{IPW}} = \hat{\mu}_1^{\text{IPW}} - \hat{\mu}_0^{\text{IPW}}$$

### Why IPW is unbiased (the key proof idea)

Consider the treated piece:

$$\mathbb{E}\left[\frac{Z_i Y_i}{e(X_i)}\right]$$

Using the tower property (condition on $X_i$ first):

$$= \mathbb{E}\left[\mathbb{E}\left[\frac{Z_i Y_i}{e(X_i)} \,\Big|\, X_i\right]\right]$$

Given $X_i$, the propensity score $e(X_i)$ is just a number, and by ignorability, $Y_i(1)$ is independent of $Z_i$ given $X_i$. Also, when $Z_i = 1$, we observe $Y_i = Y_i(1)$. So:

$$= \mathbb{E}\left[\frac{\mathbb{E}[Z_i \mid X_i] \cdot \mathbb{E}[Y_i(1) \mid X_i]}{e(X_i)}\right] = \mathbb{E}\left[\frac{e(X_i) \cdot \mathbb{E}[Y_i(1) \mid X_i]}{e(X_i)}\right] = \mathbb{E}[\mathbb{E}[Y_i(1) \mid X_i]] = \mathbb{E}[Y_i(1)]$$

The propensity score cancels out perfectly. The weights exactly undo the selection bias.

### IPW achieves covariate balance as a theorem

Here is a remarkable fact. Define the IPW weighted average of a covariate $X$ in the treated group:

$$\frac{\sum_{i=1}^{N} \frac{Z_i X_i}{\hat{e}(X_i)}}{\sum_{i=1}^{N} \frac{Z_i}{\hat{e}(X_i)}}$$

And similarly for the control group. Under correct propensity score specification, these weighted averages converge to the same thing. **IPW automatically balances covariates -- this is not a hope, it is a mathematical consequence of the weighting.**

This is exactly analogous to how regression balances covariates (Section 3.4), but IPW can handle nonlinearity because the propensity score can be modeled flexibly.

## 9.4 The Problem with Extreme Weights

IPW has a serious practical problem. If the propensity score is close to 0 or 1 for some people, the weights blow up:

- A treated person with $e(X) = 0.01$ gets weight $1/0.01 = 100$
- A control person with $1-e(X) = 0.02$ gets weight $1/0.02 = 50$

These extreme weights mean a tiny number of people can dominate the entire estimate. One person with an extreme weight can swing the treatment effect estimate dramatically.

**Consequences:**
- High variance (noisy estimate)
- Sensitive to small changes in the data
- Sensitive to misspecification of the propensity score model

**This is the overlap assumption biting back.** When propensity scores are near 0 or 1, it means there are regions of the covariate space where you only see treated (or only control) people. You are essentially extrapolating, which is always dangerous.

### Solutions to extreme weights

**1. Trimming:** Drop people with propensity scores below some threshold (e.g., 0.1) or above some threshold (e.g., 0.9). This changes the estimand -- you are now estimating the effect for the "overlapping" subpopulation, not the whole population.

**2. Stabilized weights (Hajek estimator):** Instead of the "raw" IPW weights, use weights that sum to 1 in each group:

$$\hat{\tau}_{\text{Hajek}} = \frac{\sum_{i=1}^{N}\frac{Z_i Y_i}{\hat{e}(X_i)}}{\sum_{i=1}^{N}\frac{Z_i}{\hat{e}(X_i)}} - \frac{\sum_{i=1}^{N}\frac{(1-Z_i) Y_i}{1-\hat{e}(X_i)}}{\sum_{i=1}^{N}\frac{(1-Z_i)}{1-\hat{e}(X_i)}}$$

The difference from plain IPW: the denominators normalize the weights. This is a **ratio estimator** (ratio of two weighted sums). It is technically slightly biased (unlike the raw IPW) but has much lower variance in practice.

**Why "stabilized"?** The weights $Z_i/\hat{e}(X_i)$ can be huge and don't sum to anything nice. But the Hajek weights $\frac{Z_i/\hat{e}(X_i)}{\sum Z_j/\hat{e}(X_j)}$ sum to 1 within the treated group, giving more stable estimates.

## 9.5 Augmented Inverse Probability Weighting (AIPW) -- The "Best of Both Worlds"

AIPW (also called the **doubly robust** estimator) combines IPW with outcome modeling. It tries to fix the main weaknesses of each approach by using both.

### The problem with each approach alone

| Method | What it needs to be correct | Weakness |
|--------|---------------------------|----------|
| Outcome regression | The outcome model $\mathbb{E}[Y \mid Z, X]$ must be correctly specified | If you get the outcome model wrong, you get the wrong answer |
| IPW | The propensity score model $\Pr(Z=1 \mid X)$ must be correctly specified | If you get the propensity model wrong, you get the wrong answer; also, extreme weights cause high variance |

### The AIPW estimator

$$\hat{\tau}_{\text{AIPW}} = \frac{1}{N}\sum_{i=1}^{N}\left[\hat{\mu}_1(X_i) - \hat{\mu}_0(X_i) + \frac{Z_i(Y_i - \hat{\mu}_1(X_i))}{\hat{e}(X_i)} - \frac{(1-Z_i)(Y_i - \hat{\mu}_0(X_i))}{1-\hat{e}(X_i)}\right]$$

where:
- $\hat{\mu}_1(X) = \hat{\mathbb{E}}[Y \mid Z=1, X]$ is the predicted outcome under treatment (from a regression)
- $\hat{\mu}_0(X) = \hat{\mathbb{E}}[Y \mid Z=0, X]$ is the predicted outcome under control (from a regression)
- $\hat{e}(X)$ is the estimated propensity score

### What it does in plain English

Think of AIPW in two pieces:

**Piece 1:** Start with the regression-based estimate: $\hat{\mu}_1(X_i) - \hat{\mu}_0(X_i)$. This is the predicted treatment effect for person $i$ based on their covariates.

**Piece 2:** Add a correction term that uses IPW to fix any errors in the regression. The term $Y_i - \hat{\mu}_1(X_i)$ is the **residual** -- how far the actual outcome is from what the regression predicted. The IPW weights make sure these residuals are properly averaged.

If the regression is perfect ($Y_i = \hat{\mu}_1(X_i)$ for treated, $Y_i = \hat{\mu}_0(X_i)$ for control), the correction terms are zero and you just get the regression estimate. If the regression is wrong, the IPW correction fixes it (as long as the propensity score is correct).

### The "doubly robust" property

AIPW is consistent (gives the right answer in large samples) if **either:**

1. The outcome model is correctly specified ($\hat{\mu}_1, \hat{\mu}_0$ are correct), **OR**
2. The propensity score model is correctly specified ($\hat{e}$ is correct)

You only need **one** of the two models to be right, not both. This is why it is called "doubly robust" -- you get two shots at getting it right.

**Important caveat:** If both models are wrong, AIPW can also give the wrong answer. Double robustness is not a free lunch -- it just gives you better odds.

### Why AIPW is preferred in practice

1. **Double robustness:** Safety net against model misspecification
2. **Efficiency:** When both models are correct, AIPW achieves the lowest possible variance (the "semiparametric efficiency bound")
3. **Less sensitive to extreme weights:** The outcome model "fills in" where IPW weights would be extreme

## 9.6 Diagnostics: How Do You Know It's Working?

After applying any of these methods, you need to check whether the result is trustworthy.

### Covariate balance checks

The most important diagnostic. After matching or weighting:

1. **Compute SMDs** for every covariate (both raw and transformed -- squares, interactions, etc.). All should be below 0.1 in absolute value.

2. **Variance ratios** should be close to 1 for all covariates.

3. **Love plots:** Plot SMDs before and after adjustment. Every covariate should move closer to zero.

If balance is bad after weighting/matching, the propensity score model probably needs to be improved (add more terms, interactions, nonlinearities). Do NOT proceed to the analysis phase with poor balance.

### Overlap / common support

Plot the distribution of estimated propensity scores separately for treated and control groups. They should overlap substantially. Regions with no overlap indicate populations where the treatment effect cannot be reliably estimated.

### Sensitivity analysis

Since ignorability is untestable, you should assess: "how much would an unmeasured confounder need to matter to change my conclusion?" This quantifies the robustness of your findings to potential hidden bias. (This is more of an advanced topic but is conceptually important.)

## 9.7 Putting It All Together: The Analysis Pipeline

Here is the full workflow for an observational study, from start to finish:

1. **Define the question clearly.** What is the treatment? What is the outcome? What is the target population?

2. **Identify covariates.** List all pre-treatment variables that could confound the treatment-outcome relationship. This requires subject-matter expertise.

3. **Estimate propensity scores.** Fit a model for $\Pr(Z=1 \mid X)$.

4. **Design phase -- create balance.** Use matching, subclassification, or weighting. Check balance diagnostics. Iterate until balance is good. **Do not look at outcomes during this phase.**

5. **Analysis phase -- estimate the effect.** Apply the chosen estimator (difference in means on matched data, IPW, or AIPW) and compute standard errors / confidence intervals.

6. **Sensitivity analysis.** Assess how robust the conclusion is to unmeasured confounding.

---

# 10. Key Formulas Cheat Sheet

This is everything you might need to write down on the exam.

## Notation Reference

| Symbol | Plain English |
|--------|-------------|
| $Y_i(1), Y_i(0)$ | Potential outcomes (what happens with/without treatment) |
| $Z_i$ | Treatment indicator (1 = treated, 0 = control) |
| $X_i$ | Background characteristics (covariates) |
| $Y_i^{\text{obs}}$ | The outcome you actually observe |
| $\tau_i = Y_i(1) - Y_i(0)$ | Individual treatment effect |
| $\tau$ | Average treatment effect across everyone |
| $n_1, n_0, N$ | Number treated, number control, total |
| $e(X)$ | Propensity score = $\Pr(Z=1 \mid X)$ |
| $\bar{Y}_T, \bar{Y}_C$ | Average observed outcome in treated/control group |
| $S_1^2, S_0^2$ | Variance of treated/control potential outcomes |
| $S_\tau^2$ | Variance of individual treatment effects |

## The Formulas

**Observed outcome:**
$$Y_i^{\text{obs}} = Z_i Y_i(1) + (1-Z_i)Y_i(0)$$

**Average treatment effect (the thing we want):**
$$\tau = \frac{1}{N}\sum_{i=1}^{N}\big[Y_i(1) - Y_i(0)\big]$$

**Difference-in-means estimator (how we estimate it):**
$$\hat{\tau} = \bar{Y}_T - \bar{Y}_C = \frac{1}{n_1}\sum_{i:Z_i=1}Y_i^{\text{obs}} - \frac{1}{n_0}\sum_{i:Z_i=0}Y_i^{\text{obs}}$$

**Unbiasedness:** $\mathbb{E}[\hat{\tau}] = \tau$

**Neyman's exact variance:**
$$\text{Var}(\hat{\tau}) = \frac{S_1^2}{n_1} + \frac{S_0^2}{n_0} - \frac{S_\tau^2}{N}$$

**Conservative variance bound:** $\text{Var}(\hat{\tau}) \le \frac{S_1^2}{n_1} + \frac{S_0^2}{n_0}$

**Neyman's variance estimator (what you compute in practice):**
$$\widehat{\text{Var}}(\hat{\tau}) = \frac{s_1^2}{n_1} + \frac{s_0^2}{n_0}$$

**Relationship between variances:** $S_\tau^2 = S_1^2 + S_0^2 - 2S_{10}$

**95% Confidence interval (Neyman):**
$$\hat{\tau} \pm 1.96\sqrt{\widehat{\text{Var}}(\hat{\tau})}$$

**FWL residuals:** $\tilde{Z}_i = Z_i - \hat{\mathbb{E}}[Z \mid X_i]$

**Regression coefficient via FWL:**
$$\hat{\tau} = \frac{\sum_{i=1}^{n}\tilde{Z}_i Y_i}{\sum_{i=1}^{n}\tilde{Z}_i^2}$$

**Regression balances covariates:** $\sum_{i=1}^{n} w_i X_i = 0$

**Misspecification bias:** $\text{Bias}(\hat{\tau}) = \sum_{i=1}^{n} w_i \, g(X_i)$

**Fisher's p-value:** $p = \Pr\big(|T(\mathbf{Z})| \ge |T_{\text{obs}}| \mid H_0\big)$

**Confidence set by inversion:** $\mathcal{C}_{1-\alpha} = \{\tau_0 : p(\tau_0) > \alpha\}$

**SMD:** $\text{SMD}(X) = \frac{\bar{X}_T - \bar{X}_C}{\sqrt{(s_T^2 + s_C^2)/2}}$

**Matching bias bound:** $|\text{Bias}(\hat{\tau}^M)| \le L(|\Delta_X^M| + 2s_D)$

**Selection bias decomposition:**
$$\mathbb{E}[Y|Z\!=\!1] - \mathbb{E}[Y|Z\!=\!0] = \text{ATT} + \big(\mathbb{E}[Y(0)|Z\!=\!1] - \mathbb{E}[Y(0)|Z\!=\!0]\big)$$

**Identification under ignorability:**
$$\tau = \mathbb{E}\big[\mathbb{E}[Y \mid Z\!=\!1, X] - \mathbb{E}[Y \mid Z\!=\!0, X]\big]$$

**Ignorability:** $(Y(1), Y(0)) \perp\!\!\!\perp Z \mid X$

**Overlap:** $0 < \Pr(Z=1 \mid X=x) < 1$ for all $x$

**Propensity score:** $e(X) = \Pr(Z=1 \mid X)$

**Balancing property:** $(Y(1), Y(0)) \perp\!\!\!\perp Z \mid e(X)$

**IPW estimator:**
$$\hat{\tau}_{\text{IPW}} = \frac{1}{N}\sum_{i=1}^{N}\left[\frac{Z_i Y_i}{\hat{e}(X_i)} - \frac{(1-Z_i)Y_i}{1-\hat{e}(X_i)}\right]$$

**IPW unbiasedness key step:** $\mathbb{E}\left[\frac{Z_i Y_i}{e(X_i)}\right] = \mathbb{E}[Y_i(1)]$

**Hajek (stabilized) estimator:**
$$\hat{\tau}_{\text{Hajek}} = \frac{\sum_{i}\frac{Z_i Y_i}{\hat{e}(X_i)}}{\sum_{i}\frac{Z_i}{\hat{e}(X_i)}} - \frac{\sum_{i}\frac{(1-Z_i)Y_i}{1-\hat{e}(X_i)}}{\sum_{i}\frac{(1-Z_i)}{1-\hat{e}(X_i)}}$$

**AIPW (doubly robust) estimator:**
$$\hat{\tau}_{\text{AIPW}} = \frac{1}{N}\sum_{i=1}^{N}\left[\hat{\mu}_1(X_i) - \hat{\mu}_0(X_i) + \frac{Z_i(Y_i - \hat{\mu}_1(X_i))}{\hat{e}(X_i)} - \frac{(1-Z_i)(Y_i - \hat{\mu}_0(X_i))}{1-\hat{e}(X_i)}\right]$$

**AIPW doubly robust property:** Consistent if $\hat{\mu}_1, \hat{\mu}_0$ are correct **OR** $\hat{e}$ is correct

**Subclassification estimator:**
$$\hat{\tau}_{\text{strat}} = \sum_{k=1}^{K}\frac{N_k}{N}\left(\bar{Y}_{T,k} - \bar{Y}_{C,k}\right)$$

---

# 11. Practice Questions with Answers

## Q1: What is the fundamental problem of causal inference?

**Answer:** The causal effect for a person is $\tau_i = Y_i(1) - Y_i(0)$: the difference between what happens with treatment and what happens without. The problem is that each person is either treated or not -- you see one potential outcome and the other is forever missing. You never observe both $Y_i(1)$ and $Y_i(0)$ for the same person, so individual causal effects are fundamentally unobservable. This is why we focus on estimating **average** effects, using groups.

---

## Q2: How does regression "adjust" for covariates? What does it balance, and what does it miss?

**Answer:** By the FWL theorem, the regression coefficient on treatment is computed by first removing the linear effect of covariates from both treatment and outcome, then correlating the residuals. This is equivalent to reweighting observations so that the weighted covariate averages are equal between treated and control groups ($\sum w_i X_i = 0$).

Regression balances the covariates **included in the model** (in their linear form). It does NOT balance nonlinear functions (like $X^2$), interactions, or unobserved variables. If the true outcome depends on these omitted terms, the treatment effect estimate will be biased. The bias equals the weighted imbalance in $g(X)$: $\text{Bias} = \sum w_i g(X_i)$.

---

## Q3: Why are randomized experiments the gold standard?

**Answer:** Randomization makes treatment assignment independent of all pre-treatment characteristics. This means:

1. Treated and control groups are balanced in expectation on **every** covariate -- observed, unobserved, linear, nonlinear, everything
2. The difference in means is unbiased for the average treatment effect with no modeling assumptions
3. Exact inference is possible in finite samples (Fisher's randomization test)
4. There is zero sensitivity to hidden confounders, because there are none by design

Regression can only balance what you put in the model. Randomization balances everything.

---

## Q4: Neyman's variance formula

**Answer:** The exact variance of $\hat{\tau}$ under complete randomization is:

$$\text{Var}(\hat{\tau}) = \frac{S_1^2}{n_1} + \frac{S_0^2}{n_0} - \frac{S_\tau^2}{N}$$

$S_\tau^2$ is unidentifiable (requires both potential outcomes for each person), so we use the conservative estimator $\widehat{\text{Var}}(\hat{\tau}) = s_1^2/n_1 + s_0^2/n_0$, which drops the $-S_\tau^2/N$ term. Since $S_\tau^2 \ge 0$, this overestimates the true variance, making confidence intervals wider than necessary but still valid. It is exact when treatment effects are constant ($S_\tau^2 = 0$).

---

## Q5: Explain Fisher's randomization test step by step

**Answer:**

1. **State the null:** $H_0: Y_i(1) = Y_i(0)$ for all $i$ (treatment does nothing to anyone)
2. **Under $H_0$, all potential outcomes are known:** $Y_i(1) = Y_i(0) = Y_i^{\text{obs}}$
3. **Choose a test statistic** (e.g., difference in means)
4. **Compute the observed test statistic** $T_{\text{obs}}$ from the actual data
5. **Enumerate all possible randomizations** (all $\binom{N}{n_1}$ ways to assign treatment)
6. **For each one, compute the test statistic** using the same outcomes (which don't change under $H_0$)
7. **p-value** = proportion of randomizations giving $|T| \ge |T_{\text{obs}}|$

The test is exact (no asymptotics), requires no distributional assumptions, and is valid solely because randomization was performed.

---

## Q6: What is SUTVA? Why does it matter?

**Answer:** SUTVA (Stable Unit Treatment Value Assumption) says:

1. **No interference:** Person $i$'s outcome depends only on their own treatment, not on whether anyone else was treated. (Violated in: vaccination/herd immunity, peer effects in classrooms, social networks.)

2. **No hidden versions of treatment:** "Treatment" means one well-defined thing, not different interventions lumped together. (Violated in: job training programs with varying quality, drugs with different dosages.)

SUTVA matters because without it, $Y_i(1)$ and $Y_i(0)$ are ambiguous -- you can't define the causal effect if the potential outcomes depend on who else is treated or which version of treatment you get.

---

## Q7: What is ignorability and why can't you test it?

**Answer:** Ignorability says $(Y(1), Y(0)) \perp\!\!\!\perp Z \mid X$ -- conditional on observed covariates $X$, treatment assignment is independent of the potential outcomes. In plain English: all the confounders (things that affect both treatment and outcome) are measured and included in $X$.

It is untestable because it is a claim about the **unobserved** potential outcomes. We never see both $Y(1)$ and $Y(0)$, so we cannot check whether they are independent of $Z$ after conditioning on $X$. You must justify this assumption using subject-matter knowledge about how treatment decisions are made.

---

## Q8: What is the propensity score and its balancing property?

**Answer:** The propensity score $e(X) = \Pr(Z=1 \mid X)$ is the probability of being treated given your background characteristics.

The Rosenbaum-Rubin balancing property: if ignorability holds given $X$, then it also holds given $e(X)$:
$(Y(1), Y(0)) \perp\!\!\!\perp Z \mid e(X)$

This means that among people with the **same propensity score**, the covariates are balanced between treated and control groups. So instead of matching on many covariates (hard), you can match on one number (easy). The propensity score compresses all the relevant covariate information into a single dimension.

---

## Q9: What is selection bias? When does it vanish?

**Answer:**

$$\mathbb{E}[Y|Z\!=\!1] - \mathbb{E}[Y|Z\!=\!0] = \underbrace{\mathbb{E}[Y(1)\!-\!Y(0)|Z\!=\!1]}_{\text{actual causal effect on treated}} + \underbrace{\mathbb{E}[Y(0)|Z\!=\!1] - \mathbb{E}[Y(0)|Z\!=\!0]}_{\text{selection bias}}$$

Selection bias = the difference in **baseline** outcomes between people who got treated and people who didn't. It's there because treated people are different from untreated people even before any treatment.

It vanishes when $\mathbb{E}[Y(0)|Z=1] = \mathbb{E}[Y(0)|Z=0]$ -- i.e., both groups would have had the same outcomes without treatment. This holds automatically in a randomized experiment. In an observational study, it holds conditionally under ignorability.

---

## Q10: Computation problem

An A/B test assigns 5 of 10 users to a new interface. Observed sessions:
- Treatment: 8, 6, 7, 9, 5
- Control: 4, 6, 5, 3, 4

**(a) Compute the difference in means.**

$\bar{Y}_T = (8+6+7+9+5)/5 = 35/5 = 7$

$\bar{Y}_C = (4+6+5+3+4)/5 = 22/5 = 4.4$

$\hat{\tau} = 7 - 4.4 = 2.6$

**(b) How would you test Fisher's sharp null?**

Under $H_0$: every person's outcome is the same regardless of treatment. The 10 outcomes are fixed at: 8, 6, 7, 9, 5, 4, 6, 5, 3, 4. There are $\binom{10}{5} = 252$ ways to split them into groups of 5. For each split, compute the difference in means. The p-value is the fraction of the 252 splits that produce $|T| \ge 2.6$.

**(c) Compute the Neyman variance estimate.**

$s_1^2 = \frac{(8-7)^2 + (6-7)^2 + (7-7)^2 + (9-7)^2 + (5-7)^2}{4} = \frac{1+1+0+4+4}{4} = 2.5$

$s_0^2 = \frac{(4-4.4)^2 + (6-4.4)^2 + (5-4.4)^2 + (3-4.4)^2 + (4-4.4)^2}{4} = \frac{0.16+2.56+0.36+1.96+0.16}{4} = \frac{5.2}{4} = 1.3$

$\widehat{\text{Var}}(\hat{\tau}) = \frac{2.5}{5} + \frac{1.3}{5} = 0.5 + 0.26 = 0.76$

$\text{SE} = \sqrt{0.76} \approx 0.872$

95% CI: $2.6 \pm 1.96(0.872) = 2.6 \pm 1.71 = [0.89, 4.31]$

---

## Q11: Neyman vs. t-test

**Answer:** The key difference is **where the randomness comes from**:
- **Neyman:** Potential outcomes are fixed numbers. The only randomness is the treatment assignment. Variance comes from the randomization mechanism.
- **t-test:** Outcomes are random draws from two populations. Variance comes from a probability model for the outcomes.

Neyman does not pool variances, does not require equal variances, and does not require normality. The t-test does. Neyman's approach is valid because randomization was performed; the t-test depends on modeling assumptions.

---

## Q12: Walk through the identification proof under ignorability

**Answer:** We want to show $\tau = \mathbb{E}[\mathbb{E}[Y|Z\!=\!1,X] - \mathbb{E}[Y|Z\!=\!0,X]]$.

Start with $\mathbb{E}[Y(1)]$:
1. $\mathbb{E}[Y(1)] = \mathbb{E}[\mathbb{E}[Y(1)|X]]$ (tower property -- average the conditional averages)
2. $= \mathbb{E}[\mathbb{E}[Y(1)|Z\!=\!1,X]]$ (ignorability -- conditional on $X$, $Y(1)$ doesn't depend on $Z$)
3. $= \mathbb{E}[\mathbb{E}[Y|Z\!=\!1,X]]$ (consistency -- for treated people, $Y=Y(1)$, plus overlap ensures these conditional means exist)

Same for $Y(0)$: $\mathbb{E}[Y(0)] = \mathbb{E}[\mathbb{E}[Y|Z\!=\!0,X]]$.

Subtract: $\tau = \mathbb{E}[Y(1)] - \mathbb{E}[Y(0)] = \mathbb{E}[\mathbb{E}[Y|Z\!=\!1,X] - \mathbb{E}[Y|Z\!=\!0,X]]$.

This says: compare outcomes of treated vs. control people **with the same $X$**, then average over all $X$. Under ignorability + overlap + SUTVA, this recovers the causal effect from observational data.

---

## Q13: What is IPW and why does it work?

**Answer:** The IPW estimator reweights each observation by the inverse of the probability of receiving the treatment they actually received:

$$\hat{\tau}_{\text{IPW}} = \frac{1}{N}\sum_{i=1}^{N}\left[\frac{Z_i Y_i}{\hat{e}(X_i)} - \frac{(1-Z_i)Y_i}{1-\hat{e}(X_i)}\right]$$

**Why it works:** A treated person with propensity $e(X) = 0.2$ is "rare" among similar people -- only 20% of them get treated. So this person represents $1/0.2 = 5$ people from that covariate group. By upweighting rare people, IPW reconstructs what the population would look like under random assignment.

Mathematically, $\mathbb{E}[Z_i Y_i / e(X_i)] = \mathbb{E}[Y_i(1)]$ by the tower property + ignorability + the fact that $\mathbb{E}[Z_i \mid X_i] = e(X_i)$, which cancels the denominator. This is the key proof step.

---

## Q14: What goes wrong with IPW when propensity scores are extreme?

**Answer:** When $e(X)$ is near 0 or 1, the weights $1/e(X)$ or $1/(1-e(X))$ become very large. A single person can get a weight of 50 or 100, dominating the entire estimate. This causes:

1. **High variance** -- the estimate is very noisy
2. **Instability** -- small changes in data or in the propensity model can drastically change the result
3. **Conceptual concern** -- extreme propensity scores signal a **violation of overlap**. If almost everyone with those covariates gets treated (or doesn't), there are no good comparisons to be made

**Solutions:** (1) Trimming: discard units with extreme propensity scores. (2) Stabilized/Hajek weights: normalize the weights to sum to 1 within each group, producing a ratio estimator with lower variance.

---

## Q15: What is the Hajek (stabilized) estimator and why is it better than raw IPW?

**Answer:** The Hajek estimator normalizes the IPW weights so they sum to 1 in each group:

$$\hat{\tau}_{\text{Hajek}} = \frac{\sum Z_i Y_i / \hat{e}(X_i)}{\sum Z_i / \hat{e}(X_i)} - \frac{\sum (1-Z_i)Y_i / (1-\hat{e}(X_i))}{\sum (1-Z_i) / (1-\hat{e}(X_i))}$$

Unlike raw IPW (which divides by $N$), Hajek divides by the sum of weights. This is technically slightly biased but has much lower variance, especially when some weights are large. In practice, the Hajek estimator is almost always preferred over raw IPW.

---

## Q16: What is AIPW and what makes it "doubly robust"?

**Answer:** AIPW combines an outcome regression with IPW:

$$\hat{\tau}_{\text{AIPW}} = \frac{1}{N}\sum\left[\hat{\mu}_1(X_i) - \hat{\mu}_0(X_i) + \frac{Z_i(Y_i - \hat{\mu}_1(X_i))}{\hat{e}(X_i)} - \frac{(1-Z_i)(Y_i - \hat{\mu}_0(X_i))}{1-\hat{e}(X_i)}\right]$$

**How to read it:** Start with the regression prediction of the treatment effect ($\hat{\mu}_1(X_i) - \hat{\mu}_0(X_i)$), then add an IPW-based correction using the regression residuals ($Y_i - \hat{\mu}(X_i)$).

**Doubly robust** means it is consistent if **either** the outcome model or the propensity score model is correctly specified -- you only need one of the two to be right. If the outcome model is perfect, the residuals are zero and the IPW correction vanishes. If the propensity model is perfect, the IPW correction fixes any errors in the outcome model.

This is why AIPW is generally the preferred estimator: it gives you two chances to get the right answer, and when both models are correct, it achieves the best possible precision.

---

## Q17: Why do we separate the "design" phase from the "analysis" phase in observational studies?

**Answer:** In the design phase, you construct comparable groups (via matching or weighting) and check covariate balance -- all **without looking at outcomes**. Only after achieving good balance do you look at outcomes in the analysis phase.

This separation mirrors randomized experiments (where the design is locked in before data collection) and prevents "specification searching" -- the temptation to keep trying different adjustment methods until one gives a favorable result. It adds credibility to the findings because the comparison is constructed blind to the outcome data.

---

## Q18: Compare matching, IPW, subclassification, and AIPW

**Answer:**

| Method | How it works | Main strength | Main weakness |
|--------|-------------|---------------|---------------|
| **Matching** | Pair treated with similar controls, analyze matched pairs | Transparent, easy to check balance, intuitive | Discards unmatched data; hard with many covariates |
| **Subclassification** | Stratify by propensity score, average within-stratum effects | Simple, removes ~90% of bias with 5 strata | Bias from within-stratum heterogeneity; choice of strata number |
| **IPW** | Reweight everyone by inverse propensity | Uses all data, no discarding, achieves exact balance in theory | Extreme weights cause high variance; sensitive to propensity model |
| **AIPW** | Combines outcome regression with IPW correction | Doubly robust; most efficient when both models correct | More complex; still fails if both models wrong |

All four methods require the same fundamental assumptions: SUTVA, ignorability, and overlap. They differ in how they use those assumptions, not in whether they need them.
