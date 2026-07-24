---
disable-model-invocation: true
name: writing-plans
description: Use when a spec or requirements for a multi-step task exist, before touching code
---

# Writing Plans

One plan per self-contained feature. A plan is a markdown file saved to `docs/plans/YYYY-MM-DD-<feature-name>.md` with: goal sentence, architecture sketch, file map, and bite-sized TDD tasks — a header, files list, then sequential steps each with failing test → verify fail → implement → verify pass → commit.

Default to one plan per run. If the spec covers multiple independent subsystems, split into separate plans — one per subsystem. For mixed code/no-code tasks (e.g. config + script + docs), include all types in one plan; label each task's output format.

## Output format

The deliverable is a single markdown file at `docs/plans/YYYY-MM-DD-<feature-name>.md` containing:

- **Header block**: goal sentence, architecture sketch (2-3 sentences), tech stack
- **File map**: every file to create or modify, with responsibility
- **Sequential tasks**: each with RED → GREEN → REFACTOR, exact code, and `pytest` commands

No placeholders, no TBDs, no "implement later". Every code block is complete.

## Which planning skill?

| Situation | Use |
|---|---|
| Self-contained multi-step feature (default) | **writing-plans** (this skill) |
| Work to publish as tracker tickets with blocking edges, route clear | `to-tickets` |
| Work too big for one session, wrapped in fog | `wayfinder` |

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- You reason best about code you can hold in context at once, and your edits are more reliable when files are focused. Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure - but if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition. Each task should produce self-contained changes that make sense independently.

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** Implement tasks one at a time, each with a failing-test-first RED-GREEN-REFACTOR cycle. Steps use checkbox (`- [ ]`) syntax for tracking. After all tasks, run the full test suite and verify before claiming done.

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
