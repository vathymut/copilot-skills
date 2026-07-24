---
name: code-review
description: Use when reviewing code — diffs, PRs, branches, WIP, or SQL — or when requesting or responding to code review.
---

# Code Review

Default to Branch A. Three branches:

- **Branch A — Five-factor review** (default)
- **Branch B — Request review**: dispatch a reviewer subagent
- **Branch C — Receive review**: evaluate feedback

## Branch A — Five-factor review

1. **Pin the diff** — default `git diff origin/main...HEAD`.
2. **Load conditioned references** — SQL diff → `references/sql-review.md`, Python diff → `references/python-standards.md`.
3. **Find the spec** if any, then check each factor below.
At the end, present findings per factor with one summary line each (total + worst issue). Do not merge or rerank across factors.

### 1. Code Conventions
Code follows project style and avoids known smells.
- ☐ Documented convention violations (cite file + rule)
- ☐ Baseline smells: Mysterious Name, Duplicated Code, Feature Envy, Data Clumps, Primitive Obsession, Repeated Switches, Shotgun Surgery, Divergent Change, Speculative Generality, Message Chains, Middle Man, Refused Bequest
- ☐ SQL diff → check injection (CRITICAL), anti-patterns, performance
- ☐ Python diff → check correctness, type-safety, performance, style
- ☐ Skip what tooling already enforces; documented standards override baseline

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
Code is simple, minimal, and sustainable. Be ambitious — flag deep restructuring that simplifies the codebase.
- ☐ Code-judo: can whole branches or layers be deleted rather than modified?
- ☐ Deletion test: does each new module or abstraction earn its keep?
- ☐ Shallow module: interface nearly as complex as what it wraps
- ☐ Locality: understanding requires bouncing between scattered files
- ☐ File crosses 1000 lines because of this change
- ☐ New conditionals scattered across unrelated paths
- ☐ Wrappers/casts/optionals hiding a simpler boundary
- ☐ Feature logic leaking into shared paths or wrong layer
- ☐ AI slop: verbose comments, defensive bloat, broad `except Exception`, unnecessary casts
- ☐ Structural concerns found → load `references/maintainability-review.md` for deeper standards. Report restructuring findings — do not implement.
- ☐ Diff is the smallest working change

### 5. Security & Performance
No vulnerabilities or regressions.
- ☐ Secrets exposed in diff
- ☐ SQL injection or command injection vectors
- ☐ Missing input validation
- ☐ Unnecessary allocations, N+1 queries, loop-invariant work
- ☐ Missing caching on repeated expensive operations

## Branch B — Request review

Use when the user says "request review", "review before merge", or "have someone review this".

1. **Pin SHAs:** `BASE_SHA=$(git merge-base origin/main HEAD)`, `HEAD_SHA=$(git rev-parse HEAD)`.
2. **Dispatch a reviewer subagent** via `Task` (`general`) using `references/code-reviewer.md`. Fill `{DESCRIPTION}`, `{PLAN_OR_REQUIREMENTS}`, `{BASE_SHA}`, `{HEAD_SHA}`.
3. **Act on feedback:** fix Critical immediately, Important before proceeding, note Minor, push back with reasoning if wrong.

Run before every merge. Also valuable when stuck, before refactoring, or after a complex bug fix.

## Branch C — Receive review

Use when the user pastes review feedback or says "address feedback".

**Core principle:** verify before implementing.

**Process:**

1. Read all feedback without reacting.
2. Restate each item in your own words; clarify unclear items first.
3. Verify against the codebase before changing anything.
4. Push back if the suggestion is wrong for this codebase or conflicts with prior decisions.
5. Implement one item at a time; test each. Order: blocking issues, simple fixes, complex fixes.

**Rules:**

- No performative agreement ("You're absolutely right", "Great point").
- Check YAGNI for "implement properly" suggestions: if the code isn't used, propose removal.
- Reply to inline comments in the inline thread, not as a top-level comment.
