---
name: evaluate-ml-pipeline
description: Use when a declared ML pipeline needs validation — cross-validation, a predict-time smoke test, or a read-only audit digest.
---

# Evaluate ML Pipeline

Three sub-tasks: **evaluate** (CV report), **smoke** (predict-time structural proof), **audit** (read-only digest). Pipeline declaration → `build-ml-pipeline`.

## When NOT to use

- No pipeline declared yet — use `build-ml-pipeline` first.
- You only need ad-hoc SQL/profile of a file — use `data-access`.
- Auditing without a finished `experiments/NN_*.py` run — there is no report to read.

| Signal | Branch |
|---|---|
| Choose entry point / CV / run `experiments/NN_*.py` | Evaluate |
| "write the smoke test" / smoke failure / late mark-as-X | Smoke |
| "audit 02" / record outcome / digest report | Audit |


## Gates (one-line)

| Gate | Owner | Meaning |
|---|---|---|
| G-PKG-NAME | `iterate-ml-experiment` §0.5 | Python package name |
| G-ENV-MGR | `python-stack-env` | Env manager (pixi/uv/poetry/…) |
| G-TABULAR | `iterate-ml-experiment` §0.5 | `pandas` vs `polars` |
| G-SKORE-MODE | `iterate-ml-experiment` §0.5 | `local`/`hub`/`mlflow` |
| G-EDA | `ml-eda` / `iterate-ml-experiment` §0 | `run`/`skip` |
| G-DESIGN | `iterate-ml-experiment` §3 | Design note approved? |
| G-CV-SPLITTER | `evaluate-ml-pipeline` §Evaluate | Splitter derived from `split_kwargs` |
| G-RUN | `iterate-ml-experiment` §3 | Run now vs leave for later |

Full wording: `ml-conventions:references/ml-gates.md`. Harness hints never waive `AskUserQuestion` gates.

## Stop conditions — all branches

- **Missing dependency.** `import skore` fails → `python-stack-env`. No `cross_val_score` fallback.
- **Symbol from memory forbidden.** All symbols via `python-api`.
- **`skore.evaluate` / `project.put` live only in `experiments/NN_*.py`.** Scratch/audit files are read-only.
- **CV splitter is data-driven, not default-driven (G-CV-SPLITTER).** Read `split_kwargs` from X marker. Temporal → `AskUserQuestion`.
- **No stratified splitters for class imbalance** — use `KFold`/`GroupKFold` even when imbalanced; stratification leaks distribution into folds and inflates scores (see `references/cross-validation.md` § Why no stratification). Only override when user explicitly requests stratification and accepts leakage risk.
- **CV not sufficient for history-dependent pipelines.** Smoke must pass.
- **Python-stack defaults** — `scratch/`, ruff, harness hints: `ml-conventions:references/shared-ml-conventions.md`.
- **Audit is read-only.** No evaluate/put. `project.get(id)` by id, not key.
- **Recovery and shortcuts:** `references/failure_modes.md`, `references/shortcuts.md`.

## Pre-flight

Shared gates → `ml-conventions:references/shared-preflight-evidence.md` (don't duplicate that contract here).

```
Pre-flight (evaluate-ml-pipeline):
- [ ] Branch: evaluate | smoke | audit
- [ ] (Evaluate) split_kwargs at X marker; splitter chosen
- [ ] (Smoke) Test file: tests/smoke/test_NN_<short_name>.py
- [ ] (Smoke) Hard + soft assertion wired
- [ ] (Audit) Report present; read-only contract verified
- [ ] Plus shared gates from ml-conventions; re-emit with evidence
```

## § Evaluate

**Trigger:** user chooses entry point, runs CV, or `experiments/NN_*.py` needs the evaluate call.

**Procedure:**

1. Pass `splitter=` explicitly to `skore.evaluate(...)`. Omitted splitter silently falls back to holdout.
2. Pick splitter via G-CV-SPLITTER: `groups` → `GroupKFold`; temporal → `AskUserQuestion` (`TimeSeriesSplit(gap=horizon)` default, `gap=0`, custom, or `KFold`); none → `KFold`. `split_kwargs` mapping: `references/metadata-routing.md`.
3. Use sklearn-style `skore.evaluate(estimator, X, y, splitter=...)` or env-dict-style for `SkrubLearner`.
4. Escalate only if `evaluate` is too coarse: `EstimatorReport`, `CrossValidationReport`, `ComparisonReport`. Details: `references/reports.md`.
5. Trust skore's metric defaults. Override only on user request.

**Stop conditions:** Custom splitter? Small contract in `references/custom-splitter.md`. Avoid stratified/LOO/LeaveOneGroupOut. See `references/cross-validation.md`.

## § Smoke

**Trigger:** user writes smoke test, smoke fails, or late mark-as-X diagnosed.

**Procedure:**

1. Write `tests/smoke/test_NN_<short_name>.py`. Template: `templates/smoke.py`.
2. Hard assertion: `assert len(predictions) == n_predict_grid_rows`.
3. Soft assertion: `assert smoke_mae < 3 * CV_MAE_MEAN` (CV_MAE_MEAN from design note; 3× is a coarse sanity bound — tighten per domain if the metric scale is known).
4. Use predicting package API only (`skrub` + `sklearn.metrics`). No `skore`.
5. Fixture: predict env carries only predict-grid rows. See `references/smoke-fixtures.md`.

**Stop conditions:** Hard failure → `build-ml-pipeline` (pipeline shape bug). Don't loosen assertion. Soft failure → history node not resolved at predict time. Failure blocks `done`.

## § Audit

**Trigger:** user says "audit" or "record outcome", or G-RUN completed.

**Procedure:**

1. Write `audit/NN_<short_name>.py` from template `templates/audit.py`.
2. Execute: `<agent-env-prefix> python ml-eda:scripts/run_cells.py audit/<stem>.py [scratch/audit/<stem>/audit.md]`.
3. Full cell sequence in `templates/audit.py` (imports → open Project → summarize → get report → checks → metrics). Cell anatomy: `references/cell_anatomy.md`.
4. Read-only: no `skore.evaluate`, no `project.put`.

**Stop conditions:** `project.get(id)` by id, not key. Runner streams stdout. Digest feeds `iterate-ml-experiment`. Runner details: `references/runner_internals.md`.

## Completion criteria

- [ ] Branch executed: evaluate (splitter=`K/Group/TimeSeries` explicit) | smoke (hard+soft assertions) | audit (read-only digest)
- [ ] `split_kwargs` respected from X marker; stratified/LOO avoided
- [ ] Smoke hard=`len(predictions)==n_predict` passes; soft `<3×CV_MAE_MEAN` evaluated
- [ ] Pre-flight re-emitted with evidence; skills verified via `python-api`

## Related skills

- `build-ml-pipeline` — declaration before evaluation.
- `iterate-ml-experiment` — records audit digest in JOURNAL.
- `python-stack-env` — missing `skore`; agent feature for audit.
