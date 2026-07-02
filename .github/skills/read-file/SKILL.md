---
name: read-file
description: >
  Read any data file (CSV, JSON, Parquet, Avro, Excel, spatial, SQLite) or remote URL (S3, HTTPS).
  Use when user references a data file, asks "what's in this file", or wants to preview/profile a dataset.
  Not for source code.
argument-hint: <filename or URL> [question about the data]
allowed-tools: Bash
---

Filename given: `$0`
Question: `${1:-describe the data}`

## Step 1 — Read it

`RESOLVED_PATH` is `$0`. If the user gave a bare filename (no `/`), resolve it to a full path with `find` first.

Run a single DuckDB command that defines the `read_any` macro inline and reads the file. The full macro and protocol prefixes are in `references/sql-macros.md` — read it to compose the command.

**If this fails:**
- **`duckdb: command not found`** → invoke `/duckdb-skills:install-duckdb` and retry.
- **Missing extension** (e.g. spatial files, xlsx, sqlite) → retry with `INSTALL spatial; LOAD spatial;` or `INSTALL sqlite_scanner; LOAD sqlite_scanner;` prepended before the macro.
- **Wrong reader / parse error** → use the correct `read_*` function directly instead of `read_any`.

## Step 2 — Answer

Using the schema, row count, and sample rows, answer:

`${1:-describe the data: summarize column types, row count, and any notable patterns.}`

## References (load on demand)

- `references/sql-macros.md` — the `read_any` inline macro, remote protocol prefixes, and the DESCRIBE/count/sample query shape.
