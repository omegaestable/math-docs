# Wiki Graph Schema

This document explains how the empty scaffold files are intended to grow into a math wiki graph.

## Core Goal

The long-term goal is to read mathematics from early levels upward and build a reusable graph of mathematical objects that supports:

- exact sourced definitions
- usable proven theorems
- explicit prerequisite chains
- notation-aware explanations
- proof-status tracking
- future formal assistance through systems such as Lean and mathlib

The graph should grow conservatively. Early stages should prefer small, high-confidence records over broad but unreliable extraction.

## Design Principle

The repo is not trying to become a general encyclopedia first. It is trying to become a trustworthy working graph of mathematics.

That means each future record should answer:

- What mathematical object is this?
- Where did it come from?
- What does it depend on?
- What notation is in force?
- Has it actually been checked?
- What can it be used for?

## Graph Objects

The graph is expected to contain several node types.

### Source Nodes

Represent books, chapters, sections, lecture notes, exercise sheets, and papers.

Primary file:

- `source_index.yaml`

Minimal future fields:

- `id`
- `collection`
- `title`
- `author`
- `language`
- `path`
- `source_type`
- `mathematical_level`
- `topic_tags`
- `scope`
- `reliability_tier`

### Concept Nodes

Represent definitions, constructions, and mathematical notions.

Primary landing area:

- `notes/concept_cards/`

Typical examples:

- derivative
- metric space
- compactness
- type space
- ordinary differential equation

### Theorem Nodes

Represent theorems, lemmas, propositions, corollaries, and source-backed claims.

Primary files:

- `theorem_index.yaml`
- `notes/theorem_cards/`

The central object of the wiki graph is not just a statement, but a statement plus provenance, dependencies, and proof status.

### Dependency Edges

Represent prerequisite relationships between topics, concepts, or theorem nodes.

Primary file:

- `dependency_graph.yaml`

These edges should remain conservative. If a dependency is only suspected, it should be marked as tentative later rather than asserted as reviewed.

### Proof Objects

Represent proof attempts, checked reconstructions, proof skeletons, and counterexamples.

Primary landing areas:

- `proofs/claims/`
- `proofs/proof_attempts/`
- `proofs/proof_skeletons/`
- `proofs/counterexamples/`

### Notation Objects

Represent scoped notation, macro meanings, collisions, and normalization decisions.

Primary file:

- `notation_registry.yaml`

## Population Order

The recommended order is bottom-up by trust and prerequisite level.

1. Start with early-level books and notes.
2. Extract core definitions first.
3. Extract high-use theorems next.
4. Add dependencies and notation links.
5. Add proof notes only when the statement and dependencies are stable.
6. Move into advanced and graduate materials after the lower-level vocabulary is anchored.

This order matters because later material should reuse earlier nodes whenever possible.

## What "Usable Proven Theorems" Means

A theorem is usable in the wiki sense when it has enough structure to support downstream study or reasoning.

Minimum target attributes:

- exact or carefully sourced statement
- source location
- topic tags
- dependency list
- proof status
- notation context
- related concepts or exercises

Theorems should not be treated as generally usable just because they appear in a source. The graph should preserve the distinction between `source-only`, `source-cited`, `rederived`, and `checked`.

## How the Empty Scaffold Files Fit Together

### `source_index.yaml`

This becomes the registry of source nodes. It answers where material came from and what role each source plays.

### `theorem_index.yaml`

This becomes the theorem ledger. It should eventually point to theorem cards, proof objects, source nodes, and dependency edges.

### `dependency_graph.yaml`

This becomes the topic and theorem prerequisite graph. It should eventually support study-path questions such as:

- what should be understood before this theorem?
- what earlier concepts does this chapter rely on?
- what chain leads from basic calculus to ODE existence results?

### `notation_registry.yaml`

This becomes the notation control layer. It prevents false merges across books and levels.

### `gap_log.md`

This becomes the unresolved-step and unresolved-design ledger. It protects the repo from fake completeness.

## Early-Level First Strategy

The early extraction campaign should prioritize:

- calculus
- linear algebra
- introductory proof writing
- basic differential equations
- foundational logic where relevant

Reason:

- these areas supply reusable nodes for much of the later graph
- they make study plans more coherent
- they reduce vocabulary drift when graduate topics are added later

## Future Lean And mathlib Helper

The future formal lane should be additive, not mandatory.

The likely role of a Lean or mathlib powered helper is:

- suggest formal analogues of wiki theorems
- check whether a statement already exists in mathlib
- map informal theorem nodes to formal library objects when possible
- help identify missing hypotheses in candidate statements
- provide a separate `formalized` status for results with machine support

Important constraint:

- formalization should never overwrite source-backed informal mathematics
- the formal lane is a helper for confidence and navigation, not the sole notion of truth in the repo

## Suggested Future Additions

When the repo is ready for population, likely next files include:

- `study_protocol.md` for extraction and review workflows
- `style_guide.md` for naming and writing conventions
- `formalization_registry.yaml` for Lean or mathlib links
- one extraction script to scan `.tex` for sections, theorem environments, labels, and macros

## Current Phase Boundary

Phase 1 remains scaffolding only.

That means:

- schemas are allowed
- templates are allowed
- empty indexes are allowed
- design docs are allowed
- mass record population is not yet the goal

The repository is currently being prepared so later extraction can happen with stable semantics.