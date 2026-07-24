---
name: ml-eda
description: Use when exploring a dataset for the first time in an ML workspace, before any model design note — bootstrap EDA, re-running eda.py, or answering a read-only data question.
---

# ML EDA

Understand the dataset once per workspace before any model design.
Produces `data/eda.py`, `data/eda.md`, `data/eda_<table>.html`, and
the JOURNAL `## Data understanding (EDA)` entry.

## EDA flow

1. If `data/eda.md` exists, read JOURNAL § EDA and ask whether to overwrite or skip.
2. Resolve `G-EDA`: `run` or `skip`. Skip records `Status: skipped`.
3. On run: copy `templates/eda.py`, substitute `<pkg>`, `<LOAD_RAW_DATA>`, `<TARGET_COLUMN>`, `<table>`.
4. Execute via `python-env-manager` agent env: `python ml-eda:scripts/run_cells.py data/eda.py [scratch/eda/eda.md]`
5. Read the digest and author `data/eda.md` from `templates/eda.md`.
6. Write `data/eda_<table>.html` (≥1).
7. Update `journal/JOURNAL.md` § Data understanding (EDA).

## Branch

| Signal | Action |
|---|---|
| "explore the data" / bootstrap G-EDA | Run or re-run § EDA |
| Read-only summary request | Surface existing deliverables; no write |

## Pre-flight

```
Pre-flight (ml-eda):
- [ ] Trigger: bootstrap-G-EDA | user-request | data-changed
- [ ] EDA already present? <data/eda.md + JOURNAL § EDA>
- [ ] G-EDA resolved: run | skip (AskUserQuestion)
- [ ] G-TABULAR known (pandas | polars)
- [ ] Raw data located
- [ ] Agent feature available (delegate to python-env-manager if missing)
- [ ] python-api consulted for symbols used this turn
```

## Constraints

**Stop conditions:**
- EDA precedes model design. Fire during `iterate-ml-experiment` § 0 before `journal/01_baseline.md`.
- EDA is read-only against raw data. Never rewrite input files. Cleaning belongs in `build-ml-pipeline`.
- Deliverables live under `<project>/data/`. Raw source may be anywhere.
- Agent feature required to execute. Missing → delegate to `python-env-manager`.
- All Python execution goes to `scratch/` — see `ml-conventions:references/shared-ml-conventions.md`.

**EDA contract:**
- `skrub.TableReport(..., verbose=0)` + `.json()` for facts; write HTML for the human.
- End cells on text-friendly expressions, never bare `TableReport(df)`.
- Library-agnostic summaries only; the only pandas/polars-specific line is `RAW = <LOAD_RAW_DATA>`.
- No model design, no splitter pick, no metric pick — only *implications* for those gates.

## References

- `ml-conventions:references/ml-gates.md` — gate registry.
- `references/eda-file-contract.md` — `data/eda.py` anatomy.
- `references/cell_anatomy.md` — bare-expression rules (shared with audit).
