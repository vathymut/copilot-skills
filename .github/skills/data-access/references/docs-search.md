# Docs search (DuckDB & DuckLake)

Full-text search against locally cached documentation indexes. Load this when the `docs` command needs the exact procedure or the SKILL.md pointer is insufficient.

## Indexes

| Index | Remote URL | Local cache filename | Versions | Use when |
|---|---|---|---|---|
| **DuckDB docs + blog** | `https://duckdb.org/data/docs-search.duckdb` | `duckdb-docs.duckdb` | `lts`, `current`, `blog` | Default — any DuckDB question |
| **DuckLake docs** | `https://ducklake.select/data/docs-search.duckdb` | `ducklake-docs.duckdb` | `stable`, `preview` | Query mentions DuckLake, catalogs, or DuckLake features |

Both indexes share the same schema (`docs_chunks`):

| Column | Type | Description |
|---|---|---|
| `chunk_id` | `VARCHAR` (PK) | e.g. `stable/sql/functions/numeric#absx` |
| `page_title` | `VARCHAR` | Page title from front matter |
| `section` | `VARCHAR` | Section heading (null for page intros) |
| `breadcrumb` | `VARCHAR` | e.g. `SQL > Functions > Numeric` |
| `url` | `VARCHAR` | URL path with anchor |
| `version` | `VARCHAR` | See table above |
| `text` | `TEXT` | Full markdown of the chunk |

Default: search DuckDB docs with `version = 'lts'`. Use `current` for nightly features, `blog` for blog posts/background, the DuckLake index with `stable` for DuckLake. Unsure → omit the version filter.

## Step 1 — Prerequisites

```bash
command -v duckdb || echo "missing"
duckdb :memory: -c "INSTALL httpfs; INSTALL fts;"
```

## Step 2 — Extract search terms

Natural-language question → extract key technical terms (nouns, function names, SQL keywords); drop stop words ("how", "do", "I", "the"). Function name or technical term → use as-is.

## Step 3 — Refresh the local cache if stale

Cache lives at `$HOME/.duckdb/docs/<CACHE_FILENAME>`; refresh if missing or older than 2 days:

```bash
mkdir -p "$HOME/.duckdb/docs"
CACHE_FILE="$HOME/.duckdb/docs/$CACHE_FILENAME"
if [ -f "$CACHE_FILE" ]; then
    MTIME=$(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE")
    CACHE_AGE_DAYS=$(( ( $(date +%s) - MTIME ) / 86400 ))
else
    CACHE_AGE_DAYS=999
fi
```

If stale or missing:

```bash
duckdb -c "
LOAD httpfs; LOAD fts;
ATTACH '$REMOTE_URL' AS remote (READ_ONLY);
ATTACH '$HOME/.duckdb/docs/$CACHE_FILENAME.tmp' AS tmp;
COPY FROM DATABASE remote TO tmp;
" && mv "$HOME/.duckdb/docs/$CACHE_FILENAME.tmp" "$HOME/.duckdb/docs/$CACHE_FILENAME"
```

## Step 4 — Search

```bash
duckdb "$HOME/.duckdb/docs/$CACHE_FILENAME" -readonly -json -c "
LOAD fts;
SELECT chunk_id, page_title, section, breadcrumb, url, version, text,
       fts_main_docs_chunks.match_bm25(chunk_id, '$SEARCH_QUERY') AS score
FROM docs_chunks
WHERE score IS NOT NULL
  AND version = '$VERSION'
ORDER BY score DESC
LIMIT 8;
"
```

Drop the `AND version = ...` line to search across all versions.

## Step 5 — Errors

- Extension missing (`httpfs`/`fts`) → `INSTALL` and retry.
- ATTACH fails / network unreachable → report; index is at the Remote URL above. Suggest visiting https://duckdb.org/docs or https://ducklake.select/docs directly.
- No results → broaden the query (drop the least specific term, or a single word) and retry once.

## Step 6 — Present

Format each chunk as `### {section} — {page_title}`, the url, then `{text}`. Lead with a concise synthesized answer to the original question before showing sources.
