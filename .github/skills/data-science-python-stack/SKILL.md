---
name: data-science-python-stack
description: "Opinionated Python library stack and usage rules for data-science / ML work."
---

# Data Science Python Stack

Opinionated stack — one library per job, organized into four tiers
plus an orthogonal **agent feature**:

1. **Mandatory** — installed at project start, no exceptions.
2. **User choice (competing-library jobs)** — multiple valid libraries
   for the same job; the user picks via `AskUserQuestion` before any
   import lands.
3. **Optional** — install only when the project's task requires it.
4. **Transitive** — already pulled in by the mandatory tier; do not
   install explicitly, but know they're available.
5. **Agent feature (orthogonal)** — deps that the *agent* uses
   to audit a workspace and to power the editor LSP integration
   (`ipython`, `pyright`), kept out of the production-shape
   runtime via a manager-specific scope. Install logistics owned
   by `python-env-manager` § "Agent feature"; consumed by
   `evaluate-ml-pipeline` § Audit and the opencode LSP integration.

## Stop conditions — read before naming any library

- **No silent pick on a competing-library job.** Whenever the stack
  offers two or more libraries for the same job (see § "Competing
  libraries — general rule" and the Tier 2 table), the user picks
  via `AskUserQuestion` before any `Write` that imports the library
  and before any install command runs. "Already pulled in
  transitively" / "user said 'quick'" / "the folder has no
  preference signalled" are **not** waivers. A silent pick is a
  Stop-condition violation, full stop.
- **No substitute when import fails.** When code in this stack needs
  a library but `import` fails, install it; do not rewrite to a
  non-stack equivalent (see § "Missing dependency"). The most
  common silent-rewrite path —
  `import skrub` fails → rewrite as `sklearn.Pipeline`,
  `import skore` fails → rewrite as `cross_val_score` —
  silently undoes the workflow skills' contract.
- **Harness-level "no clarifying questions" hints do NOT waive the
  competing-library `AskUserQuestion`.** The Tier 2 pick is an
  operating-contract gate, not a clarifying question. The same
  applies to user urgency phrasing: "quick baseline", "just do it",
  "go fast", "you pick", "whatever" do NOT resolve a competing-
  library gate. See § "Free-text resolution" in the general rule
  below for what *does* resolve a gate.
- **Post-hoc audit — required before ending the turn.** Before
  declaring the turn complete, verify each competing-library job
  invoked in this turn has either (a) an `AskUserQuestion` answer
  recorded this session, or (b) a matching row in
  `journal/JOURNAL.md` Status `Workspace decisions`. If any
  competing-library job ran without one of those, surface the
  non-compliance to the user explicitly as part of your final
  message — do not hide it.

## Competing libraries — general rule

This is the meta-rule that governs every "user choice" entry in
this skill. It applies to the Tier 2 table below and to any new
competing-library job added in the future.

### The rule

Whenever the stack offers two or more libraries for the same job:

1. **`AskUserQuestion` before any import or install.** Use the
   options listed for the job in the competing-jobs table.
2. **Persist the answer in `journal/JOURNAL.md` Status under
   `Workspace decisions`.** On future sessions, **read Status
   first**; do not re-ask a recorded decision.
3. **No silent default.** Even when one option is "free"
   (already pulled in transitively) and the other costs an
   install, never pick silently. The picking happens via
   `AskUserQuestion`.

### Free-text resolution

A user message resolves a competing-library gate **only** if it
names one of the listed options for the job:

- **Exact match** to an option label: resolves the gate.
- **Library named in a free-text intent**: resolves the gate.
- **No library named** ("you pick", "whatever", "no preference"):
  does **NOT** resolve. Fall through to `AskUserQuestion`.

### Adding a new contested job

Every row must name an explicit `Default-on-no-preference` — rows
without one are forbidden. If a sensible default cannot be named,
the job does not belong in the table.

## When to invoke this skill

Two events trigger this skill before any other action:

1. **A library import fails** in the stack's domain. The answer is
   install (see § "Missing dependency" below), never substitute.
2. **A library choice has to be made** — for tabular data at project
   start, or any time code is about to introduce a new dependency
   (deep learning, model serving, notebooks, …).

In both cases, **read the whole SKILL.md before deciding**. The tier
structure below determines whether a library should already be
present, needs a user prompt, or is opt-in — that decision can't be
made from a single index entry.

## Missing dependency — install, do not substitute

When code in this stack needs a library but `import` fails, the answer is
**install it**, not substitute. Specifically:

- Surface the missing dependency to the user. **Invoke
  `python-env-manager` to produce the right install command** — don't
  infer it from memory; the project may not use the default manager.
  **Stop and wait for confirmation before doing anything else.**
- Do **not** rewrite the code to use a non-stack equivalent
  (`sklearn.Pipeline` for `skrub`, `cross_val_score` + handwritten
  metric prints for `skore`. Substitution silently breaks the contract
  that the workflow skills (`build-ml-pipeline`,
  `evaluate-ml-pipeline`, `ml-scaffold`) rely on.
- This rule **overrides** "make the code run". If the user prefers a
  substitute, they will say so — until they do, install. Reaching
  for a substitute because the dependency is missing is the most
  common way the stack gets silently undone, so treat the missing
  import as a hard stop.

## How to use this skill

1. Read this whole SKILL.md before picking — the tier structure
   determines whether the library should already be installed, needs
   a user-choice prompt, or is opt-in.
2. Match the task to an entry in the right tier.
3. Read the linked `references/<library>.md` for the chosen library's
   scope and tradeoffs before introducing it.
4. For the actual install command, invoke `python-env-manager`. This
   skill owns *what* and *why*; `python-env-manager` owns *how*.
5. Don't substitute libraries silently. If no entry fits the task,
   surface the tradeoff to the user.

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
- [`ruff`](references/ruff.md) — single-tool lint + format,
  replaces `black` / `isort` / `flake8` / `pydocstyle`. This stack
  uses ruff as Tier 1 (mandatory). Copy `templates/ruff.toml` to the
  project root as `ruff.toml` (or fold it into a `[tool.ruff]` table in
  `pyproject.toml`), then run `ruff format .`, `ruff check --fix .`,
  `ruff check .`; NumPyDoc docstrings are enforced via the `D` rule.
  The environment manager routes ruff to the `dev` feature.
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

## Agent feature — orthogonal to the four tiers

Agent-only tooling (`ipython` + `pyright`) used by
`evaluate-ml-pipeline § Audit` and the editor LSP integration. Not Tier 1–4;
lives in its own manager-scoped bucket.

| Library | Role |
|---|---|
| `ipython` | Powers the in-process cell runner for `# %%` audit files |
| `pyright` | Powers the opencode LSP integration for Python files |

**Install + config: owned by `python-env-manager` § "Agent feature".**
Consumed by `evaluate-ml-pipeline § Audit` and the LSP; routes through
`G-AGENT-FEATURE` when not present. No kernel registration needed.

## Conventions

- **Ownership split.** This skill owns *what* goes in the stack and
  *why*. `python-env-manager` owns *how* it is installed (manager
  detection, command syntax, feature/layout). Never put install
  command tables here; link to `python-env-manager` instead.
- **Versions:** don't pin unless the user asks or there's a known
  incompatibility. **Exception — `skore` and `skrub` must always be
  the latest available release.**
- **One tool per job:** don't introduce a second library for a task
  already covered without explicit user request. (One library *can*
  own multiple jobs — `skore` covers both evaluation and tracking.
  The rule forbids piling a second tool onto a covered job, not a
  single tool covering multiple jobs.)
- **Line width:** wrap text at 88 chars where natural. Don't compress
  content to fit; long inline links and code spans are fine to leave
  on longer lines.
