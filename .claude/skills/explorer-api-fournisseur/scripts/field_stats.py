#!/usr/bin/env python3
"""Taux de remplissage des champs sur un échantillon de payloads JSON.

Mesure, pour chaque champ (chemin aplati), la part d'entités où il est
renseigné (non null, non chaîne vide, non liste/dict vide). Indispensable pour
distinguer un champ « théorique » (présent au schéma, toujours vide) d'un champ
réellement exploitable.

Affiche aussi le nombre de **valeurs distinctes** par champ scalaire : un champ
rempli à 100 % mais avec 1 seule valeur distincte sur un échantillon de
plusieurs entités est un signal d'**environnement à fixtures** (données canned,
non représentatives) — exiger alors une recette avec vraies données.

Usage:
  field_stats.py fichiers.json...           # un objet par fichier
  field_stats.py --key data.items liste.json # une liste sous une clé
  field_stats.py --format markdown *.json > stats_champs.md
  field_stats.py --format csv *.json > stats_champs.csv
  cat liste.json | field_stats.py -          # liste JSON sur stdin
"""
import argparse
import csv
import json
import sys
from collections import Counter, defaultdict


SCALAR_TYPES = (str, int, float, bool)
ENUM_NAME_HINTS = (
    "type",
    "statut",
    "status",
    "etat",
    "state",
    "categorie",
    "category",
    "code",
    "nature",
    "qualite",
    "role",
)


def is_filled(v):
    if v is None:
        return False
    if isinstance(v, (str, list, dict)) and len(v) == 0:
        return False
    return True


def is_scalar(v):
    return v is None or isinstance(v, SCALAR_TYPES)


def type_name(v):
    if v is None:
        return "null"
    if isinstance(v, bool):
        return "boolean"
    if isinstance(v, int) and not isinstance(v, bool):
        return "integer"
    if isinstance(v, float):
        return "number"
    if isinstance(v, str):
        return "string"
    if isinstance(v, list):
        return "array"
    if isinstance(v, dict):
        return "object"
    return type(v).__name__


def example_value(values):
    for value in values:
        if not is_filled(value):
            continue
        if isinstance(value, SCALAR_TYPES):
            text = str(value)
        else:
            text = json.dumps(value, ensure_ascii=False, sort_keys=True)
        return text[:117] + "..." if len(text) > 120 else text
    return ""


def get_by_key(data, key):
    current = data
    for part in key.split("."):
        if not isinstance(current, dict) or part not in current:
            raise KeyError(f"Clé introuvable: {key}")
        current = current[part]
    return current


def walk(obj, prefix, out, list_lengths):
    if prefix:
        out[prefix].append(obj)

    if isinstance(obj, dict):
        for k, v in obj.items():
            p = f"{prefix}.{k}" if prefix else k
            walk(v, p, out, list_lengths)
    elif isinstance(obj, list):
        if prefix:
            list_lengths[prefix].append(len(obj))
        for item in obj:
            walk(item, f"{prefix}[]", out, list_lengths)


def nearest_list_path(path):
    idx = path.rfind("[]")
    if idx == -1:
        return None
    return path[:idx]


def load_json(path):
    if path == "-":
        return json.load(sys.stdin)
    with open(path) as f:
        return json.load(f)


def coerce_records(data, key):
    if key:
        data = get_by_key(data, key)
    if isinstance(data, list):
        return data
    if isinstance(data, dict):
        return [data]
    raise TypeError("Le JSON racine doit être un objet ou une liste.")


def load_records(paths, key):
    records = []
    for path in paths or ["-"]:
        records.extend(coerce_records(load_json(path), key))
    return records


def build_stats(records):
    n = len(records)
    if n == 0:
        raise ValueError("Aucun enregistrement.")

    record_seen = Counter()
    record_filled = Counter()
    item_seen = Counter()
    item_filled = Counter()
    values_by_path = defaultdict(list)
    list_lengths = defaultdict(list)
    types_by_path = defaultdict(Counter)
    enum_values = defaultdict(Counter)

    for r in records:
        per_record = defaultdict(list)
        walk(r, "", per_record, list_lengths)
        for path, values in per_record.items():
            record_seen[path] += 1
            values_by_path[path].extend(values)
            for value in values:
                types_by_path[path][type_name(value)] += 1
                if is_scalar(value) and is_filled(value):
                    enum_values[path][str(value)] += 1
            if any(is_filled(value) for value in values):
                record_filled[path] += 1

    for path, values in values_by_path.items():
        item_seen[path] = len(values)
        item_filled[path] = sum(1 for value in values if is_filled(value))

    return {
        "n": n,
        "record_seen": record_seen,
        "record_filled": record_filled,
        "item_seen": item_seen,
        "item_filled": item_filled,
        "values_by_path": values_by_path,
        "list_lengths": list_lengths,
        "types_by_path": types_by_path,
        "enum_values": enum_values,
    }


def row_for_path(path, stats, enum_limit):
    n = stats["n"]
    values = stats["values_by_path"][path]
    record_filled = stats["record_filled"][path]
    filled_pct = 100 * record_filled / n
    list_values = stats["list_lengths"].get(path, [])
    list_min = min(list_values) if list_values else ""
    list_max = max(list_values) if list_values else ""
    list_avg = f"{sum(list_values) / len(list_values):.1f}" if list_values else ""
    list_path = nearest_list_path(path)
    item_total = sum(stats["list_lengths"].get(list_path, [])) if list_path else ""
    item_filled = stats["item_filled"][path] if list_path else ""
    item_pct = (100 * item_filled / item_total) if item_total else ""
    enum = enum_summary(path, stats["enum_values"][path], enum_limit)

    return {
        "path": path,
        "types": ", ".join(sorted(stats["types_by_path"][path])),
        "present_records": stats["record_seen"][path],
        "filled_records": record_filled,
        "total_records": n,
        "filled_pct": f"{filled_pct:.0f}%",
        "distinct": len(stats["enum_values"][path]),
        "item_filled": item_filled,
        "item_total": item_total,
        "item_filled_pct": f"{item_pct:.0f}%" if item_pct != "" else "",
        "list_min": list_min,
        "list_max": list_max,
        "list_avg": list_avg,
        "example": example_value(values),
        "enum_values": enum,
    }


def enum_summary(path, counts, enum_limit):
    if not counts:
        return ""
    looks_like_enum = any(hint in path.lower().split(".")[-1] for hint in ENUM_NAME_HINTS)
    has_repeated_values = len(counts) < sum(counts.values())
    if not looks_like_enum and (len(counts) > enum_limit or not has_repeated_values):
        return ""
    values = counts.most_common(enum_limit)
    suffix = "..." if len(counts) > enum_limit else ""
    return ", ".join(f"{value} ({count})" for value, count in values) + suffix


def fixture_warning(rows, n):
    if n < 10:
        return ""
    suspects = [r["path"] for r in rows if r["distinct"] == 1 and r["filled_records"] == n]
    if not suspects:
        return ""
    head = ", ".join(suspects[:8]) + ("…" if len(suspects) > 8 else "")
    return (
        f"\n⚠️  {len(suspects)} champ(s) remplis à 100 % avec 1 SEULE valeur "
        f"distincte sur {n} enregistrements : {head}\n"
        "    → suspecter des données de fixtures (canned), non représentatives. "
        "Exiger une recette avec vraies données.\n"
    )


def render_text(stats, enum_limit):
    rows = [row_for_path(path, stats, enum_limit) for path in sorted(stats["values_by_path"])]
    width = max(len(row["path"]) for row in rows)
    print(f"n = {stats['n']} enregistrements\n")
    for row in rows:
        suffixes = []
        if row["item_total"] != "":
            suffixes.append(f"items {row['item_filled_pct']} ({row['item_filled']}/{row['item_total']})")
        if row["list_avg"] != "":
            suffixes.append(f"liste min/max/moy {row['list_min']}/{row['list_max']}/{row['list_avg']}")
        if row["enum_values"]:
            suffixes.append(f"valeurs: {row['enum_values']}")
        suffix = "  |  " + " ; ".join(suffixes) if suffixes else ""
        distinct = f" d={row['distinct']}" if row["distinct"] else ""
        print(
            f"{row['path']:<{width}}  {row['filled_pct']:>4} "
            f"({row['filled_records']}/{row['total_records']}){distinct}  "
            f"{row['types']}{suffix}"
        )
    warning = fixture_warning(rows, stats["n"])
    if warning:
        print(warning)


def render_markdown(stats, enum_limit):
    rows = [row_for_path(path, stats, enum_limit) for path in sorted(stats["values_by_path"])]
    print(f"n = {stats['n']} enregistrements\n")
    warning = fixture_warning(rows, stats["n"])
    if warning:
        print("> " + warning.strip().replace("\n", "\n> ") + "\n")
    print("| Champ | Type(s) | Remplissage | Distinct | Items | Cardinalité liste | Exemple | Valeurs observées |")
    print("|---|---|---:|---:|---:|---:|---|---|")
    for row in rows:
        items = ""
        if row["item_total"] != "":
            items = f"{row['item_filled_pct']} ({row['item_filled']}/{row['item_total']})"
        cardinality = ""
        if row["list_avg"] != "":
            cardinality = f"{row['list_min']}/{row['list_max']}/{row['list_avg']}"
        print(
            "| {path} | {types} | {filled_pct} ({filled_records}/{total_records}) | "
            "{distinct} | {items} | {cardinality} | {example} | {enum_values} |".format(
                **{key: markdown_cell(value) for key, value in row.items()},
                items=items,
                cardinality=cardinality,
            )
        )


def markdown_cell(value):
    return str(value).replace("\n", " ").replace("|", "\\|")


def render_csv(stats, enum_limit):
    rows = [row_for_path(path, stats, enum_limit) for path in sorted(stats["values_by_path"])]
    fieldnames = [
        "path",
        "types",
        "present_records",
        "filled_records",
        "total_records",
        "filled_pct",
        "distinct",
        "item_filled",
        "item_total",
        "item_filled_pct",
        "list_min",
        "list_max",
        "list_avg",
        "example",
        "enum_values",
    ]
    writer = csv.DictWriter(sys.stdout, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(rows)


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("files", nargs="*", help="Fichiers JSON à analyser, ou '-' pour stdin.")
    parser.add_argument("--key", help="Clé contenant la liste à analyser, notation pointée acceptée.")
    parser.add_argument("--format", choices=("text", "markdown", "csv"), default="text")
    parser.add_argument("--enum-limit", type=int, default=10, help="Nombre max de valeurs d'énumération affichées.")
    return parser.parse_args()


def main():
    args = parse_args()
    try:
        stats = build_stats(load_records(args.files, args.key))
    except (KeyError, TypeError, ValueError, json.JSONDecodeError) as e:
        print(str(e), file=sys.stderr)
        sys.exit(1)

    if args.format == "markdown":
        render_markdown(stats, args.enum_limit)
    elif args.format == "csv":
        render_csv(stats, args.enum_limit)
    else:
        render_text(stats, args.enum_limit)


if __name__ == "__main__":
    main()
