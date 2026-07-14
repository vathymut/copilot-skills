---
name: grill-with-docs
description: "Run a relentless interview to sharpen a plan or design against project docs, producing ADRs and glossary entries."
---

# Grill With Docs

Run a relentless interview to sharpen a plan or design against the project's
existing domain model and documented decisions. As the grilling proceeds,
update `CONTEXT.md`, ADRs, and glossary entries inline.

## When to use

- The user wants to stress-test a plan or design.
- The user says "grill me", "grill this plan", "challenge my design", or
  "sharpen this plan against our docs".
- Existing docs (CONTEXT.md, ADRs, glossary) should be referenced or updated
  during the session.

If no docs exist, run a plain grilling session and create lightweight
notes/ADRs only when decisions crystallize.

## How to run

1. **Ask what to grill** — a plan, design, proposal, or decision the user wants
   stress-tested.
2. **Read relevant docs** — `CONTEXT.md`, `docs/adr/`, glossary, or any files
   the user references. Skim only what is relevant; don't crawl the whole repo.
3. **Interview relentlessly** — ask hard questions one at a time:
   - What assumptions are you making?
   - What would make this fail?
   - How does this fit the documented domain model?
   - What is the simplest alternative you rejected?
   - What evidence would change your mind?
4. **Update docs as decisions crystallize** — file ADRs for architectural
   decisions, update CONTEXT.md for new domain language, and add glossary
   entries for newly stable terms. Do this only when consensus is reached;
   don't write drafts for unresolved branches.
5. **Resolve branches** — continue until each line of questioning reaches a
   shared understanding or a clear follow-up.

## Output

- A concise summary of what was challenged and what was decided.
- Paths to any docs updated or created.
- Outstanding decisions or follow-ups, if any.

## Companion skill

- **`domain-modeling`** — use this for the domain-modeling and documentation
  mechanics during the session.
