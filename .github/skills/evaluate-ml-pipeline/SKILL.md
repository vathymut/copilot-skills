---
name: evaluate-ml-pipeline
description: "Evaluate, smoke-test, and audit an ML pipeline in one chain: CV report, predict-time structural proof, and read-only digest."
---

# Evaluate ML Pipeline

Validate a declared pipeline. Three sub-tasks, in order:
**evaluate** (CV report), **smoke** (predict-time structural proof),
**audit** (read-only digest). The pipeline declaration is out of scope
→ `build-ml-pipeline`.

## Branches — which path this turn

| Signal | Path | Section |
|---|---|---|
| Choose entry point / CV / run `experiments/NN_*.py` | evaluate | § Evaluate |
| "write the smoke test" / smoke failure / late mark-as-X | smoke | § Smoke |
| "audit 02" / record outcome / digest the report | audit | § Audit |

## Stop conditions — read first

- **Missing dependency.** `import skore` raises → invoke
  `python-env-manager`. Do not drop back to `cross_val_score`,
  `cross_validate`, `classification_report`, or hand-rolled prints.
- **Symbol from memory is forbidden.** Every `skore`, `skrub`,
  `sklearn` symbol this turn comes from `python-api`.
- **`skore.evaluate(...)` and `project.put(...)` live only in
  `experiments/NN_*.py`.** Scratch, audit, and one-off files are
  read-only consumers; they lookup via `summarize()` → `get(id)`.
- **CV splitter is data-driven, not default-driven (`G-CV-SPLITTER`).**
  Read `split_kwargs` from the X marker; never reach for `KFold(5)`
  out of habit. Temporal data → mandatory `AskUserQuestion` with the
  four options in § Evaluate rule 3.
- **No stratified splitters for class imbalance.** They compress
  across-fold variance and produce over-confident error bars.
- **CV is necessary but not sufficient for history-dependent
  pipelines.** Lags, rolling windows, target shifts, or joins with
  side history require a passing smoke test before the experiment can
  be marked `done`.
- **Python-stack defaults apply:** all execution to `scratch/`, no
  inline `python -c`, don't filter warnings. See `python-api` and
  `python-quality`.
- **Audit is read-only against the skore Project.** No `evaluate`,
  no `put`, no writes to `data/` / `reports/` / `src/<pkg>/`.
- **`project.get(...)` is by id, not key.** For hub, derive id from
  the printed URL (`…/cross-validations/<N>` →
  `skore:report:cross-validation:<N>`). For local/mlflow, read the
  `"id"` column from `project.summarize()`.
- **Harness "no clarifying questions" hints do not waive mandatory
  `AskUserQuestion` gates.**

## Pre-flight — emit before any code

```
Pre-flight (evaluate-ml-pipeline):
- [ ] Branch: evaluate | smoke | audit
- [ ] Tier 1 libs importable: sklearn, skrub, skore
      Evidence: scratch/<ts>_check_tier1.py + run
- [ ] `journal/NN_<short_name>.md` exists and ≥ approved;
      `experiments/NN_<short_name>.py` exists (or n/a for re-audit)
      Evidence: ls/Glob
- [ ] python-api consulted for skore/sklearn/skrub symbols this turn
      Evidence: Read/Write scratch/api/<lib>/<version>/<topic>.md
- [ ] (Evaluate) split_kwargs at X marker read: <groups | time | none>
- [ ] (Evaluate) Splitter chosen via rule 3: <name + reason>
- [ ] (Evaluate) `skore.evaluate` / `project.put` call site is
      `experiments/NN_<short_name>.py`
- [ ] (Smoke) Test file stem: `tests/smoke/test_NN_<short_name>.py`
- [ ] (Smoke) Hard assertion wired: `len(predictions) == n_predict_grid_rows`
- [ ] (Smoke) Soft assertion wired or explicitly skipped
- [ ] (Audit) Report present under key=<NN_short_name>
      Evidence: project.summarize() this turn shows the row
- [ ] (Audit) Read-only contract verified: no evaluate/put calls
- [ ] Pre-flight re-emitted with evidence before final message.
```

## § Evaluate

### Rule 1 — `skore.evaluate(...)` is the entry point

Always pass `splitter=` explicitly. Omitted `splitter=` falls back to
a single 80/20 holdout or a DataOp `cv=`; this stack does not declare
`cv` at the marker, so omission silently breaks protocol.

Data-passing forms:

- sklearn-style: `skore.evaluate(estimator, X, y, splitter=...)`.
- env-dict-style for `SkrubLearner`:
  `skore.evaluate(learner, data={"X": X, "y": y, ...}, splitter=...)`.

### Rule 2 — Escalate only when `evaluate` is too coarse

- `EstimatorReport` — final fit on held-out data after CV.
- `CrossValidationReport` — k-fold, per-fold artifacts.
- `ComparisonReport` — ≥2 learners side-by-side.

Details: `references/reports.md`.

### Rule 3 — Pick the splitter from structural facts (`G-CV-SPLITTER`)

| `split_kwargs` content | Splitter |
|---|---|
| `groups` | `GroupKFold` |
| temporal ordering | `AskUserQuestion` — four options: `TimeSeriesSplit(gap=horizon)` (default), `TimeSeriesSplit(gap=0)` with warning, custom splitter, `KFold` ignoring time |
| none | `KFold` (or `RepeatedKFold` for small/noisy data) |

Avoid by default: stratified variants, `LeaveOneOut`,
`LeaveOneGroupOut`. Reasoning: `references/cross-validation.md` § Avoid.

### Rule 4 — Trust skore's metric defaults

Override only on explicit user request. No pre-emptive `scoring=`.

### Rule 5 — Custom splitter only when sklearn lacks it

Small contract: `split` + `get_n_splits`. See
`references/custom-splitter.md`.

## § Smoke

Write `tests/smoke/test_NN_<short_name>.py`: a diagnostic fixture +
two assertions. The test uses **only** the predicting package's API
(`skrub` + `sklearn.metrics`); no `skore` import, so it is portable.

### Hard assertion — row count

```python
assert len(predictions) == n_predict_grid_rows
```

A correctly placed X marker makes this pass trivially. A late marker
silently drops cold-start rows and fails.

### Soft assertion — NaN sanity

```python
smoke_mae = mean_absolute_error(y_true, predictions)
assert smoke_mae < 3 * CV_MAE_MEAN
```

`CV_MAE_MEAN` is a literal hardcoded from the design note's headline.
Opt-out only when ground truth is deliberately absent; leave a comment
explaining why.

### Fixture contract

The predict env carries **only** the rows we want predictions for, with
**no** pre-history padding. Three common source shapes and how to build
them: `references/smoke-fixtures.md`.

### Failure semantics

- Hard failure → pipeline shape bug; route back to `build-ml-pipeline`.
  Don't loosen the assertion, don't wrap, don't add `feature_steps=[]`.
- Soft failure → values exist but are garbage (usually a history node
  not resolved at predict time).
- Failure blocks `done` in `iterate-ml-experiment`.

Template: `templates/smoke.py`.

## § Audit

Per-experiment `# %%` file at `audit/NN_<short_name>.py`; executes to a
markdown digest. Read-only.

### Allowed / forbidden

Allowed: open `skore.Project(...)`, `summarize()`, `get(id)`, every
`report.*` accessor, read-only imports from `<pkg>`.
Forbidden: `skore.evaluate(...)`, `project.put(...)`, any workspace
mutation, monkey-patching.

### Cell sequence

1. Markdown docstring (read-only rule).
2. Imports.
3. Open Project as a bare expression.
4. `project.summarize()`.
5. `report = project.get(REPORT_ID)`; `report`.
6. `report.checks.summarize().frame()`.
7. `report.metrics.summarize().frame()`.

`.frame()` is load-bearing on cells 6 and 7. Full examples:
`references/cell_anatomy.md`.

### Execution

```bash
pixi run -e agent python \
  ~/.config/opencode/skills/ml-eda/scripts/run_cells.py \
  audit/<stem>.py [scratch/audit/<stem>/audit.md]
```

The runner always streams stdout; the optional second arg also writes
  the digest. Runner lives in `ml-eda`; internals: `references/runner_internals.md`.

### The digest feeds the loop

`iterate-ml-experiment` reads `scratch/audit/<stem>/audit.md` as text
to extract metrics and check `documentation_url`s. It never re-opens
the Project.

Template: `templates/audit.py`.

## References

- `writing-great-skills:references/ml-companion-skills.md` — canonical
  ownership map.
- `references/cross-validation.md` — splitter reasoning and avoid list.
- `references/reports.md` — report escalation.
- `references/custom-splitter.md` — custom splitter contract.
- `references/metadata-routing.md` — routing `split_kwargs`.
- `references/smoke-fixtures.md` — three fixture shapes.
- `references/cell_anatomy.md` — concrete audit cell examples.
- `references/runner_internals.md` — how the cell runner works.
- `references/failure_modes.md` — audit smoke / audit recovery.
- `references/shortcuts.md` — forbidden shortcuts.
