---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Overview

Write implementation plans for an engineer who has not seen this codebase or this spec. Assume they write idiomatic code in the project's language once they know the exact interface and the exact test, and that they will make a reasonable choice wherever the plan leaves one open. What they cannot know is what you decided: which files, which names and signatures, which values from the spec, which tests prove each task. Document those. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

**Save plans to:** `docs/plans/YYYY-MM-DD-<feature-name>.md`
- (User preferences for plan location override this default)

## When NOT to use

- Single-bug fix with no multi-step decomposition — go straight to `systematic-debugging` → `test-driven-development`.

## Scope Check

Default to one plan per run. If the spec covers multiple independent subsystems, suggest breaking it into separate plans — one per subsystem. Each plan should produce working, testable software on its own. For mixed code/no-code tasks (e.g. config + script + docs), include all types in one plan; label each task's output format.

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- You reason best about code you can hold in context at once, and your edits are more reliable when files are focused. Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure — but if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition. Each task should produce self-contained changes that make sense independently.

## Task Right-Sizing

A task is the smallest unit that carries its own test cycle and is worth a fresh reviewer's gate. When drawing task boundaries: fold setup, configuration, scaffolding, and documentation steps into the task whose deliverable needs them; split only where a reviewer could meaningfully reject one task while approving its neighbor. Each task ends with an independently testable deliverable.

## Step Granularity

**Each step is one action with a checkable result:**
- "Write the failing test" — step
- "Run it to make sure it fails" — step
- "Implement the minimal code to make the test pass" — step
- "Run the tests and make sure they pass" — step
- "Commit" — step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** Implement tasks one at a time in order per `test-driven-development` (failing test → verify fail → minimal impl → verify pass → commit). Steps use checkbox (`- [ ]`) syntax for tracking. After all tasks, run the full test suite and verify before claiming done.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

**Spec:** [path to the spec/design doc this plan implements — the plan
argues from the spec, so the spec travels with it; executors read both]

## Global Constraints

[The spec's project-wide requirements — version floors, dependency limits,
naming and copy rules, platform requirements — one line each, with exact
values copied verbatim from the spec. Every task's requirements implicitly
include this section.]

## Review Focus

[The five input classes or failure modes the spec implies but no task's
tests exercise that are most likely to bite a person using this software
— one line each, naming the input or condition and the behavior a
reasonable person would expect, most likely first. The spec is a vision
document: it says what the software must do, not everything it will
meet, and its silence on an input is not permission for that input to
break the program. Write the list here, once, with the spec in front of
you. Then, for each line, add the test that pins it to the task that
owns the code, in that task's own step style.]

---
```

## Task Structure

The exact markdown template — Files list, Interfaces (Consumes/Produces), 5 checkbox steps (failing test → verify fail → signature-pinned impl → verify pass → commit) — is in `references/task-structure.md`. Load it when you write a plan's tasks.

## What a Step Contains

A step is done when the implementer can write exactly one reasonable thing from it. That is the whole requirement: unambiguous, not complete. Each kind of step carries what makes it unambiguous and nothing more:

- **A test step:** the test's name and its assertions, as code, with the spec's exact values in them.
- **A code step:** the exact signature (name, parameters, return type), the file it lives in, and the specific values the spec pins. The implementer writes the body. A body appears only for an algorithm the signature and tests do not determine, or for exact copy the spec fixes.
- **A verification step:** the command to run and the output that means it passed.
- **A reference to another task:** that task's Interfaces block says what to use; the plan does not repeat that task's code.

A plan is the set of decisions the implementer cannot make alone. A plan longer than the code it describes has written the code instead. Lines that decide nothing ("TBD", "handle edge cases", "add appropriate validation", "write tests for the above", a type or function no task defines) are the opposite failure, and the self-review catches both.

## Self-Review

After writing the complete plan, look at the spec with fresh eyes and check the plan against it. This is a checklist you run yourself — not a subagent dispatch.

**1. Spec coverage:** Skim each section/requirement in the spec. Can you point to a task that implements it? List any gaps.

**2. Step scan:** Every step must let the implementer write exactly one reasonable thing, and no step may carry more than that: a line that decides nothing is a gap, a function body the signature and tests already determine is a transcript. Fix both.

**3. Type consistency:** Do the types, method signatures, and property names you used in later tasks match what you defined in earlier tasks? A function called `clearLayers()` in Task 3 but `clearFullLayers()` in Task 7 is a bug.

**4. Review Focus:** For each input class or failure mode the spec implies, is there a task whose tests exercise it? The five uncovered ones most likely to bite a person go in the Review Focus section, and each line there gets its test added to the owning task. An empty section means you checked and found none, not that you skipped the check.

**5. Proportion:** Compare the plan's length to the spec's. A plan several times longer than the spec it implements is a transcript of the program, not a plan. If code blocks are most of the document, replace bodies with signatures, test names and assertions, and check that each step is still unambiguous.

If you find issues, fix them inline. No need to re-review — just fix and move on. If you find a spec requirement with no task, add the task.

## Execution Handoff

After saving and self-reviewing the plan, link it for your human partner to read and ask them to confirm it captures what they want. Wait for that review before implementation.

**"Plan complete and saved to `docs/plans/<filename>.md`. Please review the plan. Does it capture what you want?"**

Then implement tasks one at a time in order, each per `test-driven-development` (RED-GREEN-REFACTOR). Run tests after each task. Do not proceed past a failing task.

## Related skills

- `test-driven-development` — each task is a RED-GREEN-REFACTOR cycle.
- `ponytail` — scope discipline per task.
- `systematic-debugging` — single-bug fixes that need no plan.
- `grilling` — stress-test the plan before locking it.
- `research` / `domain-modeling` — facts and glossary/ADRs the plan argues from.
- `git-workflow` — worktree setup for isolated plan execution.

## Completion criteria

- [ ] Plan at `docs/plans/YYYY-MM-DD-<name>.md` with header (goal, architecture, stack, spec, constraints, review focus), file map, right-sized tasks
- [ ] Every step unambiguous (one reasonable thing) and minimal — signatures + assertions, bodies only for undetermined algorithms
- [ ] Self-review passed (spec coverage, step scan, type consistency, review focus, proportion)
