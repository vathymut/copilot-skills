---
name: ml-eda
description: "Run a one-time bootstrap EDA before the first ML experiment design note."
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
- **All Python execution goes to `scratch/`** — rule lives in `python-api`.

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
      Evidence: `pixi run -e agent ipython -c "print(0)"` exit 0
- [ ] python-api consulted for symbols used this turn
- [ ] Pre-flight re-emitted with evidence before final message.
```

## EDA flow

1. If `data/eda.md` exists, read JOURNAL § EDA and ask whether to
   overwrite or skip.
2. Resolve `G-EDA`: `run` or `skip`. Skip records `Status: skipped`.
3. On run: copy `templates/eda.py`, substitute `<pkg>`,
   `<LOAD_RAW_DATA>`, `<TARGET_COLUMN>`, `<table>`.
4. Execute with the shared runner:
   `pixi run -e agent python ~/.config/opencode/skills/ml-eda/scripts/run_cells.py data/eda.py [scratch/eda/eda.md]`
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

- `writing-great-skills:references/ml-gates.md` — gate registry.
- `references/eda-file-contract.md` — `data/eda.py` anatomy.
- `references/cell_anatomy.md` — bare-expression rules (shared with audit).
