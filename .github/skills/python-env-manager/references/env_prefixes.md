# Env-prefix placeholder reference

Single source of truth for the two run-prefix placeholders that
consumer skills (python-api, ml-eda, evaluate-ml-pipeline,
iterate-ml-experiment, ml-conventions) use in their procedure steps:

- **`<env-prefix>`** — the prefix that runs a command in the project's
  *default* env. Used for general script execution (the experiment
  script, scratch probes, audits, `python scratch/<ts>_*.py`).
- **`<agent-env-prefix>`** — the prefix that runs a command in the
  project's *agent* env. Used when the command needs
  `ipython` / `pyright` (audit runner, Shape 1b probes, agent-feature
  pre-flight smoke).

## Resolution table

The "Feature" column is the bucket from the 3-feature layout
(`default` / `dev` / `agent` / `lsp`); see
`references/composition_model.md` and `references/placement.md` for
which packages live where.

| Manager | `<env-prefix>` (default env) | `<agent-env-prefix>` (agent env) | Notes |
|---|---|---|---|
| pixi | `pixi run <command>` | `pixi run -e agent <command>` | `pixi run` enters the default env; feature/env selection via `-e` or `--feature`. |
| uv | `uv run <command>` | `uv run --group agent <command>` | **uv-specific gotcha:** `uv run` activates the *default* group set. If the project sets `[tool.uv] default-groups = [...]` and *excludes* `agent`, then bare `uv run` runs without the agent group — use `uv run --group agent` (or `uv run --all-groups`) when a step needs ipython. Run `uv run --no-sync --group agent -- ipython -c "print(0)"` as the G-AGENT-FEATURE smoke. |
| poetry | `poetry run <command>` | `poetry run --only agent <command>` (or `poetry env use agent && poetry run <command>`) | Poetry 1.2+ groups: `--group agent`; older `--only agent` form still works. |
| hatch | `hatch run <command>` | `hatch run -e agent <command>` | Hatch envs do not compose — agent env duplicates runtime deps. |
| conda / mamba | `conda run -n <project> <command>` | `conda run -n <project>-agent <command>` | No native features; envs are named explicitly. |
| pip + venv | `.venv/bin/python <command>` | `.venv/bin/python <command>` (install agent deps into the single venv) | If using a separate `.venv-agent/`, then `.venv-agent/bin/python <command>`. Both are acceptable. |

## How to resolve in a turn

1. Open `python-env-manager` and run its Detection table
   (`SKILL.md` § Detection) to identify the manager.
2. Read the matching row above for the prefix your step needs.
3. Use the default column for `<env-prefix>`, the agent column for
   `<agent-env-prefix>`.
4. If the operation needs both `dev` and `agent` packages (rare —
   e.g. an audit that also runs `ruff check`), pick the more
   specific one (`<agent-env-prefix>`) and add the other group's
   flag (`uv run --group dev --group agent ...`,
   `pixi run -e dev -e agent ...`).

## Worked example (uv)

A user on uv with `pyproject.toml`:

```toml
[project]
dependencies = ["skrub", "skore", "sklearn"]

[dependency-groups]
dev = ["ruff", "pytest"]
agent = ["ipython", "pyright"]
```

…and `[tool.uv] default-groups = ["dev"]` (so `uv run` includes
`dev` but NOT `agent`).

| Step in the skill | Concrete command |
|---|---|
| `python-api` § "Resolve the version" (default env) | `uv run python scratch/<ts>_version_skore.py` |
| `python-api` § "Shape 1 probe" (needs `IPython` cache write helper) | `uv run --group agent python scratch/<ts>_lookup_skore_evaluate.py` |
| `ml-eda` pre-flight (G-AGENT-FEATURE smoke) | `uv run --group agent ipython -c "print(0)"` |
| `evaluate-ml-pipeline` § Audit (`<agent-env-prefix>`) | `uv run --group agent python ml-eda:scripts/run_cells.py audit/01_baseline.py` |
| `iterate-ml-experiment` G-RUN **run now** (default env, just `python experiments/...py`) | `uv run python experiments/01_baseline.py` |
| `iterate-ml-experiment` § 4 audit (needs ipython for cell runner) | `uv run --group agent python ml-eda:scripts/run_cells.py audit/01_baseline.py` |
| `python-api` `ruff format .` after a write (dev group) | `uv run --group dev ruff format .` |

If the project does **not** set `default-groups`, then `uv run` on
its own already includes all groups; the `--group agent` flag is
harmless (idempotent) and remains the safest spelling to teach
agents — they don't have to reason about whether the project set
`default-groups` or not.

## Why a separate agent-prefix

`ipython` is in the `agent` group because it ships heavy deps
(traitlets, jedi, prompt_toolkit) and is only used by the agent's
audit / lookup work, not by the user's committed scripts. The
user's `experiments/NN_*.py` should never `import IPython`. So the
*default* env never has it, and the audit runner — which does
need it — runs under the *agent* env.

The split is the same for every manager; the syntax for entering
the agent env differs.
