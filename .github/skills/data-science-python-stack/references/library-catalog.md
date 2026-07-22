## Tier 1 — Mandatory (install at project start)

These five libraries are always installed in a data-science / ML
project. The first three co-own the modeling workflow:
scikit-learn provides the estimators, skrub provides the
data-cleaning + DataOps layer that sits before them, skore
evaluates the result and persists it as a project on disk. The
fourth, `ruff`, owns lint + format and is non-negotiable: every
project Claude touches should pass `ruff check`. The fifth,
`pytest`, runs the smoke test that every approved experiment
must have per the `evaluate-ml-pipeline` § Smoke contract — without
pytest the smoke-test gate can't enforce
predict-time correctness, so pytest stays mandatory even when
no other tests have been written yet. Each is named explicitly
even when transitively present, because the workflow skills
(`build-ml-pipeline`, `evaluate-ml-pipeline`) depend on them
directly and should not silently lose them if upstream packaging
changes.

- [`scikit-learn`](references/scikit-learn.md) — tabular ML
  algorithms, preprocessing, model-selection helpers. Use
  `HistGradientBoosting{Classifier,Regressor}` instead of pulling in
  xgboost or lightgbm. **Evaluation, cross-validation reports, and
  model comparison are owned by `skore`** — don't inline
  `cross_val_score` / `classification_report` for analysis output.
- [`skrub`](references/skrub.md) — wrap custom dataframe operations
  in a sklearn-compatible computation graph that replays
  deterministically across train and test splits. Use for the
  data-cleaning + feature-engineering layer that sits before the
  sklearn pipeline.
- [`skore`](references/skore.md) — predictive-model evaluation built
  on top of scikit-learn (`evaluate`, `EstimatorReport`,
  `CrossValidationReport`, `ComparisonReport`) **and** experiment
  tracking via the Project API (`skore.Project(...)`,
  `project.put(...)`, `project.get(...)`). Replaces ad-hoc
  `cross_val_score` + handwritten metric printouts; replaces
  `mlflow` for tracking. Brings `numpy`, `pandas`, `matplotlib`,
  `seaborn`, `plotly`, `joblib`, and others transitively (see
  Tier 4) — so static *and* interactive plotting are available
  without any extra install.

  **Skore mode variant.** `skore.Project(...)` supports three
  mutually exclusive modes: `local` (artifacts on disk), `hub`
  (artifacts on Skore Hub), `mlflow` (artifacts in an MLflow
  tracking server). The mode is a workspace-level decision owned by
  `ml-scaffold` § "G-SKORE-MODE". The exact install
  command for each mode lives in `python-env-manager` § "Tier 1
  install: skore variant per mode" — this skill only records *what*
  to install, not *how*. Default-on-no-preference: `local`.
- [`ruff`](references/ruff.md) — single-tool lint + format, Tier 1
  (mandatory). Command, config, and `dev`-feature routing: see
  `ml-conventions:references/shared-ml-conventions.md` (Ruff).
- [`pytest`](references/pytest.md) — test runner for the
  smoke-test gate enforced by `evaluate-ml-pipeline` § Smoke. Every
  approved experiment must have a
  passing `tests/smoke/test_NN_<short_name>.py` before its row
  in `JOURNAL.md` can flip to `done`; pytest is what runs that
  test, so the dependency is non-negotiable even on workspaces
  that haven't authored any tests yet. `python-env-manager` routes
  pytest to the `dev` feature.

## Tier 2 — Competing-library jobs (user choice)

Jobs in this tier have **more than one valid library** in the
stack. The user picks via `AskUserQuestion` before any import or
install (see § "Competing libraries — general rule" above).
Recorded picks live in `journal/JOURNAL.md` Status `Workspace
decisions` and are read first on every subsequent session.

### Competing-jobs table

| Job | Options | Default-on-no-preference |
|-----|---------|--------------------------|
| Tabular dataframe | `pandas` (+ `pyarrow`), `polars` | `pandas` (free via skore) |
| Deep-learning framework | `pytorch`, `keras` (multi-backend) | `pytorch` |
| sklearn-compatible DL wrapper | `skorch` (pytorch-only), `keras` (sklearn-compatible API) | `skorch` |
| Static vs interactive plotting | `matplotlib` / `seaborn`, `plotly` | task-driven — ask which output shape the user wants |
| Model serving / registry | `mlflow.pyfunc` + registry, FastAPI + `joblib` | `mlflow` |

Per-option detail:

- **Tabular dataframe**
  - **`pandas` (+ `pyarrow`)** — established tabular library;
    pyarrow is the recommended Parquet engine + Arrow-backed
    dtype backend. `pandas` is already pulled in by `skore`
    (Tier 4), so the only explicit install for this option is
    `pyarrow` if Parquet IO is in scope. See
    [`pandas`](references/pandas.md) /
    [`pyarrow`](references/pyarrow.md).
  - **`polars`** — Arrow-native tabular library; faster on
    large frames, stricter type system. Requires an explicit
    install (not pulled in by anything in Tier 1). See
    [`polars`](references/polars.md).
- **Deep-learning framework**
  - **`pytorch`** — tensor library with GPU / MPS support and
    autograd. Default DL framework in the stack. See
    [`pytorch`](references/pytorch.md).
  - **`keras`** — high-level, layer-oriented DL API;
    multi-backend (pytorch / TensorFlow / JAX). See
    [`keras`](references/keras.md).
- **sklearn-compatible DL wrapper**
  - **`skorch`** — wraps a PyTorch `nn.Module` so it behaves
    like a sklearn estimator (`fit` / `predict`, GridSearchCV,
    pipelines). See [`skorch`](references/skorch.md).
  - **`keras`** — exposes a sklearn-compatible API directly
    via `keras.wrappers.SKLearnClassifier` /
    `SKLearnRegressor`. See
    [`keras`](references/keras.md).
- **Static vs interactive plotting** — both are already
  available transitively via `skore` (matplotlib, seaborn,
  plotly all land without an explicit install). The ask is
  *which output shape the user wants for this project*, not
  which install to run. Pick by output medium: static reports
  / papers / static skore reports → matplotlib + seaborn;
  interactive notebooks / dashboards → plotly.
- **Model serving / registry** — only relevant when the
  project's roadmap includes serving a trained model. Skip the
  gate entirely if serving is out of scope. When it is in
  scope, `mlflow` is the default (registry + REST out of the
  box); FastAPI + `joblib` is the lighter custom path.

### How a Tier 2 gate fires in practice

- **Project start (bootstrap).** Every Tier 2 job the project
  touches must have a pick recorded in `Workspace decisions`
  before the matching code is written. The tabular gate fires
  on every project; the others fire only when the project's
  roadmap brings them in scope.
- **Mid-project (new job comes into scope).** When a new Tier 2
  job becomes relevant (e.g. the project pivots to add a DL
  model), the gate fires *at that point*; the existing
  `Workspace decisions` block is amended with the new row.
- **Mid-project (user wants to pivot).** Tier 2 decisions are
  immutable *unless the user explicitly says so*. A pivot is a
  user-driven event; the skill never auto-pivots even if a
  newer library would obviously be a better fit.

## Tier 3 — Optional (install on demand)

Add these only when the task calls for them. Do not pre-install.

### Deep learning

For NLP, computer vision, or any task where deep learning is the
right tool. None of these are mandatory; reach for them only when
the project's modeling task requires DL.

**The *which library* pick (pytorch vs keras as framework, skorch
vs keras as sklearn-compatible wrapper) is a competing-library
job — owned by Tier 2.** This section only covers *when* to
reach for DL at all; the framework choice has its own row in the
Tier 2 competing-jobs table and fires an `AskUserQuestion` the
first time DL comes into the project's scope.

Per-library reference material:
- [`pytorch`](references/pytorch.md) — tensor library with GPU /
  MPS support and autograd; also the GPU alternative to numpy
  for raw numerical work.
- [`keras`](references/keras.md) — high-level, layer-oriented
  deep-learning API; multi-backend (pytorch / TensorFlow / JAX).
- [`skorch`](references/skorch.md) — wraps a PyTorch `nn.Module`
  so it behaves like a sklearn estimator (`fit` / `predict`,
  GridSearchCV, pipelines).

### Model serving

**The *which library* pick (`mlflow.pyfunc` vs FastAPI +
`joblib`) is a competing-library job — owned by Tier 2.** This
section only covers *when* serving is in scope.

Per-library reference material:
- [`mlflow`](references/mlflow.md) — model packaging, registry,
  and REST serving (`mlflow.pyfunc`, `mlflow models serve`).
  Use **only** for serving and registry concerns; tracking
  belongs to `skore`.

### Notebooks

For notebook-based work, prefer Python files with `# %%` cell
markers (jupytext percent format) over `.ipynb` files. Python
files are diffable and version-control friendly; jupytext handles
the conversion to/from notebook format when needed.

- [`jupyterlab`](references/jupyterlab.md) + [`ipykernel`](references/ipykernel.md)
  — **ambient in the `dev` feature** (alongside `ruff` + `pytest`,
  per `python-env-manager` § "Where does the package belong?").
  Always installed; no per-project ask. The reference pages
  describe the tools' role, not an opt-in install.
- [`jupytext`](references/jupytext.md) — **Tier 3 opt-in**: sync
  `.ipynb` ↔ `.py` (`# %%` markers) so the notebook source-of-
  truth stays version-control friendly. Install only when the
  project wants `.ipynb` interop with the `# %%` scripts.

## Tier 4 — Transitive (already pulled in; do not install explicitly)

These land in the env as runtime dependencies of the mandatory tier
(or of the chosen tabular library). Documented here so you don't
add a redundant explicit dependency, and so you know what's
available without an extra install.

- [`numpy`](references/numpy.md) — N-d arrays, numerical
  primitives. Pulled in by `scikit-learn` and `skore`.
- [`scipy`](references/scipy.md) — scientific computing on top of
  numpy (stats, optimize, sparse, signal). Supports the array API.
  Pulled in by `scikit-learn`.
- [`matplotlib`](references/matplotlib.md) — static plotting
  foundation. Pulled in by `skore` (via `seaborn`).
- [`seaborn`](references/seaborn.md) — static statistical plots
  (distributions, regression, faceting). Pulled in by `skore`.
- [`plotly`](references/plotly.md) — interactive plots (hover,
  zoom, pan); browser-based, suited for dashboards and exploratory
  notebooks. Pulled in by `skore` — **interactive viz is free, no
  extra install needed**.

