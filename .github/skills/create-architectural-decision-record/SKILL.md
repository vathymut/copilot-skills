---
name: create-architectural-decision-record
description: 'User-invoked: Create an ADR document for architectural decisions.'
disable-model-invocation: true
---

# Create Architectural Decision Record

## When to create one

Record an ADR only when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful.
2. **Surprising without context** — a future reader will look at the code and wonder "why on earth did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons.

If a decision is easy to reverse, unsurprising, or had no real alternative, skip it.

**What typically qualifies:** architectural shape (monorepo, event sourcing); integration patterns between contexts; technology choices that carry lock-in (database, message bus, auth provider); boundary/scope decisions ("Customer data is owned by the Customer context"); deliberate deviations from the obvious path ("manual SQL instead of an ORM because X"); constraints not visible in the code (compliance, latency contracts); and non-obvious rejected alternatives (picked REST over GraphQL for subtle reasons).

## Steps

### 1. Gather Inputs

Collect from the user or conversation context:

- **Context**: Problem statement, constraints, business requirements
- **Decision**: What was decided and why
- **Alternatives**: Other options considered
- **Stakeholders**: Who is involved or affected

If any are missing, ask before proceeding. **Completion**: all inputs collected.

### 2. Determine Sequence Number

Scan `/docs/adr/` for existing `adr-NNNN-*.md` files. Next number is `max(NNNN) + 1`, zero-padded to 4 digits. Start at `0001` if none exist.

**Completion**: sequence number determined.

### 3. Fill Template

Read `references/adr-template.md` and populate every section. Use coded bullet points (`POS-001`, `NEG-001`, `ALT-001`, etc.) for multi-item sections.

**Completion**: all sections populated.

### 4. Validate

- No placeholder text (`[Bracket]` tokens)
- All consequences documented (positive and negative)
- Every alternative has a rejection rationale

**Completion**: validation passes.

### 5. Save

Write to `/docs/adr/adr-NNNN-[title-slug].md` — sequential 4-digit number, title in kebab-case. **Completion**: file written.

## Rules

- Precise, unambiguous language; both positive and negative consequences required
- Alternatives must include rejection rationale; structure for machine parsing
