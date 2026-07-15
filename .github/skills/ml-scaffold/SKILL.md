---
name: ml-scaffold
description: "Scaffold an ML experiment workspace: layout, file pairing, and the bootstrap config gates."
---

# ML Scaffold

Create the file layout and resolve the workspace-level config gates.
After this, hand off to `iterate-ml-experiment` § 0.

## Branches

| Signal | Path |
|---|---|
| No `src/` / `experiments/` / `journal/` | § Scaffold |
| Read-only / "where are we?" | → `iterate-ml-experiment` § maintenance |

## Stop conditions

- **Detection wins.** Existing `pyproject.toml`, `pixi.toml`,
  `src/<pkg>/`, `experiments/`, `journal/`, `tests/`, `audit/`, or
  `reports/` → glue to the existing layout; no renames.
- **Gates fire before files are written.** `G-PKG-NAME`,
  `G-ENV-MGR`, `G-TABULAR`, `G-SKORE-MODE`. See `writing-great-skills:references/ml-gates.md`.
- **No design note, no experiment code.** Create only the placeholder
  `journal/JOURNAL.md`; never write `experiments/NN_*.py` here.
- **All Python execution goes to `scratch/`** — rule lives in `python-api`.

## Pre-flight

```
Pre-flight (ml-scaffold):
- [ ] Layout detection: <existing | fresh>
      Evidence: ls/Glob matched signal
- [ ] G-PKG-NAME resolved
      Evidence: AskUserQuestion id=<id> | JOURNAL.md
- [ ] G-SKORE-MODE resolved
      Evidence: AskUserQuestion id=<id> | JOURNAL.md
- [ ] G-ENV-MGR delegated to python-env-manager
      Evidence: handoff recorded
- [ ] G-TABULAR delegated to data-science-python-stack
      Evidence: AskUserQuestion id=<id> | JOURNAL.md
- [ ] `pyproject.toml` + manager manifest + src/<pkg>/ skeletons written
- [ ] Empty dirs created: experiments/, tests/smoke/, audit/, journal/, scratch/, reports/
- [ ] Placeholder JOURNAL.md written from iterate-ml-experiment template
- [ ] .gitignore asked for reports/; data/ not ignored wholesale
- [ ] Pre-flight re-emitted with evidence before final message.
```

## Scaffold flow

1. Detect existing signals; glue if any.
2. Resolve `G-PKG-NAME` via `AskUserQuestion`; record in JOURNAL.md.
3. Resolve `G-SKORE-MODE` (`local` \| `hub` \| `mlflow`). Hub → workspace
   name; MLflow → tracking URI. See `references/g_skore_mode.md`.
4. Hand off to `python-env-manager` for `G-ENV-MGR`.
5. Create `pyproject.toml`, manager manifest, and `src/<pkg>/` skeletons
   from `templates/`.
6. Create `experiments/`, `tests/smoke/`, `audit/`, `journal/`,
   `scratch/`, `reports/`.
7. Ask about `.gitignore` for `reports/`; never ignore `data/` as a whole.
8. Write placeholder `journal/JOURNAL.md` from
   `iterate-ml-experiment/templates/JOURNAL.md`.
9. Write the ruff config: copy `templates/ruff.toml` to the project root as `ruff.toml` (or fold it into a `[tool.ruff]` table in `pyproject.toml`).
10. Return to `iterate-ml-experiment` § 0.

## File rules

- Four-way stem pairing:
  `journal/NN_<short_name>.md`,
  `experiments/NN_<short_name>.py`,
  `tests/smoke/test_NN_<short_name>.py`,
  `audit/NN_<short_name>.py`.
- New experiment → new file. In-place edits reuse the same skore key —
  flag this and ask.

## References

- `writing-great-skills:references/ml-gates.md` — gate registry.
- `ml-experiments` — ownership map.
- `references/scaffold_steps.md` — full step-by-step.
- `references/g_skore_mode.md` — G-SKORE-MODE detail.
- `references/forbidden-shortcuts.md` — common scaffold shortcuts.
