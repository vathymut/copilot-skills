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

## Vocabulary: deep modules

When a refactor touches module boundaries (not just local cleanup), use this
shared vocabulary so the shape of the change is unambiguous:

- **Module** — anything with an interface and an implementation (function, class, package, or tier-spanning slice).
- **Interface** — everything a caller must know to use the module correctly: type signature, invariants, ordering, error modes, config, performance.
- **Implementation** — the module's body. Distinct from **Adapter** (a concrete thing satisfying an interface at a seam).
- **Depth** — leverage at the interface: lots of behaviour behind a small interface (deep) vs. a large interface over thin logic (shallow).
- **Seam** (Feathers) — where a module's interface lives; the place you can alter behaviour without editing in place.
- **Adapter** — a concrete thing that satisfies an interface at a seam (role, not substance).
- **Leverage / Locality** — what callers gain from depth (more capability per unit of interface) and what maintainers gain (change concentrates in one place).

Principles: depth is a property of the *interface*, not the implementation; the
deletion test (delete it — does complexity vanish or reappear across callers?)
tells you if it earned its keep; the interface is the test surface; one adapter
means a hypothetical seam, two means a real one (don't introduce a seam unless
something varies across it). For deepening a cluster or exploring alternative
interfaces, see `references/DEEPENING.md` and `references/DESIGN-IT-TWICE.md`.

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
