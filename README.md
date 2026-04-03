# Mathematical Research and Teaching Archive

This repository contains multilingual mathematics material in LaTeX (`.tex`), compiled PDFs (`.pdf`), and MATLAB scripts (`.m`).

## Table of Contents (TeX-Style)

| Sec. | Context | Link |
| --- | --- | --- |
| 1 | LMFI (Master's Studies) | [LMFI/](LMFI/) |
| 1.1 | LMFI Thesis (Memoire) | [LMFI/Memoire/](LMFI/Memoire/) |
| 1.2 | LMFI Exercises and TD Sheets | [LMFI/](LMFI/) |
| 1.3 | LMFI Modelos UCR | [LMFI/Modelos UCR/](LMFI/Modelos%20UCR/) |
| 2 | Undergrad (College Projects) | [Undergrad/](Undergrad/) |
| 2.1 | Undergrad Logic and Model Theory | [Undergrad/El espacio de n-tipos/](Undergrad/El%20espacio%20de%20n-tipos/) |
| 2.2 | Undergrad O-minimal Structures | [Undergrad/Estructuras o-minimales/](Undergrad/Estructuras%20o-minimales/) |
| 2.3 | Undergrad Ordered Fields | [Undergrad/Cuerpos Ordenados/](Undergrad/Cuerpos%20Ordenados/) |
| 2.4 | Undergrad Non-elementary Integrals | [Undergrad/Integrales no elementales/](Undergrad/Integrales%20no%20elementales/) |
| 2.5 | Undergrad Transcendental Numbers | [Undergrad/Numeros Trascendentes/](Undergrad/N%C3%BAmeros%20Trascendentes/) |
| 2.6 | Undergrad Zeros of L-functions | [Undergrad/Zeros de L-funciones/](Undergrad/Zeros%20de%20L-funciones/) |
| 2.7 | Undergrad Numerical Analysis (MATLAB) | [Undergrad/Analisis Numerico/](Undergrad/An%C3%A1lisis%20Num%C3%A9rico/) |
| 3 | Books and Teaching Notes | [Books/](Books/) |
| 3.1 | MA 1005 (EN) | [Books/MA 1005_en.pdf](Books/MA%201005_en.pdf) |
| 3.2 | MA 1005 (ES) | [Books/MA 1005_es.pdf](Books/MA%201005_es.pdf) |
| 4 | First Proof Materials | [First Proof/](First%20Proof/) |
| 4.1 | Round 1 | [First Proof/Round 1/](First%20Proof/Round%201/) |
| 4.2 | Round 2 | [First Proof/Round 2/](First%20Proof/Round%202/) |
| 5 | Root Research PDF | [Problem 4.pdf](Problem%204.pdf) |

## Build

Use a standard TeX distribution (TeX Live, MacTeX, or MiKTeX):

```bash
pdflatex filename.tex
# or
latexmk -pdf filename.tex
```

For MATLAB files (`.m`), open and run them in MATLAB.

## Study Lab Scaffolding

The repository now includes an extraction-ready context layer for AI-assisted study and later mass mathematical indexing.

Primary entry points:

- [AGENTS.md](AGENTS.md)
- [active_focus.md](active_focus.md)
- [lab_manifest.yaml](lab_manifest.yaml)
- [rigor_policy.md](rigor_policy.md)
- [source_index.yaml](source_index.yaml)
- [notation_registry.yaml](notation_registry.yaml)
- [gap_log.md](gap_log.md)
- [theorem_index.yaml](theorem_index.yaml)
- [dependency_graph.yaml](dependency_graph.yaml)

These files are scaffolding only. Existing LaTeX sources remain authoritative, and the new layer is intended to support future extraction, normalization, provenance tracking, and study planning.
