# Mathematical Research & Teaching Archive

The contents of this repository are multilingual, featuring documents in **LaTeX** and code implementations in **MATLAB**. Some content is also available in Spanish and French.

## Repository Structure

### [LMFI](LMFI/) (Master's Studies)
Resources and documents related to my Master's studies in Mathematical Logic and Foundations of Computer Science (Logique Mathématique et Fondements de l'Informatique).

*   **[Master's Thesis](LMFI/Memoire/)**: My Master's thesis material.
*   **Coursework**:
    *   **[Computability Theory](LMFI/TD%201%20Calculabilité.pdf)**
    *   **[Set Theory](LMFI/TD%201%20Ensembles.pdf)**
    *   **[Model Theory](LMFI/TD%201%20Modeles.pdf)**
*   **[Exercises](LMFI/)**: Problem sets and solutions.

### [Undergrad](Undergrad/) (College Projects)
A collection of projects and papers from my undergraduate years, covering various advanced mathematical topics.

*   **Logic & Model Theory**:
    *   *[The Space of n-types](Undergrad/El%20espacio%20de%20n-tipos/)*
    *   *[O-minimal Structures](Undergrad/Estructuras%20o-minimales/)*
*   **Algebra & Analysis**:
    *   *[Ordered Fields](Undergrad/Cuerpos%20Ordenados/)*
    *   *[Non-elementary Integrals](Undergrad/Integrales%20no%20elementales/)*
    *   *[Transcendental Numbers](Undergrad/Números%20Trascendentes/)*
    *   *[Zeros of L-functions](Undergrad/Zeros%20de%20L-funciones/)*
*   **Numerical Analysis**:
    *   **[MATLAB Scripts](Undergrad/Análisis%20Numérico/)**: Implementations of algorithms for Chaos theory, Differential Equations, Interpolation, and Matrix operations.

### [Books](Books/)
Longer-form content, teaching notes, and book drafts.

*   **[Padilla Notes 1005](Books/MA%201005_en.pdf)**: A comprehensive set of notes, including source LaTeX and generated figures.

### Research Papers

*   **[The Finite Free Stam Inequality](Problem%204.pdf)**: Establishes a finite free analogue of the Stam inequality from information theory using polynomial root analysis and convolution-flow techniques.
*   **[The Critical-Point Comparison Lemma](critical_point_comparison_lemma.pdf)**: Advanced treatment of the critical-point comparison inequality using Pólya frequency sequences, total positivity, variation diminishing, interlacing, and determinant inequalities.

## Usage

Most documents in this repository are written in **LaTeX**. To build the PDFs from source, you will need a standard TeX distribution (such as TeX Live, MacTeX, or MiKTeX).

Common build command for a file:

```bash
pdflatex filename.tex
# or using latexmk for automatic dependency handling
latexmk -pdf filename.tex
```

For **MATLAB** files (`.m`), simply open them in the MATLAB environment or run them from the command window.

---
*omega*
