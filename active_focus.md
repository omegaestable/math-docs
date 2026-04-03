# Active Focus

## Current Mode

Phase 1 scaffolding for mass mathematical extraction.

## Current Objective

Make the repository extraction-ready by freezing schemas, provenance rules, notation discipline, and collection boundaries before any large-scale theorem or concept extraction.

## Collections In Scope

- `Books`
- `LMFI`
- `Undergrad`
- `First Proof`

## This Week

- Establish the root context layer.
- Seed the source index and notation registry.
- Record repo-wide gaps that block safe extraction.

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