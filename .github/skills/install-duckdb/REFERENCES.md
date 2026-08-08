# REFERENCES — CLI version check & platform upgrade

## Check CLI version

```bash
CURRENT=$(duckdb --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
LATEST=$(curl -fsSL https://duckdb.org/data/latest_stable_version.txt)
```

- `CURRENT` == `LATEST` → report the CLI is up to date.
- `CURRENT` != `LATEST` → tell the user and ask whether to upgrade now.

## Platform-specific CLI upgrade commands

| Platform | Command |
|---|---|
| macOS (Homebrew) | `brew upgrade duckdb` |
| Linux | `curl -fsSL https://install.duckdb.org \| sh` |
| Windows | `winget upgrade DuckDB.cli` |

Run the upgrade only after the user agrees. Re-verify with `duckdb --version` afterwards.
