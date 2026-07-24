---
name: data-access
description: Use when the user wants to read, profile, convert, SQL-query, or attach a local or remote data file with DuckDB for analysis — including geographic/spatial data (GeoJSON, Shapefile, GPKG, Overture Maps).
disable-model-invocation: true
argument-hint: "<command> <args> — commands: read, convert, s3, sql, spatial"
allowed-tools: Bash
---

# Data Access

Read, profile, convert, and query local/remote data with DuckDB. Replaces former `read-file`, `convert-file`, `s3-explore`, and `query` skills.

## Pre-flight

```
Pre-flight (data-access):
- [ ] duckdb available (duckdb --version)
- [ ] Extensions loaded: spatial, httpfs (as needed)
- [ ] Credentials configured (S3/R2/GCS secrets)
- [ ] Session-attach DB path resolved
```

## Commands

| Command | Use when |
|---|---|
| `read` | Read/profile a local or remote data file |
| `convert` | Convert between formats |
| `s3` | List/preview/query S3/R2/GCS/MinIO |
| `sql` | Run SQL ad-hoc or against session database |
| `spatial` | Geographic/spatial queries |

---

## `read` <filename or URL> [question]

Resolve bare filename via `find "$PWD" -name "$1" -not -path '*/.git/*'`. Run `read_any` macro from `references/sql-macros.md`. Fail: missing `duckdb` → `install-duckdb`; missing extension → `INSTALL` + `LOAD`; wrong reader → use correct `read_*`.

Answer: schema, row count, sample rows, notable patterns.

---

## `convert` <input> [output]

| Extension | Format clause |
|---|---|
| `.parquet`, `.pq` | default |
| `.csv` | `(FORMAT csv, HEADER)` |
| `.tsv` | `(FORMAT csv, HEADER, DELIMITER '\t')` |
| `.json` | `(FORMAT json, ARRAY true)` |
| `.jsonl` | `(FORMAT json, ARRAY false)` |
| `.xlsx` | `(FORMAT xlsx)` — needs `INSTALL excel; LOAD excel;` |
| `.geojson` / `.gpkg` / `.shp` | `(FORMAT GDAL, DRIVER '...')` — needs `LOAD spatial;` |

Run: `duckdb -c "COPY (FROM '<INPUT>') TO '<OUTPUT>' <FORMAT>;"`. Report input, output, size, row count. For remote inputs, prepend protocol setup per `references/sql-macros.md`.

---

## `s3` <URL> [question]

| Provider | Setup |
|---|---|
| AWS S3 | `CREATE SECRET (TYPE S3, PROVIDER credential_chain);` |
| Cloudflare R2 | rewrite `r2://` → `s3://` + `CREATE SECRET (TYPE R2, ...)` |
| GCS | `CREATE SECRET (TYPE GCS, PROVIDER credential_chain);` |
| MinIO | `CREATE SECRET (TYPE S3, KEY_ID '...', SECRET '...', ENDPOINT '...', USE_SSL true);` |

Always `LOAD httpfs;`. Directory → `read_blob('<URL>/*')`. File → `DESCRIBE FROM`, row count, `LIMIT 20`. Parquet → `parquet_metadata('<URL>')`.

---

## `sql` <SQL or question> [--file <path>] [--attach <dbpath>]

**`--attach` setup:** resolve DB path, validate, resolve state dir (`.duckdb-skills/state.sql`), append `ATTACH IF NOT EXISTS` to state file, verify. Full procedure → `references/session-setup.md`.

**Generate SQL:** NL input → `references/friendly-sql.md`. Session mode: fetch schema first. **Estimate result size** before execution: >1M rows w/o LIMIT → warn; >10 GB → warn. **Errors:** syntax → show + suggest; missing ext → `install-duckdb`; table not found → list tables; file not found → find + correct path; unclear → `duckdb-docs`.

**Present:** show output. >100 rows → note truncation. NL questions → one-line interpretation.

---

## `spatial` <question or file> [context]

Geographic/spatial queries using DuckDB `spatial` extension + Overture Maps.

Always start with:
```sql
LOAD spatial; SET geometry_always_xy = true;
```

Key patterns:
- Real-world places / POIs / buildings / roads (no user file) → Overture Maps: `references/overture.md`.
- Distance / containment / conversion → `references/functions.md`.
- Density / hotspots → H3 hex binning: `INSTALL h3 FROM community; LOAD h3;`.

**Principles:** bbox-filter first (Parquet pushdown), `geometry_always_xy = true`, use `ST_Distance_Spheroid` for real-world distances, CSV lat/lng → `ST_Point(longitude, latitude)`.

On failure: missing duckdb → `install-duckdb`; missing ext → `INSTALL spatial`; S3 access → check creds; no Overture results → widen bbox.

## References

- `references/session-setup.md` — `--attach` procedure
- `references/sql-macros.md` — `read_any` macro, remote protocol prefixes
- `references/sql-execution.md` — sandboxed vs session mode
- `references/friendly-sql.md` — NL→SQL generation
- `references/functions.md` — spatial function syntax
- `references/overture.md` — Overture Maps S3 paths and schema
