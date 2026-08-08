# `--attach` setup procedure

Load when the user passes `--attach <dbpath>`.

## 1. Resolve the DB path

- Relative path → resolve against the project root (`git rev-parse --show-toplevel`, else `$PWD`).
- `~` expansion → `$HOME`.
- Quoted path with spaces → keep quoted through every command.

## 2. Validate

- File must exist and be a DuckDB database. Quick check: `duckdb -readonly -c "SELECT 1" <dbpath>` succeeds.
- If the path doesn't exist or isn't a database, stop and tell the user — do not create an empty file silently.

## 3. Resolve the state dir

Precedence (same as `sql-execution.md`):

```bash
STATE_DIR=""
test -f .duckdb-skills/state.sql && STATE_DIR=".duckdb-skills"
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")"
PROJECT_ID="$(echo "$PROJECT_ROOT" | tr '/' '-')"
test -f "$HOME/.duckdb-skills/$PROJECT_ID/state.sql" && STATE_DIR="$HOME/.duckdb-skills/$PROJECT_ID"
```

- Found → use it.
- Not found → create `.duckdb-skills/state.sql` (repo-local) if the project is a git repo, else `$HOME/.duckdb-skills/$PROJECT_ID/state.sql`.

## 4. Append the ATTACH

```bash
echo "ATTACH IF NOT EXISTS '<dbpath>' AS <alias>;" >> "$STATE_DIR/state.sql"
```

- `IF NOT EXISTS` so re-attaching the same DB is idempotent.
- Alias: short, meaningful (e.g. `sales`, `warehouse`). Default to the DB filename stem if the user didn't name one.

## 5. Verify

```bash
duckdb -init "$STATE_DIR/state.sql" -c "SHOW ALL TABLES;" 2>&1 | head
```

- Confirm the attach loaded: tables from the attached DB are visible.
- On failure, report the error and fall back to ad-hoc mode per `sql-execution.md`.
