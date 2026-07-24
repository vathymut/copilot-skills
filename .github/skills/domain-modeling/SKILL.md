---
disable-model-invocation: true
name: domain-modeling
description: Use when the user wants to pin down domain terminology or a ubiquitous language, record an architectural decision, or when another skill needs the domain model maintained.
---

# Domain Modeling

Actively build and sharpen the project's domain model. The domain model lives in `CONTEXT.md` (glossary) and `docs/adr/` (architectural decisions).

## File structure

Most repos have a single context:

```
/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

If a `CONTEXT-MAP.md` exists at the root, the repo has multiple contexts. The map points to where each one lives:

```
/
├── CONTEXT-MAP.md
├── docs/
│   └── adr/                          ← system-wide decisions
├── src/
│   ├── ordering/
│   │   ├── CONTEXT.md
│   │   └── docs/adr/                 ← context-specific decisions
│   └── billing/
│       ├── CONTEXT.md
│       └── docs/adr/
```

Create files lazily — only when you have something to write. If no `CONTEXT.md` exists, create one when the first term is resolved. If no `docs/adr/` exists, create it when the first ADR is needed.

## During the session

1. **Load CONTEXT.md and cross-reference with incoming terms** — When the user uses a term, check it against the existing glossary. Call out conflicts immediately: "Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

2. **Challenge fuzzy language** — When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' — do you mean the Customer or the User? Those are different things."

3. **Discuss concrete scenarios** — Stress-test domain relationships with specific scenarios that probe edge cases and force precision about concept boundaries.

4. **Cross-reference with code** — When the user states how something works, check whether the code agrees. Surface contradictions: "Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"

5. **Update glossary inline** — When a term is resolved, update `CONTEXT.md` right there. Don't batch them up — capture as they happen. `CONTEXT.md` is a glossary and nothing else — devoid of implementation details, not a spec or scratch pad. Use the format in [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

### Offer ADRs sparingly

Only offer to create an ADR when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR. When all three hold, write it as an ADR (Architectural Decision Record): a short doc with title, status, context, decision, and consequences, numbered sequentially (e.g. `ADR-0007`).
