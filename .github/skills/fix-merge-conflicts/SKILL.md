---
name: fix-merge-conflicts
description: Resolve merge conflicts non-interactively, validate build and tests, and finalize conflict resolution. Use when a branch has unresolved merge conflicts and needs a reliable path to a buildable state.
---

# Fix merge conflicts

## Trigger

Branch has unresolved merge conflicts and needs a reliable path to a buildable state.

## Workflow

1. Detect all conflicting files from git status and conflict markers.
2. Resolve each conflict with minimal, correctness-first edits. Preserve both sides when safe; otherwise choose the variant that compiles and keeps public behavior stable.
3. Regenerate lockfiles with package manager tools instead of hand-editing.
4. Run compile, lint, and relevant tests.
5. Stage resolved files and summarize key decisions.

**Completion criteria:** all conflict markers removed, build passes, tests pass.

## Output

- Files resolved
- Notable resolution choices
- Build/test outcome
