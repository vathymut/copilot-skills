---
name: data-access
description: Use when the user wants to read, profile, convert, SQL-query, or attach a local or remote data file with DuckDB for analysis — including geographic/spatial data (GeoJSON, Shapefile, GPKG, Overture Maps).
disable-model-invocation: true
argument-hint: "<command> <args> — commands: read, convert, s3, sql, spatial"
allowed-tools: Bash
---

# Data Access

Read, profile, convert, and query local data files and remote object storage with DuckDB.

This skill replaces the former `read-file`, `convert-file`, `s3-explore`, and `query` skills. For natural-language questions about a single file, use `read`; use `sql` for explicit SQL or a registered session database.

## Commands

| Command | Use when |
|---|---|
| `read` | Read or profile a local or remote data file, or answer a question about it. |
| `convert` | Convert a data file from one format to another. |
| `s3` | List, preview, or query data on S3/R2/GCS/MinIO without downloading it. |
| `sql` | Run raw SQL ad-hoc against a file, or against a session database registered with `--attach`. |
| `spatial` | Answer geographic/spatial questions — distances, GeoJSON/Shapefile/GPKG, or Overture Maps analysis. |

---

## Command: `read` <filename or URL> [question]

Read any data file (CSV, JSON, Parquet, Avro, Excel, spatial, SQLite) or remote URL (S3, HTTPS).

`$1` = filename/URL, `$2` = question about the data.

### Step 1 — Resolve and read

If the filename is bare (no `/`), resolve it with `find "$PWD" -name "$1" -not -path '*/.git/*' 2>/dev/null | head -1`.

Run a single DuckDB command using the `read_any` macro from `references/sql-macros.md`.

**If this fails:**
- `duckdb: command not found` → invoke `install-duckdb` and retry.
- Missing extension (spatial, xlsx, sqlite) → prepend `INSTALL spatial; LOAD spatial;` or `INSTALL sqlite_scanner; LOAD sqlite_scanner;`.
- Wrong reader / parse error → use the correct `read_*` function directly.

### Step 2 — Answer

Using the schema, row count, and sample rows, answer the question.
Default: describe column types, row count, and notable patterns.

---

## Command: `convert` <input> [output]

Convert a data file from one format to another.

`$1` = input, `$2` = output path. If `$2` is omitted, default to input stem + `.parquet`.

### Step 1 — Resolve input and output

Infer the output format from the extension:

| Extension | Format clause |
|---|---|
| `.parquet`, `.pq` | *(default)* |
| `.csv` | `(FORMAT csv, HEADER)` |
| `.tsv` | `(FORMAT csv, HEADER, DELIMITER '\t')` |
| `.json` | `(FORMAT json, ARRAY true)` |
| `.jsonl`, `.ndjson` | `(FORMAT json, ARRAY false)` |
| `.xlsx` | `(FORMAT xlsx)` — needs `INSTALL excel; LOAD excel;` |
| `.geojson` | `(FORMAT GDAL, DRIVER 'GeoJSON')` — needs `LOAD spatial;` |
| `.gpkg` | `(FORMAT GDAL, DRIVER 'GPKG')` — needs `LOAD spatial;` |
| `.shp` | `(FORMAT GDAL, DRIVER 'ESRI Shapefile')` — needs `LOAD spatial;` |

### Step 2 — Convert

```bash
duckdb -c "
<EXTENSION_LOADS>
COPY (FROM '<INPUT>') TO '<OUTPUT>' <FORMAT_CLAUSE>;
"
```

For remote inputs, prepend protocol setup per `references/sql-macros.md`.

### Step 3 — Report

On success: input, output, size, and row count.
On failure: delegate missing-extension errors to `install-duckdb`.

---

## Command: `s3` <URL> [question]

Explore data on S3, R2, GCS, or MinIO without downloading it.

`$1` = URL, `$2` = question.

### Step 1 — Detect provider and set up credentials

| Provider | Setup |
|---|---|
| AWS S3 | `CREATE SECRET (TYPE S3, PROVIDER credential_chain);` |
| Cloudflare R2 | `CREATE SECRET (TYPE R2, PROVIDER credential_chain);` — rewrite `r2://` to `s3://` |
| GCS | `CREATE SECRET (TYPE GCS, PROVIDER credential_chain);` |
| MinIO / custom | `CREATE SECRET (TYPE S3, KEY_ID '...', SECRET '...', ENDPOINT '...', USE_SSL true);` |

Always prepend `LOAD httpfs;`. Public buckets need no secret.

### Step 2 — Determine what the URL points to

- **Directory or bucket** (no extension or ends with `/`): list files with sizes via `read_blob('<URL>/*')`.
- **Specific file or glob**: preview with `DESCRIBE FROM '<URL>'`, row count, and `LIMIT 20`.
- **Parquet files**: use `parquet_metadata('<URL>')` for row counts and sizes without downloading.

### Step 3 — Answer

Answer the question using the listing, schema, or sample data. If the user asks an analytical question, write and run the appropriate SQL query.

---

## Command: `sql` <SQL or question> [--file <path>] [--attach <dbpath>]

Run SQL against data. Input is `$@` (minus any `--file`/`--attach` flags).

### `--attach <dbpath>` — register a session database

1. Resolve `<dbpath>` to an absolute path.
2. Validate: `duckdb "<dbpath>" -c "PRAGMA version;"`. Missing file → offer to create (DuckDB writes on first use). Invalid → stop. DuckDB missing → delegate to `install-duckdb`.
3. Resolve state dir: prefer `.duckdb-skills/state.sql` in-project, else `~/.duckdb-skills/<project-id>/state.sql` (project id = repo root with `/` → `-`). Create if absent — ask in-project vs home, and offer `echo '.duckdb-skills/' >> .gitignore`.
4. Append `ATTACH IF NOT EXISTS '<dbpath>' AS <alias>;` to state.sql — **never overwrite**. Alias from filename; on conflict prompt for an alternate. Add `USE <alias>;` only when it is the first/primary database.
5. Verify: `duckdb -init "$STATE_DIR/state.sql" -c "SHOW DATABASES;"`. Report path, alias, state file, and table list. Subsequent `sql` calls use session mode automatically.

**Mode detection and the sandboxed/ad-hoc vs session execution blocks**
are in `references/sql-execution.md` — load it when you actually run a query.

### Generate SQL if needed

If the input is natural language (not valid SQL), generate SQL using `references/friendly-sql.md`. In **session mode**, fetch schema first: `SELECT table_name FROM duckdb_tables() ORDER BY table_name;` then `DESCRIBE <table>;` for relevant tables.

### Estimate result size

Before executing, bound huge outputs. **Session:** check `estimated_size` from `duckdb_tables()`. **Ad-hoc:** `duckdb :memory: -csv -c "SET allowed_paths=['FILE_PATH']; SET enable_external_access=false; SET allow_persistent_secrets=false; SET lock_configuration=true; SELECT count() FROM 'FILE_PATH';"`.

- Query already has `LIMIT`/`count()`/aggregation → safe, proceed.
- Source **>1M rows** with no LIMIT/aggregation → warn it will consume many tokens; ask before running as-is.
- Source **>10 GB** → also warn it may be slow. Proceed only on confirmation.
- Skip for intrinsically bounded queries (`DESCRIBE`, `SUMMARIZE`, aggregations, `count()`).


### Handle errors

- **Syntax error** → show it, suggest a corrected query, re-run.
- **Missing extension** → `install-duckdb <ext>` then retry.
- **Table not found** (session) → list `duckdb_tables()` and suggest corrections.
- **File not found** (ad-hoc) → `find "$PWD" -name "<filename>"` and suggest the corrected path.
- **Persistent/unclear** → `duckdb-docs <error message>` then apply and retry.

### Present

Show the output. If >100 rows, note truncation and suggest `LIMIT`. For natural-language questions, add a one-line interpretation.

---

## Command: `spatial` <question or file> [context]

Answer spatial questions using DuckDB's `spatial` extension and, when needed, Overture Maps as a free global data source. (Absorbed from the former `spatial` skill.)

### Step 1 — Classify the question

| Pattern | Data source | Key functions |
|---------|-------------|---------------|
| "Find X near Y" (no user file) | Overture Maps on S3 | `ST_Distance_Spheroid`, bbox filtering |
| "How far between A and B" | Geocode or user data | `ST_Distance_Spheroid` |
| "Which points fall inside polygons" | User files | `ST_Contains` |
| "Analyze this GeoJSON/Shapefile/GPX" | User file | `ST_Read`, measurement functions |
| "Show density/hotspots" | User or Overture data | H3 hex binning |
| "Convert to GeoJSON/GeoPackage" | User file | `COPY TO (FORMAT GDAL)` |
| "Count buildings/roads in area" | Overture Maps | bbox filtering + aggregation |

If the question involves real-world places, POIs, buildings, roads, or boundaries and the user hasn't provided a file, use **Overture Maps** — read `references/overture.md` for S3 paths and schema. For spatial function syntax, read `references/functions.md`.

### Step 2 — Write and run the query

Always start with:

```sql
LOAD spatial;
SET geometry_always_xy = true;
```

Add extensions as needed:

- Overture/remote data: `LOAD httpfs; CREATE SECRET (TYPE S3, PROVIDER config, REGION 'us-west-2');`
- H3 hex binning: `INSTALL h3 FROM community; LOAD h3;`

**Key principles:**

- **bbox filtering first** — filter on `bbox.xmin/xmax/ymin/ymax` before any spatial function; uses Parquet predicate pushdown.
- **Always set `geometry_always_xy = true`** — interprets coordinates as longitude, latitude (standard for Overture, GeoJSON). Without it, spheroid functions assume latitude first and return wrong results.
- **Use spheroid functions for real-world distances** — `ST_Distance_Spheroid` returns meters on WGS84. Plain `ST_Distance` uses planar coords and is meaningless for lat/lng. Spheroid functions require `POINT_2D` inputs; extract first: `ST_Point(ST_X(geometry), ST_Y(geometry))::POINT_2D`.
- **CSV with lat/lng** → `ST_Point(longitude, latitude)` (longitude first).

Run the query in a single bash call:

```bash
duckdb -c "
LOAD spatial;
<ADDITIONAL_SETUP>
<YOUR_QUERY>
"
```

### Step 3 — Present results

- Tabular: show the data directly.
- Spatial: consider exporting to GeoJSON for visualization (`COPY TO 'result.geojson' WITH (FORMAT GDAL, DRIVER 'GeoJSON')`).
- Distance/area: human-readable units (km large, m small).
- Density/hotspot: describe the pattern, offer to export.

If the query fails:

- `duckdb: command not found` → delegate to `install-duckdb`.
- Missing extension → `INSTALL spatial; LOAD spatial;` or `INSTALL h3 FROM community; LOAD h3;`.
- S3 access denied → check AWS credentials.
- No results with Overture → widen the bbox, check category spelling, or broaden the search.

## References

- `references/sql-macros.md` — `read_any` macro and remote protocol prefixes.
- `references/friendly-sql.md` — idiomatic DuckDB SQL constructs for NL→SQL generation.
- `references/functions.md` — spatial function syntax and examples.
- `references/overture.md` — Overture Maps S3 paths and schema.
