# Scripts Layer

This directory is reserved for future indexing, linting, and extraction support scripts.

Current Phase 1 tooling should remain non-destructive.

- `scripts/index/` may contain scanners and structure harvesters that read source files and emit reports.
- Scripts should not populate or rewrite theorem, notation, dependency, or proof indexes automatically yet.

Current Phase 1 scripts:

- `scripts/index/scan_tex_sources.py` scans `.tex` files for structure and emits a JSON report.
- `scripts/index/generate_candidate_ids.py` converts scan findings into deterministic candidate IDs without populating indexes.