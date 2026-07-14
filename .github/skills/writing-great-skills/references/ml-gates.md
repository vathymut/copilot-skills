# ML Workspace Gates

Canonical gate names across the ML experiment skills. Each gate is a
single source of truth: the owner skill owns the question and the valid
answers; other skills name the gate and route to the owner.

| Gate | Owner | When it fires | Valid answers / notes |
|---|---|---|---|
| `G-PKG-NAME` | `ml-scaffold` | Before any manifest or `src/<pkg>/` creation | Any valid Python package import name |
| `G-ENV-MGR` | `python-env-manager` | Before package installation | `pixi` \| `uv` \| `poetry` \| `hatch` \| `conda` \| `pip+venv` |
| `G-TABULAR` | `data-science-python-stack` | Before writing `data.py` | `pandas` \| `polars` |
| `G-SKORE-MODE` | `ml-scaffold` | Before `pyproject.toml` or any `skore.Project(...)` call | `local` \| `hub` \| `mlflow` |
| `G-EDA` | `ml-eda` | During bootstrap, before `journal/01_baseline.md` | `run` \| `skip` |
| `G-AGENT-FEATURE` | `python-env-manager` | Before running `# %%` audit or EDA files | `install` \| `skip` |
| `G-DESIGN` | `iterate-ml-experiment` | After a design note is drafted, before implementation | `approved` \| `more changes` |
| `G-CV-SPLITTER` | `evaluate-ml-pipeline` | Inside § 3 chain, after G-DESIGN; before writing `evaluate.py` | `KFold` \| `GroupKFold` \| `TimeSeriesSplit(...)` \| custom — always explicit, never silent default |
| `G-RUN` | `iterate-ml-experiment` | After smoke test passes, before execution | `run now` \| `leave for later` |

## Immutability rule

A recorded answer in `JOURNAL.md` § Status `Workspace decisions` becomes a
silent prior decision on later turns. Re-ask only when the user explicitly
pivots ("let's switch to polars") or adds a new competing-library job.

## Harness overrides

Mandatory `AskUserQuestion` gates owned by these skills are **not waived**
by harness instructions like "no clarifying questions". The gate is part
of the operating contract, not a discretionary clarification.
