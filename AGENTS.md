---
description: "Use when: studying, extracting, indexing, auditing, or writing mathematics in this repository."
---

# Math Study Lab Agent Contract

This repository is an extraction-ready mathematical study lab. Existing LaTeX documents remain the authoritative content sources. New metadata, indexes, and cards are overlays for retrieval, auditability, and disciplined AI assistance.

## Required Read Order

Before answering substantive mathematical questions from this repo, read in this order:

1. `active_focus.md`
2. `lab_manifest.yaml`
3. `rigor_policy.md`
4. `notation_registry.yaml`
5. The smallest relevant source set from `source_index.yaml`
6. Any relevant gap, proof, or study files created later

## Non-Negotiable Rules

- Never present an unproved or source-unverified claim as established.
- Always cite exact repository paths and local section or environment names when using repo material.
- Distinguish source theorem, derived claim, conjecture, heuristic explanation, proof sketch, and checked proof.
- Never compress a proof past validity. If a nontrivial implication is omitted, label it as a gap or cite the exact place where it is proved.
- Maintain notation from `notation_registry.yaml`. If notation differs by collection, preserve the local meaning and expose the conflict explicitly.
- Prefer canonical sources listed in `source_index.yaml` over ad hoc summaries or compiled PDFs.
- Prefer `.tex` source files over generated `.pdf` outputs when both are present.
- Do not move, rename, or rewrite existing source trees as part of extraction scaffolding.

## Claim Classes

Use these labels consistently in future indexes, cards, and proof notes:

- `source-theorem`: statement taken from a cited source with exact provenance
- `source-definition`: definition taken from a cited source with exact provenance
- `derived-claim`: consequence proved or reconstructed within the repo
- `conjecture`: plausible but unestablished statement
- `heuristic`: intuition or motivation, never treated as proof
- `counterexample`: object or construction disproving a claim or exposing a missing hypothesis

## Provenance Standard

Every extracted or discussed mathematical object should eventually support these fields:

- Stable `id`
- `collection`
- `path`
- `language`
- `topic_tags`
- `source_authority`
- `proof_status`
- `extraction_status`
- `normalization_status`

When a claim is drawn from multiple sources, identify the primary source and any supporting sources separately.

## Notation Control

- Treat notation as scoped, not global, unless `notation_registry.yaml` marks it as house notation.
- If the same macro has different meanings across collections, do not normalize silently.
- Record new notation before reusing it in extracted cards or indexes.

## Extraction Discipline

- Existing collections are first-class corpora: `Books`, `LMFI`, `Undergrad`, and `First Proof`.
- The first implementation phase is schema-first and extraction-ready, not content-migration-heavy.
- Reserve theorem-level IDs and dependency fields early, even when full extraction is deferred.
- If a source is not theorem-granular yet, index it at collection, work, or section level rather than inventing precision.

## Output Discipline

When responding about mathematics from this repository:

- State what is source-backed, what is reconstructed, and what remains unresolved.
- Surface missing hypotheses, notation conflicts, and proof gaps.
- Avoid phrases like "clearly", "obviously", or "it is easy to see" unless the omitted argument is linked elsewhere in the repo.
- Prefer explicit dependency ladders over loose summaries.