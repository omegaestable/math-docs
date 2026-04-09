#!/usr/bin/env python3
"""
Exact reduced search for a Hadamard matrix of order 668 via the length-167
Goethals-Seidel / SDS formulation, in the Paley-skew + symmetric-(B,C,D)
subbranch.

The script searches the two exact reduced branches:

  Branch A:
    colors on H = C_167^x / {±1} (|H| = 83):  B, C, D, T
    counts: (25, 22, 20, 16)
    target on translated path P_a: M(a) = 20 + 1_{C}(a)

  Branch B:
    colors on H = C_167^x / {±1} (|H| = 83):  BC, BD, CD, N
    counts: (20, 19, 18, 26)
    target on translated path P_a: M(a) = 20 + 1_{CD}(a)

If a reduced solution is found, the script lifts it to symmetric subsets
B, C, D of C_167, fixes A to the Paley skew block, and verifies exactly that

    PAF_A(s) + PAF_B(s) + PAF_C(s) + PAF_D(s) = 0    for all s != 0.

The search backend uses OR-Tools CP-SAT on the reduced 83-vertex model.
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import time
from collections import Counter
from dataclasses import dataclass
from typing import Dict, Iterable, List, Sequence, Tuple


P = 167
Q = 83
PRIMITIVE_ROOT = 5
BASE_MONO = 20


def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)


@dataclass(frozen=True)
class BranchSpec:
    key: str
    color_names: Tuple[str, str, str, str]
    counts: Tuple[int, int, int, int]
    special_color: int
    eps_B: int
    eps_C: int
    eps_D: int
    B_members: Tuple[int, ...]
    C_members: Tuple[int, ...]
    D_members: Tuple[int, ...]

    @property
    def total_same_pairs(self) -> int:
        # Every same-pair variable appears exactly twice over all translated paths.
        total_path_mono = Q * BASE_MONO + self.counts[self.special_color]
        assert total_path_mono % 2 == 0
        return total_path_mono // 2

    def color_index(self, name: str) -> int:
        try:
            return self.color_names.index(name)
        except ValueError as exc:
            raise SystemExit(
                f"Unknown color '{name}' for branch {self.key}. "
                f"Allowed: {', '.join(self.color_names)}"
            ) from exc


BRANCHES: Dict[str, BranchSpec] = {
    "A": BranchSpec(
        key="A",
        color_names=("B", "C", "D", "T"),
        counts=(25, 22, 20, 16),
        special_color=1,  # C
        eps_B=1,
        eps_C=0,
        eps_D=1,
        B_members=(0, 3),
        C_members=(1, 3),
        D_members=(2, 3),
    ),
    "B": BranchSpec(
        key="B",
        color_names=("BC", "BD", "CD", "N"),
        counts=(20, 19, 18, 26),
        special_color=2,  # CD
        eps_B=1,
        eps_C=0,
        eps_D=0,
        B_members=(0, 1),
        C_members=(0, 2),
        D_members=(1, 2),
    ),
}


@dataclass
class QuotientData:
    base_path: List[int]
    base_edges: List[Tuple[int, int]]
    pair_reps: List[int]
    same_pairs: List[Tuple[int, int, int]]
    path_term_indices: List[List[int]]


@dataclass
class SolveResult:
    found: bool
    status_name: str
    wall_time: float
    colors: List[int] | None = None
    prefix_index: int | None = None
    prefix_total: int | None = None


class SearchUnavailable(RuntimeError):
    pass



def discrete_log_table(p: int, g: int) -> Dict[int, int]:
    table: Dict[int, int] = {}
    x = 1
    for e in range(p - 1):
        if x in table:
            raise AssertionError("primitive root power cycle repeated early")
        table[x] = e
        x = (x * g) % p
    if len(table) != p - 1:
        raise AssertionError("primitive root does not generate all nonzero residues")
    return table



def build_quotient_data() -> QuotientData:
    log_tab = discrete_log_table(P, PRIMITIVE_ROOT)

    # Pair-class representatives in exponent coordinates 0..82.
    pair_reps = [pow(PRIMITIVE_ROOT, e, P) for e in range(Q)]
    assert len(set(pair_reps)) == Q

    # Base path: classes of 1,2,...,83 in exponent coordinates mod 83.
    base_path = [log_tab[n] % Q for n in range(1, Q + 1)]
    assert len(base_path) == Q
    assert len(set(base_path)) == Q

    base_edges = list(zip(base_path[:-1], base_path[1:]))
    assert len(base_edges) == Q - 1

    # Exact check: each nonzero undirected difference class appears exactly twice.
    diff_count: Counter[int] = Counter()
    for u, v in base_edges:
        d = (v - u) % Q
        d = min(d, Q - d)
        if d == 0:
            raise AssertionError("zero difference in base path")
        diff_count[d] += 1
    assert len(diff_count) == (Q - 1) // 2
    assert set(diff_count.values()) == {2}

    same_pairs: List[Tuple[int, int, int]] = []
    same_index: Dict[Tuple[int, int], int] = {}
    for d in range(1, (Q - 1) // 2 + 1):
        for x in range(Q):
            y = (x + d) % Q
            idx = len(same_pairs)
            same_pairs.append((x, y, d))
            same_index[(x, d)] = idx
    assert len(same_pairs) == Q * (Q - 1) // 2

    path_term_indices: List[List[int]] = []
    multiplicity: Counter[int] = Counter()
    for t in range(Q):
        terms: List[int] = []
        for u, v in base_edges:
            a = (u + t) % Q
            b = (v + t) % Q
            delta = (b - a) % Q
            if not (1 <= delta <= Q - 1):
                raise AssertionError("bad translated edge")
            if delta <= (Q - 1) // 2:
                idx = same_index[(a, delta)]
            else:
                d = Q - delta
                idx = same_index[(b, d)]
            terms.append(idx)
            multiplicity[idx] += 1
        assert len(terms) == Q - 1
        path_term_indices.append(terms)
    assert len(path_term_indices) == Q
    assert len(multiplicity) == len(same_pairs)
    assert set(multiplicity.values()) == {2}

    return QuotientData(
        base_path=base_path,
        base_edges=base_edges,
        pair_reps=pair_reps,
        same_pairs=same_pairs,
        path_term_indices=path_term_indices,
    )



def parse_fix_assignments(spec: BranchSpec, fix_specs: Sequence[str]) -> Dict[int, int]:
    fixes: Dict[int, int] = {}
    for raw in fix_specs:
        if ":" not in raw:
            raise SystemExit(f"Bad --fix entry '{raw}'. Expected vertex:ColorName")
        left, right = raw.split(":", 1)
        try:
            vertex = int(left)
        except ValueError as exc:
            raise SystemExit(f"Bad vertex in --fix '{raw}'") from exc
        if not (0 <= vertex < Q):
            raise SystemExit(f"Vertex {vertex} out of range 0..{Q - 1}")
        color = spec.color_index(right)
        if vertex in fixes and fixes[vertex] != color:
            raise SystemExit(f"Conflicting fixes on vertex {vertex}")
        fixes[vertex] = color
    return fixes



def generate_prefixes(
    spec: BranchSpec,
    qd: QuotientData,
    split_depth: int,
    fixes: Dict[int, int],
) -> List[Dict[int, int]]:
    if split_depth <= 0:
        return [dict(fixes)]

    order = [v for v in qd.base_path if v != 0 and v not in fixes]
    if split_depth > len(order):
        raise SystemExit(
            f"split depth {split_depth} exceeds available free anchor vertices {len(order)}"
        )
    anchors = order[:split_depth]

    remaining = list(spec.counts)
    # Translation symmetry break: force vertex 0 to the special color.
    remaining[spec.special_color] -= 1
    if remaining[spec.special_color] < 0:
        raise AssertionError("special color count already negative")

    for v, c in fixes.items():
        if v == 0:
            if c != spec.special_color:
                return []
            continue
        remaining[c] -= 1
        if remaining[c] < 0:
            return []

    prefixes: List[Dict[int, int]] = []
    current = dict(fixes)
    current[0] = spec.special_color

    def rec(i: int) -> None:
        if i == len(anchors):
            prefixes.append(dict(current))
            return
        v = anchors[i]
        for c in range(4):
            if remaining[c] <= 0:
                continue
            current[v] = c
            remaining[c] -= 1
            rec(i + 1)
            remaining[c] += 1
            del current[v]

    rec(0)
    return prefixes



def verify_reduced_solution(spec: BranchSpec, qd: QuotientData, colors: Sequence[int]) -> None:
    if len(colors) != Q:
        raise AssertionError("wrong number of quotient colors")
    if colors[0] != spec.special_color:
        raise AssertionError("vertex 0 is not fixed to the special color")
    counts = [0, 0, 0, 0]
    for c in colors:
        if c not in (0, 1, 2, 3):
            raise AssertionError("invalid color code")
        counts[c] += 1
    if tuple(counts) != spec.counts:
        raise AssertionError(f"wrong color counts: got {tuple(counts)}, expected {spec.counts}")

    total_same = 0
    for x, y, _d in qd.same_pairs:
        if colors[x] == colors[y]:
            total_same += 1
    if total_same != spec.total_same_pairs:
        raise AssertionError(
            f"wrong total same-pair count: got {total_same}, expected {spec.total_same_pairs}"
        )

    for t in range(Q):
        mono = 0
        for u, v in qd.base_edges:
            if colors[(u + t) % Q] == colors[(v + t) % Q]:
                mono += 1
        target = BASE_MONO + (1 if colors[t] == spec.special_color else 0)
        if mono != target:
            raise AssertionError(
                f"path constraint failed at t={t}: got {mono}, expected {target}"
            )



def paley_skew_set() -> set[int]:
    # A[j] = -1 on quadratic residues j!=0, and +1 on 0 and on nonresidues.
    residues = {pow(x, 2, P) for x in range(1, P)}
    residues.discard(0)
    if len(residues) != (P - 1) // 2:
        raise AssertionError("wrong number of quadratic residues")
    return residues



def lift_symmetric_sets(
    spec: BranchSpec,
    qd: QuotientData,
    colors: Sequence[int],
) -> Tuple[set[int], set[int], set[int]]:
    XB: set[int] = {0} if spec.eps_B else set()
    XC: set[int] = {0} if spec.eps_C else set()
    XD: set[int] = {0} if spec.eps_D else set()

    B_members = set(spec.B_members)
    C_members = set(spec.C_members)
    D_members = set(spec.D_members)

    for e, c in enumerate(colors):
        r = qd.pair_reps[e]
        s = (-r) % P
        if c in B_members:
            XB.add(r)
            XB.add(s)
        if c in C_members:
            XC.add(r)
            XC.add(s)
        if c in D_members:
            XD.add(r)
            XD.add(s)

    return XB, XC, XD



def seq_from_set(X: Iterable[int]) -> List[int]:
    seq = [1] * P
    for x in X:
        if not (0 <= x < P):
            raise AssertionError(f"index out of range in set: {x}")
        seq[x] = -1
    return seq



def periodic_autocorrelation(seq: Sequence[int], shift: int) -> int:
    n = len(seq)
    return sum(seq[i] * seq[(i + shift) % n] for i in range(n))



def verify_sequences(
    a: Sequence[int],
    b: Sequence[int],
    c: Sequence[int],
    d: Sequence[int],
) -> None:
    if len(a) != P or len(b) != P or len(c) != P or len(d) != P:
        raise AssertionError("sequence lengths are not 167")

    row_sums = (sum(a), sum(b), sum(c), sum(d))
    if sum(s * s for s in row_sums) != 4 * P:
        raise AssertionError(f"row-sum square identity failed: sums={row_sums}")

    for s in range(1, P):
        val = (
            periodic_autocorrelation(a, s)
            + periodic_autocorrelation(b, s)
            + periodic_autocorrelation(c, s)
            + periodic_autocorrelation(d, s)
        )
        if val != 0:
            raise AssertionError(f"PAF identity failed at shift {s}: value {val}")



def export_solution(
    out_path: str,
    spec: BranchSpec,
    qd: QuotientData,
    colors: Sequence[int],
    XB: Sequence[int],
    XC: Sequence[int],
    XD: Sequence[int],
    a: Sequence[int],
    b: Sequence[int],
    c: Sequence[int],
    d: Sequence[int],
) -> None:
    payload = {
        "prime": P,
        "quotient_order": Q,
        "branch": spec.key,
        "color_names": list(spec.color_names),
        "color_counts": list(spec.counts),
        "special_color": spec.color_names[spec.special_color],
        "quotient_coloring": [spec.color_names[x] for x in colors],
        "pair_representatives": qd.pair_reps,
        "A_set": sorted(paley_skew_set()),
        "B_set": sorted(XB),
        "C_set": sorted(XC),
        "D_set": sorted(XD),
        "A_sequence": list(a),
        "B_sequence": list(b),
        "C_sequence": list(c),
        "D_sequence": list(d),
    }
    with open(out_path, "w", encoding="utf-8") as fh:
        json.dump(payload, fh, indent=2, sort_keys=False)



def solve_with_cpsat(
    spec: BranchSpec,
    qd: QuotientData,
    prefix_fixes: Dict[int, int],
    time_limit: float,
    workers: int,
    log_progress: bool,
    fixed_search: bool,
    seed: int,
) -> SolveResult:
    try:
        from ortools.sat.python import cp_model
    except ImportError as exc:
        raise SearchUnavailable(
            "OR-Tools is required for the search backend. Install with: pip install ortools"
        ) from exc

    model = cp_model.CpModel()

    color = [model.NewIntVar(0, 3, f"color_{v}") for v in range(Q)]
    is_color = [[model.NewBoolVar(f"x_{v}_{c}") for c in range(4)] for v in range(Q)]

    for v in range(Q):
        model.AddExactlyOne(is_color[v])
        for c in range(4):
            model.Add(color[v] == c).OnlyEnforceIf(is_color[v][c])
            model.Add(color[v] != c).OnlyEnforceIf(is_color[v][c].Not())

    for c, need in enumerate(spec.counts):
        model.Add(sum(is_color[v][c] for v in range(Q)) == need)

    # Translation symmetry break.
    model.Add(is_color[0][spec.special_color] == 1)

    for v, c in sorted(prefix_fixes.items()):
        model.Add(is_color[v][c] == 1)

    same = []
    for x, y, _d in qd.same_pairs:
        b = model.NewBoolVar(f"same_{x}_{y}")
        model.Add(color[x] == color[y]).OnlyEnforceIf(b)
        model.Add(color[x] != color[y]).OnlyEnforceIf(b.Not())
        same.append(b)

    for t, idxs in enumerate(qd.path_term_indices):
        model.Add(sum(same[idx] for idx in idxs) == BASE_MONO + is_color[t][spec.special_color])

    model.Add(sum(same) == spec.total_same_pairs)

    order = qd.base_path[:]
    model.AddDecisionStrategy(
        [color[v] for v in order],
        cp_model.CHOOSE_FIRST,
        cp_model.SELECT_MIN_VALUE,
    )

    solver = cp_model.CpSolver()
    if time_limit > 0:
        solver.parameters.max_time_in_seconds = time_limit
    if workers > 0:
        solver.parameters.num_search_workers = workers
    solver.parameters.random_seed = seed
    solver.parameters.log_search_progress = log_progress
    solver.parameters.cp_model_presolve = True
    solver.parameters.symmetry_level = 2
    if fixed_search:
        solver.parameters.search_branching = cp_model.FIXED_SEARCH

    t0 = time.time()
    status = solver.Solve(model)
    elapsed = time.time() - t0

    status_name = solver.StatusName(status)
    if status in (cp_model.OPTIMAL, cp_model.FEASIBLE):
        colors = [solver.Value(color[v]) for v in range(Q)]
        return SolveResult(True, status_name, elapsed, colors=colors)
    return SolveResult(False, status_name, elapsed, colors=None)



def run_branch(
    spec: BranchSpec,
    qd: QuotientData,
    time_limit: float,
    workers: int,
    log_progress: bool,
    fixed_search: bool,
    seed: int,
    split_depth: int,
    job: int,
    jobs: int,
    fixes: Dict[int, int],
    out_dir: str,
) -> SolveResult:
    prefixes = generate_prefixes(spec, qd, split_depth, fixes)
    if not prefixes:
        return SolveResult(False, "PREFIX_INFEASIBLE", 0.0, None, None, None)

    selected = [p for i, p in enumerate(prefixes) if i % jobs == job]
    if not selected:
        return SolveResult(False, "NO_PREFIX_FOR_JOB", 0.0, None, None, None)

    eprint(
        f"[branch {spec.key}] prefixes total={len(prefixes)} selected_for_job={len(selected)} "
        f"job={job}/{jobs} split_depth={split_depth}"
    )

    status_seen: set[str] = set()

    for local_idx, prefix in enumerate(selected, 1):
        eprint(
            f"[branch {spec.key}] solving prefix {local_idx}/{len(selected)}: "
            + ", ".join(f"{v}:{spec.color_names[c]}" for v, c in sorted(prefix.items()))
        )
        res = solve_with_cpsat(
            spec=spec,
            qd=qd,
            prefix_fixes=prefix,
            time_limit=time_limit,
            workers=workers,
            log_progress=log_progress,
            fixed_search=fixed_search,
            seed=seed,
        )
        res.prefix_index = local_idx
        res.prefix_total = len(selected)
        status_seen.add(res.status_name)

        eprint(
            f"[branch {spec.key}] prefix {local_idx}/{len(selected)} status={res.status_name} "
            f"time={res.wall_time:.2f}s"
        )

        if res.found and res.colors is not None:
            verify_reduced_solution(spec, qd, res.colors)

            XA = paley_skew_set()
            XB, XC, XD = lift_symmetric_sets(spec, qd, res.colors)
            a = seq_from_set(XA)
            b = seq_from_set(XB)
            c = seq_from_set(XC)
            d = seq_from_set(XD)
            verify_sequences(a, b, c, d)

            os.makedirs(out_dir, exist_ok=True)
            stamp = int(time.time())
            out_path = os.path.join(out_dir, f"hadamard668_branch_{spec.key}_{stamp}.json")
            export_solution(out_path, spec, qd, res.colors, XB, XC, XD, a, b, c, d)
            eprint(f"[branch {spec.key}] exact verified solution written to {out_path}")
            return res

    if status_seen == {"INFEASIBLE"}:
        final_status = "ALL_SELECTED_PREFIXES_INFEASIBLE"
    elif "UNKNOWN" in status_seen:
        final_status = "NO_SOLUTION_FOUND_WITHIN_LIMITS"
    else:
        final_status = "NO_SOLUTION_IN_SELECTED_PREFIXES"
    return SolveResult(False, final_status, 0.0, None, None, len(selected))



def parse_args(argv: Sequence[str]) -> argparse.Namespace:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--branch",
        choices=("A", "B", "both"),
        default="both",
        help="which reduced exact branch to search",
    )
    ap.add_argument(
        "--time-limit",
        type=float,
        default=0.0,
        help="per-prefix CP-SAT time limit in seconds; 0 means no limit",
    )
    ap.add_argument(
        "--workers",
        type=int,
        default=0,
        help="number of CP-SAT workers; 0 lets OR-Tools choose",
    )
    ap.add_argument(
        "--seed",
        type=int,
        default=0,
        help="CP-SAT random seed",
    )
    ap.add_argument(
        "--fixed-search",
        action="store_true",
        help="force the explicit fixed variable order instead of CP-SAT portfolio search",
    )
    ap.add_argument(
        "--log-progress",
        action="store_true",
        help="enable CP-SAT internal progress logging",
    )
    ap.add_argument(
        "--split-depth",
        type=int,
        default=0,
        help="split the search by fixing the first D nonzero vertices along the base path",
    )
    ap.add_argument(
        "--jobs",
        type=int,
        default=1,
        help="number of deterministic prefix jobs",
    )
    ap.add_argument(
        "--job",
        type=int,
        default=0,
        help="which deterministic prefix job to run (0-indexed)",
    )
    ap.add_argument(
        "--fix",
        action="append",
        default=[],
        help="extra exact color fixing of the form vertex:ColorName; may be repeated",
    )
    ap.add_argument(
        "--out-dir",
        default="solutions_668",
        help="directory where exact verified solutions are written",
    )
    return ap.parse_args(list(argv))



def main(argv: Sequence[str]) -> int:
    args = parse_args(argv)

    if args.jobs <= 0:
        raise SystemExit("--jobs must be >= 1")
    if not (0 <= args.job < args.jobs):
        raise SystemExit("--job must satisfy 0 <= job < jobs")

    qd = build_quotient_data()
    branches = [BRANCHES[args.branch]] if args.branch in BRANCHES else [BRANCHES["A"], BRANCHES["B"]]

    try:
        for spec in branches:
            fixes = parse_fix_assignments(spec, args.fix)
            t0 = time.time()
            result = run_branch(
                spec=spec,
                qd=qd,
                time_limit=args.time_limit,
                workers=args.workers,
                log_progress=args.log_progress,
                fixed_search=args.fixed_search,
                seed=args.seed,
                split_depth=args.split_depth,
                job=args.job,
                jobs=args.jobs,
                fixes=fixes,
                out_dir=args.out_dir,
            )
            elapsed = time.time() - t0
            eprint(f"[branch {spec.key}] finished status={result.status_name} total_time={elapsed:.2f}s")
            if result.found:
                return 0
        return 1
    except SearchUnavailable as exc:
        eprint(str(exc))
        return 2


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
