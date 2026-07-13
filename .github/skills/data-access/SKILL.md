---
name: data-access
description: User-invoked skill for reading, profiling, converting, and accessing data files and remote object storage. Invoke when the user references a data file, asks "what's in this file", wants to preview/profile/convert a dataset, or mentions S3/R2/GCS/MinIO URLs.
disable-model-invocation: true
argument-hint: <command> <args> — commands: read, convert, s3
allowed-tools: Bash
---

# Data Access

Read, profile, convert, and query local data files and remote object storage with DuckDB.

This skill replaces the former `read-file`, `convert-file`, and `s3-explore` skills.

## Commands

| Command | Use when |
|---|---|
| `read` | Read or profile a local or remote data file. |
| `convert` | Convert a data file from one format to another. |
| `s3` | List, preview, or query data on S3/R2/GCS/MinIO without downloading it. |

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

## References

- `references/sql-macros.md` — `read_any` macro and remote protocol prefixes.
