---
name: ml-scaffold
description: Use when starting a new ML experiment workspace, or when src/, experiments/, and journal/ are missing and need layout, stem-pairing, and bootstrap config gates.
---

# ML Scaffold

Create the file layout and resolve the workspace-level config gates.
After this, hand off to `iterate-ml-experiment` § 0.

## Branches

| Signal | Path |
|---|---|
| No `src/` / `experiments/` / `journal/` | § Scaffold |
| Read-only / "where are we?" | → `iterate-ml-experiment` § maintenance |

## Scaffold flow

1. **Detect** existing layout. If `pyproject.toml`, `src/<pkg>/`, `experiments/`, `journal/`, `tests/`, `audit/`, or `reports/` already exist, glue to the existing layout; no renames.
2. **Resolve gates** `G-PKG-NAME`, `G-SKORE-MODE` (`local`|`hub`|`mlflow`), and `G-TABULAR`. See `ml-conventions:references/ml-gates.md` and `references/g_skore_mode.md`.
3. **Delegate** `G-ENV-MGR` to `python-env-manager`.
4. **Create layout** — `pyproject.toml`, manager manifest, `src/<pkg>/` skeletons, `experiments/`, `tests/smoke/`, `audit/`, `journal/`, `scratch/`, `reports/`, ruff config. Four-way stem pairing applies: `journal/NN_<short_name>.md`, `experiments/NN_<short_name>.py`, `tests/smoke/test_NN_<short_name>.py`, `audit/NN_<short_name>.py`.
5. **Write placeholder** `journal/JOURNAL.md` (from `iterate-ml-experiment/templates/JOURNAL.md`) and return to `iterate-ml-experiment` § 0.

## Plan

Re-emit this pre-flight checklist when asked:

```
Pre-flight (ml-scaffold):
- [ ] Layout detection: <existing | fresh>
- [ ] G-PKG-NAME resolved
- [ ] G-SKORE-MODE resolved
- [ ] G-ENV-MGR delegated to python-env-manager
- [ ] G-TABULAR delegated to data-science-python-stack
- [ ] pyproject.toml + manager manifest + src/<pkg>/ skeletons written
- [ ] Dirs created: experiments/, tests/smoke/, audit/, journal/, scratch/, reports/
- [ ] Placeholder JOURNAL.md written
- [ ] .gitignore asked for reports/; data/ not ignored wholesale
```

## References

- `ml-conventions:references/ml-gates.md` — gate registry.
- `iterate-ml-experiment` — canonical ownership map for the ML-workspace family.
- `references/scaffold_steps.md` — full step-by-step.
- `references/g_skore_mode.md` — G-SKORE-MODE detail.
- `references/forbidden-shortcuts.md` — common scaffold shortcuts.
