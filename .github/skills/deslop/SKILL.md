---
name: deslop
description: Remove AI-generated code slop and clean up code style. Use when asked to "deslop", "remove slop", "clean up AI code", or "tidy the diff".
---

Tighten a diff by removing AI slop while preserving behavior.

## Slop patterns

- Unnecessary comments or verbose explanations
- Defensive checks and try/catch blocks abnormal for the code path
- Casts to `any` / `type: ignore` / broad `except Exception` to bypass type issues
- Deep nesting that early returns would flatten
- Anything inconsistent with the surrounding codebase

## Steps

1. Read the diff against main. Understand what changed and why.
2. Identify slop patterns. Apply minimal edits.
3. Keep behavior unchanged unless a bug is obvious.
4. Confirm the diff now contains only intentional, non-slop changes.

## Completion criteria

- [ ] No slop patterns remain.
- [ ] Behavior matches the original intent.
- [ ] Summary is 1–3 sentences.
