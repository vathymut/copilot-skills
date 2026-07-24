---
name: documentation-writer
description: Use when the user asks for docs — a tutorial, how-to guide, reference, or explanation.
disable-model-invocation: true
---

# Documentation Writer

Write documentation using the Diátaxis framework.

## When NOT to use

- The user needs code comments, not prose docs. Route to a code-writing skill instead.
- The user wants a commit message, changelog entry, or inline annotation — those are structured metadata, not documentation.

## Document types — structural conventions

| Type | Purpose | Typical structure | Tone |
|---|---|---|---|
| Tutorial | Learning-oriented, hands-on steps for a newcomer | Prerequisites → Step-by-step with numbered actions → Recap | Instructional, encouraging |
| How-to Guide | Problem-oriented, steps to solve a specific task | Task heading → Prerequisites → Steps → Expected outcome | Direct, concise |
| Reference | Information-oriented, technical descriptions | Alphabetical or hierarchical listing → Each entry: signature/syntax, description, example | Neutral, precise |
| Explanation | Understanding-oriented, clarifies a topic | Context → What → Why → How it fits → Related concepts | Contextual, narrative |

## Workflow

1. **Clarify** — document type, audience, user goal, scope. Ask if any are missing.
2. **Propose an outline** — wait for approval.
3. **Write** — use the project's tone and terminology. Don't copy from source files unless asked.

## Principles

- Clear, accurate, user-centric, consistent.
- Include only what serves the user's goal.
- No external sources unless the user provides a link.

> **ADR (architectural decision records)** — see [`references/adr-workflow.md`](references/adr-workflow.md). The ADR workflow is extracted there to keep this skill focused on documentation writing.
