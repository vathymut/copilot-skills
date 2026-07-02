---
name: query
description: >
  Run SQL queries against the attached DuckDB database or ad-hoc against files.
  Accepts raw SQL or natural language questions. Uses DuckDB Friendly SQL idioms.
argument-hint: <SQL or question> [--file path]
allowed-tools: Bash
---

Input: `$@`

Follow these steps in order.

## Step 1 — Resolve state and determine the mode

Look for an existing state file in either location:

```bash
STATE_DIR=""
test -f .duckdb-skills/state.sql && STATE_DIR=".duckdb-skills"
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")"
PROJECT_ID="$(echo "$PROJECT_ROOT" | tr '/' '-')"
test -f "$HOME/.duckdb-skills/$PROJECT_ID/state.sql" && STATE_DIR="$HOME/.duckdb-skills/$PROJECT_ID"
```

If found, verify the databases it references are still accessible:

```bash
duckdb -init "$STATE_DIR/state.sql" -c "SHOW DATABASES;"
```

Now determine the mode:

- **Ad-hoc mode** if: the `--file` flag is present, or the SQL references file paths/literals (e.g. `FROM 'data.csv'`), or `STATE_DIR` is empty.
- **Session mode** if: `STATE_DIR` is set and the input references table names, is natural language, or is SQL without file references.

If no state file exists and no file is referenced, fall back to ad-hoc mode against `:memory:` — the user must reference files directly in their SQL.

If the state file exists but any ATTACH in it fails, warn the user and fall back to ad-hoc mode.

## Step 2 — Check DuckDB is installed

```bash
command -v duckdb
```

If not found, delegate to `/duckdb-skills:install-duckdb` and then continue.

## Step 3 — Generate SQL if needed

If the input is natural language (not valid SQL), generate SQL using the Friendly SQL reference (`references/friendly-sql.md`).

In **session mode**, first retrieve the schema to inform query generation:

```bash
duckdb -init "$STATE_DIR/state.sql" -csv -c "
SELECT table_name FROM duckdb_tables() ORDER BY table_name;
"
```

Then for relevant tables:

```bash
duckdb -init "$STATE_DIR/state.sql" -csv -c "DESCRIBE <table_name>;"
```

Use the schema context and the Friendly SQL reference to generate the most appropriate query.

## Step 4 — Estimate result size

Before executing, estimate whether the query could produce a very large result that would
consume excessive tokens when returned to this conversation.

**Session mode** — check row counts for the tables involved:

```bash
duckdb -init "$STATE_DIR/state.sql" -csv -c "
SELECT table_name, estimated_size, column_count
FROM duckdb_tables()
WHERE table_name IN ('<table1>', '<table2>');
"
```

**Ad-hoc mode** — probe the source:

```bash
duckdb :memory: -csv -c "
SET allowed_paths=['FILE_PATH'];
SET enable_external_access=false;
SET allow_persistent_secrets=false;
SET lock_configuration=true;
SELECT count() AS row_count FROM 'FILE_PATH';
"
```

**Evaluate**:
- If the query already has a `LIMIT`, `count()`, or other aggregation that bounds the output -> safe, proceed.
- If the source has **>1M rows** and the query has no LIMIT or aggregation -> tell the user:
  *"This query would return a very large result set. Displaying it here would consume a lot of tokens and increase cost. I'd recommend adding `LIMIT 1000` or an aggregation to keep the output manageable."*
  Ask for confirmation before running as-is.
- If the data size is **>10 GB** -> additionally warn:
  *"This table is over 10 GB — the query may take a while to complete."*
  Proceed if the user confirms.

Skip this step for queries that are intrinsically bounded (e.g. `DESCRIBE`, `SUMMARIZE`, aggregations, `count()`).

## Step 5 — Execute the query

**Ad-hoc mode** (sandboxed — only the referenced file is accessible):

```bash
duckdb :memory: -csv <<'SQL'
SET allowed_paths=['FILE_PATH'];
SET enable_external_access=false;
SET allow_persistent_secrets=false;
SET lock_configuration=true;
<QUERY>;
SQL
```

Replace `FILE_PATH` with the actual file path extracted from the query or `--file` argument.
If multiple files are referenced, include all paths in the `allowed_paths` list.

**Session mode** (user-trusted database):

```bash
duckdb -init "$STATE_DIR/state.sql" -csv -c "<QUERY>"
```

For multi-line queries, use a heredoc with `-init`:

```bash
duckdb -init "$STATE_DIR/state.sql" -csv <<'SQL'
<QUERY>;
SQL
```

Always use heredocs (`<<'SQL'`) for multi-line queries to avoid shell quoting issues.

## Step 6 — Handle errors

- **Syntax error**: show the error, suggest a corrected query, and re-run.
- **Missing extension** (e.g. `Extension "X" not loaded`): delegate to `/duckdb-skills:install-duckdb <ext>`, then retry.
- **Table not found** (session mode): list available tables with `FROM duckdb_tables()` and suggest corrections.
- **File not found** (ad-hoc mode): use `find "$PWD" -name "<filename>" 2>/dev/null` to locate the file and suggest the corrected path.
- **Persistent or unclear DuckDB error**: use `/duckdb-skills:duckdb-docs <error message or relevant keywords>` to search the documentation for guidance, then apply the fix and retry.

## Step 7 — Present results

Show the query output to the user. If the result has more than 100 rows, note the truncation and suggest adding `LIMIT` to the query.

For natural language questions, also provide a brief interpretation of the results.

## References (load on demand)

- `references/friendly-sql.md` — DuckDB idiomatic SQL constructs for query generation.
