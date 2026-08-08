#!/usr/bin/env bash
# stream-live.sh <SEARCH_QUERY>
# Fallback: query duckdb.org's live search API when no cached index is
# available (e.g. DuckDB < 1.2.0 or no network for the mirror fetch).
set -euo pipefail

QUERY=$(python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.argv[1]))' "$1")

curl -s "https://duckdb.org/docs/api/query.html?query=$QUERY" \
  | python3 -c "import sys,json,html; d=json.load(sys.stdin); [print(f\"### {r['title']}\\n{r['url']}\\n\\n{html.unescape(r['snippet'])}\") for r in d.get('results',[])]" 2>/dev/null \
  || echo "Fallback unavailable; visit https://duckdb.org/docs"
