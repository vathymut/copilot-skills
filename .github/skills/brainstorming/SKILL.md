---
name: brainstorming
description: Use when exploring intent and design before building — PRDs, specs, or research directions. Default planning entry point.
---

# Brainstorming Ideas Into Designs

Help turn ideas into fully formed designs, specs, or research proposals. Core loop: explore → question → propose → approve.

## Routing

| Input | Skill |
|---|---|
| New feature request | `brainstorming` first (this skill), then `writing-plans` |
| Tickets with clear route | `to-tickets` |
| Large uncertain effort | `wayfinder` |
| Plan already written | `writing-plans` |
| Question to investigate | `research` |
| Issues / external PRs | `triage` |
| Throwaway prototype | `ponytail` |

## Pivot: review existing vs. draft new

- **Reviewing an existing design/spec** → audit for gaps, non-goals, success criteria. Do not re-draft.
- **Drafting from scratch** → use the generic open-question generation below, then route to the template.

## Generic open-question generation

Ask one at a time, multiple-choice when possible:

1. **Purpose** — what problem are we solving? For whom? Why now?
2. **Scope** — what's in bounds? Out of bounds?
3. **Success** — how do we know it worked? Measurable criteria.
4. **Constraints** — budget, stack, deadline, must-play-with?
5. **Approach preferences** — any preferred patterns, libraries, or architectures to consider?

Once answered, route to the appropriate artifact template:

| Artifact | Template location |
|---|---|
| **PRD / product spec** | `references/prd-template.md` |
| **Technical spec** | `references/spec-template.md` |
| **Spike doc** | `references/spike-template.md` |
| **Planning doc / design doc** | `references/design-doc-template.md` |
| **Research ideation** | `references/research-ideation.md` |

## When NOT to use

- The user reported a clear bug with a failing test and wants a direct fix — use `systematic-debugging` → `test-driven-development`.
- The request is a throwaway prototype or spike explicitly marked as disposable — use `ponytail` prototype mode or a `spike` doc (`references/spike-template.md`) and skip the full design loop.
- The plan/spec is already approved and the user said "implement now" — go straight to `writing-plans`.

## Hard gate

Do NOT invoke any implementation skill, write code, scaffold a project, or take implementation action until the user has approved a design or research proposal. Exceptions: (1) a time-boxed spike (`references/spike-template.md`), (2) a `research` investigation when blocked, or (3) the user said "implement now" / "skip design" / the task is labeled throwaway (`ponytail` prototype) / single-bug fix via `systematic-debugging`. Every project benefits from this loop; for <1 day tasks use the fast-track: one question → one paragraph decision → proceed.

## Completion criteria

- [ ] Purpose, scope, success, constraints, and approach preferences asked (one at a time)
- [ ] Artifact type chosen and template loaded from `references/`
- [ ] Draft produced and user approval received before any implementation dispatch
- [ ] Routing decision recorded (next skill: `writing-plans`, `wayfinder`, `research`, or `to-tickets`)

## Key principles

- One question at a time; multiple-choice preferred
- YAGNI ruthlessly; explore alternatives
- Incremental validation (approval before moving on)
- Be flexible — go back and clarify when needed

## Related skills

- `writing-plans` — next after approval.
- `to-tickets` — when route is clear, skip plan.
- `wayfinder` — when route is foggy.
- `research` — investigate open question before deciding.
