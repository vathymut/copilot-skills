---
disable-model-invocation: true
name: duckdb-docs
description: Use when the user needs DuckDB or DuckLake documentation, function syntax, or error explanations not already in the local cache.
argument-hint: <question or keyword>
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
CACHE="$HOME/.duckdb/docs/CACHE_FILENAME"; REMOTE="REMOTE_URL"
mkdir -p "$HOME/.duckdb/docs"
[ -f "$CACHE" ] && [ "$(( $(date +%s) - $(stat -f %m "$CACHE") ))" -lt 172800 ] \
  && echo "cache fresh" \
  || duckdb -c "LOAD httpfs; LOAD fts; ATTACH '$REMOTE' AS r (READ_ONLY); COPY FROM DATABASE r TO '$CACHE.tmp';" \
     && mv "$CACHE.tmp" "$CACHE"
```

If the fetch fails → network unavailable → report and fall through to 5‑b.

#### 5‑b. Fallback: stream live from duckdb.org

```bash
curl -s "https://duckdb.org/docs/api/query.html?query=$(python3 -c 'import urllib.parse; print(urllib.parse.quote("SEARCH_QUERY"))')" \
  | python3 -c "import sys,json,html; d=json.load(sys.stdin); [print(f\"### {r['title']}\\n{r['url']}\\n\\n{html.unescape(r['snippet'])}\") for r in d.get('results',[])]" 2>/dev/null \
  || echo "Fallback unavailable; visit https://duckdb.org/docs"
```

### 6. Search cached index (skip if fallback was used above)

```bash
duckdb "$HOME/.duckdb/docs/CACHE_FILENAME" -readonly -json -c "
LOAD fts;
SELECT chunk_id, page_title, section, breadcrumb, url, version, text,
       fts_main_docs_chunks.match_bm25(chunk_id, 'SEARCH_QUERY') AS score
FROM docs_chunks
WHERE score IS NOT NULL
  AND version = 'VERSION'
ORDER BY score DESC LIMIT 8;"
```

Remove `AND version = 'VERSION'` to search all versions. If no results → drop terms and retry; still empty → report none found and suggest duckdb.org/docs.

### 7. Present results

Per result:
```
### {section} — {page_title}
{url}

{text}

---
```

After all chunks, synthesize a concise answer to `$@`. If chunks answer directly, lead with the answer before sources.
