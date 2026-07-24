---
name: evaluate-ml-pipeline
description: Use when a declared ML pipeline needs validation — cross-validation, a predict-time smoke test, or a read-only audit digest.
---

# Evaluate ML Pipeline

Three sub-tasks: **evaluate** (CV report), **smoke** (predict-time structural proof), **audit** (read-only digest). Pipeline declaration → `build-ml-pipeline`.

| Signal | Branch |
|---|---|
| Choose entry point / CV / run `experiments/NN_*.py` | Evaluate |
| "write the smoke test" / smoke failure / late mark-as-X | Smoke |
| "audit 02" / record outcome / digest report | Audit |

## Stop conditions — all branches

- **Missing dependency.** `import skore` fails → `python-env-manager`. No `cross_val_score` fallback.
- **Symbol from memory forbidden.** All symbols via `python-api`.
- **`skore.evaluate` / `project.put` live only in `experiments/NN_*.py`.** Scratch/audit files are read-only.
- **CV splitter is data-driven, not default-driven (G-CV-SPLITTER).** Read `split_kwargs` from X marker. Temporal → `AskUserQuestion`.
- **No stratified splitters for class imbalance.**
- **CV not sufficient for history-dependent pipelines.** Smoke must pass.
- **Python-stack defaults** — `scratch/`, ruff, harness hints: `ml-conventions:references/shared-ml-conventions.md`.
- **Audit is read-only.** No evaluate/put. `project.get(id)` by id, not key.

## Pre-flight

```
Pre-flight (evaluate-ml-pipeline):
- [ ] Branch: evaluate | smoke | audit
- [ ] Tier 1 libs importable: sklearn, skrub, skore
- [ ] python-api consulted for skore/sklearn/skrub symbols
- [ ] (Evaluate) split_kwargs at X marker; splitter chosen
- [ ] (Smoke) Test file: tests/smoke/test_NN_<short_name>.py
- [ ] (Smoke) Hard + soft assertion wired
- [ ] (Audit) Report present; read-only contract verified
- [ ] Pre-flight re-emitted with evidence
```

## § Evaluate

**Trigger:** user chooses entry point, runs CV, or `experiments/NN_*.py` needs the evaluate call.

**Procedure:**

1. Pass `splitter=` explicitly to `skore.evaluate(...)`. Omitted splitter silently falls back to holdout.
2. Pick splitter via G-CV-SPLITTER: `groups` → `GroupKFold`; temporal → `AskUserQuestion` (`TimeSeriesSplit(gap=horizon)` default, `gap=0`, custom, or `KFold`); none → `KFold`.
3. Use sklearn-style `skore.evaluate(estimator, X, y, splitter=...)` or env-dict-style for `SkrubLearner`.
4. Escalate only if `evaluate` is too coarse: `EstimatorReport`, `CrossValidationReport`, `ComparisonReport`. Details: `references/reports.md`.
5. Trust skore's metric defaults. Override only on user request.

**Stop conditions:** Custom splitter? Small contract in `references/custom-splitter.md`. Avoid stratified/LOO/LeaveOneGroupOut. See `references/cross-validation.md`.

## § Smoke

**Trigger:** user writes smoke test, smoke fails, or late mark-as-X diagnosed.

**Procedure:**

1. Write `tests/smoke/test_NN_<short_name>.py`. Template: `templates/smoke.py`.
2. Hard assertion: `assert len(predictions) == n_predict_grid_rows`.
3. Soft assertion: `assert smoke_mae < 3 * CV_MAE_MEAN` (CV_MAE_MEAN from design note).
4. Use predicting package API only (`skrub` + `sklearn.metrics`). No `skore`.
5. Fixture: predict env carries only predict-grid rows. See `references/smoke-fixtures.md`.

**Stop conditions:** Hard failure → `build-ml-pipeline` (pipeline shape bug). Don't loosen assertion. Soft failure → history node not resolved at predict time. Failure blocks `done`.

## § Audit

**Trigger:** user says "audit" or "record outcome", or G-RUN completed.

**Procedure:**

1. Write `audit/NN_<short_name>.py` from template `templates/audit.py`.
2. Execute: `<agent-env-prefix> python ml-eda:scripts/run_cells.py audit/<stem>.py [scratch/audit/<stem>/audit.md]`.
3. Full cell sequence in `templates/audit.py` (imports → open Project → summarize → get report → checks → metrics).
4. Read-only: no `skore.evaluate`, no `project.put`.

**Stop conditions:** `project.get(id)` by id, not key. Runner streams stdout. Digest feeds `iterate-ml-experiment`. Runner details: `references/runner_internals.md`.

## References

- `iterate-ml-experiment` — ownership map.
- `references/cross-validation.md` — splitter reasoning.
- `references/reports.md` — report escalation.
- `references/custom-splitter.md` — custom splitter contract.
- `references/metadata-routing.md` — `split_kwargs`.
- `references/smoke-fixtures.md` — fixture shapes.
- `references/failure_modes.md` — recovery.
- `references/shortcuts.md` — forbidden shortcuts.
