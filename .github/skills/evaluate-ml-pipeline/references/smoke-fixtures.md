# Smoke-test fixtures

Three common source-binding shapes for `tests/smoke/test_NN_*.py`.

## Directory of raw files

Experiment binds `data_dir`; loader globs files inside it.

- Predict env: create a tiny temp dir with the time-sliced raw files
  using `tmp_path`; bind it as `data_dir`.
- `n_predict_grid_rows`: row count of the supervised representation of
  the predict env (e.g. `len(build_supervised_frame(predict_dir))`),
  known a priori from the slice.

## Predict-grid + raw-history sources

Early-mark shape from `build-ml-pipeline` rule 2: `predict_grid` plus
`history_source` / `weather_source` / etc.

- Predict env: build the in-memory `predict_grid` (timestamps, panel
  keys, …) and source identifiers. No file write needed.
- `n_predict_grid_rows`: `len(predict_grid)`.

## Materialized `(X, y)` for IID

`build_learner` binds `X` and `y` directly.

- Predict env: hold out a small subset of rows from materialized `X`
  (and matching `y`) before fit.
- `n_predict_grid_rows`: `len(predict_subset)`.

## General fixture rules

- Use the **smallest** predict window that still triggers the failure
  mode (one horizon-length slice is usually enough).
- No pre-history padding beyond what predict-time-known features
  require.
- `y_true` comes from the supervised representation of the predict env.
- Never write derived files to `data/holdout/` or `data/train/`; use
  `tmp_path` for any on-disk fixture pieces.
