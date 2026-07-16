---
name: planning
description: Use when the user wants the right planning or development-workflow skill — plans, wayfinder, subagent-driven development, or research and triage.
disable-model-invocation: true
---

# Planning Router

Index of planning and development-workflow skills. Invoke the right skill by name.

| Skill | Use when |
|---|---|
| `brainstorming` | Explore user intent, requirements, and design *before* any creative or implementation work. Hard gate before code. |
| `writing-plans` | Write a multi-step implementation plan from a spec or requirements (before touching code). `brainstorming` produces that spec/PRD. |
| `wayfinder` | Break work into tracker tickets with blocking edges (lightweight) or chart a huge multi-session map (heavyweight). |
| `subagent-driven-development` | Execute a written plan in the current session via a fresh subagent per task + two-stage review. |
| `research` | Investigate a question against primary sources and capture findings as a repo Markdown file. |
| `triage` | Move issues and external PRs through a state machine of triage roles and write agent-ready briefs. |

For a throwaway design prototype, use `ponytail` (prototype mode).

Default routing: a new feature request → `brainstorming` first, then `writing-plans`; a large/uncertain effort → `wayfinder`; a ready plan → `subagent-driven-development`.
