---
name: git-workflow
description: User-invoked router for git-related skills. Type this skill name to see which git skill to use.
disable-model-invocation: true
---

# Git Workflow Router

Index of the git-related skills. Invoke the right skill by name.

| Skill | Use when |
|---|---|
| `git-commit` | Stage files, write a Conventional Commit message, and execute `git commit`. |
| `fix-merge-conflicts` | Resolve unresolved merge conflicts and get back to a buildable state. |
| `using-git-worktrees` | Start feature work in an isolated workspace or worktree. |
| `finishing-a-development-branch` | Implementation is complete and you need to decide merge / PR / cleanup. |

These skills are model-invoked; you can type their names directly, or let the
agent pick them when you say "commit", "merge conflict", "worktree", or
"finish this branch".
