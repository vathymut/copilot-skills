#!/usr/bin/env bash
# Identifier uniqueness check for implementation plans.
# Usage: bash validate-identifiers.sh <plan-file>
#
# Prerequisites: POSIX shell with grep, sed, sort, uniq.

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <plan-file>" >&2
  exit 1
fi

PLAN_FILE="$1"

if [ ! -f "$PLAN_FILE" ]; then
  echo "Error: file not found: $PLAN_FILE" >&2
  exit 1
fi

echo "=== Identifier Uniqueness Check: $PLAN_FILE ==="
echo ""

# 1) Duplicate TASK / GOAL declarations in table rows.
echo "--- Check 1: Duplicate TASK/GOAL declarations ---"
dups1=$(grep -oE '\| (TASK|GOAL)-[0-9]+ \|' "$PLAN_FILE" \
  | sed -E 's/.*((TASK|GOAL)-[0-9]+).*/\1/' \
  | sort | uniq -d)
if [ -z "$dups1" ]; then
  echo "PASS: No duplicate TASK/GOAL declarations."
else
  echo "FAIL: Duplicate TASK/GOAL declarations found:"
  echo "$dups1"
fi
echo ""

# 2) Duplicate declaration IDs in bullet-style spec lines.
echo "--- Check 2: Duplicate bullet declarations ---"
dups2=$(grep -oE '^- \*\*(REQ|SEC|CON|GUD|RISK|ASSUMPTION|TASK|GOAL|FILE|TEST|PAT|ALT|DEP)-[0-9]+\*\*:' "$PLAN_FILE" \
  | sed -E 's/^- \*\*([A-Z]+-[0-9]+)\*\*:.*/\1/' \
  | sort | uniq -d)
if [ -z "$dups2" ]; then
  echo "PASS: No duplicate bullet declarations."
else
  echo "FAIL: Duplicate bullet declarations found:"
  echo "$dups2"
fi
echo ""

# 3) Broad duplicate scan (diagnostic only; may include valid references).
echo "--- Check 3: Broad duplicate scan (informational) ---"
dups3=$(grep -oE '(REQ|SEC|CON|GUD|RISK|ASSUMPTION|TASK|GOAL|FILE|TEST|PAT|ALT|DEP)-[0-9]+' "$PLAN_FILE" \
  | sort | uniq -d)
if [ -z "$dups3" ]; then
  echo "INFO: No duplicate identifiers at all."
else
  echo "INFO: Duplicate identifiers found (may be valid references):"
  echo "$dups3"
fi
echo ""

# Exit with failure if checks 1 or 2 failed.
if [ -n "$dups1" ] || [ -n "$dups2" ]; then
  echo "RESULT: FAIL — re-number duplicate identifiers and re-run."
  exit 1
else
  echo "RESULT: PASS — all declarations unique."
  exit 0
fi
