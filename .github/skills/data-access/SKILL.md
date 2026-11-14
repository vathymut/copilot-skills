---
name: data-access
description: Use when the user wants to read, profile, convert, SQL-query, or attach a local or remote data file with DuckDB for analysis — including geographic/spatial data (GeoJSON, Shapefile, GPKG, Overture Maps).
argument-hint: "<command> <args> — commands: read, convert, s3, sql, spatial, docs, install"
allowed-tools: Bash
---

# Data Access

Read, profile, convert, and query local/remote data with DuckDB. For geographic/spatial work (GeoJSON/Shapefile/Overture), load `references/spatial.md` (extracted from § spatial below).

## When NOT to use

- The question is about a DuckDB SQL function or syntax in the abstract — use the `docs` command (below).
- The data exploration is a one-time bootstrap before an ML experiment — do it once here, then move on to the experiment (this skill stays available for ad-hoc SQL).
- No DuckDB available and the file is tiny (few KB) — plain `Read`/`pandas` is faster than installing DuckDB.

## Pre-flight

```
Pre-flight (data-access):
- [ ] duckdb available (duckdb --version)
- [ ] Extensions loaded: spatial, httpfs (as needed)
- [ ] Credentials configured (S3/R2/GCS secrets)
- [ ] Session-attach DB path resolved
```

## Commands

| Command | Use when | Loads |
|---|---|
| `read` | Read/profile a local or remote data file | `references/sql-macros.md` |
| `convert` | Convert between formats | `references/sql-macros.md` |
| `s3` | List/preview/query S3/R2/GCS/MinIO | `references/sql-macros.md` |
| `sql` | Run SQL ad-hoc or against session database | `references/session-setup.md`, `references/sql-execution.md` |
| `spatial` | Geographic/spatial queries | `references/spatial.md` + `references/overture.md` |
| `docs` | Search DuckDB/DuckLake docs for a function or error | `references/docs-search.md` |
| `install` | Install/update DuckDB extensions or the CLI | — |

---

## `read` <filename or URL> [question]

Resolve bare filename via `find "$PWD" -name "$1" -not -path '*/.git/*'`. Run `read_any` macro from `references/sql-macros.md`. Fail: missing `duckdb` → § install; missing extension → `INSTALL` + `LOAD`; wrong reader → use correct `read_*`.

Answer: schema, row count, sample rows, notable patterns.

---

## `convert` <input> [output]

| Extension | Format clause |
|---|---|
| `.parquet`, `.pq` | default |
| `.csv` | `(FORMAT csv, HEADER)` |
| `.tsv` | `(FORMAT csv, HEADER, DELIMITER '\t')` |
| `.json` | `(FORMAT json, ARRAY true)` |
| `.jsonl` / `.ndjson` | `(FORMAT json, ARRAY false)` |
| `.xlsx` | `(FORMAT xlsx)` — needs `INSTALL excel; LOAD excel;` |
| `.geojson` / `.gpkg` / `.shp` | `(FORMAT GDAL, DRIVER '...')` — needs `LOAD spatial;` |

Run: `duckdb -c "COPY (FROM '<INPUT>') TO '<OUTPUT>' <FORMAT>;"`. Report input, output, size, row count. For remote inputs, prepend protocol setup per `references/sql-macros.md`.

- User asks for partitioning ("partition by year") → add `PARTITION_BY (col)` — Parquet and CSV output only.
- User asks for compression ("use zstd") → add `CODEC 'zstd'` for Parquet output.

---

## `s3` <URL> [question]

| Provider | Setup |
|---|---|
| AWS S3 | `CREATE SECRET (TYPE S3, PROVIDER credential_chain);` |
| Cloudflare R2 | rewrite `r2://` → `s3://` + `CREATE SECRET (TYPE R2, ...)` |
| GCS | `CREATE SECRET (TYPE GCS, PROVIDER credential_chain);` |
| MinIO | `CREATE SECRET (TYPE S3, KEY_ID '...', SECRET '...', ENDPOINT '...', USE_SSL true);` |

Always `LOAD httpfs;`. **Public buckets** (e.g. Overture Maps, AWS open data) need no secret — skip setup.

- **URL is a directory/bucket** (no file extension or ends with `/`): list contents with sizes via `read_blob` — select only `filename`, `size`, `last_modified`, never `content` (it would download the files):

  ```sql
  SELECT filename, (size / 1024 / 1024)::DECIMAL(10,1) AS size_mb, last_modified
  FROM read_blob('<URL>/*') ORDER BY filename LIMIT 50;
  ```

- **URL is a file or glob**: `DESCRIBE FROM`, row count, `LIMIT 20`.
- **Parquet**: rows/compressed size from metadata only, no data download:

  ```sql
  SELECT file_name, sum(row_group_num_rows) AS total_rows,
         (sum(row_group_compressed_bytes) / 1024 / 1024)::DECIMAL(10,1) AS compressed_mb
  FROM parquet_metadata('<URL>') GROUP BY file_name;
  ```

Errors: 403 → check credentials (`aws configure`, env vars, or explicit key/secret); 404 → check URL and region; timeout on large listing → narrow the glob pattern or add a prefix.

---

## `sql` <SQL or question> [--file <path>] [--attach <dbpath>]

**`--attach` setup:** resolve DB path, validate, resolve state dir (`.duckdb-skills/state.sql`), append `ATTACH IF NOT EXISTS` to state file, verify. Full procedure → `references/session-setup.md`. Execution mode (sandboxed vs session): `references/sql-execution.md`.

**Generate SQL:** NL input → `references/friendly-sql.md`. Session mode: fetch schema first. **Estimate result size** before execution: >1M rows w/o LIMIT → warn; >10 GB → warn. **Errors:** syntax → show + suggest; missing ext → § install; table not found → list tables; file not found → find + correct path; unclear → § docs.

**Present:** show output. >100 rows → note truncation. NL questions → one-line interpretation.

---

## `docs` <question or keyword>

Search DuckDB/DuckLake documentation and blog posts. Full-text (BM25) search against a locally cached index. Full procedure → `references/docs-search.md`.

Sketch: `INSTALL httpfs; INSTALL fts;` → refresh cache if older than 2 days (`COPY FROM DATABASE remote TO tmp` against `https://duckdb.org/data/docs-search.duckdb`) → `match_bm25` query, top 8 → synthesize an answer first, then show sources. Query mentions DuckLake → use the DuckLake index (`ducklake.select/data/docs-search.duckdb`) with `version = 'stable'`.

---

## `spatial` <question or file> [context]

Geographic/spatial queries using DuckDB `spatial` extension + Overture Maps. Full procedure → `references/spatial.md`.

On failure: missing duckdb → § install; missing ext → `INSTALL spatial`; S3 access → check creds; no Overture results → widen bbox.

## Completion criteria

- [ ] `read`/`s3`/`sql` → file/schema/row-count/sample or SQL output with truncation note (>100 rows noted, >1M rows warned)
- [ ] `convert` → input/output/size/row-count reported; remote inputs use protocol setup from `references/sql-macros.md`
- [ ] `spatial` → starts with `LOAD spatial; SET geometry_always_xy = true;` and bbox-filter first
- [ ] `install` → extension installed via `INSTALL`/`LOAD` and verified with `SELECT * FROM duckdb_extensions()`

## Related skills

- `tufte-data-viz` — chart the queried data.
- `research` — capture findings from a multi-source investigation (this skill runs the data queries inside it).

---

## `install` [ext1 ext2@repo ...] [--update]

Install or upgrade DuckDB extensions; upgrade the CLI. Extension args: `name` → `INSTALL name;`; `name@repo` → `INSTALL name FROM repo;`.

| Flag | Mode | DuckDB invocation |
|------|------|-------------------|
| (none) | Install | `duckdb :memory: -c "INSTALL <ext1>; INSTALL <ext2> FROM <repo2>;"` |
| `--update` | Update CLI + extensions | Check CLI version first (below), then `duckdb :memory: -c "UPDATE EXTENSIONS;"` |

Locate: `DUCKDB=$(command -v duckdb)`. Not found → tell the user to install it (brew, `curl -fsSL https://install.duckdb.org | sh`, or winget), then stop.

**CLI upgrade (`--update`):** compare `CURRENT=$(duckdb --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')` against `LATEST=$(curl -fsSL https://duckdb.org/data/latest_stable_version.txt)`. Different → ask before upgrading: macOS `brew upgrade duckdb`; Linux `curl -fsSL https://install.duckdb.org | sh`; Windows `winget upgrade DuckDB.cli`. Re-verify with `duckdb --version`.
