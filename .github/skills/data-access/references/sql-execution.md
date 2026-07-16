# SQL command — mode detection & execution (extracted)

Load when running the `sql` command.

### Determine the mode

Look for an existing state file in either location:

```bash
STATE_DIR=""
test -f .duckdb-skills/state.sql && STATE_DIR=".duckdb-skills"
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")"
PROJECT_ID="$(echo "$PROJECT_ROOT" | tr '/' '-')"
test -f "$HOME/.duckdb-skills/$PROJECT_ID/state.sql" && STATE_DIR="$HOME/.duckdb-skills/$PROJECT_ID"
```

- **Session mode** if `STATE_DIR` is set and the input references table names, is natural language, or is SQL without file references.
- **Ad-hoc mode** if `--file` is given, the SQL references file paths/literals (e.g. `FROM 'data.csv'`), or `STATE_DIR` is empty. No state file and no file referenced → ad-hoc against `:memory:` (user must reference files directly).
- If a state ATTACH fails, warn the user and fall back to ad-hoc.

### Execute

**Ad-hoc (sandboxed — only the referenced file is accessible):**

```bash
duckdb :memory: -csv <<'SQL'
SET allowed_paths=['FILE_PATH'];
SET enable_external_access=false;
SET allow_persistent_secrets=false;
SET lock_configuration=true;
<QUERY>;
SQL
```

**Session (trusted database):**

```bash
duckdb -init "$STATE_DIR/state.sql" -csv -c "<QUERY>"
# multi-line → heredoc with -init
```
