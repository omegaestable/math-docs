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