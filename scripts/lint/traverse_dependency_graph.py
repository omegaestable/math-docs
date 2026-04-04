from __future__ import annotations

import argparse
import json
import sys
from collections import Counter, deque
from pathlib import Path
from typing import Any

try:
    import yaml
except ImportError:
    print("Error: PyYAML is required for scripts/lint/traverse_dependency_graph.py", file=sys.stderr)
    print("Install it with: pip install pyyaml", file=sys.stderr)
    raise SystemExit(1)


def repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


def load_yaml(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as handle:
        return yaml.safe_load(handle)


def build_graph(root: Path) -> tuple[dict[str, Any], dict[str, str], dict[str, set[str]], dict[str, set[str]], list[dict[str, Any]]]:
    dependency_payload = load_yaml(root / "dependency_graph.yaml")
    theorem_payload = load_yaml(root / "theorem_index.yaml")

    labels: dict[str, str] = {}
    for node in dependency_payload.get("seed_nodes", []):
        node_id = node.get("id")
        if node_id:
            labels[node_id] = node.get("label", node_id)

    for entry in theorem_payload.get("entries", []):
        theorem_id = entry.get("id")
        if theorem_id:
            labels[theorem_id] = entry.get("label", theorem_id)

    adjacency: dict[str, set[str]] = {node_id: set() for node_id in labels}
    reverse: dict[str, set[str]] = {node_id: set() for node_id in labels}
    missing_edges: list[dict[str, Any]] = []

    for edge in dependency_payload.get("edges", []):
        source = edge.get("from")
        target = edge.get("to")
        if source not in labels or target not in labels:
            missing_edges.append(edge)
            continue
        adjacency.setdefault(source, set()).add(target)
        reverse.setdefault(target, set()).add(source)

    return dependency_payload, labels, adjacency, reverse, missing_edges


def bfs(start: str, graph: dict[str, set[str]], depth: int | None) -> list[str]:
    seen = {start}
    queue: deque[tuple[str, int]] = deque([(start, 0)])
    order: list[str] = []

    while queue:
        node_id, current_depth = queue.popleft()
        if depth is not None and current_depth >= depth:
            continue
        for neighbor in sorted(graph.get(node_id, set())):
            if neighbor in seen:
                continue
            seen.add(neighbor)
            order.append(neighbor)
            queue.append((neighbor, current_depth + 1))
    return order


def detect_cycles(adjacency: dict[str, set[str]]) -> list[list[str]]:
    cycles: list[list[str]] = []
    temporary: set[str] = set()
    permanent: set[str] = set()
    stack: list[str] = []

    def visit(node_id: str) -> None:
        if node_id in permanent:
            return
        if node_id in temporary:
            if node_id in stack:
                start_index = stack.index(node_id)
                cycles.append(stack[start_index:] + [node_id])
            return

        temporary.add(node_id)
        stack.append(node_id)
        for neighbor in sorted(adjacency.get(node_id, set())):
            visit(neighbor)
        stack.pop()
        temporary.remove(node_id)
        permanent.add(node_id)

    for node_id in sorted(adjacency):
        if node_id not in permanent:
            visit(node_id)

    return cycles


def make_summary(
    dependency_payload: dict[str, Any],
    labels: dict[str, str],
    adjacency: dict[str, set[str]],
    reverse: dict[str, set[str]],
    missing_edges: list[dict[str, Any]],
) -> dict[str, Any]:
    edge_count = sum(len(values) for values in adjacency.values())
    isolated_count = sum(1 for node_id in labels if not adjacency.get(node_id) and not reverse.get(node_id))
    entry_points = sorted(node_id for node_id in labels if not reverse.get(node_id))
    leaf_nodes = sorted(node_id for node_id in labels if not adjacency.get(node_id))
    confidence_counts = Counter(edge.get("confidence", "unknown") for edge in dependency_payload.get("edges", []))
    cycles = detect_cycles(adjacency)

    return {
        "node_count": len(labels),
        "edge_count": edge_count,
        "isolated_count": isolated_count,
        "entry_points": entry_points,
        "leaf_nodes": leaf_nodes,
        "missing_edge_references": len(missing_edges),
        "cycle_count": len(cycles),
        "confidence_counts": dict(confidence_counts),
        "cycles": cycles,
    }


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Traverse dependency_graph.yaml in a read-only way."
    )
    parser.add_argument("node_id", nargs="?", help="Optional node id to inspect.")
    parser.add_argument(
        "--direction",
        choices=["forward", "backward", "both"],
        default="both",
        help="Traversal direction for node queries.",
    )
    parser.add_argument(
        "--depth",
        type=int,
        default=1,
        help="Traversal depth for node queries. Use 0 for immediate node metadata only.",
    )
    parser.add_argument("--json", action="store_true", help="Emit JSON instead of text.")
    args = parser.parse_args()

    root = repo_root()
    dependency_payload, labels, adjacency, reverse, missing_edges = build_graph(root)

    if not labels and not dependency_payload.get("edges"):
        if args.json:
            print(json.dumps({"status": "empty-graph", "message": "No nodes or edges in dependency graph."}, indent=2))
        else:
            print("No nodes or edges in dependency graph (dependency_graph.yaml is still scaffold-only).")
        return 0

    summary = make_summary(dependency_payload, labels, adjacency, reverse, missing_edges)

    if not args.node_id:
        if args.json:
            print(json.dumps(summary, indent=2, ensure_ascii=False))
        else:
            print(f"nodes: {summary['node_count']}")
            print(f"edges: {summary['edge_count']}")
            print(f"isolated: {summary['isolated_count']}")
            print(f"entry_points: {len(summary['entry_points'])}")
            print(f"leaf_nodes: {len(summary['leaf_nodes'])}")
            print(f"missing_edge_references: {summary['missing_edge_references']}")
            print(f"cycle_count: {summary['cycle_count']}")
            if summary["cycle_count"]:
                print("cycles:")
                for cycle in summary["cycles"]:
                    print(f"  - {' -> '.join(cycle)}")
        return 0

    node_id = args.node_id
    if node_id not in labels:
        print(f"Unknown node_id: {node_id}", file=sys.stderr)
        return 1

    depth = None if args.depth < 0 else args.depth
    prerequisites = bfs(node_id, reverse, depth) if args.direction in {"backward", "both"} else []
    dependents = bfs(node_id, adjacency, depth) if args.direction in {"forward", "both"} else []

    payload = {
        "node_id": node_id,
        "label": labels[node_id],
        "direction": args.direction,
        "depth": args.depth,
        "prerequisites": prerequisites,
        "dependents": dependents,
    }

    if args.json:
        print(json.dumps(payload, indent=2, ensure_ascii=False))
    else:
        print(f"NODE: {node_id}")
        print(f"  label: {labels[node_id]}")
        if args.direction in {"backward", "both"}:
            print(f"  prerequisites: {prerequisites}")
        if args.direction in {"forward", "both"}:
            print(f"  dependents: {dependents}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())