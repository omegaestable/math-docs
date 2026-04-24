# Math Docs

This repository is a multilingual mathematics archive that is being upgraded into an extraction-ready study and research lab.

The existing LaTeX and MATLAB materials remain the authoritative source corpus. Around that corpus, the repo now has a scaffolding layer for provenance-aware extraction, theorem indexing, notation control, dependency tracking, and future theorem-wiki workflows.

## What This Repo Is For

This repo is meant to support three different kinds of work at the same time:

- human writing and maintenance of mathematics notes, books, and coursework
- disciplined AI-assisted study with explicit provenance and proof status
- future large-scale extraction into a wiki-like graph of concepts, theorems, dependencies, and proof objects

The long-term direction is to grow a trustworthy internal mathematics graph from early-level sources upward, and later connect parts of that graph to formal systems such as Lean or mathlib when useful.

## Current Status

The repository is in Phase 1 scaffolding.

That means:

- the policy layer exists
- the empty index and registry files exist
- templates exist
- non-mutating extraction tooling exists
- mass theorem population has not started yet

So the repo is extraction-ready in structure, not extraction-complete in content.

## Source Collections

The main source corpora are:

| Collection | Purpose | Notes |
| --- | --- | --- |
| [Books/](Books/) | Teaching notes and course books | Includes bilingual MA 1005 differential equations notes |
| [LMFI/](LMFI/) | Master's-level logic and model theory materials | Includes thesis, exercise sheets, and multilingual notes |
| [Undergrad/](Undergrad/) | Undergraduate topic notes and projects | Includes LaTeX notes and MATLAB material |
| [First Proof/](First%20Proof/) | Proof training and review material | More provisional and review-oriented |

Representative entry points:

- [Books/MA 1005_en.tex](Books/MA%201005_en.tex)
- [Books/MA 1005_es.tex](Books/MA%201005_es.tex)
- [LMFI/Memoire/Memoire_en.tex](LMFI/Memoire/Memoire_en.tex)
- [Undergrad/](Undergrad/)
- [First Proof/](First%20Proof/)

## Control Layer

These files define how the repository should be interpreted and extended.

| File | Role |
| --- | --- |
| [AGENTS.md](AGENTS.md) | Agent contract and read order |
| [active_focus.md](active_focus.md) | Small current working context |
| [lab_manifest.yaml](lab_manifest.yaml) | Machine-readable repo map |
| [rigor_policy.md](rigor_policy.md) | Proof, provenance, and uncertainty rules |
| [source_index.yaml](source_index.yaml) | Empty source registry scaffold |
| [notation_registry.yaml](notation_registry.yaml) | Empty notation control scaffold |
| [theorem_index.yaml](theorem_index.yaml) | Empty theorem ledger scaffold |
| [dependency_graph.yaml](dependency_graph.yaml) | Empty dependency graph scaffold |
| [gap_log.md](gap_log.md) | Empty unresolved-gap ledger scaffold |
| [formalization_registry.yaml](formalization_registry.yaml) | Empty future formal-link scaffold |

Supporting design and workflow documents:

- [context/wiki_graph_schema.md](context/wiki_graph_schema.md)
- [context/study_protocol.md](context/study_protocol.md)
- [context/style_guide.md](context/style_guide.md)

## Directory Layout

The repository now has two layers.

### 1. Source Layer

This is the original mathematical corpus.

- [Books/](Books/)
- [LMFI/](LMFI/)
- [Undergrad/](Undergrad/)
- [First Proof/](First%20Proof/)

### 2. Extraction And Study Layer

This is the new scaffolding for future theorem-wiki work.

- [context/](context/) for design and workflow documents
- [notes/](notes/) for future concept and theorem cards
- [study/](study/) for reading plans, exercise sets, and review workflows
- [proofs/](proofs/) for claims, proof attempts, proof skeletons, and counterexamples
- [research/](research/) for future problem lists, literature maps, and conjectures
- [scripts/](scripts/) for non-mutating extraction and lint support
- [templates/](templates/) for review, theorem, concept, and proof templates

## How To Use The Repo Now

### As A Human Reader

Start with the source collections directly if you want the mathematical content.

Use the control layer if you want to understand how the repo is being standardized for future theorem extraction and research workflows.

### As An Agent Or AI Workflow

Read in this order:

1. [active_focus.md](active_focus.md)
2. [lab_manifest.yaml](lab_manifest.yaml)
3. [rigor_policy.md](rigor_policy.md)
4. [notation_registry.yaml](notation_registry.yaml)
5. [source_index.yaml](source_index.yaml)
6. [context/wiki_graph_schema.md](context/wiki_graph_schema.md)
7. [context/study_protocol.md](context/study_protocol.md)

Then read only the smallest relevant source subset.

## Current Tooling

The current tooling is intentionally conservative.

### TeX Structure Scanner

[scripts/index/scan_tex_sources.py](scripts/index/scan_tex_sources.py) scans `.tex` files and emits a JSON report containing:

- chapter and section boundaries
- labels
- macros
- theorem-environment definitions
- theorem-like environment usage
- include and input relationships

It does not populate the wiki indexes.

Example usage:

```powershell
c:/Users/nacho/Documents/GitHub/math-docs/.venv/Scripts/python.exe scripts/index/scan_tex_sources.py --root . --output .tmp/tex_scan_report.json
```

### Candidate ID Generator

[scripts/index/generate_candidate_ids.py](scripts/index/generate_candidate_ids.py) converts a TeX scan report into deterministic candidate IDs for sections, labels, and theorem-like findings.

It does not publish anything into [theorem_index.yaml](theorem_index.yaml) or any other registry.

Example usage:

```powershell
c:/Users/nacho/Documents/GitHub/math-docs/.venv/Scripts/python.exe scripts/index/generate_candidate_ids.py --scan-report .tmp/tex_scan_report.json --output .tmp/candidate_ids.json
```

### Integration Check

[scripts/lint/run_repo_integration.py](scripts/lint/run_repo_integration.py) runs a repo-level integration check over the current Python tooling:

- the TeX structure scan
- candidate ID generation
- registry validation
- dependency graph traversal
- Hadamard search-module setup

It can also compile explicit TeX smoke targets when `pdflatex` is available.

Example usage:

```powershell
c:/Users/nacho/Documents/GitHub/math-docs/.venv/Scripts/python.exe scripts/lint/run_repo_integration.py
c:/Users/nacho/Documents/GitHub/math-docs/.venv/Scripts/python.exe scripts/lint/run_repo_integration.py --with-tex --tex-target corrected_partition_calculus_note.tex --tex-target "Undergrad/Representaciones de Grupos/trgf_padilla_tarea_6.tex"
```

### Review Template

[templates/theorem_candidate_review.md](templates/theorem_candidate_review.md) is the handoff format for promoting a scanned theorem-like candidate into a reviewed theorem node later.

## Build And Source Editing

For LaTeX builds, use a standard TeX distribution such as TeX Live or MiKTeX.

```bash
pdflatex filename.tex
latexmk -pdf filename.tex
```

For MATLAB files, open and run the `.m` files in MATLAB.

Existing source files remain authoritative. The scaffolding layer should not silently rewrite or rename them.

## Python Setup

The Python tooling for this repo is pinned in [requirements.txt](requirements.txt).

```powershell
python -m venv .venv
.venv\Scripts\python.exe -m pip install --upgrade pip
.venv\Scripts\python.exe -m pip install -r requirements.txt
```

This covers the repo's Python scripts only. TeX compilation still requires a separate TeX distribution such as MiKTeX or TeX Live.

## Standardization Rules

The most important repo-wide rules are:

1. Preserve source meaning before forcing normalization.
2. Treat notation as scoped unless explicitly promoted to house notation.
3. Keep candidate IDs separate from published theorem IDs.
4. Use explicit proof, extraction, and normalization statuses.
5. Prefer non-mutating scripts during the scaffolding phase.

For the full standardization policy, read [context/style_guide.md](context/style_guide.md).

## What The Repo Can Support Next

The current scaffold is suitable for:

- large-scale TeX structure harvesting
- later creation of theorem, concept, and dependency records
- conservative theorem review and publication workflows
- future research assistance based on explicit provenance and dependency structure
- future formal links through Lean or mathlib once theorem nodes are stable

What it does not support yet is automatic trustworthy synthesis from thousands of records, because the actual theorem and concept graph is still intentionally empty.

## Near-Term Roadmap

The next serious stages are:

1. expand source intake and review workflows
2. run scan and candidate-ID tooling on selected source families
3. begin reviewed population from early-level materials
4. grow the concept and theorem graph conservatively
5. add linting and later formal-link support

## Repository Principle

This is not just a note dump and not yet a completed theorem wiki.

It is a source-first mathematical lab being prepared to support large-scale extraction, disciplined study, and eventually research workflows built on a trustworthy internal graph.
