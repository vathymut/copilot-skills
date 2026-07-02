---
name: refactor
description: 'Surgical code refactoring — improve maintainability without changing behavior. Use when the user asks to clean up, refactor, improve code structure, break down large functions, or eliminate code smells.'
license: MIT
---

# Refactor

Improve code structure and readability without changing external behavior. Small steps, always with tests.

## When to Use

Use this skill when:

- Code is hard to understand or maintain
- Functions/classes are too large
- Adding features is difficult due to code structure

**Not for:** rewrites from scratch (use `repo-rebuilder`), or working on code without tests.

---

## Steps

### 1. Prepare

Write or confirm tests exist that cover current behavior. Commit the working state. Identify the specific code smell to address.

**Completion criterion:** Tests pass on current code, clean commit exists, target smell is identified.

### 2. Plan the path

Read the code to understand what it does. Consult `references/code-smells.md` to identify which smell applies. If the refactoring involves replacing conditional logic with polymorphism, see `references/design-patterns.md`. Decide the smallest change that addresses the smell.

**Completion criterion:** You can name the specific change, the smell it fixes, and the behavior it preserves.

### 3. Refactor in small steps

Make one change. Run tests. Commit if they pass. Repeat. Never mix refactoring with feature changes.

**Completion criterion:** Every intermediate commit passes tests; no single commit changes behavior.

### 4. Verify

Run the full test suite. If the project has a type checker, run it. Confirm no behavioral changes were introduced.

**Completion criterion:** All tests pass, types check, and manual spot-checks confirm behavior is unchanged.

### 5. Clean up

Update comments and documentation that reference the old structure. Remove any temporary markers.

**Completion criterion:** No stale references to removed code remain in comments or docs.

---

## Constraints

- **Behavior is preserved** — refactoring changes structure, not behavior
- **Tests are mandatory** — without tests, you're editing, not refactoring
- **One change at a time** — don't bundle refactoring with feature work
- **Small steps** — if a step feels large, split it further

### When NOT to Refactor

- Code that works and won't change again
- Critical production code without tests (add tests first)
- Under a tight deadline with no time for verification
