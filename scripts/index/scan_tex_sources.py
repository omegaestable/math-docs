from __future__ import annotations

import argparse
import json
import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Iterable


SECTION_RE = re.compile(r"^\\(chapter|section|subsection|subsubsection)\*?\{(?P<title>.*)\}")
LABEL_RE = re.compile(r"\\label\{(?P<label>[^}]+)\}")
NEWCOMMAND_RE = re.compile(r"\\(?:re)?newcommand\{\\(?P<name>[A-Za-z]+)\}")
DECLARE_OP_RE = re.compile(r"\\DeclareMathOperator\{\\(?P<name>[A-Za-z]+)\}\{(?P<body>[^}]+)\}")
NEWTHEOREM_RE = re.compile(r"\\newtheorem\*?\{(?P<name>[A-Za-z]+)\}")
NEWTCBTHEOREM_RE = re.compile(r"\\newtcbtheorem(?:\[[^\]]+\])?\{(?P<name>[A-Za-z]+)\}\{(?P<title>[^}]*)\}")
BEGIN_ENV_RE = re.compile(r"\\begin\{(?P<name>[A-Za-z*]+)\}")
INCLUDE_RE = re.compile(r"\\(?:include|input)\{(?P<target>[^}]+)\}")

DEFAULT_SKIP_DIRS = {".git", ".tmp", ".vscode", ".claude", ".agent"}
THEOREM_LIKE_HINTS = {
    "theorem",
    "teorema",
    "lemma",
    "lem",
    "proposition",
    "prop",
    "corollary",
    "cor",
    "definition",
    "def",
    "defn",
    "remark",
    "rem",
    "fact",
}


@dataclass
class TexFileReport:
    path: str
    sections: list[dict[str, object]] = field(default_factory=list)
    labels: list[str] = field(default_factory=list)
    macros: list[dict[str, str]] = field(default_factory=list)
    theorem_definitions: list[dict[str, str]] = field(default_factory=list)
    theorem_usages: list[dict[str, object]] = field(default_factory=list)
    includes: list[str] = field(default_factory=list)


def iter_tex_files(root: Path) -> Iterable[Path]:
    for path in sorted(root.rglob("*.tex")):
        if any(part in DEFAULT_SKIP_DIRS for part in path.parts):
            continue
        yield path


def classify_env(name: str) -> str:
    lowered = name.lower()
    if lowered in THEOREM_LIKE_HINTS:
        return "theorem-like"
    if any(token in lowered for token in ("teore", "theorem", "lemma", "prop", "def", "cor", "remark", "fact")):
        return "theorem-like"
    return "other"


def scan_tex_file(path: Path, root: Path) -> TexFileReport:
    report = TexFileReport(path=path.relative_to(root).as_posix())
    text = path.read_text(encoding="utf-8", errors="replace")

    for line_number, line in enumerate(text.splitlines(), start=1):
        section_match = SECTION_RE.search(line)
        if section_match:
            report.sections.append(
                {
                    "kind": section_match.group(1),
                    "title": section_match.group("title"),
                    "line": line_number,
                }
            )

        for label_match in LABEL_RE.finditer(line):
            report.labels.append(label_match.group("label"))

        newcommand_match = NEWCOMMAND_RE.search(line)
        if newcommand_match:
            report.macros.append(
                {
                    "kind": "newcommand",
                    "name": newcommand_match.group("name"),
                    "line": str(line_number),
                }
            )

        declare_op_match = DECLARE_OP_RE.search(line)
        if declare_op_match:
            report.macros.append(
                {
                    "kind": "DeclareMathOperator",
                    "name": declare_op_match.group("name"),
                    "body": declare_op_match.group("body"),
                    "line": str(line_number),
                }
            )

        newtheorem_match = NEWTHEOREM_RE.search(line)
        if newtheorem_match:
            env_name = newtheorem_match.group("name")
            report.theorem_definitions.append(
                {
                    "kind": "newtheorem",
                    "name": env_name,
                    "classification": classify_env(env_name),
                    "line": str(line_number),
                }
            )

        newtcbtheorem_match = NEWTCBTHEOREM_RE.search(line)
        if newtcbtheorem_match:
            env_name = newtcbtheorem_match.group("name")
            report.theorem_definitions.append(
                {
                    "kind": "newtcbtheorem",
                    "name": env_name,
                    "title": newtcbtheorem_match.group("title"),
                    "classification": classify_env(env_name),
                    "line": str(line_number),
                }
            )

        for begin_match in BEGIN_ENV_RE.finditer(line):
            env_name = begin_match.group("name")
            classification = classify_env(env_name)
            if classification == "theorem-like":
                report.theorem_usages.append(
                    {
                        "name": env_name,
                        "classification": classification,
                        "line": line_number,
                    }
                )

        for include_match in INCLUDE_RE.finditer(line):
            report.includes.append(include_match.group("target"))

    return report


def build_summary(file_reports: list[TexFileReport]) -> dict[str, object]:
    theorem_env_names = sorted(
        {
            entry["name"]
            for report in file_reports
            for entry in report.theorem_definitions
            if entry["classification"] == "theorem-like"
        }
    )

    return {
        "files_scanned": len(file_reports),
        "section_count": sum(len(report.sections) for report in file_reports),
        "label_count": sum(len(report.labels) for report in file_reports),
        "macro_count": sum(len(report.macros) for report in file_reports),
        "theorem_definition_count": sum(len(report.theorem_definitions) for report in file_reports),
        "theorem_usage_count": sum(len(report.theorem_usages) for report in file_reports),
        "theorem_like_environment_names": theorem_env_names,
    }


def make_payload(root: Path) -> dict[str, object]:
    reports = [scan_tex_file(path, root) for path in iter_tex_files(root)]
    return {
        "schema_version": "0.1.0",
        "mode": "non-mutating-tex-structure-scan",
        "root": root.as_posix(),
        "summary": build_summary(reports),
        "files": [report.__dict__ for report in reports],
    }


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Scan TeX sources and emit a structure report without modifying repository indexes."
    )
    parser.add_argument(
        "--root",
        default=".",
        help="Repository root to scan. Defaults to the current directory.",
    )
    parser.add_argument(
        "--output",
        help="Optional path for the JSON report. If omitted, prints to stdout.",
    )
    args = parser.parse_args()

    root = Path(args.root).resolve()
    payload = make_payload(root)
    rendered = json.dumps(payload, indent=2, ensure_ascii=False)

    if args.output:
        output_path = Path(args.output)
        if not output_path.is_absolute():
            output_path = root / output_path
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text(rendered + "\n", encoding="utf-8")
    else:
        print(rendered)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())