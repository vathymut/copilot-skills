---
name: planning
description: User-invoked router for planning and development-workflow skills. Type this skill name to see which planning skill to use.
disable-model-invocation: true
---

# Planning Router

Index of planning and development-workflow skills. Invoke the right skill by name.

| Skill | Use when |
|---|---|
| `brainstorming` | Explore user intent, requirements, and design *before* any creative or implementation work. Hard gate before code. |
| `writing-plans` | Write a multi-step implementation plan from a spec or requirements (before touching code). |
| `to-tickets` | Break a plan/spec into tracer-bullet tickets with blocking edges, published to a tracker. |
| `wayfinder` | Plan a huge, multi-session chunk of work as a shared map of investigation tickets. |
| `subagent-driven-development` | Execute a written plan in the current session via a fresh subagent per task + two-stage review. |
| `prototype` | Build a throwaway prototype to answer a design question (not production code). |
| `triage` | Move issues and external PRs through a state machine of triage roles and write agent-ready briefs. |

Default routing: a new feature request → `brainstorming` first, then `writing-plans`; a large/uncertain effort → `wayfinder`; a ready plan → `subagent-driven-development`.
