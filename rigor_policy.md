# Rigor Policy

This repository is designed for high-trust mathematical study, extraction, and later large-scale normalization. The default posture is conservative: expose uncertainty, preserve provenance, and separate established material from incomplete reasoning.

## Claim Labels

Use one of these labels whenever claims are indexed or discussed:

- `source-theorem`: exact statement copied or closely paraphrased from a cited source with precise location
- `source-definition`: exact sourced definition with precise location
- `derived-claim`: result reconstructed inside the repo from cited dependencies
- `conjecture`: unproved statement proposed for investigation
- `heuristic`: explanatory intuition or pattern, not a proof object
- `counterexample`: construction showing a statement is false or incomplete

## Proof Status Values

These values are reserved for theorem indexes, proof notes, gap logs, and future extraction pipelines:

| Status | Meaning |
| --- | --- |
| `source-only` | Present in a source, but not yet locally checked or reconstructed |
| `source-cited` | Source and location are recorded precisely |
| `rederived` | Reconstructed locally, but not yet fully audited end to end |
| `checked` | Reviewed line by line against stated dependencies and definitions |
| `gap-present` | One or more nontrivial steps remain unresolved |
| `formalized` | Mechanically checked in a proof assistant or equivalent formal lane |
| `counterexample-found` | Claim is false as stated or missing a necessary hypothesis |

## Extraction Status Values

| Status | Meaning |
| --- | --- |
| `unseen` | Not yet triaged for extraction |
| `queued` | Known target for extraction, not yet indexed |
| `indexed` | Present in a source or collection index |
| `partially-extracted` | Some metadata or structure captured, but not atomized |
| `extracted` | Atomic record created with provenance and tags |
| `audited` | Extracted record reviewed for consistency and provenance |

## Normalization Status Values

| Status | Meaning |
| --- | --- |
| `raw` | Mirrors source notation and naming without harmonization |
| `mapped` | Linked to house taxonomy or notation registry |
| `canonicalized` | Approved house form chosen and recorded |
| `conflict-flagged` | Ambiguity or notation collision identified and left explicit |
| `deprecated` | Superseded by a better normalized record |

## Provenance Requirements

Every serious mathematical answer or extracted object should eventually support:

- Stable `id`
- Exact `path`
- Local section, environment, or heading reference when available
- `collection`
- `language`
- `topic_tags`
- `source_authority`
- `proof_status`
- `extraction_status`
- `normalization_status`

If the repo contains both source `.tex` and compiled `.pdf`, cite the `.tex` file unless the source is unavailable.

## Banned Compression Habits

The following are disallowed unless backed by a local proof or precise citation:

- "clearly"
- "obviously"
- "it is easy to see"
- "by standard arguments"
- hidden use of unstated hypotheses
- proof by notation abuse

## Required Behavior on Uncertainty

- If a step is nontrivial and unresolved, mark it explicitly as a gap.
- If two sources disagree in notation or hypotheses, record the difference instead of silently merging them.
- If a theorem has not been independently checked, do not upgrade it to `checked`.
- If a counterexample is found, preserve the failed statement and annotate the failure rather than deleting the history.

## Extraction-Ready Discipline

- Existing LaTeX documents remain authoritative sources.
- New manifests, cards, and logs are overlays and must not silently rewrite source meaning.
- IDs must be stable, ASCII-safe, and collection-aware.
- Multilingual variants should be linked, not conflated.
- Section-level indexing is acceptable when theorem-level extraction is not yet justified by the source structure.