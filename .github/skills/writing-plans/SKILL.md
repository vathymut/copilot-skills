---
name: writing-plans
description: Use when a spec or requirements for a multi-step task exist, before touching code
---

# Writing Plans

One plan per self-contained feature. A plan is a markdown file saved to `docs/plans/YYYY-MM-DD-<feature-name>.md` with: goal sentence, architecture sketch, file map, and bite-sized TDD tasks — a header, files list, then sequential steps, each one RED-GREEN-REFACTOR cycle per `test-driven-development` (failing test → verify fail → implement → verify pass → commit).

## When NOT to use

- Need tracer-bullet tickets with blocking edges right now — use `to-tickets`.
- Route is genuinely unclear / multi-session fog — use `wayfinder`.
- Single-bug fix with no multi-step decomposition — go straight to `systematic-debugging` → `test-driven-development`.

Default to one plan per run. If the spec covers multiple independent subsystems, split into separate plans — one per subsystem. For mixed code/no-code tasks (e.g. config + script + docs), include all types in one plan; label each task's output format.

## Output format

The deliverable is a single markdown file at `docs/plans/YYYY-MM-DD-<feature-name>.md` containing:

- **Header block**: goal sentence, architecture sketch (2-3 sentences), tech stack
- **File map**: every file to create or modify, with responsibility
- **Sequential tasks**: each one RED-GREEN-REFACTOR cycle per `test-driven-development`, with exact code and `pytest` commands

No placeholders, no TBDs, no "implement later". Every code block is complete.

Not tracker tickets with clear edges (`to-tickets`) and not too-big-for-one-session fog (`wayfinder`)? Use this skill — one plan per self-contained feature.

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for — decomposition decisions get locked in here. File-design guidance: `references/task-structure.md` § File design.

This structure informs the task decomposition. Each task should produce self-contained changes that make sense independently.

## Bite-Sized Task Granularity

Each step is one action (2-5 minutes). Code tasks follow `test-driven-development`: failing test → verify fail → minimal impl → verify pass → commit. Doc/config tasks use draft → review instead of TDD (note output format: `docs`, `config`, `script`).

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** Implement tasks one at a time. Code tasks: failing-test-first RED-GREEN-REFACTOR; doc/config tasks: draft→review. Steps use checkbox (`- [ ]`) syntax. After all tasks, run the full test suite and verify before claiming done.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Task Structure

The exact markdown template — Files list, 5 checkbox steps (failing
test → verify fail → minimal impl → verify pass → commit) with code and
pytest run blocks — is in `references/task-structure.md`. Load it when
you write a plan's tasks.

## No Placeholders

Every step must contain the actual content an engineer needs. These are **plan failures** — never write them:
- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without actual test code)
- "Similar to Task N" (repeat the code — the engineer may be reading tasks out of order)
- Steps that describe what to do without showing how (code blocks required for code steps)
- References to types, functions, or methods not defined in any task

## Remember
- Exact file paths always
- Complete code in every step — if a step changes code, show the code
- Exact commands with expected output
- DRY, TDD, frequent commits; for scope discipline defer to `ponytail`

## Self-Review

After writing the complete plan, look at the spec with fresh eyes and check the plan against it. This is a checklist you run yourself — not a subagent dispatch.

**1. Spec coverage:** Skim each section/requirement in the spec. Can you point to a task that implements it? List any gaps.

**2. Placeholder scan:** Search your plan for red flags — any of the patterns from the "No Placeholders" section above. Fix them.

**3. Type consistency:** Do the types, method signatures, and property names you used in later tasks match what you defined in earlier tasks? A function called `clearLayers()` in Task 3 but `clearFullLayers()` in Task 7 is a bug.

If you find issues, fix them inline. No need to re-review — just fix and move on. If you find a spec requirement with no task, add the task.

## Execution Handoff

After saving the plan, hand off to execution:

**"Plan complete and saved to `docs/plans/<filename>.md`."**

- Implement tasks one at a time in order, each with TDD (RED-GREEN-REFACTOR). Run tests after each task. Do not proceed past a failing task.
- For planning details and the task structure template, see `references/task-structure.md`.

## Related skills

- `to-tickets` / `wayfinder` — tickets vs fog vs plan.
- `test-driven-development` — each task is a RED-GREEN-REFACTOR cycle.
- `ponytail` — scope discipline per task.

## Completion criteria

- [ ] Plan at `docs/plans/YYYY-MM-DD-<name>.md` with header, file map, bite-sized tasks (code tasks TDD, doc tasks draft→review)
- [ ] No placeholders (`TBD`/`TODO`/"handle edge cases"); every step has complete code + `pytest` command
- [ ] Self-review passed (spec coverage, placeholder scan, type consistency)
