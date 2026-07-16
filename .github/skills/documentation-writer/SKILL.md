---
name: documentation-writer
description: Use when the user asks for docs — a tutorial, how-to guide, reference, or explanation — or wants an architectural decision record (ADR).
disable-model-invocation: true
---

# Documentation Writer

Write documentation using the Diátaxis framework.

## Document types

| Type | Purpose |
|---|---|
| Tutorial | Learning-oriented, hands-on steps for a newcomer |
| How-to Guide | Problem-oriented, steps to solve a specific task |
| Reference | Information-oriented, technical descriptions |
| Explanation | Understanding-oriented, clarifies a topic |

## Workflow

1. **Clarify** — document type, audience, user goal, scope. Ask if any are missing.
2. **Propose an outline** — wait for approval.
3. **Write** — use the project's tone and terminology. Don't copy from source files unless asked.

## Principles

- Clear, accurate, user-centric, consistent.
- Include only what serves the user's goal.
- No external sources unless the user provides a link.

## Branch: ADR (architectural decision record)

Create an Architectural Decision Record — a documentation artifact for a
hard-to-reverse, surprising, trade-off-bearing decision. If a decision is easy
to reverse, unsurprising, or had no real alternative, skip it. Qualifies:
architectural shape (monorepo, event sourcing); integration patterns;
lock-in technology choices (database, message bus, auth); boundary/scope
decisions; deliberate deviations from the obvious path; constraints not visible
in code (compliance, latency); non-obvious rejected alternatives.

### Steps

1. **Gather inputs** — Context, Decision, Alternatives, Stakeholders. Ask if any are missing.
2. **Determine sequence number** — scan `/docs/adr/` for `adr-NNNN-*.md`; next is `max(NNNN)+1`, zero-padded; start `0001` if none.
3. **Fill template** — read `references/adr-template.md`; populate every section using coded bullets (`POS-001`, `NEG-001`, `ALT-001`, …).
4. **Validate** — no `[Bracket]` placeholder text; all consequences documented; every alternative has a rejection rationale.
5. **Save** — write to `/docs/adr/adr-NNNN-[title-slug].md`.

**Completion criteria:** file written to `/docs/adr/`; all sections populated; validation passes.

## Completion criteria

- [ ] Document type and audience are clear (or: ADR saved and validated).
- [ ] Outline was approved or waived.
- [ ] Full doc follows Diátaxis conventions.
