---
name: refactor
description: Use when existing code needs restructuring without behavior change — large functions, code smells, hard-to-maintain structure, or a multi-file refactor plan with tests.
license: MIT
---

# Refactor

Improve code structure without changing external behavior. Branch A is the
default path: change structure in small steps, always with tests.

**Not for:** rewrites from scratch, or code without tests. For architectural
deepening (module interfaces, seams, testability), fold that work into the
restructure itself rather than handing off to a separate skill. Scope
discipline (how small is small enough) is a separate concern — this skill
reshapes *structure*, it does not shrink *scope*.

## When to use

- Code is hard to understand or maintain.
- Functions/classes are too large.
- Adding features is difficult due to code structure.
- The user asks for a refactor plan.

## Vocabulary: key terms

- **Deep module** — lots of behaviour behind a small interface.
- **Interface** — everything a caller must know to use a module correctly: type signature, invariants, ordering, error modes, config, performance.
- **Seam** (Feathers) — where a module's interface lives; the place you can alter behaviour without editing in place.
- **Adapter** — a concrete thing that satisfies an interface at a seam.
- **Depth** — leverage at the interface; the deletion test tells you if a module earned its keep.

For deepening clusters or exploring alternatives, see `references/DEEPENING.md` and `references/DESIGN-IT-TWICE.md`.

## Local refactor

1. **Prepare** — Write or confirm tests. Commit working state. Identify the code smell.

2. **Refactor in small steps** — One change, run tests, commit if they pass. Repeat. Never mix refactoring with feature changes.

3. **Verify** — Run full test suite and type checker. Confirm no behavioral changes.

4. **Clean up** — Update comments and docs. Remove temporary markers.

## Multi-file refactor

Adds a written plan step before the local refactor steps above:

0. **Write plan** — Read the code. Identify affected files, dependencies, and hidden coupling. Sequence changes: contracts/types first, then implementations, callers, tests, cleanup. Include verification between phases and rollback for risky phases. Use `references/refactor-plan-template.md`. Confirm with user before implementing.

Then follow Local refactor steps 1-4.

## Constraints

- **Behavior is preserved** — refactoring changes structure, not behavior.
- **Tests are mandatory** — without tests, you're editing, not refactoring.
- **One change at a time** — don't bundle refactoring with feature work.
- **Small steps** — if a step feels large, split it further.

### When not to refactor

Code that works and won't change again, or production code without tests (add tests first).
