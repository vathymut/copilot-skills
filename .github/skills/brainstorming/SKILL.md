---
name: brainstorming
description: Use when the user wants to explore intent and design before building, write a PRD/spec, or generate research directions — or a piece of work needs routing across planning, design, or development-workflow skills. This is the default planning entry point.
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

## Hard gate

Do NOT invoke any implementation skill, write code, scaffold a project, or take implementation action until the user has approved a design or research proposal. This applies to every project regardless of perceived simplicity.

Every project goes through this process. "Simple" projects are where unexamined assumptions cause the most wasted work.

## Key principles

- One question at a time; multiple-choice preferred
- YAGNI ruthlessly; explore alternatives
- Incremental validation (approval before moving on)
- Be flexible — go back and clarify when needed
