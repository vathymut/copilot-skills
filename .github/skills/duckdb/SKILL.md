---
name: duckdb
description: User-invoked router for DuckDB-related skills. Type this skill name to see which DuckDB skill to use.
disable-model-invocation: true
---

# DuckDB Router

Index of DuckDB skills. Invoke the right skill by name (all children are user-invoked; `query` also exposes an `--attach <path>` mode for registering a database).

| Skill | Use when |
|---|---|
| `query` | Run SQL against an attached database or ad-hoc against files; `--attach <path>` to register a DB. |
| `data-access` | Read, profile, convert, or query data files and remote object storage. |
| `spatial` | Query or analyze spatial data with DuckDB's spatial extension. |
| `duckdb-docs` | Search DuckDB or DuckLake documentation and blog posts. |
| `install-duckdb` | Install or update DuckDB extensions. |

Note: `read-file`, `convert-file`, and `s3-explore` were merged into `data-access`; `attach-db` was merged into `query`.
