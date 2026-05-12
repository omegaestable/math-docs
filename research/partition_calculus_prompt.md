Prove: for every countable ordinal β < ω₁ and every finite n ≥ 2, 𝔠 → (β, n)³₂, where 𝔠 is the initial ordinal of cardinality 2^ℵ₀.

You may assume Ramsey's theorem (ω → (ω)ʳₖ) and the Erdős–Rado stepping-up lemma. No other external results without full proof.

## Known results (do not re-derive)

- n = 2 or n = 3, all countable β: trivial (vacuous / single-triple witness).
- β ≤ ω+1, all finite n: from Ramsey + stepping-up at κ = ω → 𝔠 → (ω+1)³₂, then sym-to-asym.

The open case is n ≥ 4 and β > ω+1. Start there.

## Dead ends — do NOT attempt these strategies

1. **"BHT theorem" (ω₁ → (γ)ʳₖ for all finite r).** This does not exist. Baumgartner–Hajnal is for pairs only (r = 2). Do not cite or assume any extension to r ≥ 3.

2. **Stepping-up from ω₁.** BH gives ω₁ → (α)²ₖ; stepping up yields 2^ω₁ → (α+1)³ₖ. But 2^ω₁ ≥ ℵ₂ > 𝔠 in general, so this does not land at 𝔠. Dead end.

3. **Stepping-up from ω beyond (ω+1)³.** Stepping-up with κ = ω needs ω → (ω+1)²₂ as input, which is false (every subset of ω has order type ≤ ω). Cannot reach 𝔠 → (ω+2)³₂ this way.

4. **Countable balanced sources.** λ → (ω+1)³₂ is false for every countable λ. (Counterexample: biject λ → ω and color by pre-image structure.) Cannot build a base case on a countable cardinal for triples.

5. **Strong extension lemma (greedy transfinite induction).** FALSE. The strategy: "Given 0-homogeneous A of type γ, find ξ > sup A extending A to type γ+1" fails. Explicit counterexample: define f on [𝔠]³ so that A = ω is 0-homogeneous, f has no 1-homogeneous 4-set, yet f({0,1,ξ}) = 1 for every ξ ≥ ω. The counterexample does NOT refute the theorem — in the same coloring, {2,3,…} ∪ {ω,ω+1,…} IS 0-homogeneous of type ω·2. What fails is the strategy of extending a fixed, previously chosen set.

6. **Weak extension lemma.** Weakening to "∃ some A, ∃ some ξ" does not drive transfinite induction because the provided A has no relationship to the chain already under construction.

7. **Pattern extraction + Ramsey on the blocking set.** After pigeonhole gives a fixed blocking pair (u,v) with f({u,v,ξ}) = 1 for 𝔠-many ξ, Ramsey refines patterns. The (1,1) pattern contradicts n = 4, but for n ≥ 5 you need n−2 points from a countable set in a 1-clique, and Ramsey on a countable set only gives order type ω. The argument stops here.

## Constraints

- Write every implication. No "clearly," "routine," "standard argument," or hand-waving.
- If a step fails, stop, diagnose, and restart from the failure. Do not patch.
- Do not search the web. Work from definitions and axioms only.
- State your full proof strategy as a lemma list before writing any proof.
- After the proof, verify it end-to-end with β = ω·ω and n = 5.
- If your strategy resembles any dead end listed above, STOP and explain why yours is different before proceeding.
