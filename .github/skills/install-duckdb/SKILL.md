---
name: install-duckdb
description: Use when DuckDB is missing an extension, needs an extension upgraded, or the CLI itself is outdated.
argument-hint: "[--update] [ext1 ext2@repo ext3 ...]"
allowed-tools: Bash
disable-model-invocation: true
---

Arguments: `$@`

Each extension argument has the form `name` or `name@repo`.
- `name` → `INSTALL name;`
- `name@repo` → `INSTALL name FROM repo;`

## Decision table

| Flag | Mode | DuckDB invocation |
|------|------|-------------------|
| (none) | Install | `duckdb :memory: -c "INSTALL <ext1>; INSTALL <ext2> FROM <repo2>;"` |
| `--update` | Update CLI + extensions | Check CLI version first (see REFERENCES.md), then `duckdb :memory: -c "UPDATE EXTENSIONS;"` |

## Usage

```bash
duckdb :memory: -c "INSTALL <ext1>; INSTALL <ext2> FROM <repo2>;"
duckdb :memory: -c "UPDATE EXTENSIONS;"
duckdb :memory: -c "UPDATE EXTENSIONS (<ext1>, <ext2>);"
```

## Locate DuckDB

```bash
DUCKDB=$(command -v duckdb)
```

If not found, tell the user to install it first (brew, curl -fsSL https://install.duckdb.org | sh, or winget) then re-run.

Stop if DuckDB is not found.

For platform-specific CLI upgrade commands, see [REFERENCES.md](REFERENCES.md).
