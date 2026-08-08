#!/usr/bin/env bash
# fetch-docs.sh <CACHE_PATH> <REMOTE_URL>
# Mirrors a remote docs-search DuckDB database to CACHE_PATH unless it is
# fresh (< 2 days old). Prints "cache fresh" when nothing was fetched.
set -euo pipefail

CACHE="$1"
REMOTE="$2"

mkdir -p "$(dirname "$CACHE")"

if [ -f "$CACHE" ]; then
  if [ "$(uname)" = "Darwin" ]; then
    MTIME=$(stat -f %m "$CACHE")
  else
    MTIME=$(stat -c %Y "$CACHE")
  fi
  if [ "$(( $(date +%s) - MTIME ))" -lt 172800 ]; then
    echo "cache fresh"
    exit 0
  fi
fi

duckdb -c "LOAD httpfs; LOAD fts; ATTACH '$REMOTE' AS r (READ_ONLY); COPY FROM DATABASE r TO '$CACHE.tmp';"
mv "$CACHE.tmp" "$CACHE"
