# Shared ML Conventions

Single source of truth for the cross-cutting rules repeated across the
ML skills (`data-science-python-stack`, `ml-scaffold`, `build-ml-pipeline`,
`evaluate-ml-pipeline`, `iterate-ml-experiment`, `python-api`,
`python-env-manager`). Each skill points here instead of re-stating
these rules.

## Ruff (lint + format)

Ruff is the single Tier 1 lint + format tool — it replaces
`black` / `isort` / `flake8` / `pydocstyle`. Copy
`data-science-python-stack/templates/ruff.toml` to the project root as
`ruff.toml` (or fold it into a `[tool.ruff]` table in `pyproject.toml`),
then run:

```bash
ruff format .
ruff check --fix .
ruff check .
```

NumPyDoc docstrings are enforced via the `D` rule. The environment
manager routes `ruff` to the `dev` feature.

Full rationale and config: `data-science-python-stack/references/ruff.md`.

## All Python execution goes to scratch/

Every Python command — `python -c`, `pixi run python -c`, heredoc-style
`python << 'EOF'`, or any inline Python — is forbidden regardless of
length. Write the script to
`scratch/<YYYY-MM-DD>_<HHMMSS>_<short>.py` first, then execute it via
`pixi run python scratch/<ts>_<short>.py`. Applies to version checks,
import smokes, signature lookups, module-surface dumps, docstring
extraction — anything. If you catch yourself typing `python -c`, STOP
and write the file.

Authoritative owner: `python-api` (Stop conditions).

## Harness hints do not waive gates

Harness "no clarifying questions" hints do **not** waive mandatory
`AskUserQuestion` gates. Manager/scope picks and competing-library
picks are operating-contract gates, not clarifying questions. User
urgency phrasing — "quick baseline", "just do it", "go fast", "you
pick", "whatever" — does **not** resolve a gate. Fall through to
structured `AskUserQuestion`.

## Missing dependency → python-env-manager

When an import in this stack fails, **install it**; do not rewrite to a
non-stack equivalent. The most common silent-rewrite path —
`import skrub` fails → rewrite as `sklearn.Pipeline`, `import skore`
fails → rewrite as `cross_val_score` — silently undoes the workflow
skills' contract. Delegate the install to `python-env-manager`; this
skill owns *what* and *why*, `python-env-manager` owns *how*.

## Config-gate ownership

The workspace-level config gates are owned, not duplicated:

| Gate | Picks | Owner |
|---|---|---|
| `G-PKG-NAME` | `src/<pkg>/` name | `ml-scaffold` |
| `G-ENV-MGR` | Env manager | `python-env-manager` |
| `G-TABULAR` | Tabular library | `data-science-python-stack` |
| `G-SKORE-MODE` | Skore Project mode + URI | `ml-scaffold` |
| `G-EDA` | Run / skip EDA | `ml-eda` |
| `G-AGENT-FEATURE` | Install ipython + pyright | `python-env-manager` |
| `G-CV-SPLITTER` | CV family | `evaluate-ml-pipeline` |

Gate definitions: `writing-great-skills:references/ml-gates.md`.
