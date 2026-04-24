from __future__ import annotations

import argparse
import importlib
import json
import shutil
import subprocess
import sys
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any


@dataclass
class CheckResult:
    name: str
    status: str
    detail: str
    artifacts: list[str]


def repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


def run_command(args: list[str], cwd: Path, expected_exit_codes: set[int] | None = None) -> subprocess.CompletedProcess[str]:
    completed = subprocess.run(args, cwd=cwd, capture_output=True, text=True)
    allowed = expected_exit_codes or {0}
    if completed.returncode not in allowed:
        output = (completed.stdout + "\n" + completed.stderr).strip()
        excerpt = "\n".join(output.splitlines()[:40])
        raise RuntimeError(
            f"command failed with exit code {completed.returncode}: {' '.join(args)}\n{excerpt}".rstrip()
        )
    return completed


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def run_scan(root: Path, artifact_dir: Path) -> tuple[CheckResult, Path]:
    output_path = artifact_dir / "tex_scan_report.json"
    run_command(
        [
            sys.executable,
            str(root / "scripts" / "index" / "scan_tex_sources.py"),
            "--root",
            str(root),
            "--output",
            str(output_path),
        ],
        cwd=root,
    )
    payload = load_json(output_path)
    summary = payload.get("summary", {})
    files_scanned = int(summary.get("files_scanned", 0))
    section_count = int(summary.get("section_count", 0))
    if files_scanned <= 0:
        raise RuntimeError("scan_tex_sources.py produced an empty file set")
    if section_count <= 0:
        raise RuntimeError("scan_tex_sources.py did not detect any sections")
    return (
        CheckResult(
            name="tex-scan",
            status="passed",
            detail=f"scanned {files_scanned} TeX files and found {section_count} sections",
            artifacts=[output_path.relative_to(root).as_posix()],
        ),
        output_path,
    )


def run_candidate_generation(root: Path, artifact_dir: Path, scan_report: Path) -> CheckResult:
    output_path = artifact_dir / "candidate_ids.json"
    run_command(
        [
            sys.executable,
            str(root / "scripts" / "index" / "generate_candidate_ids.py"),
            "--scan-report",
            str(scan_report),
            "--output",
            str(output_path),
        ],
        cwd=root,
    )
    payload = load_json(output_path)
    summary = payload.get("summary", {})
    files_with_candidates = int(summary.get("files_with_candidates", 0))
    candidate_count = int(summary.get("candidate_count", 0))
    if files_with_candidates <= 0 or candidate_count <= 0:
        raise RuntimeError("generate_candidate_ids.py produced no candidates")
    return CheckResult(
        name="candidate-ids",
        status="passed",
        detail=f"generated {candidate_count} candidate ids across {files_with_candidates} files",
        artifacts=[output_path.relative_to(root).as_posix()],
    )


def run_registry_validation(root: Path) -> CheckResult:
    completed = run_command(
        [sys.executable, str(root / "scripts" / "lint" / "validate_registries.py"), "--json"],
        cwd=root,
    )
    payload = json.loads(completed.stdout)
    summary = payload.get("summary", {})
    errors = int(summary.get("errors", 0))
    warnings = int(summary.get("warnings", 0))
    if errors != 0 or warnings != 0:
        raise RuntimeError(f"validate_registries.py reported {errors} errors and {warnings} warnings")
    registry_count = len(payload.get("registries", []))
    return CheckResult(
        name="registry-validation",
        status="passed",
        detail=f"validated {registry_count} registries with 0 findings",
        artifacts=[],
    )


def run_dependency_traversal(root: Path) -> CheckResult:
    completed = run_command(
        [sys.executable, str(root / "scripts" / "lint" / "traverse_dependency_graph.py"), "--json"],
        cwd=root,
    )
    payload = json.loads(completed.stdout)
    if payload.get("status") == "empty-graph":
        return CheckResult(
            name="dependency-traversal",
            status="passed",
            detail="dependency graph is scaffold-only and reports empty-graph as expected",
            artifacts=[],
        )
    node_count = int(payload.get("node_count", 0))
    edge_count = int(payload.get("edge_count", 0))
    return CheckResult(
        name="dependency-traversal",
        status="passed",
        detail=f"loaded dependency graph with {node_count} nodes and {edge_count} edges",
        artifacts=[],
    )


def run_hadamard_smoke(root: Path) -> CheckResult:
    try:
        from ortools.sat.python import cp_model  # noqa: F401
    except ImportError as exc:
        raise RuntimeError("OR-Tools is not installed") from exc

    if str(root) not in sys.path:
        sys.path.insert(0, str(root))
    module = importlib.import_module("research.search_hadamard_668")
    quotient_data = module.build_quotient_data()
    if len(quotient_data.base_path) != 83:
        raise RuntimeError("unexpected quotient base path length")
    if len(quotient_data.base_edges) != 82:
        raise RuntimeError("unexpected quotient base edge count")
    if sorted(module.BRANCHES.keys()) != ["A", "B"]:
        raise RuntimeError("unexpected branch configuration in search_hadamard_668.py")
    return CheckResult(
        name="hadamard-smoke",
        status="passed",
        detail="imported the research search module, OR-Tools, and built quotient data",
        artifacts=[],
    )


def run_tex_smoke(root: Path, tex_targets: list[str], tex_passes: int) -> CheckResult:
    if not tex_targets:
        return CheckResult(
            name="tex-smoke",
            status="skipped",
            detail="no TeX targets were provided",
            artifacts=[],
        )

    pdflatex = shutil.which("pdflatex")
    if pdflatex is None:
        raise RuntimeError("pdflatex was not found on PATH")

    compiled: list[str] = []
    for raw_target in tex_targets:
        tex_path = (root / raw_target).resolve()
        if not tex_path.exists():
            raise RuntimeError(f"missing TeX target: {raw_target}")
        if tex_path.suffix.lower() != ".tex":
            raise RuntimeError(f"TeX target must end with .tex: {raw_target}")

        for _ in range(tex_passes):
            run_command(
                [
                    pdflatex,
                    "-interaction=nonstopmode",
                    "-halt-on-error",
                    "-file-line-error",
                    tex_path.name,
                ],
                cwd=tex_path.parent,
            )

        pdf_path = tex_path.with_suffix(".pdf")
        if not pdf_path.exists():
            raise RuntimeError(f"expected PDF was not produced for {raw_target}")
        compiled.append(raw_target.replace("\\", "/"))

    return CheckResult(
        name="tex-smoke",
        status="passed",
        detail=f"compiled {len(compiled)} TeX targets with pdflatex",
        artifacts=compiled,
    )


def format_text(results: list[CheckResult]) -> str:
    lines: list[str] = []
    for result in results:
        lines.append(f"[{result.status.upper()}] {result.name}: {result.detail}")
        if result.artifacts:
            lines.append(f"  artifacts: {', '.join(result.artifacts)}")
    passed = sum(1 for result in results if result.status == "passed")
    failed = sum(1 for result in results if result.status == "failed")
    skipped = sum(1 for result in results if result.status == "skipped")
    lines.append("")
    lines.append(f"summary: {passed} passed, {failed} failed, {skipped} skipped")
    return "\n".join(lines) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description="Run an integration check over the repo's Python tooling and optional TeX targets.")
    parser.add_argument("--json", action="store_true", help="Emit the report as JSON.")
    parser.add_argument("--with-tex", action="store_true", help="Also compile explicit TeX smoke targets with pdflatex.")
    parser.add_argument(
        "--tex-target",
        action="append",
        default=[],
        help="Repo-relative .tex file to compile when --with-tex is set. May be repeated.",
    )
    parser.add_argument(
        "--tex-passes",
        type=int,
        default=2,
        help="Number of pdflatex passes per TeX smoke target.",
    )
    args = parser.parse_args()

    root = repo_root()
    artifact_dir = root / ".tmp" / "integration"
    artifact_dir.mkdir(parents=True, exist_ok=True)

    results: list[CheckResult] = []

    try:
        scan_result, scan_report = run_scan(root, artifact_dir)
        results.append(scan_result)
    except Exception as exc:
        results.append(CheckResult("tex-scan", "failed", str(exc), []))
        scan_report = None

    if scan_report is not None:
        try:
            results.append(run_candidate_generation(root, artifact_dir, scan_report))
        except Exception as exc:
            results.append(CheckResult("candidate-ids", "failed", str(exc), []))
    else:
        results.append(CheckResult("candidate-ids", "skipped", "skipped because TeX scan did not complete", []))

    for name, runner in (
        ("registry-validation", lambda: run_registry_validation(root)),
        ("dependency-traversal", lambda: run_dependency_traversal(root)),
        ("hadamard-smoke", lambda: run_hadamard_smoke(root)),
    ):
        try:
            results.append(runner())
        except Exception as exc:
            results.append(CheckResult(name, "failed", str(exc), []))

    if args.with_tex:
        try:
            results.append(run_tex_smoke(root, args.tex_target, args.tex_passes))
        except Exception as exc:
            results.append(CheckResult("tex-smoke", "failed", str(exc), []))
    else:
        results.append(CheckResult("tex-smoke", "skipped", "re-run with --with-tex and one or more --tex-target values to include LaTeX compilation", []))

    if args.json:
        print(json.dumps([asdict(result) for result in results], indent=2, ensure_ascii=False))
    else:
        print(format_text(results), end="")

    return 1 if any(result.status == "failed" for result in results) else 0


if __name__ == "__main__":
    raise SystemExit(main())