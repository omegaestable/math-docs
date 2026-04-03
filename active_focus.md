# Active Focus

## Current Mode

Phase 1 scaffolding for mass mathematical extraction.

## Current Objective

Make the repository extraction-ready by freezing schemas, provenance rules, notation discipline, and collection boundaries before any large-scale theorem or concept extraction.

## Long-Term Direction

Build a wiki-like graph of usable mathematics, starting from early-level sources and growing toward advanced material with explicit provenance, dependencies, and proof status.

## Future Helper Lane

Reserve room for a future Lean or mathlib powered helper that can link formal artifacts to the wiki graph without replacing source-first mathematical study.

## Collections In Scope

- `Books`
- `LMFI`
- `Undergrad`
- `First Proof`

## This Week

- Establish the root context layer.
- Finalize extraction protocols and empty index schemas.
- Add non-mutating extraction tooling for `.tex` structure scans.

## Unresolved Blockers

- No theorem-level index yet.
- No dependency graph yet.
- Notation collisions exist across collections.
- Citation infrastructure is inconsistent across sources.

## Notation In Force

Use scope-first interpretation. Do not assume a macro has the same meaning across `Books`, `LMFI`, and `Undergrad` unless the notation registry says so.

## Recent Mistakes To Avoid

- Do not treat compiled PDFs as canonical when `.tex` exists.
- Do not normalize conflicting notation silently.
- Do not atomize long notes before stable IDs and statuses exist.