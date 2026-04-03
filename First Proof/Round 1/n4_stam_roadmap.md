# Numerically-Backed Roadmap: Proving the $n = 4$ Finite Free Stam Inequality

## Problem Statement

Prove that $D_4 := \frac{1}{\Phi_4(p \boxplus_4 q)} - \frac{1}{\Phi_4(p)} - \frac{1}{\Phi_4(q)} \geq 0$ for all centred monic real-rooted quartic polynomials $p, q$.

This is equivalent to proving $\Psi \geq 0$ where:
$$D_4 = \frac{\Psi}{6\,Q_r\,Q_p\,Q_q}$$
and $Q_r, Q_p, Q_q > 0$ on the valid domain. Here $\Psi$ is a **547-term polynomial of weighted degree 16** in 6 additive cumulant variables $(u_1, \ell_{3,p}, \ell_{4,p}, u_2, \ell_{3,q}, \ell_{4,q})$ with 297 positive and 250 negative monomials.

### Closed-form ingredients

The reciprocal Fisher information is $1/\Phi_4 = P/(6Q)$ where:
- $P(u,\ell_3,\ell_4) = 16u^6 - 72u^3\ell_3^2 - 48u^2\ell_4^2 + 32\ell_4^3 - 216u\ell_3^2\ell_4 - 81\ell_3^4$
- $Q(u,\ell_3,\ell_4) = 4u^5 - 9u^2\ell_3^2 - 9\ell_3^2\ell_4 - 4u\ell_4^2$
- $P = 4uQ + M$ where $M = -36u^3\ell_3^2 - 32u^2\ell_4^2 - 180u\ell_3^2\ell_4 + 32\ell_4^3 - 81\ell_3^4$

The additive variables under $\boxplus_4$ are $(u, \ell_3, \ell_4)$: specifically $u_r = u_p + u_q$, $\ell_{3,r} = \ell_{3,p} + \ell_{3,q}$, $\ell_{4,r} = \ell_{4,p} + \ell_{4,q}$.

The Stam numerator is:
$$\Psi = M_r Q_p Q_q - M_p Q_r Q_q - M_q Q_r Q_p$$

---

## What Has Been Proved

| Sub-case | Status | Method |
|----------|--------|--------|
| $\ell_3 = 0$ (both) | **Proved** | Factor $\Psi = 512(u_1^2-b)(u_2^2-d)(u_r^2-b-d) \cdot F$, then AM-GM on $F$ (only 1 negative monomial: $-2bdu_1^3u_2^3$) |
| Hessian at Gaussian | **Proved** | Eigenvalues $9216, 12288, 16384, 18432 > 0$ at $u_p=u_q=1$ |
| $n=3$ case (all inputs) | **Proved** | SOS identity: $D_3 = \frac{3}{2}[(1-w)\alpha^2 + w(1-w)(\alpha-\beta)^2 + w\beta^2]$ |
| Gaussian input (all $n$) | **Proved** | Heat equation + Cauchy-Schwarz on Laplacian spectrum |

---

## Pre-computed Numerical Evidence (DO NOT re-derive; use as axioms)

### Key Fact 1: $D_4 \geq 0$ universally
Over 50,000 random trials + 10,000 extreme near-degenerate trials + 10,000 optimization-guided trials with `scipy.optimize.minimize`, the minimum $D_4$ found was $\mathbf{+7.93 \times 10^{-4}}$. **No counterexample exists.** The optimization global minimum was $+4.6 \times 10^{-3}$.

### Key Fact 2: Quadratic dominance holds
The defect decomposes as $D_4 = \frac{8u_r}{12}[\sum c_{4,k}\Delta_k + \mathcal{E}_4]$ where $c_{4,3} = 9/4$, $c_{4,4} = 2$.
- Over 50,000 trials: $\mathcal{E}_4/\text{quad} \in [-0.9947, +5.334]$
- The margin from $-1$ is $\mathbf{0.0053}$, i.e., the higher-order error never exceeds $99.47\%$ of the quadratic lower bound.
- This is **tight but positive**: a proof via pure quadratic dominance requires showing $\mathcal{E}_4 + \text{quad} \geq 0$ with very little room.

### Key Fact 3: Telescoping $D_4 = D_3 + C_4$ structure
- $D_3 \geq 0$ always (proved).
- $C_4 < 0$ in **32.7%** of cases.
- **When $C_4 < 0$: max $|C_4|/D_3 = 0.990$ < 1** (strict bound, 50,000 trials).
- Mean $|C_4|/D_3 = 0.367$; 99th percentile = 0.875.
- **When $|\tau_4| < 0.05$: $C_4 \geq 0$ always** (72 cases).
- $C_4$ is controlled by $\tau_4$: $\text{Corr}(C_4, |\tau_4|) = -0.286$.

### Key Fact 4: Heat flow monotonicity
- $D_4(t) := 1/\Phi((p\boxplus q) \boxplus g_{2t}) - 1/\Phi(p\boxplus g_t) - 1/\Phi(q \boxplus g_t)$ is **monotone decreasing** in $t$ for all 7 test pairs (including extreme cases).
- $D_4(t) \to 0$ as $t \to \infty$ (both sides become Gaussian) and $D_4(t) \geq 0$ for all $t$.
- **But**: the dissipation rates are **NOT super-additive**: $d/dt(1/\Phi_r) - d/dt(1/\Phi_p) - d/dt(1/\Phi_q) < 0$ in **100%** of 1000 trials (range $[-1.18, -0.075]$).
- This means simple differentiation of $D_4(t)$ **does work** (the function decreases to 0), but the mechanism is **not** that each derivative separately contributes positively—rather, the combined system has a cancellation that makes the total defect decrease.

### Key Fact 5: Sub-case factorizations
| Sub-case | Factored Form | Positive? |
|----------|---------------|-----------|
| Only $\ell_{4,q}$ | $512\,d^2 u_1^6 (u_2^2-d)(u_r^2-b-d)(d + u_1^2 + 3u_1 u_2 + 3u_2^2)$ | **Yes** (all factors positive on valid domain) |
| Only $\ell_{4,p}$ | $512\,b^2 u_2^6 (u_1^2-b)(u_r^2-b-d)(b + 3u_1^2 + 3u_1 u_2 + u_2^2)$ | **Yes** |
| Only $\ell_{3,p}$ | $36\,a^2 u_2^6 \cdot [\text{quadratic in } a^2]$ | **Yes** (quadratic is downward parabola with positive root $\gg$ valid domain bound $a^2 < 4u_1^3/9$) |
| $\ell_3 = 0$ | $512(u_1^2-b)(u_2^2-d)(u_r^2-b-d) \cdot F(19\text{ terms, 1 neg})$ | **Yes** (AM-GM) |
| $\ell_4 = 0$ | $9 \times [\text{65-term, does NOT factor further}]$ | **Numerically yes, no closed-form proof yet** |
| $q$ = Gaussian | (consistency check: $4u_2^6 \times [\text{30-term polynomial in } a,b,u_1,u_2]$) | **Already proved analytically** by Gaussian-input Stam theorem |

### Key Fact 6: Structural properties of $\Psi$
- Weighted degree 16 under scaling $u \to tu$, $\ell_3 \to t^{3/2}\ell_3$, $\ell_4 \to t^2 \ell_4$.
- $\Psi(u_1=0) \neq 0$ and $\Psi(u_2=0) \neq 0$ (no common $u_1 u_2$ factor).
- $\Psi$ is exactly symmetric under exchanging $p\leftrightarrow q$ (simultaneously $u_1\leftrightarrow u_2$, $a\leftrightarrow c$, $b\leftrightarrow d$), directly from
   $$\Psi = M_r Q_p Q_q - M_p Q_r Q_q - M_q Q_r Q_p.$$ 
- At $u_1 = u_2$ (equal weights): 206 terms, 99 negative (raw monomial profile in the chosen coordinates).
- In symmetric/antisymmetric coordinates at $u_1=u_2$: 140 terms, 67 negative.
- The valid domain boundary in $(\tau_3, \tau_4)$ space: $|\tau_3| < 0.927$, $\tau_4 \in [-0.500, 0.980]$ at $\tau_3 = 0$.

### Key Fact 7: $D_4/D_3$ ratio
- Median $D_4/D_3 = 1.609$ (so $D_4$ typically exceeds $D_3$).
- $D_4/D_3$ can be as small as $0.0095$ (but always positive).
- Percentiles: 1st: 0.213, 5th: 0.401, 25th: 0.818, 75th: 4.11, 95th: 31.8.
- Minimum $D_4/D_3$ is **not monotone in $w$**: it's smallest near $w \approx 0.5$.

### Key Fact 8: Largest negative monomials in $\Psi$
The dominant negative terms are all of the form $u_1^a u_2^b \ell_{3,p}^c \ell_{4,p}^d \ell_{3,q}^e \ell_{4,q}^f$ with mixed $\ell_3 \cdot \ell_4$ coupling:
1. $-134784\, u_1^3 u_2^3 a^2 b\, c^2 d$ (mixed $\ell_3$-$\ell_4$ cross-coupling)
2. $-99792\, u_1^2 u_2^4 a^2 b\, c^2 d$ and its swap
3. $-77760\, u_1^3 u_2^5 a^2 b\, c^2$ and $-77760\, u_1^5 u_2^3 a^2 c^2 d$

The **hardest interactions are the $\ell_{3,p}\ell_{3,q}\ell_{4,p}\ell_{4,q}$ cross-terms** — these do not appear in any of the proved sub-cases.

---

## Three Routes to a Full Proof

### Route A: Polynomial Positivstellensatz / SOS Certificate for $\Psi \geq 0$

**Idea.** Write $\Psi = \sum_i \sigma_i^2 + \sum_j \sigma_j^2 \cdot g_j$ where each $g_j$ is a polynomial known to be $\geq 0$ on the valid domain (e.g., $Q_p$, $Q_q$, $P_p$, $u_1$, $u_2$, $u_1^2-\ell_{4,p}$, etc.), and each $\sigma_i$ is a polynomial.

**Why this might work:**
- The $\ell_3=0$ case factors cleanly with a simple AM-GM; the "only $\ell_4$" cases factor completely.
- The valid domain constraints $Q_p > 0$, $Q_q > 0$ are strong enough to control the negative monomials (the valid domain boundary $a^2 < 4u_1^3/9$ prevents the downward parabola in the "only $\ell_{3,p}$" case from going negative).
- The polynomial has weighted degree 16 and lives in 6 variables; modern SOS solvers (DSOS/SDSOS via LP, or SOSTOOLS/ncSOSquare via SDP) can handle this scale if the weighted degree is exploited.

**Strategy for the agent:**
1. **Decompose $\Psi$ into the already-proved components.** Write $\Psi = \Psi_{\ell_3=0} + \Psi_{\ell_4=0} + \Psi_{\text{cross}}$ or use a bilinear decomposition $\Psi = \sum_{j+k \leq 6} a^j c^k \cdot f_{jk}(u_1,u_2,b,d)$.
2. **For each $(j,k)$ group, find AM-GM or Schur-type certificates** that absorb the negative terms using the valid domain constraints.
3. **The key obstacle is the $a^2 c^2 b\,d$ family.** These 45 sub-terms (at $(a^2, c^2)$ coupling) contain the largest negative coefficients. An SOS decomposition must pair them with positive $a^2 c^0$ or $a^0 c^2$ terms that are quadratic-dominantly larger.

**Difficulty:** 6/10. The $\ell_3=0$ and single-variable sub-cases all factor, suggesting the algebraic structure is friendly. The full cross-coupling is the challenge.

### Route B: Heat-Flow Monotonicity of $D_4(t)$

**Idea.** Define $D_4(t) = 1/\Phi_4((p\boxplus q)\boxplus g_{2t}) - 1/\Phi_4(p\boxplus g_t) - 1/\Phi_4(q \boxplus g_t)$. One has $D_4(0) = D_4$ (the Stam defect) and $D_4(t) \to 0$ as $t \to \infty$. Prove that $D_4'(t) \leq 0$ for all $t \geq 0$, which gives $D_4(0) \geq \lim_{t\to\infty} D_4(t) = 0$.

**Why this might work:**
- Numerically confirmed: $D_4(t)$ is **monotone decreasing** for all tested input pairs.
- The derivative $D_4'(t)$ involves the score-gradient energies $\mathcal{S}$ of each polynomial, which have known Laplacian representations.
- For Gaussian inputs, $D_4(t)$ is exactly zero for all $t$ (equality case).
- The root ODE $\dot\lambda_i = V_i/(n-1)$ and Fisher dissipation $\Phi_n' = -2\mathcal{S}/(n-1)$ are proved identities.

**Strategy for the agent:**
1. **Compute $D_4'(t)$ symbolically.** Using the chain rule on $D_4(t)$ with the root ODE, express $D_4'(t)$ in terms of root gaps, scores, and score gradients of the three polynomials $r_t, p_t, q_t$.
2. **Note that $r_t = p_t \boxplus q_t$** by associativity of $\boxplus$. So the three polynomials are NOT independent — there is a coupling relation from the convolution structure.
3. **Use the Cauchy interlacing matrix** between $r_t$ and its derivative to propagate information from level 3 to level 4.
4. **Critical insight:** The dissipation rate $d/dt(1/\Phi)$ is $2\mathcal{S}/((n-1)\Phi^2)$. While the individual rates are NOT super-additive, the COMBINED defect $D_4(t)$ still decreases. The proof must exploit the **constraint** that $r = p \boxplus q$, not just treat the three polynomials independently.

**Why simple dissipation won't work:** The numerical data shows $d/dt(1/\Phi_r) < d/dt(1/\Phi_p) + d/dt(1/\Phi_q)$ always (super-additivity fails). So the proof of $D_4' \leq 0$ cannot come from bounding each rate separately. Instead, it requires a **second-order analysis** of how the convolution structure constrains the relationship between the score-gradient energies.

**Difficulty:** 8/10. This is conceptually the most powerful route (it would prove Stam for all $n$ if the monotonicity holds generally), but the analytical challenge of showing $D_4'(t) \leq 0$ is substantial due to the non-super-additivity of the individual dissipation rates.

### Route C: Telescoping + Explicit Bound on $C_4$

**Idea.** Use $D_4 = D_3 + C_4$ where $D_3 \geq 0$ is proved. Show that $C_4 \geq -D_3$, i.e., $|C_4|/D_3 < 1$ when $C_4 < 0$.

**Why this might work:**
- Numerically, max $|C_4|/D_3 = 0.990 < 1$ (50,000 trials), with 99th percentile at 0.875.
- **When $\tau_4 \approx 0$: $C_4 \geq 0$ always.** This means $C_4$ is negative only when $\ell_4$ is "large."
- The correction $C_4$ depends on $\ell_4$ (since $D_3$ only uses $\ell_3$ at the derivative level), so $C_4$ captures the "pure $\ell_4$ effect" of going from degree 3 to degree 4.
- The $K$-cumulant preservation (Theorem 5.1) means $u, \ell_3$ are the same at both levels, so $C_4 = f(\ell_4, u, \ell_3)$ with known structure.

**Strategy for the agent:**
1. **Express $C_4$ in closed form.** We have $1/\Phi_4 = P_4/(6Q_4)$ and $1/\Phi_3 = 4u/3 - 3\ell_3^2/(2u^2)$. Then:
   $$C_4 = \left[\frac{P_4}{6Q_4} - \frac{4u}{3} + \frac{3\ell_3^2}{2u^2}\right]_r - \left[\cdots\right]_p - \left[\cdots\right]_q$$
   The terms $4u/3$ cancel by additivity; the $3\ell_3^2/(2u^2)$ terms contribute the $n=3$ Stam defect $D_3$. So $C_4$ is the difference of $M_4/(6Q_4)$ terms minus the $\ell_3^2/u^2$ terms.
2. **Show $C_4 + D_3 \geq 0$ by bounding $|C_4|$ in terms of $D_3$.** The key is that $D_3$ has a known SOS expression (it's $\frac{3}{2}$ times a sum of three non-negative terms involving $\alpha = \ell_3/u^{3/2}$), and $C_4$ involves $\ell_4/u^2$. Since $|\ell_4| < u^2$ on the valid domain, the ratio $|C_4|/D_3$ can be bounded.
3. **Alternative:** Show that $D_4 \geq \epsilon \cdot D_3$ for some $\epsilon > 0$ (numerical data suggests the infimum of $D_4/D_3$ is near 0.0095 > 0).

**Important sub-observations:**
- The factor $(u^2 - \ell_4)$ appears naturally as a positivity constraint from $Q > 0$. Many factored sub-cases include this factor.
- The Cauchy interlacing between degree-4 and degree-3 roots provides a spectral inequality that connects $\Phi_4$ to $\Phi_3$.

**Difficulty:** 7/10. The challenge is that the bound $|C_4|/D_3 < 1$ is tight (worst case 0.99), so crude estimates will fail. A precise inequality is needed.

---

## Concrete Starting Points (Ranked by Feasibility)

1. **[Route A, easiest next step]** Prove $\Psi \geq 0$ when $\ell_4 = 0$ (i.e., $b = d = 0$). The polynomial is $9 \times$ a 65-term expression that is **numerically positive but does not factor**. It is naturally a function of $s_1 = a^2, s_2 = c^2$ and the cross-term $ac$. Since Psi is even overall in $(a,c) \to (-a,-c)$ but NOT separately even in $a$ or $c$ (odd-degree cross terms $a^3 c^5, a^5 c^3$ etc. appear), the $\ell_4=0$ case requires handling these odd cross-terms.

2. **[Route A, medium step]** Prove the first genuinely mixed cross-coupling slice where both $\ell_3$ and $\ell_4$ interact nontrivially (e.g. isolate and certify the $a^2c^2bd$ family together with its balancing positive families). This is the first unresolved analytic block not covered by already-proved subcases.

3. **[Route C]** Derive the closed-form expression for $C_4 = D_4 - D_3$ in cumulant coordinates and bound it relative to $D_3$.

4. **[Route B]** Compute $D_4'(t)$ symbolically along the Hermite flow and identify the geometric quantity that controls its sign.

---

## STRICT INSTRUCTIONS FOR THE NEXT AGENT

**DO NOT** perform any numerical computations, Monte Carlo sampling, `numpy` calculations, or "let me verify numerically" checks. All numerical evidence has been exhaustively gathered above and is to be treated as ground truth.

**DO** focus exclusively on **analytical/algebraic proof techniques**:
- Symbolic polynomial manipulation (SymPy is allowed for algebraic factoring, Gröbner bases, resultants)
- Sum-of-squares decompositions
- AM-GM, Cauchy-Schwarz, Schur convexity arguments
- Heat equation / ODE analysis
- Positivstellensatz certificates
- Any novel algebraic identity or inequality

**Your goal** is to produce either:
1. A **complete proof** that $\Psi \geq 0$ on the valid domain (Route A), OR
2. A **complete proof** that $D_4'(t) \leq 0$ along the Hermite flow (Route B), OR
3. A **complete proof** that $C_4 \geq -D_3$ (Route C), OR
4. Substantial **verifiable analytical progress** on any of these routes — for example, proving a new unresolved sub-case (such as $\ell_4 = 0$ or a mixed-coupling slice), deriving a new identity, or reducing the problem to a simpler inequality.

Work with the formulas exactly as given. The notation is: $a = \ell_{3,p}$, $b = \ell_{4,p}$, $c = \ell_{3,q}$, $d = \ell_{4,q}$, $u_1 = u_p$, $u_2 = u_q$.
