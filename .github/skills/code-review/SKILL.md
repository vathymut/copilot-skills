---
name: code-review
description: Use when the user wants to review a diff, PR, branch, work-in-progress changes, SQL/database code, request a reviewer subagent, or respond to code review feedback.
---

# Code Review

Three branches:

- **Branch A — Three-axis review** (default): review the change against Standards, Spec, and Maintainability.
- **Branch B — Request review**: dispatch a reviewer subagent before merging or after a major task.
- **Branch C — Receive review**: evaluate feedback before implementing.

Default to Branch A unless the user asks for one of the others.

## Branch A — Three-axis review

Run Standards, Spec, and Maintainability as **parallel sub-agents**, then aggregate.

### 1. Pin the comparison

Find the diff the user wants reviewed. It may be a git range, a PR, or a set of files. If the user didn't specify one:

- A git repo: default to `git diff origin/main...HEAD`.
- A PR or branch: use the provided refs.
- Individual files: compare the provided files against their last-known-good state or review them as-is.

Confirm the range resolves and is non-empty before spawning sub-agents.

### 2. Identify the spec source

Look for the originating spec in this order:

1. Issue/PR references in commit messages or the PR body.
2. A path the user passed as an argument.
3. A spec, PRD, or design doc under `docs/`, `specs/`, `.scratch/`, or matching the branch/feature name.
4. If nothing is found, ask the user. If there is no spec, the Spec sub-agent skips and reports "no spec available".

### 3. Identify the standards sources

Look for repo conventions: `CODING_STANDARDS.md`, `CONTRIBUTING.md`, `STYLE.md`, linter configs, etc. If the repo documents nothing, use the smell baseline below.

**Rules:**

- Documented repo standards override the baseline.
- Each smell is a judgement call, never a hard violation.
- Skip anything tooling already enforces.

**Smell baseline** (Fowler, _Refactoring_, ch. 3):

- **Mysterious Name** → rename; if no honest name fits, the design is murky.
- **Duplicated Code** → extract the shared shape.
- **Feature Envy** → move the method onto the data it envies.
- **Data Clumps** → bundle the fields/params into a type.
- **Primitive Obsession** → give the domain concept its own small type.
- **Repeated Switches** → replace with polymorphism or a shared map.
- **Shotgun Surgery** → gather scattered edits into one module.
- **Divergent Change** → split the module so each changes for one reason.
- **Speculative Generality** → delete unused abstraction/parameters/hooks.
- **Message Chains** → hide the walk behind one method.
- **Middle Man** → cut it, call the target direct.
- **Refused Bequest** → drop inheritance, use composition.

### 4. Maintainability posture

Load `references/maintainability-review.md` and give it to the Maintainability sub-agent as its brief.

Leading questions:

- Is there a **code-judo** move that deletes whole branches or layers?
- Does any file cross **1000 lines** because of this change?
- Are new conditionals scattered across unrelated paths?
- Are wrappers, casts, or optionals hiding a simpler boundary?
- Is feature logic leaking into shared paths or the wrong layer?
- Are there patterns of AI-generated slop (verbose comments, defensive bloat, broad `except Exception`, unnecessary casts)?
- Is the diff the smallest working change?

### 5. Spawn sub-agents in parallel

Use the `general-purpose` subagent. Each prompt includes the diff/range, the spec (if found), and the standards sources/baseline.

**Standards sub-agent brief:**
> Report per file/hunk (a) documented-standard violations (cite file + rule) and (b) baseline smells (name and quote the hunk). Distinguish hard violations from judgement calls; baseline smells are always judgement calls. Skip tooling-enforced issues. Under 400 words. When the diff is SQL, also load `references/sql-review.md` and report injection (CRITICAL), anti-pattern, and performance findings. When it is Python, load `references/python-standards.md` and report correctness, type-safety, performance, and style findings.

**Spec sub-agent brief** (skip if no spec):
> Report: requirements missing/partial, behaviour not asked for (scope creep), and implementations that look wrong. Quote the spec for each. Under 400 words.

**Maintainability sub-agent brief:**
> Report the highest-conviction structural findings. Prioritize code-judo simplifications, file-size regressions past 1000 lines, scattered special-case branching, abstraction bloat, boundary leaks, canonical-layer mistakes, and AI-generated slop. Quote each hunk. Under 400 words.

### 6. Aggregate

Present the reports under `## Standards`, `## Spec`, and `## Maintainability`. Do **not** merge or rerank across axes. End with one summary line per axis: total findings and the worst issue (if any).

### Why separate axes

A change can pass two axes and fail the third. Keeping the axes separate prevents one from masking another.

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
