---
name: documentation-writer
description: Use when the user asks for docs — a tutorial, how-to guide, reference, or explanation.
allowed-tools: Read, Glob, Grep, Bash, Write
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
2. **Propose an outline** — wait for approval. For outline templates per type, see `references/outline-templates.md` (Diátaxis-specific scaffolds).
3. **Write** — use the project's tone and terminology. Don't copy from source files unless asked.

## Principles

- Clear, accurate, user-centric, consistent.
- Include only what serves the user's goal.
- No external sources unless the user provides a link.
- Length guard: tutorial 300–600 words, how-to 200–400, reference per-entry 80–150, explanation 250–500. Version docs in `docs/` not `README.md`.

> **Architectural decision records (ADRs)** are owned by `domain-modeling` — use that skill when a decision needs recording.

## Completion criteria

- [ ] Document type, audience, goal, and scope clarified
- [ ] Outline proposed and approved before drafting
- [ ] Draft follows Diátaxis structure for the chosen type and uses project terminology

## Related skills

- `domain-modeling` — ADRs and ubiquitous language; this skill stays on prose docs.
- `mermaid-diagram-specialist` — diagrams inside docs.
- `tufte-data-viz` — charts inside docs.
