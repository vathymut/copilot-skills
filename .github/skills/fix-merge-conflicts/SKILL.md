---
name: fix-merge-conflicts
description: Resolve an in-progress git merge or rebase conflict, validate the result, and finalize. Use when the user says "resolve conflicts", "fix merge conflict", or "finish rebase".
disable-model-invocation: true
---

# Fix Merge Conflicts

Resolve an in-progress git merge or rebase. **Never `--abort` without explicit user approval.**

## Workflow

1. **See the current state.** Read `git status`, the conflicted files, and recent history.
2. **Find the intent behind each side.** Read commit messages, PR/issue references, and the code to understand why each change was made.
3. **Resolve each hunk.** Preserve both intents when possible. When they conflict, pick the side that matches the merge's goal and note the trade-off. Do **not** invent new behavior.
4. **Regenerate lockfiles with the package manager** if they conflict — do not hand-edit them.
5. **Run automated checks.** Compile/typecheck, then tests, then lint/format. Fix anything the merge broke.
6. **Finalize.** Stage all resolved files and complete the merge or rebase; continue rebasing until done.

## Completion criteria

- [ ] No conflict markers remain.
- [ ] The working tree builds and relevant tests pass.
- [ ] Resolution choices are summarized for the user.
