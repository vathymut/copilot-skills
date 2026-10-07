# Five-Factor Rubric

Single source of truth for `code-review` Branches A and B. `SKILL.md`
summarizes; `code-reviewer.md` dispatches against this file. Do not duplicate
this rubric elsewhere — reference it.

Spec, when one exists, governs scope — deviations from it are problems unless
clearly justified.

## 1. Code Conventions

Style and known smells. Skip what tooling (lint/format) already enforces;
documented project standards override baseline.

- Documented convention violations (cite file + rule).
- Baseline smells: Mysterious Name, Duplicated Code, Feature Envy, Data Clumps,
  Primitive Obsession, Repeated Switches, Shotgun Surgery, Divergent Change,
  Speculative Generality, Message Chains, Middle Man, Refused Bequest.
- Language refs (conditioned): SQL → `sql-review.md` anti-patterns only;
  Python → `python-standards.md` correctness/type-safety/performance/style.
  Injection findings belong in Factor 5, not here.
- Other languages: use generic rubric above; defer deep structural smells to
  `refactor` skill if needed.

## 2. Spec Alignment

Requirements missing or partial; behaviour not asked for (scope creep);
implementation that looks wrong (quote the spec). No spec available → skip
this factor. Quick review may skip this factor; full review must attempt
spec lookup first.

## 3. Correctness

Off-by-one and boundary errors in ranges; unhandled error paths or silent
failures; wrong data types or implicit casts that lose precision; race
conditions or shared-mutation bugs.

## 4. Maintainability

Be ambitious — flag restructuring that simplifies. Report; do not implement.

- Code-judo: can branches or layers be deleted rather than modified?
- Deletion test: does each new module or abstraction earn its keep?
- Shallow modules, poor locality (scattered files), file crossing 1000 lines,
  new conditionals in unrelated paths.
- Wrappers/casts/optionals hiding a simpler boundary; feature logic in the
  wrong layer.
- AI slop: verbose comments, defensive bloat, broad `except Exception`,
  unnecessary casts.
- Diff is the smallest working change.
- Structural concerns → apply `maintainability-review.md` depth standards.

## 5. Security & Performance

Single home for injection/vuln findings (do not also file under Factor 1).

- Secrets exposed in diff.
- SQL or command injection vectors.
- Missing input validation.
- Unnecessary allocations, N+1 queries, loop-invariant work.
- Missing caching on repeated expensive operations.

## Output contract (Branches A and B)

Apply every factor. Per factor: one summary line (count + worst issue).
Then issues grouped Critical / Important / Minor; every finding carries
file:line, what's wrong, why it matters, and a fix if not obvious. End with
**Ready to merge?** Yes | No | With fixes, plus a 1-2 sentence technical
assessment.

Keep factor order fixed; the verdict follows the severest issue. Name
specific strengths or say nothing.
