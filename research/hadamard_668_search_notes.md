# Hadamard 668 exact-search notes and roadmap

This note is for an agent running and refining `search_hadamard_668.py` over long horizons.

It has four goals:

1. record the exact mathematical reduction already obtained,
2. separate **proved dead ends** from **live search branches**,
3. explain how to run, log, partition, and resume the current code safely,
4. explain how to turn runtime evidence into exact improvements of the model.

---

## 1. Exact formulation

We want a Hadamard matrix of order

\[
668 = 4 \cdot 167.
\]

The working exact route is the standard four-circulant Goethals–Seidel / SDS formulation over the cyclic group

\[
G = C_{167}.
\]

Let `a,b,c,d` be four \(\{\pm1\}\)-sequences of length 167. If they satisfy

\[
\operatorname{PAF}_a(s)+\operatorname{PAF}_b(s)+\operatorname{PAF}_c(s)+\operatorname{PAF}_d(s)=0
\qquad (s\neq 0),
\]

then the corresponding circulant matrices \(A,B,C,D\) satisfy

\[
AA^T + BB^T + CC^T + DD^T = 668 I_{167},
\]

and the standard Goethals–Seidel array gives a Hadamard matrix of order 668.

Equivalently, with indicator sets \(X_i \subseteq G\) defined by

\[
-1 \iff j \in X_i,
\]

and sizes \(k_i = |X_i|\), the SDS condition is

\[
\sum_{i=1}^4 \nu_{X_i}(s)=\lambda
\qquad (s\neq 0),
\]

with

\[
\lambda = k_1+k_2+k_3+k_4-167.
\]

The row sums satisfy

\[
s_a^2+s_b^2+s_c^2+s_d^2 = 668,
\]

with each \(s_i\) odd, and the only possible positive quadruples are:

- `(1,1,15,21)`
- `(1,9,15,19)`
- `(3,3,5,25)`
- `(3,3,11,23)`
- `(3,3,17,19)`
- `(3,7,9,23)`
- `(3,7,13,21)`
- `(3,9,17,17)`
- `(5,9,11,21)`
- `(7,13,15,15)`

with SDS parameter branches:

- `(83,83,76,73), λ=148`
- `(83,79,76,74), λ=145`
- `(82,82,81,71), λ=149`
- `(82,82,78,72), λ=147`
- `(82,82,75,74), λ=146`
- `(82,80,79,72), λ=146`
- `(82,80,77,73), λ=145`
- `(82,79,75,75), λ=144`
- `(81,79,78,73), λ=144`
- `(80,77,76,76), λ=142`

---

## 2. Exact normalization used by the script

The current script fixes the first block `A` to the Paley skew block on `C_167`.

That means:

- `A[j] = -1` on nonzero quadratic residues,
- `A[j] = +1` on 0 and on nonresidues,
- `A` is skew,
- `sum(A) = 1`,
- `PAF_A(s) = -1` for every nonzero shift \(s\).

So the remaining exact condition becomes

\[
\operatorname{PAF}_B(s)+\operatorname{PAF}_C(s)+\operatorname{PAF}_D(s)=1
\qquad (s\neq 0).
\]

This immediately reduces the live row-sum branches to the two branches containing a `1`:

### Branch A

- row sums `(1,1,15,21)`
- SDS parameters `(83,83,76,73), λ=148`
- for `(B,C,D)` alone:
  - sizes `(83,76,73)`
  - effective λ for the three-block condition: `107`

### Branch B

- row sums `(1,9,15,19)`
- SDS parameters `(83,79,76,74), λ=145`
- for `(B,C,D)` alone:
  - sizes `(79,76,74)`
  - effective λ for the three-block condition: `104`

---

## 3. Exact symmetric reduction used by the script

The current script does **not** search all live Paley-skew solutions. It searches the classical exact subbranch:

- `A` fixed skew Paley,
- `B,C,D` constrained to be symmetric subsets of `C_167`.

This allows quotienting by `±1`.

Let

\[
H = C_{167}^{\times}/\{\pm1\}, \qquad |H| = 83.
\]

Each symmetric set is determined by its membership on the 83 pair-classes.

The script uses the exponent model of `H ≅ C_83` with primitive root `5 mod 167`, and the exact translated path

\[
1,2,\dots,83
\]

projected into `H`.

A key exact combinatorial fact already used in the code:

- the base path has 82 edges,
- each nonzero undirected difference class in `C_83` appears **exactly twice** among those 82 edges.

This makes the path constraints very tight and explains the reduced model.

---

## 4. Exact color models on the 83-point quotient

### 4.1 Branch A quotient model

For Branch A, parity forces each quotient vertex into exactly one of four types:

- `B`
- `C`
- `D`
- `T`  (triple membership)

with exact counts:

- `|B| = 25`
- `|C| = 22`
- `|D| = 20`
- `|T| = 16`

For each translated copy of the 82-edge base path, the number of monochromatic edges must be

\[
20 + 1_C(t).
\]

So:

- if the starting vertex has color `C`, the path must contain 21 monochromatic adjacencies,
- otherwise it must contain 20.

The script encodes exactly this condition.

### 4.2 Branch B quotient model

For Branch B, parity forces each quotient vertex into exactly one of four types:

- `BC`
- `BD`
- `CD`
- `N`  (no membership)

with exact counts:

- `|BC| = 20`
- `|BD| = 19`
- `|CD| = 18`
- `|N|  = 26`

For each translated copy of the 82-edge base path, the number of monochromatic edges must be

\[
20 + 1_{CD}(t).
\]

So:

- if the starting vertex has color `CD`, the path must contain 21 monochromatic adjacencies,
- otherwise it must contain 20.

Again, the script encodes exactly this condition.

---

## 5. What the current script proves and what it does not prove

### What it **does** search exactly

For each of Branch A and Branch B, the script searches the reduced exact model:

- 83 quotient vertices,
- 4 colors per vertex,
- exact color counts,
- exact path constraints for all 83 translates,
- exact total same-pair count,
- exact lift back to symmetric subsets of `C_167`,
- exact verification of the 167-length PAF identities before writing a solution.

So every saved JSON output is an **exact verified construction** inside the searched subbranch.

### What it **does not** search

It does **not** search:

- the non-Paley branches,
- Paley-skew solutions with nonsymmetric `B,C,D`,
- the eight original row-sum branches without a row sum 1,
- other exact block families not expressible in this reduced symmetric quotient model.

Therefore:

- success in the script is a full exact success,
- failure of the script is only failure in this specific exact subbranch.

---

## 6. Exact dead ends already identified

These are worth preserving so the agent does not re-do useless work.

### Dead end 1: second perfect size-83 block inside symmetric Branch A

Inside Branch A, the further subbranch

- `A` = Paley skew,
- `B` also a size-83 perfect difference set,
- `C,D` symmetric,

is impossible by exact parity/count comparison on quotient pairs.

Do not search it.

### Dead end 2: tiny affine Paley-core circulant family

The 3-dimensional circulant algebra spanned by `I, J, Q` only gives the following ±1 circulants:

- `±J`
- `±(J-2I)`
- `±(Q+I)`
- `±(Q-I)`

and no four-block Goethals–Seidel combination from these can satisfy the exact order-668 identity.

Do not search it.

### Dead end 3: tested quadratic-character family on the quotient

A nontrivial exact family built from products of functions of the form

\[
\chi(x^2-\alpha)
\]

on the 83-point quotient has already been tested in Branch A and found empty.

Do not spend more time on that exact family unless the family itself is enlarged in a mathematically new way.

---

## 7. What the code currently does

The code structure is:

1. build the quotient data,
2. generate deterministic prefix assignments,
3. for each prefix, solve a CP-SAT model,
4. if a reduced solution is found, lift it to sets `B,C,D`,
5. exactly verify the full 167-length PAF identity,
6. write a JSON solution.

The crucial functions are:

- `build_quotient_data()`
- `generate_prefixes()`
- `solve_with_cpsat()`
- `verify_reduced_solution()`
- `lift_symmetric_sets()`
- `verify_sequences()`

### Current symmetry break

The only symmetry break built into the model is translation on `C_83`, implemented by fixing quotient vertex `0` to the special color:

- Branch A: color `C`
- Branch B: color `CD`

This is exact and safe.

---

## 8. How prefix splitting works

The script can split the search by fixing the first `D` nonzero vertices along the base path.

Command-line options:

- `--split-depth D`
- `--jobs J`
- `--job j`

The script generates all prefixes of depth `D`, then assigns prefix number `i` to job `i mod J`.

### Important exact fact

For small depths the color counts do not yet bind, so the number of prefixes is simply

\[
4^D.
\]

In particular, for both branches:

- `D=4` gives `256` prefixes,
- `D=5` gives `1024`,
- `D=6` gives `4096`,
- `D=7` gives `16384`,
- `D=8` gives `65536`.

This matters for planning resumable long runs.

---

## 9. How to run it for long periods

## 9.1 First sanity run

```bash
python search_hadamard_668.py --branch both --workers 8 --time-limit 30
```

Purpose:

- confirm OR-Tools is installed,
- confirm the script runs,
- confirm logs and output directory behave as expected.

## 9.2 Broad branch scan

```bash
python search_hadamard_668.py --branch A --workers 16 --time-limit 300
python search_hadamard_668.py --branch B --workers 16 --time-limit 300
```

Purpose:

- compare Branch A vs Branch B,
- see which branch accumulates faster infeasibility,
- see whether one branch has clearly harder prefixes.

## 9.3 Deterministic job array mode

For long campaigns, use splitting. Example:

```bash
python search_hadamard_668.py --branch A --split-depth 6 --jobs 4096 --job 173 --workers 4 --time-limit 1800
```

At `split-depth = 6`, each job corresponds to exactly one depth-6 prefix, because `4^6 = 4096`.

This is the cleanest way to make jobs resumable and non-overlapping.

### Recommended pattern

- use `split-depth 6`, `7`, or `8`,
- set `jobs = 4^D`,
- let each OS process handle a single exact prefix.

Then each process is naturally resumable and there is no wasted rework after interruptions.

---

## 10. Logging: what to record and how

The script writes progress to **stderr** via `eprint(...)`.

So to save logs, redirect both stdout and stderr.

### Example with full capture

```bash
python search_hadamard_668.py --branch A --split-depth 6 --jobs 4096 --job 173 --workers 4 --time-limit 1800 \
  2>&1 | tee logs/branchA_d6_job0173.log
```

### Recommended directory layout

```text
project/
  search_hadamard_668.py
  logs/
  solutions_668/
  manifests/
  summaries/
```

### Recommended log filename scheme

```text
logs/
  A_d6_job000173_seed0_w4_t1800.log
  A_d6_job000174_seed0_w4_t1800.log
  B_d6_job000173_seed0_w4_t1800.log
```

### What current logs contain

For each branch/job the script prints lines like:

- total prefix count,
- selected prefix count,
- each prefix assignment being solved,
- solver status for that prefix,
- per-prefix elapsed time,
- final branch status.

### Status names to track

Useful statuses are:

- `INFEASIBLE`
- `UNKNOWN`
- `FEASIBLE`
- `OPTIMAL`
- `ALL_SELECTED_PREFIXES_INFEASIBLE`
- `NO_SOLUTION_FOUND_WITHIN_LIMITS`
- `NO_SOLUTION_IN_SELECTED_PREFIXES`

Interpretation:

- `INFEASIBLE`: exact proof that this reduced prefix has no solution,
- `UNKNOWN`: solver hit the time limit or stopped without proof,
- `FEASIBLE` / `OPTIMAL`: a candidate coloring was found and then exactly verified by the script,
- `ALL_SELECTED_PREFIXES_INFEASIBLE`: this entire job is fully done and closed.

### Minimal summary extraction

A simple shell summary:

```bash
grep -E "status=|finished status=" logs/A_d6_job000173_seed0_w4_t1800.log
```

A rough count across many logs:

```bash
grep -h "status=" logs/*.log | sort | uniq -c
```

---

## 11. Resume: what is possible now, and what is not

## 11.1 What works now without editing code

The safest resumable mode **right now** is:

- choose `split-depth = D`,
- choose `jobs = 4^D`,
- run one `--job` per process.

Then each job is exactly one prefix, and resuming is trivial: rerun only unfinished jobs.

Example:

```bash
python search_hadamard_668.py --branch B --split-depth 7 --jobs 16384 --job 9412 --workers 2 --time-limit 3600
```

If that process dies, rerun exactly the same command.

## 11.2 What does **not** work well now

If `jobs` is much smaller than the number of prefixes, then a single process handles many prefixes in sequence. If it dies halfway through, rerunning the same command starts that job from the beginning of its selected prefix list.

So current code has **no built-in checkpoint** for per-prefix progress.

---

## 12. First code edits to make long runs resumable

These are the highest-value edits.

### Edit 1: write one JSONL record after every prefix

After every solved prefix, append a line to a progress log file with fields:

- branch,
- split depth,
- jobs,
- job,
- local prefix index,
- exact prefix assignment,
- solver status,
- wall time,
- seed,
- workers,
- time limit,
- timestamp.

Recommended format: JSONL.

Example record:

```json
{"branch":"A","split_depth":6,"jobs":4096,"job":173,"local_idx":1,"prefix":{"0":"C","40":"B","11":"T"},"status":"INFEASIBLE","wall_time":83.42,"seed":0,"workers":4,"time_limit":1800}
```

Then, on restart, read the JSONL and skip completed local indices.

### Edit 2: add `--resume-log FILE`

Semantics:

- if present, read completed prefix indices from the JSONL file,
- skip those prefixes,
- continue only on unresolved prefixes.

### Edit 3: add `--prefix-index i`

This is the simplest exact control knob.

Semantics:

- generate the full prefix list for the chosen branch/split depth/fixes,
- run only prefix number `i`.

This makes exact replay and targeted investigation much easier than the current modulo-job scheme.

### Edit 4: export prefix manifests

Add a mode that writes every generated prefix to a file, one per line, with its deterministic index.

Then all later runs can refer to **stable prefix IDs**.

This helps with:

- reproducibility,
- exact resume,
- comparing different solver settings on the same prefix,
- cluster scheduling.

---

## 13. How to learn from runtime behavior

The key principle is:

> treat logs as mathematical evidence about which reduced regions are trivial, hard, or repetitive.

### 13.1 What to measure

For every prefix, track:

- branch (`A` or `B`),
- prefix assignment,
- status,
- solve time,
- whether it was closed as infeasible,
- whether it remained unknown.

### 13.2 What patterns matter

#### Pattern A: many fast infeasible prefixes

If most prefixes close quickly as `INFEASIBLE`, that means the reduced model is strong. Increase split depth and isolate the few hard prefixes.

#### Pattern B: a small number of very hard prefixes

Those prefixes are the right place to:

- add more exact symmetry breaking,
- add more exact cuts,
- inspect repeated local color patterns,
- try different branching orders.

#### Pattern C: one branch dominates runtime

If Branch A is mostly fast infeasible and Branch B contains almost all hard prefixes, focus development on Branch B only, or vice versa.

#### Pattern D: a repeated bad anchor color pattern

If hard prefixes repeatedly begin with the same first few anchor colors, add these patterns to a targeted investigation queue.

Do **not** hard-code a prune from such evidence unless the prune is mathematically proved.

---

## 14. Exact improvements to the code that are worth trying first

These edits are ordered by expected value.

### Improvement 1: checkpointing and stable prefix IDs

This is the first priority. It saves actual wall-clock time immediately.

### Improvement 2: record solver stats

After each solve, log `solver.ResponseStats()` or its structured equivalent.

Useful numbers include:

- conflicts,
- branches,
- propagations,
- deterministic time,
- presolve reductions.

This tells you whether hard prefixes are hard because of:

- weak presolve,
- poor branching,
- large proof trees,
- time spent before search even starts.

### Improvement 3: compare `portfolio` vs `fixed-search`

Current code supports:

- default CP-SAT portfolio search,
- `--fixed-search` using the explicit base-path variable order.

A systematic campaign should compare both on the **same exact prefix set**.

Recommended experiment:

- choose 100 representative hard prefixes,
- run each prefix once with portfolio,
- run once with fixed search,
- compare median and worst-case solve times.

Keep whichever closes more prefixes exactly.

### Improvement 4: keep one prefix per process for hard runs

This is not a code change, but it is often the best performance change operationally.

Why:

- exact resume is trivial,
- hard prefixes do not block unrelated prefixes,
- different seeds or worker counts can be compared prefix-by-prefix,
- scheduling becomes clean.

### Improvement 5: add per-prefix timeout classes

Use a staged campaign:

1. shallow fast pass: small time limit,
2. medium pass on unresolved prefixes,
3. deep pass only on persistent hard prefixes.

This is exact because every infeasible result remains exact, and unknown prefixes are simply deferred.

---

## 15. Mathematical cuts worth investigating next

These are exact directions, not guesses. Only encode them after proving the identity being added.

### Cut family 1: stronger edge-color bookkeeping

The current reduced model tracks only whether a quotient edge is monochromatic.

Possible strengthening:

- count how many translated edges are of type `(color i, color j)`,
- derive exact identities relating these transition counts to the fixed color counts and path equations,
- add those as redundant exact linear constraints.

This may tighten proofs without changing the solution set.

### Cut family 2: more safe symmetry breaking after vertex 0

Current model uses only translation symmetry.

Check whether there is any additional exact automorphism of the reduced quotient/path model that survives after fixing the special color at vertex 0. If so, add one more lexicographic or anchor-color break.

Only do this after proving the automorphism is genuine.

### Cut family 3: exact character constraints after lifting

The full 167-length sequences satisfy exact group-character identities. If a useful subset of those constraints can be rewritten directly on the quotient variables, they may strengthen the model materially.

This is a high-value exact direction, but only after the formulas are written down cleanly.

### Cut family 4: branch-specific counting identities

The two branches have different color semantics:

- Branch A: `B,C,D,T`
- Branch B: `BC,BD,CD,N`

It is possible there are extra exact counts involving adjacency types, zero-membership flags, or lifted set intersections that have not yet been encoded. Those are good targets.

---

## 16. Operational roadmap for a multi-day campaign

## Stage 1: establish baselines

Run both branches with modest split depth and modest time limit.

Example:

```bash
python search_hadamard_668.py --branch A --split-depth 5 --jobs 1024 --job 0   --workers 4 --time-limit 600
python search_hadamard_668.py --branch A --split-depth 5 --jobs 1024 --job 1   --workers 4 --time-limit 600
python search_hadamard_668.py --branch B --split-depth 5 --jobs 1024 --job 0   --workers 4 --time-limit 600
python search_hadamard_668.py --branch B --split-depth 5 --jobs 1024 --job 1   --workers 4 --time-limit 600
```

Goal:

- verify the full toolchain,
- compare branch hardness,
- estimate typical per-prefix time.

## Stage 2: one-prefix-per-job sweep

Move to `jobs = 4^D` with `D = 6` or `7`.

Goal:

- exact resumability,
- stable per-prefix statistics,
- easy cluster distribution.

## Stage 3: isolate hard prefixes

Collect all prefixes still returning `UNKNOWN` after the first pass.

Goal:

- build a hard-prefix manifest,
- replay those only,
- compare solver settings exactly on that set.

## Stage 4: instrument and refine

Before changing mathematics, add:

- JSONL checkpointing,
- stable prefix IDs,
- solver stats logging.

Then inspect the hard-prefix set and adjust:

- split depth,
- worker count,
- time limit,
- fixed-search vs portfolio.

## Stage 5: only then add new exact cuts

Do not add speculative constraints. Every new prune must be mathematically justified.

---

## 17. Practical worker-count advice

CP-SAT portfolio search does not always benefit from very high worker counts per process.

A good exact campaign usually compares:

- many jobs with small worker count, versus
- fewer jobs with larger worker count.

Recommended comparisons:

- `workers=1`
- `workers=2`
- `workers=4`
- `workers=8`

on the **same exact hard-prefix set**.

For a machine with many cores, it is often better to run more single-prefix jobs in parallel than to give one prefix too many workers.

---

## 18. Seed handling

The script exposes `--seed`.

Use seeds systematically, not randomly.

Recommended rule:

- first pass: `seed=0`,
- second pass on unresolved prefixes: compare `seed=1,2,3`,
- record outcomes prefix-by-prefix.

Different seeds do not change correctness. They only change solver search order.

---

## 19. Exact replay protocol

Whenever a prefix looks interesting, preserve:

- branch,
- split depth,
- jobs,
- job number or stable prefix index,
- seed,
- worker count,
- time limit,
- any explicit `--fix` values,
- solver mode (`--fixed-search` or not).

That makes every notable event exactly reproducible.

---

## 20. Suggested code edits in order

1. **Checkpoint JSONL after every prefix**
2. **Resume from checkpoint file**
3. **Stable prefix IDs / manifest export**
4. **Log solver stats per prefix**
5. **Single-prefix replay mode**
6. **Hard-prefix manifest mode**
7. **Then** consider stronger exact cuts

That order is important. Better instrumentation usually yields larger speedups than guessing at new constraints.

---

## 21. Minimal command cookbook

### Branch A broad scan

```bash
python search_hadamard_668.py --branch A --workers 8 --time-limit 300
```

### Branch B broad scan

```bash
python search_hadamard_668.py --branch B --workers 8 --time-limit 300
```

### One exact prefix per process

```bash
python search_hadamard_668.py --branch A --split-depth 6 --jobs 4096 --job 173 --workers 2 --time-limit 1800
```

### Fixed-search comparison on same prefix

```bash
python search_hadamard_668.py --branch A --split-depth 6 --jobs 4096 --job 173 --workers 2 --time-limit 1800 --fixed-search
```

### Verbose solver internals

```bash
python search_hadamard_668.py --branch B --split-depth 6 --jobs 4096 --job 91 --workers 4 --time-limit 600 --log-progress
```

### Manual exact color fixing

```bash
python search_hadamard_668.py --branch A --fix 40:B --fix 11:T --workers 4
```

---

## 22. Bottom line

The current script is already searching a strong exact branch:

- Paley skew core at length 167,
- symmetric three-block quotient reduction to 83 vertices,
- exact path-count model,
- exact lift and exact PAF verification.

The right next move for long campaigns is not to guess new mathematics immediately. It is to make the current exact search:

- checkpointable,
- resumable,
- prefix-addressable,
- statistically transparent.

Once that is done, runtime evidence will tell you where the real hard core is, and that is where new exact cuts or reformulations should be aimed.
