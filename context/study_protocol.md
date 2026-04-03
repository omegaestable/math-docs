# Study Protocol

This document defines how agents and future extraction tooling should turn source mathematics into a trustworthy wiki-like graph.

## Purpose

The protocol exists to support three goals at once:

- disciplined study from early mathematics upward
- mass extraction into reusable theorem and concept records
- future research workflows that rely on a high-trust internal mathematical graph

The protocol is conservative by design. It should help agents self-serve from the repository without inventing missing structure or overstating correctness.

## Read Order For Agents

Before doing any substantial mathematical task in this repo, an agent should read:

1. `active_focus.md`
2. `lab_manifest.yaml`
3. `rigor_policy.md`
4. `notation_registry.yaml`
5. `source_index.yaml`
6. `context/wiki_graph_schema.md`
7. this file
8. the smallest relevant source set

## Extraction Philosophy

- Start from early-level sources first.
- Prefer exact statements over ambitious summaries.
- Prefer section-level extraction over theorem-level guessing.
- Prefer empty fields over fabricated metadata.
- Prefer explicit gaps over compressed proofs.

This repository should become useful by accumulating many small, reliable records.

## Primary Workflow Modes

### 1. Source Intake

Use when a new book, note set, or paper enters the repository.

Required output targets:

- `source_index.yaml`
- `notation_registry.yaml` if new notation appears
- `gap_log.md` if source quality or structure blocks extraction

Checklist:

1. Identify collection, language, and mathematical level.
2. Record exact source path.
3. Decide whether the source is canonical, supporting, or provisional.
4. Record major scope, topic tags, and prerequisite hints.
5. Record obvious notation conflicts.

### 2. Chapter Or Section Scan

Use when beginning structured extraction from a source.

Required output targets later:

- `theorem_index.yaml`
- `notes/concept_cards/`
- `notes/theorem_cards/`
- `dependency_graph.yaml`

Checklist:

1. Identify sections and subsection boundaries.
2. Detect theorem-like environments and labels.
3. Detect definitions, examples, and exercises.
4. Detect local macros and notation candidates.
5. Record any structural ambiguity in `gap_log.md`.

### 3. Concept Extraction

Use when a source introduces foundational vocabulary.

Priority order:

1. definitions
2. constructions
3. equivalent formulations
4. basic examples and nonexamples

A concept node should only be created when the source location is stable and the notation context is known.

### 4. Theorem Extraction

Use when a theorem or proposition is valuable enough to be reused elsewhere in the graph.

Minimum conditions before a theorem is treated as reusable:

- the statement can be sourced precisely
- dependencies are at least partially identifiable
- notation context is known
- proof status is assigned conservatively

Theorem extraction should start with high-use theorems, not every statement indiscriminately.

### 4a. Theorem Candidate Review

Use when a scanned theorem-like object is important enough to evaluate for promotion into a theorem node.

Primary review template:

- `templates/theorem_candidate_review.md`

Checklist:

1. Confirm exact source path and locator.
2. Confirm the environment really contains a theorem-like statement worth indexing.
3. Assign only conservative statuses.
4. Record notation scope before normalization.
5. Promote the candidate only after the statement, provenance, and dependency sketch are defensible.

### 5. Dependency Review

Use when a theorem, chapter, or topic is going to be reused in study plans or research synthesis.

Checklist:

1. Separate true prerequisites from merely nearby topics.
2. Record only defensible edges.
3. Leave uncertain edges for later review rather than overclaiming.

### 6. Proof Review

Use when moving a theorem from sourced material toward local mathematical reuse.

Checklist:

1. Expand hidden hypotheses.
2. Expand nontrivial steps.
3. Record unresolved steps in `gap_log.md`.
4. Upgrade proof status only after explicit review.

### 7. Research Mode

Use when the repository is mature enough to support conjecture generation, synthesis, or literature-guided exploration.

Research mode must preserve the following separation:

- source-backed facts
- locally derived claims
- heuristics
- conjectures
- failed attempts
- counterexamples

No agent should blur these categories.

## Early-Level First Plan

The first real population passes should usually start with:

1. calculus
2. linear algebra
3. proof-writing basics
4. introductory differential equations
5. foundational logic where it supports later collections

The reason is not that these are intrinsically more important than advanced topics. It is that they provide a stable vocabulary base for the rest of the graph.

## How Agents Can Self-Serve Later

Once the wiki graph is populated, agents should be able to do the following without rereading entire books:

- retrieve theorem nodes with exact provenance
- follow dependency chains backward to foundational definitions
- compare notation across collections before synthesizing an answer
- see whether a theorem is only sourced, locally rederived, checked, or formalized
- identify missing lemmas or unresolved gaps before proposing a proof plan
- generate study plans and review ladders from dependency structure

This is the basis for future self-service mathematical work.

## How This Supports Future Research

If the wiki is populated carefully, research leverage comes from structure rather than from raw summarization.

Agents should be able to:

- identify reusable theorem packages around a topic
- trace prerequisite bottlenecks that block a conjecture or proof idea
- compare the same concept across multiple sources and notation systems
- reuse prior proof skeletons and counterexamples
- separate what is established from what is being proposed

This is the minimum standard for using the repository as a research assistant rather than as a note browser.

## Future Formal Lane

If a Lean or mathlib helper is added later, it should plug into this workflow after theorem nodes are already stable.

Recommended role:

- map informal theorem nodes to formal artifacts
- suggest formal analogues
- identify likely missing hypotheses
- provide a path toward `formalized` status

Formal assistance should strengthen the wiki graph, not redefine it.

## Phase 1 Boundary

This protocol is allowed to define workflows before the indexes are populated.

During Phase 1:

- documents and schemas may be added
- scanning tools may be added
- empty registries may be reserved
- review templates may be added
- no mass extraction should be committed as settled content yet