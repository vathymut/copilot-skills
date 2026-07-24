---
name: writing-great-skills
description: Use when writing, editing, reviewing, or consolidating a skill — especially when its description, predictability, or structure needs work, or before deploying a new or changed skill.
---

# Writing Great Skills — 6-Step Workflow

A skill exists to wrangle determinism out of a stochastic system. **Predictability** — the agent taking the same _process_ every run — is the root virtue.

## Workflow

### Step 1 — Read the glossary
The vocabulary (context load, leading word, completion criterion, context pointer, failure modes) is in [`GLOSSARY.md`](GLOSSARY.md). Read it first.

### Step 2 — Write test cases first
Treat the skill as TDD for process docs. Write pressure scenarios the skill must handle, then run them with a subagent to confirm they fail (RED baseline).

### Step 3 — Write the skill
Follow the how-to in [`references/writing-how-to.md`](references/writing-how-to.md): structure, description/SDO, keywords, cross-referencing, flowchart, code examples, anti-patterns.

### Step 4 — Test (GREEN)
Re-run your pressure scenarios. The skill passes only when the subagent follows the intended process.

### Step 5 — Refactor
Close loopholes, reduce token count, make every word pull weight. Bulletproofing research basis is in [`persuasion-principles.md`](persuasion-principles.md).

### Step 6 — Render flowcharts
`./render-graphs.js <skill-folder>` produces SVGs. See `graphviz-conventions.dot` for style rules.

## Completion criteria

- [ ] RED baseline: subagent fails without the skill
- [ ] GREEN pass: subagent complies with the skill
- [ ] No duplicate or sediment content
- [ ] Every external reference points to existing docs (theory/reference material lives in `references/`)
- [ ] Flowcharts rendered and checked in

> Reference material (theory, eval tooling, platform-specifics, Anthropic best practices) lives in `references/` — load on demand, not here.
