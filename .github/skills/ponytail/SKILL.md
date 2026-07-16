---
name: ponytail
description: Use when writing or reviewing code and tempted to over-build, or when a minimal YAGNI solution is preferred.
argument-hint: "[lite|full|ultra]"
license: MIT
---

# Ponytail

## Persistence

ACTIVE EVERY RESPONSE. No drift back to over-building. Still active if
unsure. Off only: "stop ponytail" / "normal mode". Default: **full**.
Switch: `/ponytail lite|full|ultra`.

## The ladder

Stop at the first rung that holds:

1. **Does this need to exist at all?** Speculative need = skip it, say so in one line. (YAGNI)
2. **Already in this codebase?** A helper, util, type, or pattern that already lives here → reuse it. Look before you write; re-implementing what's a few files over is the most common slop.
3. **Stdlib does it?** Use it.
4. **Native platform feature covers it?** `<input type="date">` over a picker lib, CSS over JS, DB constraint over app code.
5. **Already-installed dependency solves it?** Use it. Never add a new one for what a few lines can do.
6. **Can it be one line?** One line.
7. **Only then:** the minimum code that works.

The ladder is a reflex, not a research project — but it runs *after* you
understand the problem, not instead of it. Read the task and the code it
touches first, trace the real flow end to end, then climb. Two rungs work →
take the higher one and move on. The first lazy solution that works is the
right one — once you actually know what the change has to touch.

**Bug fix = root cause, not symptom.** A report names a symptom; before you edit, grep every caller of the function you're about to touch. The lazy fix IS the root-cause fix: one guard in the shared function is a smaller diff than a guard in every caller, and patching only the path the ticket names leaves every sibling caller still broken. Fix it once, where all callers route through.

## Rules

- No unrequested abstractions: no interface with one implementation, no factory for one product, no config for a value that never changes.
- No boilerplate, no scaffolding "for later", later can scaffold for itself.
- Deletion over addition. Boring over clever, clever is what someone decodes at 3am.
- Fewest files possible. Shortest working diff wins — but only once you understand the problem. The smallest change in the wrong place isn't lazy, it's a second bug.
- Complex request? Ship the lazy version and question it in the same response, "Did X; Y covers it. Need full X? Say so." Never stall on an answer you can default.
- Two stdlib options, same size? Take the one that's correct on edge cases. Lazy means writing less code, not picking the flimsier algorithm.
- Mark deliberate simplifications with a `ponytail:` comment (`// ponytail: this exists`), simple reads as intent, not ignorance. Shortcut with a known ceiling (global lock, O(n²) scan, naive heuristic)? The comment names the ceiling and the upgrade path: `# ponytail: global lock, per-account locks if throughput matters`.

## Output

Code first. Then at most three short lines: what was skipped, when to add it.
No essays, no feature tours, no design notes. If the explanation is longer
than the code, delete the explanation, every paragraph defending a
simplification is complexity smuggled back in as prose. Explanation the user
explicitly asked for (a report, a walkthrough, per-phase notes) is not debt,
give it in full, the rule is only against unrequested prose.

Pattern: `[code] → skipped: [X], add when [Y].`

## Intensity

Three levels — **lite** (name the lazier alternative, user picks),
**full** (the ladder enforced; default), **ultra** (YAGNI extremist,
deletion before addition) — with a worked example are in
`references/intensity.md`. Load it when choosing how lazy to be.

## Prototype mode

Build a throwaway prototype to answer a design question — the extreme,
throwaway bottom rung of this ladder. NOT for production code.

- **Logic / state model** → `references/prototype-logic.md`
- **UI direction** → `references/prototype-ui.md`

Rules: mark it throwaway; one command to run; no persistence, tests, or
abstractions beyond "runnable"; skip the polish; capture the validated decision
and archive the prototype on a throwaway branch when done.

## Boundaries

Ponytail governs what you build, not how you talk. Level persists until changed or session end.

## Minimalism is the point

Ponytail owns the *how small is small enough* stance: whenever you're tempted to add code, structure, a plan task, or an abstraction, climb the ladder first — reuse, stdlib, native, one line — and apply it directly. Prototype mode (above) answers a design question with the throwaway minimum, the extreme bottom rung of this ladder.

The shortest path to done is the right path.
