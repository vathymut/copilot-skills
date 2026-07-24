---
name: code-review
description: Use when the user wants to review a diff, PR, branch, work-in-progress changes, SQL/database code, request a reviewer subagent, or respond to code review feedback.
---

# Code Review

Three branches:

- **Branch A — Five-factor review** (default)
- **Branch B — Request review**: dispatch a reviewer subagent
- **Branch C — Receive review**: evaluate feedback

Default to Branch A.

## Branch A — Five-factor review

Pin the diff (default `git diff origin/main...HEAD`), find the spec if any, then check each factor below.

### 1. Code Conventions
Code follows project style and avoids known smells.
- ☐ Documented convention violations (cite file + rule)
- ☐ Baseline smells: Mysterious Name, Duplicated Code, Feature Envy, Data Clumps, Primitive Obsession, Repeated Switches, Shotgun Surgery, Divergent Change, Speculative Generality, Message Chains, Middle Man, Refused Bequest
- ☐ SQL diff → also load `references/sql-review.md`: injection (CRITICAL), anti-patterns, performance
- ☐ Python diff → also load `references/python-standards.md`: correctness, type-safety, performance, style
- ☐ Skip anything tooling already enforces; documented standards override baseline

### 2. Spec Alignment
Change matches requirements without scope creep.
- ☐ Requirements missing or partial
- ☐ Behaviour not asked for (scope creep)
- ☐ Implementation that looks wrong (quote spec)
- ☐ No spec available → skip this factor

### 3. Correctness
Logic is sound; edge cases handled.
- ☐ Off-by-one and boundary errors in ranges
- ☐ Unhandled error paths or silent failures
- ☐ Wrong data types or implicit casts that lose precision
- ☐ Race conditions or shared-mutation bugs

### 4. Maintainability
Code is simple, minimal, and sustainable.
- ☐ Code-judo moves that delete branches/layers
- ☐ File crosses 1000 lines because of this change
- ☐ New conditionals scattered across unrelated paths
- ☐ Wrappers/casts/optionals hiding a simpler boundary
- ☐ Feature logic leaking into shared paths or wrong layer
- ☐ AI slop: verbose comments, defensive bloat, broad `except Exception`, unnecessary casts
- ☐ Diff is the smallest working change

### 5. Security & Performance
No vulnerabilities or regressions.
- ☐ Secrets exposed in diff
- ☐ SQL injection or command injection vectors
- ☐ Missing input validation
- ☐ Unnecessary allocations, N+1 queries, loop-invariant work
- ☐ Missing caching on repeated expensive operations

Present findings per factor; end with one summary line per factor (total + worst issue). Do not merge or rerank across factors.

## Branch B — Request review

Use when the user says "request review", "review before merge", or "have someone review this".

1. **Get SHAs:** `BASE_SHA=$(git rev-parse HEAD~1)` (or `origin/main`), `HEAD_SHA=$(git rev-parse HEAD)`.
2. **Dispatch a reviewer subagent** via `Task` (`general-purpose`) using `references/code-reviewer.md`. Fill `{DESCRIPTION}`, `{PLAN_OR_REQUIREMENTS}`, `{BASE_SHA}`, `{HEAD_SHA}`.
3. **Act on feedback:** fix Critical immediately, Important before proceeding, note Minor, push back with reasoning if wrong.

**Mandatory before merge.** Optional but valuable when stuck, before refactoring, or after a complex bug fix.

## Branch C — Receive review

Use when the user pastes review feedback or says "address feedback".

**Core principle:** verify before implementing.

**Process:**

1. Read all feedback without reacting.
2. Restate each item in your own words; ask if anything is unclear.
3. Verify against the codebase before changing anything.
4. Push back if the suggestion is wrong for this codebase or conflicts with prior decisions.
5. Implement one item at a time; test each.

**Rules:**

- No performative agreement ("You're absolutely right", "Great point").
- Clarify unclear items first; don't implement partially understood feedback.
- Order: blocking issues, simple fixes, complex fixes.
- Check YAGNI for "implement properly" suggestions: if the code isn't used, propose removal.
- Reply to inline comments in the inline thread, not as a top-level comment.
