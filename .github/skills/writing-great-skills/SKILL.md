---
name: writing-great-skills
description: Use when writing, editing, reviewing, or consolidating a skill — especially when its description, predictability, or structure needs work, or before deploying a new or changed skill.
---

# Writing Great Skills

A skill exists to wrangle determinism out of a stochastic system. **Predictability** — the agent taking the same _process_ every run, not producing the same output — is the root virtue; every lever below serves it.

The vocabulary for achieving it — **context load**, **cognitive load**, **leading word**, **completion criterion**, **context pointer**, **branching**, and the five **failure modes** (premature completion, duplication, sediment, sprawl, no-op) — is defined in [`GLOSSARY.md`](GLOSSARY.md). Read it first when judging or shaping a skill.

## Workflow — TDD for skills

Writing skills IS Test-Driven Development applied to process documentation: write test cases (pressure scenarios with subagents), watch them fail (baseline), write the skill, watch tests pass (agents comply), refactor (close loopholes). The executable workflow lives in disclosed reference:

- **The how-to** — TDD mapping, when to create a skill, SKILL.md structure, description/SDO writing, keyword coverage, token efficiency, cross-referencing, flowcharts, code examples, file organization, the Iron Law, testing all skill types, bulletproofing, match-the-form, RED-GREEN-REFACTOR, anti-patterns, and the creation checklist → [`references/writing-how-to.md`](references/writing-how-to.md)
- **Subagent testing methodology** (pressure scenarios, pressure types, meta-testing) → [`testing-skills-with-subagents.md`](testing-skills-with-subagents.md)
- **Concise eval loop** → [`references/eval-workflow.md`](references/eval-workflow.md)
- **Anthropic's official authoring best practices** → [`anthropic-best-practices.md`](anthropic-best-practices.md)
- **Bulletproofing research basis** (authority, commitment, scarcity, social proof, unity) → [`persuasion-principles.md`](persuasion-principles.md)
- **Eval tooling & schemas** → [`scripts/`](scripts), [`eval-viewer/`](eval-viewer), [`references/schemas.md`](references/schemas.md), [`references/platform-specific.md`](references/platform-specific.md)

**Start here to write or edit a skill:** open `references/writing-how-to.md` and follow it. A skill is done only after a failing-test baseline (RED) and a passing re-run (GREEN); the Iron Law applies to new skills _and_ edits — **no skill without a failing test first.**

### Flowchart / graph rendering

To render a skill's flowcharts to SVG: `./render-graphs.js <skill-folder>` (or `--combine`). See `graphviz-conventions.dot` for style rules.
