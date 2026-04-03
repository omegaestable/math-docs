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
| `REPO-INFRA-001` | notation | Resolve the cross-collection meaning of `\LL` without forcing a false global normalization. | The same macro denotes Laplace transform in `Books` and first-order language in `LMFI`. Silent normalization would corrupt extraction. | `notation_registry.yaml`, scoped IDs, future lint rule | `tracked` |
| `REPO-INFRA-002` | citations | Standardize source-level citation metadata for collections that currently lack consistent bibliography files. | Extraction should distinguish repo-authored notes from externally sourced statements, but bibliography support is uneven. | `source_index.yaml`, future bibliography audit script | `open` |
| `REPO-INFRA-003` | indexing | Define stable theorem and definition ID rules that work across multilingual and non-uniform source structures. | The repo contains chapter-structured books, standalone notes, multilingual variants, and mixed `.tex` and `.m` material. | future `theorem_index.yaml`, ID policy, extraction script | `open` |
| `REPO-INFRA-004` | dependencies | Seed a prerequisite graph that can relate undergraduate topics, LMFI model theory, and course notes without overclaiming dependencies. | Different collections operate at very different levels and use different local vocabularies. | future `dependency_graph.yaml`, topic taxonomy | `open` |
| `REPO-INFRA-005` | provenance | Decide how generated PDFs and non-LaTeX artifacts should be linked to source-first records. | Some folders include both `.tex` and compiled `.pdf`, and numerical analysis also includes MATLAB files. | `lab_manifest.yaml`, future ingestion rules | `tracked` |