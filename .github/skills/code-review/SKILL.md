---
name: code-review
description: Use when reviewing code or SQL statements, when pasted review feedback needs triaging, or when an independent reviewer check is requested.
---

# Code Review

## Overview

Pin the diff, apply every factor, produce the verdict. Verify before judging:
report findings and reshape nothing during review.

## When to Use

- Unmerged changes need a verdict: branch, PR, WIP, or staged work.
- SQL statements need injection, anti-pattern, and performance review.
- Pasted reviewer comments need verifying and triaging.
- A reviewer check is requested before merge, refactor, or after a hard fix.

When NOT to use:

- Trivial formatting/linter-only diff — tooling already enforces; skip review.
- No diff to pin (nothing changed).

## Quick Reference

| Branch | Fires when | Reaches |
|---|---|---|
| A — review | unmerged code or SQL is present, no pasted feedback, no reviewer asked | `references/five-factors.md` |
| B — reviewer check | a reviewer or subagent is asked for | `references/code-reviewer.md` |
| C — triage feedback | pasted reviewer comments are present | `references/receive-feedback.md` |

Match in order C → B → A: pasted feedback present beats reviewer asked,
which beats the default review.

## Implementation

1. Pin the diff using the first predicate that holds: PR context →
   `gh pr diff`; branch → merge-base against `origin/main` or `main`;
   otherwise `git status` plus `git diff HEAD` (and `--cached` if staged).
   Done when: base and head are named and the working-tree state is recorded.
2. Load only the refs this run reaches: always the rubric
   (`references/five-factors.md`); SQL statements → `references/sql-review.md`;
   Python files → `references/python-standards.md`; structural concerns →
   `references/maintainability-review.md`; reviewer asked →
   `references/code-reviewer.md`; pasted feedback →
   `references/receive-feedback.md`.
   Done when: the rubric is loaded and no unfired ref is in context.
3. Run the matched branch to its verdict.
   Done when: Branch A — every factor applied, per-factor summary plus
   **Ready to merge?** Yes | No | With fixes; Branch B — reviewer dispatched
   via `Task` (`general`) where available, otherwise reviewed inline with the
   same rubric; Branch C — every item verified with file:line reasoning and
   legwork (tests run) shown.

## Common Mistakes

| What goes wrong | Fix |
|---|---|
| Verdict reranked across factors; style outshouts a blocker | Keep per-factor summaries; the verdict follows the severest issue, the order of factors never changes |
| Injection filed under conventions | File all injection in Factor 5; Factor 1 holds smells and style only |
| Review reshapes code instead of reporting it | Flag restructuring with file:line and stop; the smallest working change is a finding, not an edit |
| Vague praise or agreement without a reason | Name the specific strength or technical reason, or say nothing |

## Related skills

- Root-cause fixes precede any review re-run.
- `refactor` — structural concerns flagged, not implemented.
