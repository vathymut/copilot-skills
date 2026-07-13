---
name: organize-ml-workspace
description: >
  Decide where files live in an ML experimentation project and scaffold
  the workspace layout. One `# %%` script per experiment, design notes
  in `journal/`, reusable code in `src/<pkg>/`. Triggers on new project
  setup, first experiment file, or questions about project structure.
---

# Organize ML Workspace

Where things live, when to create a new file, what each file is
allowed to contain.

## Next-step pointers

| You came here for… | → next |
|---|---|
| Bootstrap a fresh workspace | → `python-env-manager` § Bootstrap; then `iterate-ml-experiment` § 0 |
| First experiment script | → `iterate-ml-experiment` § 0 for the design note |
| Add a new experiment iteration | → `iterate-ml-experiment` § 1 (new vs edit decision) |
| Pipeline / evaluate / smoke-test content | → `build-ml-pipeline` / `evaluate-ml-pipeline` / `smoke-test-ml-pipeline` |

Always re-emit the Pre-flight checklist with evidence before
declaring the turn done.

## Sibling skills — open just-in-time

Don't pre-read every sibling at session start. Open each
sibling SKILL.md when a step calls for it. Emit this tracker once
per turn:

```
Sibling skills (just-in-time):
  - data-science-python-stack, python-env-manager, python-api,
    python-code-style, iterate-ml-experiment, explore-ml-data,
    build-ml-pipeline, evaluate-ml-pipeline, test-ml-pipeline,
    smoke-test-ml-pipeline
```

## Stop conditions — read before anything else

- **Missing dependency.** If `import skore` raises, STOP. Invoke
  `python-env-manager`. Do not drop `skore.Project` for `mlflow`/pickles.
- **Symbol from memory is forbidden.** Signatures must come from
  `python-api` this turn.
- **Existing layout wins — detect first.** Run Detection before scaffolding.
- **Notebooks are not silent.** `.ipynb` in experiment folder → ask first.
- **Scratch is read-only against skore.** MUST NOT call `skore.evaluate`
  or `project.put(...)`. Lookup: `summarize()` → `(key, id)` → `get(id)`.
- **G-TABULAR.** Invoke `data-science-python-stack`. Persisted in JOURNAL.md.
- **G-PKG-NAME.** `AskUserQuestion` before any manifest creation.
- **G-SKORE-MODE.** `AskUserQuestion` for `local`|`hub`|`mlflow` before
  any template with `skore.Project(...)`. Persists as `skore mode:`.
  Hub → follow-up for workspace name. MLflow → follow-up for tracking URI.
  → `references/g_skore_mode.md` for details.
- **Switching skore mode mid-project forbidden by default.** Requires
  explicit confirmation. → `references/g_skore_mode.md`.
- **G-ENV-MGR.** Hand off to `python-env-manager`. No `pixi init`/`uv init`
  until G-ENV-MGR has passed.
- **No-clarifying-questions hints do NOT waive these gates.**
- **Post-hoc audit — required before ending the turn.** Surface any
  unfilled pre-flight Evidence cell explicitly.

## Forbidden shortcuts

→ See `references/forbidden-shortcuts.md` for the full table.

## Pre-flight — emit before any code

Each ticked box needs an Evidence line. Format spec:
`writing-great-skills:references/shared-preflight-evidence.md`.
Inline `python -c` is NOT evidence — use scratch files.

```
Pre-flight (organize-ml-workspace):
- [ ] `Workspace decisions` in JOURNAL.md Status checked
      Evidence: <gate>: <value | not recorded> | "n/a — fresh"
- [ ] Tier 1 libs importable: sklearn, skrub, skore
      Evidence: scratch/<ts>_check_tier1.py + pixi run python
- [ ] Layout detection: <existing | fresh>
      Evidence: ls/Glob + matched Detection signal
- [ ] G-TABULAR resolved
      Evidence: AskUserQuestion | JOURNAL.md | user quote
- [ ] G-ENV-MGR resolved
      Evidence: AskUserQuestion | JOURNAL.md
- [ ] G-PKG-NAME resolved
      Evidence: AskUserQuestion | JOURNAL.md | manifest confirmed
- [ ] G-SKORE-MODE resolved
      Evidence: AskUserQuestion | JOURNAL.md `skore mode:` row
- [ ] pyproject.toml present + editable install wired
      Evidence: Read pyproject.toml + manager call
- [ ] python-api consulted: Project, put, evaluate
      Evidence: scratch/api cache or "n/a — cached"
- [ ] Decision: new file vs edit existing
      Evidence: AskUserQuestion | "n/a — first experiment"
- [ ] journal/ scaffolded
      Evidence: Write JOURNAL.md | "already exists"
- [ ] Pre-flight re-emitted with evidence
      Evidence: appears in end-of-turn summary
```

## Detection — existing workspace first

| Signal | Meaning |
|---|---|
| `pyproject.toml` with `[project] name` + setuptools/poetry/hatch | Package declared installable |
| `pixi.toml` / `[tool.poetry]` / `[tool.uv]` with name but **no** `[project]` | Manager knows project but package isn't installable |
| `src/<pkg>/__init__.py` or `<pkg>/__init__.py` at root | Package dir already chosen |
| `<pkg>.egg-info/` at root or under `src/` | Stale `pip install -e .` — flag drift |
| `experiments/`, `notebooks/`, `scripts/`, `analyses/` | Experiment location chosen |
| `audit/` with `# %%` files | Audit location chosen |
| `journal/`, `plans/`, `proposals/` | Journal location chosen |
| `reports/`, `results/`, `runs/` | Report location chosen |
| `tests/` | Test location chosen |
| `mlflow.db` / `mlruns/` at root | Prior tracker artifacts — leave alone |
| `.ipynb` files in experiment folder | Surface the shift and ask |

**Any signal present → glue to existing convention.** No renames.
**None present → fresh scaffold** (below).

→ next: G-PKG-NAME, then `python-env-manager` for G-ENV-MGR.

## Default layout (fresh workspace)

```
project/
├── pyproject.toml          # declares src/<pkg>/ as installable
├── <manager manifest>      # pixi.toml / poetry / uv / hatch
├── src/<pkg>/
│   ├── __init__.py         # exposes PROJECT_ROOT
│   ├── data.py             # data loading, splits, split_kwargs
│   ├── features.py         # transformers, encoders, feature fns
│   ├── pipeline.py         # the learner declaration (skrub DataOps)
│   └── evaluate.py         # ONLY: CV strategy + optional metric overrides
├── journal/
│   ├── JOURNAL.md          # session-start log; index of experiments
│   └── 01_baseline.md      # one `.md` per planned experiment
├── experiments/
│   └── 01_baseline.py      # one `# %%` script per experiment
├── audit/
│   └── 01_baseline.py      # body owned by audit-ml-pipeline (read-only)
├── tests/
│   └── smoke/              # body owned by smoke-test-ml-pipeline
├── scratch/                # agent-only (gitignored entirely)
└── reports/                # skore Project lives here
```

**The package is installable.** `pyproject.toml` declares
`src/<pkg>/`; the manager installs in **editable** mode.
Runtime deps (sklearn, skrub, skore, tabular) live in the
manager's manifest, not in `[project.dependencies]`.

**Deliberately absent:** no `data/` (user-owned), no `models/`
(out of scope). The sole writer into `data/` is `explore-ml-data`.

## File-creation rules

### Design note first, then code

Before creating `experiments/NN_<short_name>.py`, the matching
`journal/NN_<short_name>.md` must exist and have been validated by
the user.

### Four-way stem pairing

Every experiment is identified by `NN_<short_name>` in four places:

```
journal/NN_<short_name>.md            (design note)
experiments/NN_<short_name>.py        (script)
tests/smoke/test_NN_<short_name>.py   (smoke test)
audit/NN_<short_name>.py              (audit file — read-only)
```

### New experiment → new file. Iterating → ask first.

Default: new file. When the user says "let's tweak experiment 02",
fire `AskUserQuestion`:

> Should this be a new experiment file (e.g.
> `04_text_encoder_v2.py`) or an in-place edit of
> `02_text_encoder.py`?

In-place edits **overwrite the prior result in the skore Project**
if the same key is reused — flag this.

## Decision flow (12 steps)

Full version: `references/scaffold_steps.md`.

1. Read project root; Detection matches → glue. No match → continue
2. **G-PKG-NAME** structured ask. Record in `Workspace decisions`
2a. **G-SKORE-MODE** ask: local | hub | mlflow (+ follow-ups)
3. Drop `pyproject.toml` from template. Hand off to `python-env-manager`
4. Create `src/<pkg>/` with skeletons from `templates/src_*.py`
5. Create `experiments/01_baseline.py` (substitute `<SKORE_PROJECT_INIT>`)
6. Create empty `tests/smoke/`. Verify pytest
6a. Create empty `audit/`
7. Create `journal/JOURNAL.md` one-line placeholder
8. Create empty `scratch/`
9. Create empty `reports/`
10. Touch `.gitignore` — always ask about `reports/`. Never ignore `data/`
11. Hand off to `python-code-style` § Initial setup
12. Hand back to relevant sibling

## Files in src/<pkg>/

- **`__init__.py`** — exposes `PROJECT_ROOT` (absolute, from `__file__`).
- **`data.py`** — loaders, `X`, `y`, `split_kwargs` at the X marker.
- **`features.py`** — feature functions and transformers.
- **`pipeline.py`** — the learner declaration (`SkrubLearner`).
- **`evaluate.py`** — CV strategy + optional metric overrides only.

## Experiment scripts — `experiments/NN_*.py`

`# %%` cell markers, not `.ipynb`. Template: `templates/experiment.py`.

1. Open / attach to the `skore.Project` at `reports/`.
2. Import learner from `<pkg>.pipeline` and CV from `<pkg>.evaluate`.
3. Call `skore.evaluate(...)`.
4. Call `project.put("<experiment-key>", report)`.

**Project init substitution** — `<SKORE_PROJECT_INIT>` in template
replaced per recorded `skore mode:`. Three forms:
→ `references/g_skore_mode.md`.

**Experiment key convention** — file stem (e.g.
`01_baseline.py` → `"01_baseline"`).

## Companion skills

`iterate-ml-experiment` (journal/design notes), `explore-ml-data`
(EDA in `data/`), `build-ml-pipeline` (pipeline.py/features.py/data.py),
`evaluate-ml-pipeline` (evaluate.py), `test-ml-pipeline` (tests/ layout),
`smoke-test-ml-pipeline` (smoke test body), `audit-ml-pipeline` (audit/),
`python-api` (signatures), `python-env-manager` (install/bootstrap),
`data-science-python-stack` (what to install), `python-code-style`
(ruff.toml + NumPyDoc).

See the shared ML companion map at
`writing-great-skills:references/ml-companion-skills.md`.

## References (load on demand)

- `writing-great-skills:references/ml-companion-skills.md` — canonical
  ownership map for the ML-workspace family.
- `references/scaffold_steps.md` — full 13-step Decision flow
- `references/g_skore_mode.md` — G-SKORE-MODE gate detail
- `references/forbidden-shortcuts.md` — shortcuts table
