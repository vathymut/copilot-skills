#!/usr/bin/env bash
# search-docs.sh <CACHE_PATH> <SEARCH_QUERY> [VERSION]
# FTS search over the cached docs index, top 8 by BM25 score.
# Omit VERSION to search all versions. Prints JSON lines to stdout.
set -euo pipefail

CACHE="$1"
QUERY="$2"
VERSION="${3:-}"

VERSION_FILTER=""
if [ -n "$VERSION" ]; then
  VERSION_FILTER="AND version = '$VERSION'"
fi

duckdb "$CACHE" -readonly -json -c "
LOAD fts;
SELECT chunk_id, page_title, section, breadcrumb, url, version, text,
       fts_main_docs_chunks.match_bm25(chunk_id, '$QUERY') AS score
FROM docs_chunks
WHERE score IS NOT NULL
  $VERSION_FILTER
ORDER BY score DESC LIMIT 8;"
