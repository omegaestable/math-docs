from __future__ import annotations

import argparse
import json
import re
import unicodedata
from collections import defaultdict
from pathlib import Path


SLUG_RE = re.compile(r"[^a-z0-9]+")


def slugify(value: str) -> str:
    normalized = unicodedata.normalize("NFKD", value).encode("ascii", "ignore").decode("ascii")
    lowered = normalized.lower()
    slug = SLUG_RE.sub("-", lowered).strip("-")
    return slug or "item"


def infer_collection(path: str) -> str:
    first = Path(path).parts[0].lower()
    mapping = {
        "books": "books",
        "lmfi": "lmfi",
        "undergrad": "undergrad",
        "first proof": "first-proof",
    }
    return mapping.get(first, "unknown")


def infer_work_slug(path: str) -> str:
    file_path = Path(path)
    if file_path.suffix.lower() == ".tex":
        return slugify(file_path.stem)
    return slugify(file_path.name)


def make_candidate_id(collection: str, work_slug: str, local_slug: str, kind: str, sequence: int) -> str:
    return f"{collection}.{work_slug}.{local_slug}.{kind}.{sequence:03d}"


def build_candidates(payload: dict[str, object]) -> dict[str, object]:
    file_candidates: list[dict[str, object]] = []

    for file_entry in payload.get("files", []):
        path = file_entry["path"]
        collection = infer_collection(path)
        work_slug = infer_work_slug(path)
        counters: defaultdict[tuple[str, str], int] = defaultdict(int)
        candidates: list[dict[str, object]] = []

        for section in file_entry.get("sections", []):
            local_slug = slugify(section["title"])
            key = (section["kind"], local_slug)
            counters[key] += 1
            candidates.append(
                {
                    "candidate_id": make_candidate_id(collection, work_slug, local_slug, section["kind"], counters[key]),
                    "object_type": "section",
                    "kind": section["kind"],
                    "title": section["title"],
                    "source_path": path,
                    "source_locator": f"line:{section['line']}",
                    "review_status": "unreviewed",
                }
            )

        for theorem_usage in file_entry.get("theorem_usages", []):
            local_slug = slugify(theorem_usage["name"])
            key = ("theorem-usage", local_slug)
            counters[key] += 1
            candidates.append(
                {
                    "candidate_id": make_candidate_id(collection, work_slug, local_slug, "candidate", counters[key]),
                    "object_type": "theorem-candidate",
                    "kind": theorem_usage["name"],
                    "title": theorem_usage["name"],
                    "source_path": path,
                    "source_locator": f"line:{theorem_usage['line']}",
                    "review_status": "unreviewed",
                }
            )

        for label in file_entry.get("labels", []):
            local_slug = slugify(label)
            key = ("label", local_slug)
            counters[key] += 1
            candidates.append(
                {
                    "candidate_id": make_candidate_id(collection, work_slug, local_slug, "label", counters[key]),
                    "object_type": "label",
                    "kind": "label",
                    "title": label,
                    "source_path": path,
                    "source_locator": "label",
                    "review_status": "unreviewed",
                }
            )

        file_candidates.append(
            {
                "path": path,
                "collection": collection,
                "work_slug": work_slug,
                "candidate_count": len(candidates),
                "candidates": candidates,
            }
        )

    return {
        "schema_version": "0.1.0",
        "mode": "candidate-id-generation",
        "status": "candidate-only",
        "summary": {
            "files_with_candidates": len(file_candidates),
            "candidate_count": sum(entry["candidate_count"] for entry in file_candidates),
        },
        "files": file_candidates,
    }


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Generate deterministic candidate IDs from a TeX scan report without modifying repository indexes."
    )
    parser.add_argument(
        "--scan-report",
        required=True,
        help="Path to the JSON report produced by scan_tex_sources.py.",
    )
    parser.add_argument(
        "--output",
        help="Optional path for the candidate ID JSON output. If omitted, prints to stdout.",
    )
    args = parser.parse_args()

    report_path = Path(args.scan_report).resolve()
    payload = json.loads(report_path.read_text(encoding="utf-8"))
    rendered = json.dumps(build_candidates(payload), indent=2, ensure_ascii=False)

    if args.output:
        output_path = Path(args.output)
        if not output_path.is_absolute():
            output_path = report_path.parent / output_path
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text(rendered + "\n", encoding="utf-8")
    else:
        print(rendered)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())