---
name: ml-eda
description: Use when exploring a dataset for the first time in an ML workspace, before any model design note — bootstrap EDA, re-running eda.py, or answering a read-only data question.
---

# ML EDA

Understand the dataset once per workspace before any model design.
Produces `data/eda.py`, `data/eda.md`, `data/eda_<table>.html`, and
the JOURNAL `## Data understanding (EDA)` entry.

## Branch

| Signal | Action |
|---|---|
| "explore the data" / bootstrap G-EDA | Run or re-run § EDA |
| Read-only summary request | Surface existing deliverables; no write |

## Stop conditions

- **EDA precedes model design.** Fire during `iterate-ml-experiment` § 0
  before `journal/01_baseline.md`.
- **EDA is read-only against raw data.** Never rewrite the user's input
  files. Cleaning belongs in the pipeline (`build-ml-pipeline`).
- **Deliverables live under `<project>/data/`.** The raw source may be
  anywhere; `data/eda.py` / `data/eda.md` / `data/eda_*.html` are durable.
- **Agent feature required to execute.** `ipython` missing → delegate to
  `python-env-manager` § Agent feature. Decline → skip path.
- **All Python execution goes to `scratch/`** — rule and command: see `ml-conventions:references/shared-ml-conventions.md` (scratch/ rule); authoritative owner `python-api`.

## Pre-flight

```
Pre-flight (ml-eda):
- [ ] Trigger: bootstrap-G-EDA | user-request | data-changed
- [ ] EDA already present? <data/eda.md + JOURNAL § EDA>
- [ ] G-EDA resolved: run | skip
      Evidence: AskUserQuestion id=<id>, answer=<run|skip>
- [ ] G-TABULAR known (pandas | polars)
- [ ] Raw data located (may be outside `data/`)
- [ ] Agent feature available (run path only)
      Evidence: `<agent-env-prefix> ipython -c "print(0)"` exit 0
      (where `<agent-env-prefix>` is the `agent`-env invocation for the
      env-manager `python-env-manager` detected — e.g. `pixi run -e agent`,
      `uv run --group agent`, `poetry run --only agent`; full table at
      `python-env-manager:references/env_prefixes.md`). **Inline
      `<agent-env-prefix> python -c "..."` is NOT evidence.**
- [ ] python-api consulted for symbols used this turn
- [ ] Pre-flight re-emitted with evidence before final message.
```

## EDA flow

1. If `data/eda.md` exists, read JOURNAL § EDA and ask whether to
   overwrite or skip.
2. Resolve `G-EDA`: `run` or `skip`. Skip records `Status: skipped`.
3. On run: copy `templates/eda.py`, substitute `<pkg>`,
   `<LOAD_RAW_DATA>`, `<TARGET_COLUMN>`, `<table>`.
4. Execute with the shared runner: `<agent-env-prefix> python
   ml-eda:scripts/run_cells.py data/eda.py [scratch/eda/eda.md]`
   (where `<agent-env-prefix>` is the prefix that enters the
   project's `agent` env per `python-env-manager`; full table at
   `python-env-manager:references/env_prefixes.md`).
5. Read the digest and author `data/eda.md` from `templates/eda.md`.
6. Write `data/eda_<table>.html` (≥1).
7. Update `journal/JOURNAL.md` § Data understanding (EDA).

## EDA contract

- `skrub.TableReport(..., verbose=0)` + `.json()` for facts; write HTML
  for the human.
- End cells on text-friendly expressions, never bare `TableReport(df)`.
- Library-agnostic summaries only; the only pandas/polars-specific line
  is `RAW = <LOAD_RAW_DATA>`.
- No model design, no splitter pick, no metric pick — only *implications*
  for those gates.

## References

- `ml-conventions:references/ml-gates.md` — gate registry.
- `references/eda-file-contract.md` — `data/eda.py` anatomy.
- `references/cell_anatomy.md` — bare-expression rules (shared with audit).
