from __future__ import annotations

import argparse
import json
import re
import sys
from collections import Counter
from dataclasses import dataclass
from pathlib import Path
from typing import Any

try:
    import yaml
except ImportError:
    print("Error: PyYAML is required for scripts/lint/validate_registries.py", file=sys.stderr)
    print("Install it with: pip install pyyaml", file=sys.stderr)
    raise SystemExit(1)


THEOREM_ID_RE = re.compile(r"^[a-z0-9-]+\.[a-z0-9-]+\.[a-z0-9-]+\.[a-z0-9-]+\.\d{3}$")


@dataclass
class Finding:
    severity: str
    registry: str
    message: str


def repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


def load_yaml(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as handle:
        return yaml.safe_load(handle)


def add_findings_for_missing_keys(
    findings: list[Finding],
    registry: str,
    payload: dict[str, Any],
    required_keys: list[str],
) -> None:
    for key in required_keys:
        if key not in payload:
            findings.append(Finding("error", registry, f"missing top-level key: {key}"))


def require_entry_fields(
    findings: list[Finding],
    registry: str,
    entry: dict[str, Any],
    required_fields: list[str],
    entry_label: str,
) -> None:
    for field_name in required_fields:
        if field_name not in entry:
            findings.append(Finding("error", registry, f"{entry_label} missing required field: {field_name}"))


def path_exists(root: Path, raw_path: str) -> bool:
    return (root / raw_path).exists()


def validate_manifest(root: Path, findings: list[Finding]) -> dict[str, Any]:
    registry = "lab_manifest.yaml"
    payload = load_yaml(root / registry)
    add_findings_for_missing_keys(
        findings,
        registry,
        payload,
        ["schema_version", "repo", "study_stage", "collections", "reserved_statuses"],
    )

    collections = payload.get("collections", [])
    collection_ids = [entry.get("id") for entry in collections if isinstance(entry, dict)]
    duplicates = [item for item, count in Counter(collection_ids).items() if item and count > 1]
    for duplicate in duplicates:
        findings.append(Finding("error", registry, f"duplicate collection id: {duplicate}"))

    return payload


def validate_source_index(
    root: Path,
    manifest: dict[str, Any],
    findings: list[Finding],
    strict: bool,
) -> dict[str, Any]:
    registry = "source_index.yaml"
    payload = load_yaml(root / registry)
    add_findings_for_missing_keys(
        findings,
        registry,
        payload,
        ["schema_version", "authority_tiers", "collection_defaults", "required_fields", "sources"],
    )

    manifest_collections = {entry["id"] for entry in manifest.get("collections", []) if "id" in entry}
    authority_tiers = {entry["id"] for entry in payload.get("authority_tiers", []) if "id" in entry}
    required_fields = payload.get("required_fields", [])

    for collection_id in payload.get("collection_defaults", {}).keys():
        if collection_id not in manifest_collections:
            findings.append(Finding("error", registry, f"collection_defaults references unknown collection: {collection_id}"))

    for index, entry in enumerate(payload.get("sources", []), start=1):
        label = f"source entry {index}"
        require_entry_fields(findings, registry, entry, required_fields, label)

        collection_id = entry.get("collection")
        if collection_id and collection_id not in manifest_collections:
            findings.append(Finding("error", registry, f"{label} has unknown collection: {collection_id}"))

        reliability_tier = entry.get("reliability_tier")
        if reliability_tier and reliability_tier not in authority_tiers:
            findings.append(Finding("error", registry, f"{label} has unknown reliability_tier: {reliability_tier}"))

        raw_path = entry.get("path")
        if raw_path and not path_exists(root, raw_path):
            severity = "error" if strict else "warning"
            findings.append(Finding(severity, registry, f"{label} path does not exist: {raw_path}"))

    return payload


def validate_notation_registry(
    root: Path,
    manifest: dict[str, Any],
    findings: list[Finding],
) -> dict[str, Any]:
    registry = "notation_registry.yaml"
    payload = load_yaml(root / registry)
    add_findings_for_missing_keys(
        findings,
        registry,
        payload,
        ["schema_version", "house_policy", "required_fields", "entries", "ambiguity_required_fields", "ambiguities"],
    )

    manifest_collections = {entry["id"] for entry in manifest.get("collections", []) if "id" in entry}
    required_fields = payload.get("required_fields", [])
    ambiguity_required_fields = payload.get("ambiguity_required_fields", [])
    entry_ids: list[str] = []

    for index, entry in enumerate(payload.get("entries", []), start=1):
        label = f"notation entry {index}"
        require_entry_fields(findings, registry, entry, required_fields, label)
        if "id" in entry:
            entry_ids.append(entry["id"])

        scope = entry.get("scope", "")
        if isinstance(scope, str) and scope.startswith("collection:"):
            collection_id = scope.split(":", 1)[1]
            if collection_id not in manifest_collections:
                findings.append(Finding("error", registry, f"{label} references unknown collection scope: {collection_id}"))

        for seed_path in entry.get("source_seeds", []):
            if not path_exists(root, seed_path):
                findings.append(Finding("warning", registry, f"{label} source seed does not exist: {seed_path}"))

    for duplicate in [item for item, count in Counter(entry_ids).items() if item and count > 1]:
        findings.append(Finding("error", registry, f"duplicate notation id: {duplicate}"))

    for index, entry in enumerate(payload.get("ambiguities", []), start=1):
        label = f"ambiguity entry {index}"
        require_entry_fields(findings, registry, entry, ambiguity_required_fields, label)
        for collection_id in entry.get("collections", []):
            if collection_id not in manifest_collections:
                findings.append(Finding("error", registry, f"{label} references unknown collection: {collection_id}"))

    return payload


def validate_theorem_index(
    root: Path,
    manifest: dict[str, Any],
    payload: dict[str, Any],
    findings: list[Finding],
    strict: bool,
) -> None:
    registry = "theorem_index.yaml"
    add_findings_for_missing_keys(
        findings,
        registry,
        payload,
        ["schema_version", "id_policy", "required_fields", "entries"],
    )

    manifest_collections = {entry["id"] for entry in manifest.get("collections", []) if "id" in entry}
    reserved_statuses = manifest.get("reserved_statuses", {})
    proof_statuses = set(reserved_statuses.get("proof_status", []))
    extraction_statuses = set(reserved_statuses.get("extraction_status", []))
    normalization_statuses = set(reserved_statuses.get("normalization_status", []))
    required_fields = payload.get("required_fields", [])
    theorem_ids: list[str] = []

    for index, entry in enumerate(payload.get("entries", []), start=1):
        label = f"theorem entry {index}"
        require_entry_fields(findings, registry, entry, required_fields, label)

        theorem_id = entry.get("id")
        if theorem_id:
            theorem_ids.append(theorem_id)
            if not THEOREM_ID_RE.match(theorem_id):
                findings.append(Finding("error", registry, f"{label} has invalid theorem id: {theorem_id}"))

        collection_id = entry.get("collection")
        if collection_id and collection_id not in manifest_collections:
            findings.append(Finding("error", registry, f"{label} has unknown collection: {collection_id}"))

        for field_name, allowed_values in (
            ("proof_status", proof_statuses),
            ("extraction_status", extraction_statuses),
            ("normalization_status", normalization_statuses),
        ):
            value = entry.get(field_name)
            if value and value not in allowed_values:
                findings.append(Finding("error", registry, f"{label} has invalid {field_name}: {value}"))

        raw_path = entry.get("source_path")
        if raw_path and not path_exists(root, raw_path):
            severity = "error" if strict else "warning"
            findings.append(Finding(severity, registry, f"{label} source_path does not exist: {raw_path}"))

    for duplicate in [item for item, count in Counter(theorem_ids).items() if item and count > 1]:
        findings.append(Finding("error", registry, f"duplicate theorem id: {duplicate}"))


def validate_dependency_graph(
    payload: dict[str, Any],
    theorem_payload: dict[str, Any],
    findings: list[Finding],
    strict: bool,
) -> None:
    registry = "dependency_graph.yaml"
    add_findings_for_missing_keys(
        findings,
        registry,
        payload,
        ["schema_version", "node_policy", "required_node_fields", "required_edge_fields", "seed_nodes", "edges"],
    )

    required_node_fields = payload.get("required_node_fields", [])
    required_edge_fields = payload.get("required_edge_fields", [])
    confidence_levels = set(payload.get("node_policy", {}).get("confidence_levels", []))

    graph_node_ids: list[str] = []
    for index, node in enumerate(payload.get("seed_nodes", []), start=1):
        label = f"dependency node {index}"
        require_entry_fields(findings, registry, node, required_node_fields, label)
        if "id" in node:
            graph_node_ids.append(node["id"])

    theorem_ids = {entry.get("id") for entry in theorem_payload.get("entries", []) if entry.get("id")}
    known_nodes = set(graph_node_ids) | theorem_ids

    for duplicate in [item for item, count in Counter(graph_node_ids).items() if item and count > 1]:
        findings.append(Finding("error", registry, f"duplicate dependency node id: {duplicate}"))

    for index, edge in enumerate(payload.get("edges", []), start=1):
        label = f"dependency edge {index}"
        require_entry_fields(findings, registry, edge, required_edge_fields, label)

        confidence = edge.get("confidence")
        if confidence and confidence not in confidence_levels:
            findings.append(Finding("error", registry, f"{label} has invalid confidence: {confidence}"))

        for endpoint_name in ("from", "to"):
            endpoint = edge.get(endpoint_name)
            if endpoint and endpoint not in known_nodes:
                severity = "error" if strict else "warning"
                findings.append(Finding(severity, registry, f"{label} references unknown node {endpoint_name}={endpoint}"))


def validate_formalization_registry(
    payload: dict[str, Any],
    theorem_payload: dict[str, Any],
    findings: list[Finding],
    strict: bool,
) -> None:
    registry = "formalization_registry.yaml"
    add_findings_for_missing_keys(
        findings,
        registry,
        payload,
        ["schema_version", "purpose", "required_fields", "allowed_values", "entries"],
    )

    required_fields = payload.get("required_fields", [])
    allowed_values = payload.get("allowed_values", {})
    theorem_ids = {entry.get("id") for entry in theorem_payload.get("entries", []) if entry.get("id")}

    for index, entry in enumerate(payload.get("entries", []), start=1):
        label = f"formalization entry {index}"
        require_entry_fields(findings, registry, entry, required_fields, label)

        for field_name, allowed in allowed_values.items():
            value = entry.get(field_name)
            if value and value not in set(allowed):
                findings.append(Finding("error", registry, f"{label} has invalid {field_name}: {value}"))

        informal_object_id = entry.get("informal_object_id")
        if informal_object_id and informal_object_id not in theorem_ids:
            severity = "error" if strict else "warning"
            findings.append(
                Finding(severity, registry, f"{label} references unknown informal_object_id: {informal_object_id}")
            )


def build_text_report(registry_summaries: list[tuple[str, int, str]], findings: list[Finding]) -> str:
    grouped: dict[str, list[Finding]] = {}
    for finding in findings:
        grouped.setdefault(finding.registry, []).append(finding)

    lines: list[str] = []
    for registry, entry_count, status in registry_summaries:
        lines.append(f"registry: {registry}")
        lines.append(f"  entries: {entry_count}")
        lines.append(f"  status: {status}")
        issues = grouped.get(registry, [])
        if issues:
            lines.append(f"  findings: {len(issues)}")
            for finding in issues[:5]:
                lines.append(f"    - {finding.severity}: {finding.message}")
        else:
            lines.append("  findings: none")
        lines.append("")

    errors = sum(1 for finding in findings if finding.severity == "error")
    warnings = sum(1 for finding in findings if finding.severity == "warning")
    lines.append(f"summary: {errors} errors, {warnings} warnings")
    return "\n".join(lines).rstrip() + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Validate core math-docs registries without mutating any index files."
    )
    parser.add_argument("--strict", action="store_true", help="Escalate unresolved references to errors.")
    parser.add_argument("--json", action="store_true", help="Emit JSON instead of text.")
    args = parser.parse_args()

    root = repo_root()
    findings: list[Finding] = []

    manifest = validate_manifest(root, findings)
    source_payload = validate_source_index(root, manifest, findings, args.strict)
    notation_payload = validate_notation_registry(root, manifest, findings)
    theorem_payload = load_yaml(root / "theorem_index.yaml")
    validate_theorem_index(root, manifest, theorem_payload, findings, args.strict)
    dependency_payload = load_yaml(root / "dependency_graph.yaml")
    validate_dependency_graph(dependency_payload, theorem_payload, findings, args.strict)
    formal_payload = load_yaml(root / "formalization_registry.yaml")
    validate_formalization_registry(formal_payload, theorem_payload, findings, args.strict)

    registry_summaries = [
        (
            "lab_manifest.yaml",
            len(manifest.get("collections", [])),
            manifest.get("study_stage", {}).get("current_phase", "unknown"),
        ),
        ("source_index.yaml", len(source_payload.get("sources", [])), source_payload.get("status", "unknown")),
        ("notation_registry.yaml", len(notation_payload.get("entries", [])), notation_payload.get("status", "unknown")),
        ("theorem_index.yaml", len(theorem_payload.get("entries", [])), theorem_payload.get("status", "unknown")),
        (
            "dependency_graph.yaml",
            len(dependency_payload.get("seed_nodes", [])) + len(dependency_payload.get("edges", [])),
            dependency_payload.get("status", "unknown"),
        ),
        (
            "formalization_registry.yaml",
            len(formal_payload.get("entries", [])),
            formal_payload.get("status", "unknown"),
        ),
    ]

    if args.json:
        payload = {
            "strict": args.strict,
            "registries": [
                {"registry": registry, "entries": count, "status": status}
                for registry, count, status in registry_summaries
            ],
            "findings": [finding.__dict__ for finding in findings],
            "summary": {
                "errors": sum(1 for finding in findings if finding.severity == "error"),
                "warnings": sum(1 for finding in findings if finding.severity == "warning"),
            },
        }
        print(json.dumps(payload, indent=2, ensure_ascii=False))
    else:
        print(build_text_report(registry_summaries, findings), end="")

    return 1 if any(finding.severity == "error" for finding in findings) else 0


if __name__ == "__main__":
    raise SystemExit(main())