# Style Guide

This document records the standardization rules and best practices that should govern future extraction, indexing, and mathematical synthesis in this repository.

## Diagnosis

The repository now has a workable scaffolding layer for large-scale extraction, but the main remaining risks are not raw scale. They are inconsistency risks.

The most important consistency risks are:

- different collections use different naming habits
- multilingual variants can drift semantically if linked loosely
- theorem-like environments vary across sources
- macros are abundant and collection-scoped
- future automation could accidentally write low-trust records too early

This style guide exists to reduce those risks before thousands of theorem and concept nodes are created.

## Core Standardization Principles

1. Preserve source meaning before optimizing for uniformity.
2. Standardize metadata aggressively, but normalize mathematical content conservatively.
3. Treat notation as scoped unless explicitly promoted to house notation.
4. Prefer deterministic machine output for candidate records, then require review before publication.
5. Keep source, review, and formalization layers distinct.

## File And Directory Standards

### Existing Source Trees

- Existing source directories keep their current names.
- Existing `.tex`, `.pdf`, and `.m` materials remain authoritative artifacts inside their own collections.
- Do not rename source files for cosmetic consistency.

### New Scaffold And Derived Files

- New metadata registries use `.yaml`.
- New workflow and policy documents use `.md`.
- New extraction templates use `.md` or `.tex` depending on whether the target artifact is procedural or mathematical.
- Machine-generated reports should default to `.json` inside `.tmp/` unless explicitly meant to be committed.

### Naming Style

- Use lowercase ASCII kebab-case for new markdown and yaml filenames where practical.
- Use lowercase ASCII snake_case for Python scripts.
- Use stable dot-separated lowercase ASCII IDs for indexed objects.

## Metadata Standards

### Collection IDs

Use these canonical collection IDs:

- `books`
- `lmfi`
- `undergrad`
- `first-proof`

### Language Codes

- Use short language codes like `en`, `es`, and `fr`.
- Use `multi` only when an object genuinely spans multiple coordinated language variants.

### Status Values

- Only use statuses already declared in `lab_manifest.yaml` and `rigor_policy.md`.
- Do not invent one-off proof or extraction statuses inside cards or scripts.

### Provenance Fields

Every published node should eventually support:

- exact source path
- local source locator
- collection
- language
- proof status
- extraction status
- normalization status

## ID Standards

### Published IDs

- Published IDs must be stable once a node enters an index.
- Published IDs should encode collection before local scope.
- Published IDs must be ASCII-safe and lowercase.

### Candidate IDs

- Candidate IDs generated from scans are provisional.
- Candidate IDs must be deterministic for a given repository state.
- Candidate IDs should never be treated as published theorem IDs until reviewed.

## Theorem And Concept Best Practices

### Concepts First

- Prefer extracting foundational definitions before higher theorems that depend on them.
- Reuse concept nodes whenever a theorem uses already-indexed notions.

### Conservative Theorem Publication

- A theorem should not enter the published index merely because a scanner found a theorem-like environment.
- The theorem candidate review template should be used before promotion.
- Dependencies can start incomplete, but provenance and statement quality must not be vague.

### Proof Discipline

- Separate source-backed proof existence from locally checked proof quality.
- If a proof is not checked, say so.
- If a step is missing, log a gap instead of compressing the proof.

## Notation Best Practices

- Never assume a macro keeps the same meaning across collections.
- Prefer source-local notation in early extraction stages.
- Only promote notation to house scope when the meaning is stable across many uses.
- Record conflicts before attempting normalization.

## Script Best Practices

- Phase 1 scripts should be non-mutating by default.
- Scripts may scan, classify, and emit reports.
- Scripts should not silently rewrite indexes.
- If a later script becomes mutating, it should require an explicit output target and a review step.

## Research Best Practices

- Use the graph to separate established facts from conjectural work.
- Reuse checked nodes and explicit dependency chains when exploring a new question.
- Keep failed attempts and counterexamples visible.
- Treat formal links as strengthening evidence, not as a license to ignore source context.

## Scale Strategy For Thousands Of Theorems

If the repository grows to thousands of theorem records, the winning strategy is:

1. deterministic candidate harvesting
2. review before publication
3. conservative normalization
4. explicit status tracking
5. source-first retrieval

Raw extraction volume is not the bottleneck. Consistent publication standards are.