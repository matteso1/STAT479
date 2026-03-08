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

**Concrete example of misspecification:** Suppose income ($Y$) depends on education ($X$) in a curvy way: people with very high education earn *much* more (the curve bends upward). You run a linear regression of $Y$ on treatment $Z$ and education $X$. The regression perfectly balances education: the weighted average education is the same in both groups. But it does NOT balance $X^2$ (education squared). If treated people happen to have more extreme education values (some very high, some very low), then $\sum w_i X_i^2 \neq 0$, and the curvy relationship between education and income bleeds into your treatment effect estimate.

## 3.6 The Extrapolation Problem

This is a separate failure mode that the practice problems emphasize.

**What it is:** If treated and control groups occupy different regions of the covariate space, regression is forced to **extrapolate** -- it uses the fitted line to predict what would happen in a region where you have no data.

**Example:** Suppose all treated people have income > \$80K and all control people have income < \$40K. There is a huge gap in the middle. Regression fits a line through the treated data and another through the control data, then uses those lines to "fill in" the gap. But if the true relationship is nonlinear in that gap, the extrapolation can be wildly wrong.

**Why this matters:** Regression gives you a number no matter what. It does not warn you that it is extrapolating. You have to check the overlap of the covariate distributions yourself. This connects directly to the **overlap assumption** in observational studies (Week 6).

**How to detect it:** Look at the distributions of covariates in the treated and control groups. If they barely overlap, regression is extrapolating. Love plots and histograms help.

## 3.7 Key Limitations Summary

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

Jerzy Neyman developed a framework focused on **estimating** the average treatment effect and quantifying uncertainty. This is one of the most important sections for the exam -- you need to understand not just the formulas, but **why** they work.

### Unbiasedness

Under a completely randomized design:

$$\mathbb{E}[\hat{\tau}] = \tau$$

**Translation:** If you could repeat the experiment many times (re-randomizing each time), the average of all your estimates would be the true treatment effect. The estimator is not systematically off in any direction.

**Why does this work? Walk through it with a concrete example.**

Suppose you have 6 people. Their potential outcomes are:

| Person | $Y_i(1)$ | $Y_i(0)$ | $\tau_i$ |
|--------|----------|----------|----------|
| Alice | 8 | 5 | 3 |
| Bob | 6 | 4 | 2 |
| Carol | 10 | 6 | 4 |
| Dave | 4 | 3 | 1 |
| Eve | 7 | 5 | 2 |
| Frank | 9 | 7 | 2 |

True ATE: $\tau = (3+2+4+1+2+2)/6 = 14/6 \approx 2.33$.

Now randomly assign 3 to treatment. One possible randomization: Alice, Carol, Eve get treated. You observe:
- Treated outcomes: 8, 10, 7. Mean = 8.33
- Control outcomes: 4, 3, 7. Mean = 4.67
- $\hat{\tau} = 8.33 - 4.67 = 3.67$ (too high this time)

Another randomization: Bob, Dave, Frank get treated. You observe:
- Treated outcomes: 6, 4, 9. Mean = 6.33
- Control outcomes: 5, 6, 5. Mean = 5.33
- $\hat{\tau} = 6.33 - 5.33 = 1.00$ (too low this time)

Each individual estimate can be too high or too low. But if you averaged $\hat{\tau}$ across ALL $\binom{6}{3} = 20$ possible randomizations, you would get exactly $\tau = 2.33$. That is what unbiasedness means.

**The mechanism:** Randomization makes each person equally likely to be in the treated group. So the treated group mean is an unbiased estimate of $\bar{Y}(1)$ (the average of ALL treated potential outcomes), and the control group mean is an unbiased estimate of $\bar{Y}(0)$. No modeling assumptions needed.

### How much does the estimate bounce around? (Neyman's Exact Variance)

We just saw that $\hat{\tau}$ bounces around from randomization to randomization. Neyman's variance formula tells you **how much** it bounces.

First, some building blocks. Define these **finite-population variances** (these just measure how spread out the potential outcomes are across ALL $N$ people):

$$S_1^2 = \frac{1}{N-1}\sum_{i=1}^{N}\big(Y_i(1) - \bar{Y}(1)\big)^2$$

This measures how spread out the treated potential outcomes are. If everyone would respond similarly to treatment, $S_1^2$ is small.

$$S_0^2 = \frac{1}{N-1}\sum_{i=1}^{N}\big(Y_i(0) - \bar{Y}(0)\big)^2$$

Same thing for control potential outcomes.

$$S_\tau^2 = \frac{1}{N-1}\sum_{i=1}^{N}(\tau_i - \tau)^2$$

This measures how much the treatment effect **varies across people**. Think of it this way:
- If a drug lowers blood pressure by exactly 10 points for everyone: $S_\tau^2 = 0$ (constant effect)
- If the drug lowers blood pressure by 20 for some people and does nothing for others: $S_\tau^2$ is large (heterogeneous effects)

**Neyman's exact variance formula:**

$$\text{Var}(\hat{\tau}) = \frac{S_1^2}{n_1} + \frac{S_0^2}{n_0} - \frac{S_\tau^2}{N}$$

**Read it in pieces:**
- $S_1^2 / n_1$: Sampling $n_1$ people from the population for the treated group introduces noise proportional to how spread out treated outcomes are, divided by the group size. More people in the group = less noise.
- $S_0^2 / n_0$: Same logic for the control group.
- $-S_\tau^2 / N$: This is the subtle part. When treatment effects vary a lot ($S_\tau^2$ large), the variance is actually *smaller*. Why? Because heterogeneous effects create a negative correlation between $\bar{Y}_T$ and $\bar{Y}_C$. When the high-$\tau$ people happen to land in the treated group, they push $\bar{Y}_T$ up but their absence from the control group also pushes $\bar{Y}_C$ down. The difference $\hat{\tau} = \bar{Y}_T - \bar{Y}_C$ doesn't move as much as each piece does individually.

### The problem with $S_\tau^2$ (and $S_{10}$)

Here is the critical issue that drives the entire conservative approach.

$S_\tau^2$ requires knowing $\tau_i = Y_i(1) - Y_i(0)$ for every person -- which requires seeing **both** potential outcomes. We never have that.

**There is an algebraic identity that makes this even clearer:**

$$S_\tau^2 = S_1^2 + S_0^2 - 2S_{10}$$

where $S_{10} = \frac{1}{N-1}\sum_{i=1}^{N}\big(Y_i(1) - \bar{Y}(1)\big)\big(Y_i(0) - \bar{Y}(0)\big)$ is the **covariance** between treated and control potential outcomes.

**Why $S_{10}$ is unidentifiable:** To compute $S_{10}$, you need to know $Y_i(1)$ AND $Y_i(0)$ for the same person. But you only ever see one. You see $Y_i(1)$ for the treated people and $Y_i(0)$ for the control people -- never both for the same person. So $S_{10}$ is forever unknown.

**Concrete example:** Suppose a study drug helps sick people more than healthy people. Then people with high $Y_i(0)$ (healthy, high baseline) would have lower $\tau_i$, meaning $Y_i(1)$ and $Y_i(0)$ move together -- $S_{10}$ would be large and positive. But you can never verify this from the data because you never see both outcomes for the same person.

Since $S_{10}$ is unidentifiable, and $S_\tau^2 = S_1^2 + S_0^2 - 2S_{10}$ contains $S_{10}$, we cannot compute $S_\tau^2$ either.

### The conservative workaround -- and WHY it is ALWAYS valid

Here is the chain of logic. Follow each step carefully:

**Step 1:** $S_\tau^2$ is a variance. Variances are sums of squared deviations. Squares are always non-negative. Therefore:

$$S_\tau^2 = \frac{1}{N-1}\sum_{i=1}^{N}(\tau_i - \tau)^2 \ge 0$$

This is **universally true**. It does not matter what the treatment is, what the population looks like, or whether effects are constant or wildly heterogeneous. A sum of squares is never negative. Period.

**Step 2:** Since $S_\tau^2 \ge 0$, the term $-S_\tau^2/N$ in the exact variance is always $\le 0$. So:

$$\text{Var}(\hat{\tau}) = \frac{S_1^2}{n_1} + \frac{S_0^2}{n_0} - \underbrace{\frac{S_\tau^2}{N}}_{\ge 0} \le \frac{S_1^2}{n_1} + \frac{S_0^2}{n_0}$$

The true variance is always **at most** $S_1^2/n_1 + S_0^2/n_0$.

**Step 3:** We CAN estimate $S_1^2$ and $S_0^2$ from the data. For $S_1^2$: among the $n_1$ treated people we observe, compute their sample variance. This is an unbiased estimator of $S_1^2$ (by the same randomization logic -- the treated people are a random sample from the population).

$$s_1^2 = \frac{1}{n_1-1}\sum_{i:Z_i=1}(Y_i^{\text{obs}} - \bar{Y}_T)^2, \quad s_0^2 = \frac{1}{n_0-1}\sum_{i:Z_i=0}(Y_i^{\text{obs}} - \bar{Y}_C)^2$$

**Step 4: Neyman's conservative variance estimator:**

$$\widehat{\text{Var}}(\hat{\tau}) = \frac{s_1^2}{n_1} + \frac{s_0^2}{n_0}$$

This **overestimates** the true variance because it pretends $S_\tau^2 = 0$ (drops the $-S_\tau^2/N$ term). Since the dropped term was always negative (or zero), what remains is always bigger than (or equal to) the truth.

**In one sentence:** We are deliberately overestimating how noisy our estimate is. This makes our confidence intervals wider than they technically need to be, but they are never too narrow. They always cover at the advertised rate (or better).

### When is the conservative estimator exact? (When does equality hold?)

When $S_\tau^2 = 0$, meaning the treatment effect is **constant** -- the same for everyone:

$$Y_i(1) = Y_i(0) + \tau \quad \text{for all } i$$

Then $\tau_i = \tau$ for everyone, so there is zero variation in treatment effects, and $S_\tau^2 = 0$. The $-S_\tau^2/N$ term vanishes and the conservative estimator equals the exact variance.

**Also note from the identity:** $S_\tau^2 = S_1^2 + S_0^2 - 2S_{10}$. If effects are constant, $Y_i(1) = Y_i(0) + \tau$, which means $Y_i(1)$ and $Y_i(0)$ are perfectly linearly related, so $S_{10} = S_0^2 = S_1^2$ (well, $S_{10} = S_0 \cdot S_1 \cdot 1$ since correlation is 1). In that case $S_\tau^2 = 0$.

### The 95% Confidence Interval -- WHY It Covers 95%

This is the part you need to really understand. The CI formula is:

$$\hat{\tau} \pm 1.96\sqrt{\widehat{\text{Var}}(\hat{\tau})}$$

**But WHY does this cover the true $\tau$ at least 95% of the time?** There are three pieces to the argument, and each one does a specific job:

---

**PIECE 1: The Finite-Population CLT -- this is what CENTERS the distribution**

The Central Limit Theorem for finite populations says that under complete randomization, as the sample size grows:

$$\frac{\hat{\tau} - \tau}{\sqrt{\text{Var}(\hat{\tau})}} \xrightarrow{d} N(0,1)$$

**What this says in plain English:** The distribution of $\hat{\tau}$ across all possible randomizations is approximately a bell curve (normal distribution) centered at $\tau$.

**Why is it centered at $\tau$?** Because $\hat{\tau}$ is unbiased: $\mathbb{E}[\hat{\tau}] = \tau$. The CLT is what tells you the **shape** is a bell curve. Unbiasedness is what tells you the **center** of that bell curve is the true treatment effect.

**Where does the randomness come from?** NOT from assuming outcomes are normally distributed. NOT from any model. The randomness comes purely from the **physical act of randomization** -- which $n_1$ people out of $N$ happen to get assigned to treatment. Different randomizations give different estimates, and the distribution of those estimates across all $\binom{N}{n_1}$ randomizations is approximately normal.

**Analogy:** Imagine you have a jar of 100 marbles with numbers on them. You randomly grab 50. The average of your 50 will vary depending on which ones you happened to grab. If you did this many times, the histogram of averages would be bell-shaped. That is the CLT at work -- and it has nothing to do with the numbers on the marbles being "normal."

---

**PIECE 2: The standard error quantifies the WIDTH of that bell curve**

The standard deviation of $\hat{\tau}$ (its standard error) tells you how wide the bell curve is. A narrow bell curve means $\hat{\tau}$ doesn't bounce around much; a wide one means it bounces a lot.

The true SE is $\sqrt{\text{Var}(\hat{\tau})} = \sqrt{S_1^2/n_1 + S_0^2/n_0 - S_\tau^2/N}$.

We estimate it with $\sqrt{s_1^2/n_1 + s_0^2/n_0}$, which is **too big** (because we dropped the $-S_\tau^2/N$ term). So we think the bell curve is wider than it actually is.

---

**PIECE 3: Putting it together -- why the CI covers AT LEAST 95%**

For a standard normal distribution, 95% of the probability mass is within $\pm 1.96$ standard deviations of the center.

So the interval $\hat{\tau} \pm 1.96 \times \text{true SE}$ would contain $\tau$ in approximately 95% of all randomizations. (This is the "exact 95%" part, from the CLT.)

But we use $\hat{\tau} \pm 1.96 \times \text{estimated SE}$, and our estimated SE is **too big**. That means our interval is **wider** than the "exact 95%" interval. A wider interval catches the true value **more often** than 95%. So:

$$\Pr(\tau \in \text{CI}) \ge 95\%$$

The coverage is **at least** 95%. It might be 96% or 97% in practice, but it is never below 95%. This is what "conservative" means -- we err on the side of caution, and the coverage guarantee always holds.

**Summary of the logic chain:**

1. Randomization + unbiasedness centers $\hat{\tau}$ around $\tau$
2. The finite-population CLT says the distribution is approximately bell-shaped (normal)
3. For a normal distribution, $\pm 1.96$ SDs covers 95%
4. We overestimate the SD (because $S_\tau^2 \ge 0$ always), so we get $\ge$ 95% coverage
5. This works for ANY population, ANY treatment effect distribution -- because $S_\tau^2 \ge 0$ is a mathematical fact, not an assumption

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

If you match each treated person $i$ to a control person $j(i)$ with similar covariates, the bias of the matched estimator is:

$$\text{Bias} = \frac{1}{n_M}\sum_{i=1}^{n_M}\big(g(X_i) - g(X_{j(i)})\big)$$

**The intuition:** Each pair contributes $g(X_i) - g(X_{j(i)})$ to the bias. If the matched pair has similar covariates ($X_i \approx X_{j(i)}$), and the outcome function $g$ is smooth (doesn't jump around wildly), then $g(X_i) \approx g(X_{j(i)})$ and the bias from that pair is tiny. Sum up a bunch of tiny biases and the total bias is small.

**Example:** Suppose $g(X) = X^2$ and you match a treated person with income $X_i = 50K$ to a control person with $X_{j(i)} = 48K$. The bias contribution is $50^2 - 48^2 = 2500 - 2304 = 196$. If instead you matched them to someone with $X_{j(i)} = 30K$, the bias would be $50^2 - 30^2 = 2500 - 900 = 1600$. Close matches matter.

### The Chebyshev-type bias bound

This formalizes "better matching = less bias":

$$|\text{Bias}| \le L\big(|\Delta_X^M| + 2s_D\big)$$

where:
- $L$ = the **Lipschitz constant** of $g$. This is the maximum steepness of the outcome function. If $g$ changes by at most $L$ units when $X$ changes by 1 unit, then $L$ is the Lipschitz constant. Steeper functions (larger $L$) = more bias potential.
- $\Delta_X^M$ = the **average covariate difference** in matched pairs. If the average matched pair has a covariate gap of 0.1, this term is small.
- $s_D$ = the **standard deviation** of pairwise covariate differences. Even if the average gap is small, if some pairs are well-matched and others are badly matched, $s_D$ will be large and the bound gets worse.

**What this bound tells you practically:** You control the bias by making all three terms small. You cannot control $L$ (that is a property of nature -- how curvy the outcome function is). But you CAN control $\Delta_X^M$ and $s_D$ by matching better.

## 7.6 Exact Balance vs. Near-Fine Balance

These are different standards for what matching achieves:

**Exact balance:** The distribution of a covariate is **identical** in the treated and matched control groups. For example, if 40% of treated people are female, exactly 40% of matched controls are female. This is the gold standard but hard to achieve for many covariates simultaneously.

**Near-fine balance:** The distributions are **approximately** equal. The SMD is small (say < 0.1) but not exactly zero. In practice, this is what you usually get and it is good enough, because the bias bound depends on how close matches are, and near-fine balance means the matches are close.

**Why the distinction matters:** Some covariates (like gender or race) can be exactly balanced because they are categorical with few levels. Continuous covariates (like age or income) will almost never be exactly balanced -- you settle for near-fine balance.

## 7.7 Mahalanobis Distance and the Curse of Dimensionality

**Mahalanobis distance** accounts for the fact that covariates may have different scales and be correlated:

$$d_M(X_i, X_j) = \sqrt{(X_i - X_j)^\top \hat{\Sigma}^{-1} (X_i - X_j)}$$

where $\hat{\Sigma}$ is the sample covariance matrix of the covariates.

**Why not just use Euclidean distance?** If age is in years (range 20-80) and income is in dollars (range 20K-200K), Euclidean distance would be dominated by income because its scale is much larger. Mahalanobis distance normalizes by the covariance matrix, putting all covariates on equal footing.

**The curse of dimensionality:** As the number of covariates grows, Mahalanobis distance matching gets worse. In high dimensions, all points are roughly equally far apart, so "nearest neighbor" matches are not actually close. This is why the propensity score (which collapses everything to one dimension) becomes essential in high-dimensional settings.

**A common hybrid approach:** Use Mahalanobis distance matching on a few key covariates, with a **propensity score caliper** -- only allow matches where the propensity scores are within some threshold (e.g., 0.2 standard deviations). This combines the strengths of both approaches.

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

**When it fails:** If there are regions of covariate space where you only see treated people or only see control people, you cannot estimate the treatment effect there.

**Concrete example of overlap failure:** Suppose you are studying the effect of a prestigious MBA program on salary. Everyone with GPA > 3.8 gets accepted (treated), and nobody with GPA < 3.0 even applies. In the 3.0-3.8 range, some people apply and some don't. You can estimate the treatment effect in the 3.0-3.8 range (where you see both treated and untreated), but you CANNOT estimate it for GPA > 3.8 (no controls to compare to) or GPA < 3.0 (no treated people). Any estimate for those regions is pure extrapolation.

**What to do about it:** Trim the sample to the region of overlap. Drop units with propensity scores below 0.1 or above 0.9 (or whatever threshold makes the overlap plot look reasonable). This changes the estimand -- you are now estimating the treatment effect for the **overlapping subpopulation**, not the entire population. That is a weaker but more honest claim.

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

**How to interpret propensity score model coefficients:** If you fit a logistic regression $\text{logit}(e(X)) = \alpha + \beta_1 \cdot \text{age} + \beta_2 \cdot \text{male} + \ldots$, the coefficients tell you what **predicts treatment selection**, not what affects the outcome. A large positive $\beta_1$ means older people are more likely to be treated. This has nothing to do with whether age affects the outcome -- it only describes the treatment selection process.

**Common mistake:** Including too many covariates can actually hurt. If you include a covariate that perfectly predicts treatment (e.g., a covariate that is 1 for all treated and 0 for all control), the estimated propensity scores will be 0 or 1, violating overlap. Include confounders (things that affect BOTH treatment and outcome), but be careful about including "instruments" (things that affect treatment but not outcomes) -- they increase variance without reducing bias.

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

**Analogy:** It is like a referee reviewing a play in football. They decide the rules and review process before the play happens. If they waited until after seeing the play to decide what counts as a foul, every call would be suspect. Same logic here: decide your comparison method, check that the groups are balanced, and THEN look at what happened.

**What counts as the design phase:** Estimating propensity scores, running matching, checking SMDs, making Love plots, checking overlap -- all of this uses ONLY the covariates $X$ and the treatment indicator $Z$. The outcome $Y$ is not touched.

**What counts as the analysis phase:** Computing $\hat{\tau}$ (whether via matched difference-in-means, IPW, AIPW, etc.), building confidence intervals, running hypothesis tests. This is where $Y$ enters.

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

### The intuition -- a concrete example

Imagine you are studying the effect of a job training program on wages. You have two types of people: college-educated and non-college-educated.

- Among college-educated people: 80% enroll in training ($e(X) = 0.8$)
- Among non-college-educated people: 20% enroll in training ($e(X) = 0.2$)

If you just look at the treated group, it is 80% college-educated and 20% non-college. That does NOT look like the overall population (which might be 50/50). The treated group is skewed toward college-educated people.

**IPW fixes this by reweighting:**
- A treated college person gets weight $1/0.8 = 1.25$ (they are "over-represented" among the treated, so downweight slightly)
- A treated non-college person gets weight $1/0.2 = 5$ (they are "rare" among treated, so upweight a lot -- this one person represents 5 similar people who mostly did NOT get treated)
- A control non-college person gets weight $1/(1-0.2) = 1.25$
- A control college person gets weight $1/(1-0.8) = 5$

After reweighting, both groups look like the overall population. The weighted treated group is 50/50 college/non-college. The weighted control group is also 50/50. Now the comparison is apples-to-apples.

**General principle:** A treated person with $e(X) = 0.2$ (only 20% of people like them get treated) gets weight $1/0.2 = 5$. They "stand in for" all the similar people who didn't get treated. A treated person with $e(X) = 0.9$ only gets weight $1/0.9 \approx 1.1$ because most people like them get treated anyway -- they don't need to represent many missing people.

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

**Piece 1:** Start with the regression-based estimate: $\hat{\mu}_1(X_i) - \hat{\mu}_0(X_i)$. This is the predicted treatment effect for person $i$ based on their covariates. "If I trust my outcome regression completely, this is my best guess."

**Piece 2:** Add a correction term that uses IPW to fix any errors in the regression. The term $Y_i - \hat{\mu}_1(X_i)$ is the **residual** -- how far the actual outcome is from what the regression predicted. The IPW weights make sure these residuals are properly averaged across covariate groups.

**The beautiful self-correcting mechanism:**
- If the regression is perfect ($Y_i \approx \hat{\mu}_1(X_i)$ for treated), the residuals are near zero, the IPW correction vanishes, and AIPW just returns the regression estimate. The propensity score doesn't even matter.
- If the regression is terrible but the propensity score is correct, the residuals are large but the IPW weights properly re-average them to get the right answer. The regression's predictions wash out.
- If both are pretty good (but not perfect), you get a better answer than either method alone, because the regression handles the "smooth" part and IPW handles the "reweighting" part.

### The "doubly robust" property

AIPW is consistent (gives the right answer in large samples) if **either:**

1. The outcome model is correctly specified ($\hat{\mu}_1, \hat{\mu}_0$ are correct), **OR**
2. The propensity score model is correctly specified ($\hat{e}$ is correct)

You only need **one** of the two models to be right, not both. This is why it is called "doubly robust" -- you get two shots at getting it right.

**Why "doubly robust" and not just "more robust":** The mathematical structure guarantees that when one model is correct, the errors from the other model get multiplied by something that converges to zero. It is not just "kind of robust" -- it is a formal guarantee.

**Concrete scenario:** Suppose you are estimating the effect of a new teaching method on test scores. You model the outcome as a linear function of GPA ($\hat{\mu}$), and you model the propensity to adopt the new method as a logistic function of GPA ($\hat{e}$). Even if the true outcome-GPA relationship is nonlinear (so your outcome regression is wrong), as long as the propensity model is right, AIPW still nails it. OR, even if the propensity model is wrong (maybe the adoption decision also depends on teacher enthusiasm, which you missed), as long as the outcome regression correctly predicts scores from GPA, AIPW still nails it. You only fail if BOTH models are wrong.

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

**Relationship between variances (KEY identity):** $S_\tau^2 = S_1^2 + S_0^2 - 2S_{10}$, where $S_{10}$ is the covariance between $Y_i(1)$ and $Y_i(0)$ -- **unidentifiable** because you never see both for the same person

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

---

## Q19: Why is $S_{10}$ (the covariance between potential outcomes) unidentifiable? What does this imply?

**Answer:** $S_{10} = \frac{1}{N-1}\sum_{i=1}^{N}(Y_i(1) - \bar{Y}(1))(Y_i(0) - \bar{Y}(0))$ requires knowing both $Y_i(1)$ and $Y_i(0)$ for the same person. But the fundamental problem of causal inference means we only ever see one. Among treated people we observe $Y_i(1)$ but not $Y_i(0)$; among control people we observe $Y_i(0)$ but not $Y_i(1)$. So we can never pair up both outcomes for the same person.

**Implication:** Since $S_\tau^2 = S_1^2 + S_0^2 - 2S_{10}$, and $S_{10}$ is unidentifiable, $S_\tau^2$ is also unidentifiable. This is why Neyman's exact variance $\text{Var}(\hat{\tau}) = S_1^2/n_1 + S_0^2/n_0 - S_\tau^2/N$ cannot be computed. We must use the conservative estimator that drops $S_\tau^2/N$.

**Special case:** Under constant treatment effects ($\tau_i = \tau$ for all $i$), we have $S_\tau^2 = 0$, which means $S_{10} = (S_1^2 + S_0^2)/2$. In this case (and only this case), the conservative estimator is exact.

---

## Q20: FWL and extrapolation -- when and why regression breaks down in observational studies

**Answer:** The FWL theorem shows that the regression estimate $\hat{\tau}$ uses weights $w_i = \tilde{Z}_i / \sum \tilde{Z}_j^2$ where $\tilde{Z}_i$ is the residual from regressing $Z$ on $X$.

**Extrapolation problem:** If treated and control groups occupy different regions of covariate space (e.g., all treated people are high-income, all control are low-income), the residuals $\tilde{Z}_i$ tend to be large and the regression is implicitly extrapolating the linear fit into regions with no data. Even if the model perfectly balances $X$, it does not balance $g(X)$ for nonlinear $g$, and with poor overlap the residual imbalance in $g(X)$ gets amplified.

**Key insight from the practice problems:** When you run a regression, always check whether the covariate distributions overlap. If they don't, your regression coefficient is unreliable regardless of its p-value or standard error. The number comes from extrapolation, not from comparing similar people.

---

## Q21: Compare the Wilcoxon rank sum test to the difference-in-means test in a randomization framework

**Answer:** Both can be used as test statistics in Fisher's randomization test. The procedure is the same (enumerate all randomizations, compute the statistic, find the p-value). They differ in what kind of departures from $H_0$ they are best at detecting:

- **Difference in means:** Powerful against constant additive effects (the treatment shifts everyone's outcome by the same amount). Sensitive to outliers because it uses the raw outcome values.
- **Wilcoxon rank sum:** Uses ranks instead of raw values. More robust to outliers and skewed data. Better at detecting effects when the treatment affects the middle of the distribution more than the tails (or vice versa).

**When to use which:** If outcomes are well-behaved (roughly symmetric, no crazy outliers), difference-in-means is fine. If outcomes are skewed (e.g., income data with a few billionaires), Wilcoxon is safer because one extreme value can't dominate the test statistic.

Both tests have exact p-values from the randomization distribution -- no normal approximation needed.

---

## Q22: What does "design without outcomes" mean in practice?

**Answer:** In an observational study, the design phase constructs comparable groups using only covariates $X$ and treatment $Z$ -- the outcome $Y$ is not used at all. This means:

1. Estimate propensity scores using $X$ and $Z$ only
2. Match or weight using propensity scores
3. Check covariate balance (SMDs, Love plots, overlap) using $X$ only
4. If balance is bad, revise the propensity model and repeat steps 1-3
5. ONLY after achieving good balance, unblind the outcomes and estimate $\hat{\tau}$

**Why this matters:** It prevents "fishing" -- the temptation to try many different propensity score specifications and pick the one that gives the treatment effect you want. By committing to the design before seeing outcomes, the analysis is more credible. This is the observational study analog of pre-registering a clinical trial.

**What you CAN'T do in the design phase:** Look at $Y$, compute $\hat{\tau}$, or check whether the treatment effect is "significant."

**What you CAN do in the design phase:** Everything involving $X$ and $Z$ -- compute propensity scores, match, check SMDs, make Love plots, check overlap, trim the sample.

---

## Q23: IPW achieves covariate balance -- explain the proof and what it means

**Answer:** The IPW weighted mean of any covariate $X$ in the treated group is:

$$\frac{\sum_{i=1}^{N} \frac{Z_i X_i}{\hat{e}(X_i)}}{\sum_{i=1}^{N} \frac{Z_i}{\hat{e}(X_i)}}$$

Under correct propensity score specification, this converges to $\mathbb{E}[X]$ (the population mean). The same holds for the control group. So the weighted covariate means are equal.

**Proof intuition:** Take any subgroup defined by $X = x$. Among people with covariates $x$, a fraction $e(x)$ are treated. Each treated person gets weight $1/e(x)$. So the total weight of treated people with covariates $x$ is $n_x \cdot e(x) \cdot (1/e(x)) = n_x$ -- the full count of people with those covariates. The weighting "undoes" the selection, making the weighted treated group look like the whole population.

**This is a theorem, not a hope.** If the propensity score model is correct, IPW MUST balance all covariates (and all functions of covariates). This is why checking balance after IPW is both a diagnostic and a test of the propensity score model. If balance is bad, the propensity model is wrong.

---

## Q24: When does IPW become unstable, and what are the practical fixes?

**Answer:** IPW becomes unstable when propensity scores are close to 0 or 1:

**Numerical example:** Suppose $\hat{e}(X_i) = 0.01$ for one treated person. Their weight is $1/0.01 = 100$. If there are 200 treated people total with average weight around 2, this one person has a weight 50 times larger than average. Their single outcome dominates the entire weighted mean. If their outcome happens to be unusual, the entire ATE estimate is dragged by this one person.

**Practical fixes:**
1. **Trimming:** Drop units with $\hat{e}(X) < c$ or $\hat{e}(X) > 1-c$ (e.g., $c = 0.1$). Changes the estimand to the treatment effect on the overlap subpopulation.
2. **Hajek/stabilized weights:** Normalize weights to sum to 1. The Hajek estimator $\hat{\tau}_{\text{Hajek}}$ is a ratio estimator -- slightly biased but MUCH lower variance.
3. **AIPW:** The outcome model "fills in" for extreme-weight regions, reducing dependence on those weights.

**Connection to overlap assumption:** Extreme propensity scores are a symptom of overlap violation. If $e(X) \approx 0$ for some covariate pattern, it means almost nobody with those covariates gets treated. There are essentially no good comparisons to make, and any method (not just IPW) will struggle.

---

## Q25: Work through a complete observational study analysis pipeline

**Answer:** Here is the full sequence, with what you do at each step:

**Step 1 -- Define the question:** What is the treatment? What is the outcome? What is the target population? (E.g., treatment = job training program, outcome = earnings 2 years later, population = unemployed workers in Wisconsin.)

**Step 2 -- List confounders:** Using subject-matter knowledge, list everything that could affect BOTH whether someone gets treated AND their outcome. (Age, education, prior earnings, industry, motivation.) These go into $X$.

**Step 3 -- Estimate propensity scores:** Fit logistic regression $\text{logit}(\hat{e}(X)) = \alpha + \beta^\top X$. Maybe include interactions and nonlinear terms.

**Step 4 -- Check overlap:** Plot histograms of $\hat{e}(X)$ for treated vs. control. If they don't overlap, trim the non-overlapping regions.

**Step 5 -- Match or weight:** Choose your method (matching, IPW, subclassification).

**Step 6 -- Check balance:** Compute SMDs for all covariates. Make a Love plot. All SMDs should be < 0.1. If not, go back to Step 3 and revise the propensity model.

**Step 7 -- (Now look at outcomes):** Estimate $\hat{\tau}$ using your chosen estimator. Build a 95% CI.

**Step 8 -- Sensitivity analysis:** How robust is the result to an unmeasured confounder?

**Key principle:** Steps 3-6 happen WITHOUT ever looking at $Y$. This is the design phase. Step 7 is the analysis phase. The boundary between steps 6 and 7 is sacred.
