# Scripts Layer

This directory is reserved for future indexing, linting, and extraction support scripts.

Current Phase 1 tooling should remain non-destructive.

- `scripts/index/` may contain scanners and structure harvesters that read source files and emit reports.
- `scripts/lint/` may contain validation and graph-analysis tools that read registry files and report structural issues.
- Scripts should not populate or rewrite theorem, notation, dependency, or proof indexes automatically yet.

Current Phase 1 scripts:

- `scripts/index/scan_tex_sources.py` scans `.tex` files for structure and emits a JSON report.
- `scripts/index/generate_candidate_ids.py` converts scan findings into deterministic candidate IDs without populating indexes.
- `scripts/lint/validate_registries.py` validates the structure and cross-file consistency of the core YAML registries.
- `scripts/lint/traverse_dependency_graph.py` reports dependency graph summaries and node-local prerequisite and dependent relationships without mutation.
- `scripts/lint/run_repo_integration.py` runs an integration check over the scan pipeline, registry linting, dependency traversal, and the Hadamard search setup, with optional TeX smoke compilation.

Note: the lint scripts use `PyYAML`. If it is not installed in the repo virtual environment, they will exit with a friendly error message.

Example usage:

```powershell
.venv\Scripts\python.exe scripts\lint\run_repo_integration.py
.venv\Scripts\python.exe scripts\lint\run_repo_integration.py --with-tex --tex-target "proofs/proof_attempts/corrected_partition_calculus_note.tex" --tex-target "Undergrad/Representaciones de Grupos/trgf_padilla_tarea_6.tex"
```