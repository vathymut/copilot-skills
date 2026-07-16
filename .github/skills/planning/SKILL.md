---
name: planning
description: Use when a piece of work needs routing across planning, design, or development-workflow skills — before picking which one to invoke.
disable-model-invocation: true
---

# Planning

Route the work before invoking a sibling skill. The skills themselves are
discoverable; this skill exists only to pick the right first move.

## Default routing

- **New feature request** → `brainstorming` first (intent/design gate), then `writing-plans` (multi-step plan).
- **Large or uncertain effort, route unclear** → `wayfinder` (tickets with blocking edges, or a multi-session map).
- **Plan already written** → `subagent-driven-development` (one subagent per task + two-stage review).
- **Question to investigate** → `research` (primary sources → repo Markdown).
- **Issues / external PRs to sort** → `triage` (state machine + agent-ready briefs).
- **Throwaway design prototype** → `ponytail` (prototype mode).
