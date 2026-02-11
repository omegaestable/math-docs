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

### Research Documents

*   **[The Finite Free Stam Inequality](Problem%204.tex)** ([PDF](Problem%204.pdf)): A complete proof of the finite free Stam inequality for real-rooted polynomials, establishing an analogue of the classical information-theoretic Stam inequality in finite free probability theory.
*   **[Critical-Point Comparison Lemma](Critical_Point_Comparison_Lemma.tex)**: An IMO-style rigorous proof of the Critical-Point Comparison Lemma (CL) in full generality for all real-rooted monic degree-n polynomials. This lemma provides essential comparison estimates for critical-point data under symmetric additive convolution, serving as a key technical ingredient in the finite free Stam inequality.

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
