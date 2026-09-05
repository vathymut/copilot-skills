---
name: ml-eda
description: Use when exploring a dataset for the first time in an ML workspace before any model design note. For ad-hoc DuckDB reads outside the ML flow, use data-access instead.
---

# ML EDA

Understand the dataset once per workspace before any model design.
Produces `data/eda.py`, `data/eda.md`, `data/eda_<table>.html`, and
the JOURNAL `## Data understanding (EDA)` entry.

## When NOT to use

- You only need ad-hoc SQL/profile of a single file — use `data-access`.
- EDA already done and unchanged — surface existing `data/eda.md`, don't re-run.
- Data is non-tabular (text/image) — no `skrub.TableReport` to emit.


## Gates (one-line)

| Gate | Owner | Meaning |
|---|---|---|
| G-PKG-NAME | `iterate-ml-experiment` §0.5 | Python package name |
| G-ENV-MGR | `python-stack-env` | Env manager (pixi/uv/poetry/…) |
| G-TABULAR | `iterate-ml-experiment` §0.5 | `pandas` vs `polars` |
| G-SKORE-MODE | `iterate-ml-experiment` §0.5 | `local`/`hub`/`mlflow` |
| G-EDA | `ml-eda` / `iterate-ml-experiment` §0 | `run`/`skip` |
| G-DESIGN | `iterate-ml-experiment` §3 | Design note approved? |
| G-CV-SPLITTER | `evaluate-ml-pipeline` §Evaluate | Splitter derived from `split_kwargs` |
| G-RUN | `iterate-ml-experiment` §3 | Run now vs leave for later |

Full wording: `ml-conventions:references/ml-gates.md`. Harness hints never waive `AskUserQuestion` gates.

## EDA flow

1. If `data/eda.md` exists, read JOURNAL § EDA and ask whether to overwrite or skip.
2. Resolve `G-EDA`: `run` or `skip` (gate registry: `ml-conventions:references/ml-gates.md`). Skip records `Status: skipped`.
3. On run: copy `templates/eda.py`, substitute `<pkg>`, `<LOAD_RAW_DATA>`, `<TARGET_COLUMN>`, `<table>` (use Python templating or `sed`; avoid bare `str.replace` on overlapping tokens).
4. Execute via `python-stack-env` agent env: `python ml-eda:scripts/run_cells.py data/eda.py [scratch/eda/eda.md]`
5. Read the digest and author `data/eda.md` from `templates/eda.md` (`data/eda.py` anatomy: `references/eda-file-contract.md`).
6. Write `data/eda_<table>.html` (≥1).
7. Update `journal/JOURNAL.md` § Data understanding (EDA).

## Branch

| Signal | Action |
|---|---|
| "explore the data" / bootstrap G-EDA | Run or re-run § EDA |
| Read-only summary request | Surface existing deliverables; no write |

## Pre-flight

Shared gates → `ml-conventions:references/shared-preflight-evidence.md` (don't duplicate that contract here).

```
Pre-flight (ml-eda):
- [ ] Trigger: bootstrap-G-EDA | user-request | data-changed
- [ ] EDA already present? <data/eda.md + JOURNAL § EDA>
- [ ] G-EDA resolved: run | skip (AskUserQuestion)
- [ ] G-TABULAR known (pandas | polars)
- [ ] Raw data located
- [ ] Agent feature available (delegate to python-stack-env if missing)
- [ ] Plus shared gates from ml-conventions; re-emit with evidence
```

## Constraints

**Stop conditions:**
- EDA precedes model design. Fire during `iterate-ml-experiment` § 0 before `journal/01_baseline.md`.
- EDA is read-only against raw data. Never rewrite input files. Cleaning belongs in `build-ml-pipeline`.
- Deliverables live under `<project>/data/`. Raw source may be anywhere.
- Agent feature required to execute. Missing → delegate to `python-stack-env`.
- All Python execution goes to `scratch/` — see `ml-conventions:references/shared-ml-conventions.md`.

**EDA contract:**
- `skrub.TableReport(..., verbose=0)` + `.json()` for facts; write HTML for the human.
- End cells on text-friendly expressions, never bare `TableReport(df)` (shared with audit: `references/cell_anatomy.md`).
- Library-agnostic summaries only; the only pandas/polars-specific line is `RAW = <LOAD_RAW_DATA>`.
- No model design, no splitter pick, no metric pick — only *implications* for those gates.

## Completion criteria

- [ ] G-EDA resolved (run/skip); if run: `data/eda.py` + `data/eda.md` + `data/eda_<table>.html` present
- [ ] `journal/JOURNAL.md` § Data understanding (EDA) updated
- [ ] Deliverables read-only on raw data; no raw rewrite

## Related skills

- `iterate-ml-experiment` — orchestrates EDA at § 0 before baseline.
- `data-access` — ad-hoc profiling outside the loop.
- `python-stack-env` — agent feature / missing `skrub`.
