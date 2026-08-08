---
name: duckdb-docs
description: Use when the user needs DuckDB or DuckLake documentation, function syntax, or error explanations not already in the local cache.
argument-hint: "<question or keyword>"
allowed-tools: Bash
---

You are helping the user find relevant DuckDB or DuckLake documentation.

Query: `$@`

## Decision tree

### 1. Is DuckDB installed?

```bash
command -v duckdb
```

If not → delegate to `install-duckdb`, then continue.

### 2. What version of DuckDB?

Run `duckdb --version`. If ≥1.2.0, use the DuckDB docs search index. If <1.2.0 or unknown, fall back to streaming queries over HTTP (see 5‑b below).

### 3. Choose the data source

| Index | Remote URL | Cache file | Versions | Use when |
|-------|-----------|------------|----------|----------|
| **DuckDB docs** | `https://duckdb.org/data/docs-search.duckdb` | `duckdb-docs.duckdb` | `lts`, `current`, `blog` | Default |
| **DuckLake docs** | `https://ducklake.select/data/docs-search.duckdb` | `ducklake-docs.duckdb` | `stable`, `preview` | Query mentions DuckLake |

Default version = `lts`. Switch to `current` for nightly features, `blog` for background posts. Omit version filter when unsure.

### 4. Extract search terms

Natural-language question → extract nouns, function names, SQL keywords. Drop stop words. Function name → use as-is. Result is `SEARCH_QUERY`.

### 5. Fetch and cache (single command)

```bash
bash duckdb-docs:scripts/fetch-docs.sh "$HOME/.duckdb/docs/duckdb-docs.duckdb" "https://duckdb.org/data/docs-search.duckdb"
```

For DuckLake: cache file `ducklake-docs.duckdb`, remote `https://ducklake.select/data/docs-search.duckdb`.

If the fetch fails → network unavailable → report and fall through to 5‑b.

#### 5‑b. Fallback: stream live from duckdb.org

```bash
bash duckdb-docs:scripts/stream-live.sh "SEARCH_QUERY"
```

### 6. Search cached index (skip if fallback was used above)

```bash
bash duckdb-docs:scripts/search-docs.sh "$HOME/.duckdb/docs/duckdb-docs.duckdb" "SEARCH_QUERY" "VERSION"
```

Omit the version argument to search all versions. If no results → drop terms and retry; still empty → report none found and suggest duckdb.org/docs.

### 7. Present results

Per result:
```
### {section} — {page_title}
{url}

{text}

---
```

After all chunks, synthesize a concise answer to `$@`. If chunks answer directly, lead with the answer before sources.
