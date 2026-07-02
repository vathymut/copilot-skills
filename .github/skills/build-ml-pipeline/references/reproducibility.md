# Reproducibility — extending without breaking prior experiments

`iterate-ml-experiment` enforces a hard rule: every `done` row in
`JOURNAL.md` History must stay runnable on `main` and produce the
same result. When touching a shared module under `src/<pkg>/`,
**default behavior must preserve prior experiments' shape**.

## Three options, picked by judgment

- **Option 1 — parametrize the existing function** (with a
  default-preserving flag). Pick when the change is small and
  scoped: a step appended at the end, a single conditional, a
  stateless transform that adds columns without reshaping
  existing ones. **The flag's default mirrors prior behavior.**
- **Option 2 — add a new function called only from the new
  experiment.** Pick when the change doesn't fit cleanly behind a
  flag: new estimator at the tail, a step that reshapes the
  graph, or Option 1 would grow ugly internal branching.
- **Option 3 — branch the module.** Last resort. Only when the
  change touches enough internal structure that Options 1 and 2
  would obscure the diff. Usually a signal of a deeper layering
  issue worth surfacing to the user.

## Tripwires (load-bearing)

- **3+ flags in one function** → parametrization is leaking;
  reach for Option 2 next.
- **Visible branching in the function body** that makes it hard
  to read → reach for Option 2.
- **A flag changes default behavior of an existing caller** →
  STOP. Rule broken. Either keep the default preserving, or use
  Option 2.

## Cheap executable check

`iterate-ml-experiment` § 3's smoke-test gate runs **all** of
`tests/smoke/`, not just the new one. A prior smoke test going
red after a change = default behavior not preserved. Fix before
declaring the new experiment ready.
