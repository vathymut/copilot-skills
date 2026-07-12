---
name: refactor
description: 'Surgical code refactoring — improve maintainability without changing behavior. Use when the user asks to clean up, refactor, improve code structure, break down large functions, or eliminate code smells. Also use when the user asks for a refactor plan; planning is step 1 of this skill.'
license: MIT
---

# Refactor

Improve code structure and readability without changing external behavior. Small steps, always with tests.

**Not for:** rewrites from scratch, or code without tests.

## When to use

- Code is hard to understand or maintain.
- Functions/classes are too large.
- Adding features is difficult due to code structure.
- The user asks for a refactor plan.

## Steps

### 1. Prepare

Write or confirm tests exist that cover current behavior. Commit the working state. Identify the specific code smell to address.

**Completion criterion:** Tests pass on current code, clean commit exists, target smell is identified.

### 2. Plan the path

For a **multi-file refactor**, or when the user explicitly asks for a plan, produce a written plan before touching code:

1. Read the code to understand what it does.
2. Identify affected files, ownership boundaries, dependencies, and hidden coupling.
3. Sequence the changes safely: contracts/types first, then implementations, then callers, then tests, then cleanup.
4. Include verification steps between phases and a final validation command.
5. Include rollback or recovery steps for the riskiest phases.
6. Stop and ask for confirmation before implementing, unless the user explicitly said to proceed without review.

Use the plan format in [references/refactor-plan-template.md](references/refactor-plan-template.md).

For a **local refactor**, plan mentally but still name the change, the smell it fixes, and the behavior it preserves.

**Completion criterion:** You can name the specific change(s), the smell(s) addressed, the behavior preserved, and the user has confirmed a multi-file plan if one was written.

### 3. Refactor in small steps

Make one change. Run tests. Commit if they pass. Repeat. Never mix refactoring with feature changes.

**Completion criterion:** Every intermediate commit passes tests; no single commit changes behavior.

### 4. Verify

Run the full test suite. If the project has a type checker, run it. Confirm no behavioral changes were introduced.

**Completion criterion:** All tests pass, types check, and manual spot-checks confirm behavior is unchanged.

### 5. Clean up

Update comments and documentation that reference the old structure. Remove any temporary markers.

**Completion criterion:** No stale references to removed code remain in comments or docs.

## Constraints

- **Behavior is preserved** — refactoring changes structure, not behavior.
- **Tests are mandatory** — without tests, you're editing, not refactoring.
- **One change at a time** — don't bundle refactoring with feature work.
- **Small steps** — if a step feels large, split it further.

### When not to refactor

- Code that works and won't change again.
- Critical production code without tests (add tests first).
- Under a tight deadline with no time for verification.
