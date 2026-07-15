---
name: code-quality
description: User-invoked router for code-quality skills (review, refactor, debugging, testing). Type this skill name to see which to use.
disable-model-invocation: true
---

# Code-Quality Router

Index of code-quality skills. Invoke the right skill by name.

| Skill | Use when |
|---|---|
| `code-review` | Review a diff, PR, branch, or work-in-progress; dispatch a reviewer subagent; or respond to review feedback. |
| `refactor` | Improve code structure without changing behavior. |
| `systematic-debugging` | Investigate a bug, test failure, or unexpected behavior *before* proposing a fix. |
| `test-driven-development` | Build test-first (red-green-refactor) and raise coverage on existing code. |

Note: `verification-before-completion` is an always-on discipline (fresh evidence before any "done" claim), not a routed skill. `sql-code-review` is subsumed by `code-review`'s SQL review reference.
