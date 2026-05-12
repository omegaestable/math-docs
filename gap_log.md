# Gap Log

This file records unresolved mathematical or infrastructure gaps that block safe extraction, normalization, or proof-tracking.

## Status Key

- `open`: unresolved and actively relevant
- `tracked`: identified and bounded, but not yet resolved
- `blocked`: requires external source work or design decision
- `resolved`: closed with a concrete artifact or rule

## Entries

| Gap ID | Scope | Exact Missing Step | Why It Is Nontrivial | Candidate Tools | Status |
| --- | --- | --- | --- | --- | --- |
| GAP-PART-TRIPLES-01 | `corrected_partition_calculus_note.tex`, §§ 7–9 | Successor extension of 0-homogeneous sets past ω+1 for triples | Strong extension lemma is false (Counterexample 7); weak form doesn't drive induction; pattern extraction stops at ω for n≥5 | Todorcevic walks, canonical partition theorems | open |
| GAP-IDIST-CLUSTERS-01 | `proofs/claims/integer_distance_preprint.tex`, Assumption `assumption:unbounded-clusters` | Existence, for every n, of n-point planar integral clusters with no three collinear points and no four concyclic points | Current references record the arbitrary-large version as open; known constructions under both constraints reach size 7, so sharpness of the admissible graph bounds is conditional | Eppstein 2026 Example 4; Kreisel--Kurz 2008; Noll--Bell 1989; targeted literature search | open |
| GAP-IDIST-ELLIPSE-B | `proofs/proof_attempts/integer_distance_gap_note.tex`, Question `corrected Missing Lemma B` | For every n, find a rational-angle unit `u=e^{2i\theta}` and `rho in Q_{>0}\{1}` such that `|rho-u^m| in Q` for all `m=3,...,2n-1` | This is a simultaneous rational-square condition on a fiber product of conics over the common `rho`-line; fixed-angle versions may be higher genus and are stronger than the moving-`u` target | Rational points on conic fiber products; elliptic/higher-genus curve search; computational experiments with variable `u` | open |
| GAP-IDIST-HYPERBOLA-D | `proofs/proof_attempts/integer_distance_gap_note.tex`, Question `Missing Lemma D` | For every n, find distinct rationals `1<t_1<...<t_n` such that `(t_i t_j)^2+1` is a rational square for every pair | Equivalent to arbitrarily large rational Diophantine tuples whose entries are rational squares; no construction is supplied in the note | Literature on rational Diophantine tuples; elliptic curve extension methods; multiplicative clique search in Pythagorean rationals | open |
| GAP-IDIST-PARABOLA-E | `proofs/proof_attempts/integer_distance_gap_note.tex`, Question `standalone parabola problem` | For every n, find distinct positive rationals `x_1,...,x_n` such that `1+(x_i+x_j)^2` is a rational square for every pair | Equivalent to arbitrarily large additive cliques in the rational Pythagorean-leg set; the arithmetic-progression/CRT construction suggested externally is unverified and false as stated for the audited sample formula | Rational points on intersections of quadrics; elliptic curve search; additive clique search in Pythagorean rationals; verify Kemnitz-style literature claims from source | open |
