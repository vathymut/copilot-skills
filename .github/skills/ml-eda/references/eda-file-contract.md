# EDA file contract — cell anatomy

`data/eda.py` is **jupytext percent format** (`# %%`), executed by
the shared runner. Template: `templates/eda.py`.

## Substitutions

| Placeholder | Replaced with |
|---|---|
| `<pkg>` | The importable package name (from `src/<pkg>/`); used for `from <pkg> import PROJECT_ROOT` (only to locate `EDA_DIR = PROJECT_ROOT / "data"`) |
| `<LOAD_RAW_DATA>` | The real load of the raw file(s), pointing wherever the data lives (in `data/`, another folder, an absolute path, or external). Uses the workspace tabular lib (pandas/polars); skrub accepts both. The one library-specific line |
| `<TARGET_COLUMN>` | The target column name (from the goal / `data/README.md`), or remove the target cell if unsupervised / unknown |
| `<table>` | A short slug per table for the HTML filename (`eda_<table>.html`) — for a single table use the dataset name |

## Cell sequence (what each cell does)

1. **Module docstring (markdown)** — what this file is, the
   read-only-against-raw-data rule, raw-vs-deliverables split, how it
   is executed.
2. **Imports + paths (code)** — `import json`, `import skrub`,
   `from <pkg> import PROJECT_ROOT`, `EDA_DIR = PROJECT_ROOT / "data"`
   (+ `EDA_DIR.mkdir(parents=True, exist_ok=True)`). No pandas/polars
   import here.
3. **Load raw data (code, bare expression)** — `RAW = <LOAD_RAW_DATA>`
   pointing wherever the data lives; end on `RAW.shape`.
4. **Per-table overview (code)** — `report = skrub.TableReport(RAW,
   title=..., verbose=0)`; `report.write_html(EDA_DIR /
   "eda_<table>.html")`; then `summary = json.loads(report.json())`
   and end on a `dict`/`list` of per-column dtype / null / cardinality
   facts. One such cell per table.
5. **Target analysis (code, bare expression)** — pick the target's
   entry out of `summary["columns"]`; it carries value counts
   (classification) or a distribution summary (regression). Drives the
   metric default and whether the splitter should stratify.
6. **Structure signals (code, bare expression)** — datetime columns
   (from skrub's inferred dtypes, catches string dates) and high
   unique-ratio id/group columns. Drives the `G-CV-SPLITTER` choice
   (`TimeSeriesSplit` / `GroupKFold`).
7. **Associations (code, bare expression)** —
   `skrub.column_associations(RAW)` to flag strong predictors and
   possible leakage.
8. **End (markdown)** — reminder that the agent now authors
   `data/eda.md` + the JOURNAL section from this digest.

`write_html(...)` is load-bearing on the overview cells (the human
artifact). `verbose=0` and the bare `report.json()`-derived
expressions are load-bearing for a clean, library-agnostic digest.
For multi-table data, run cells 5–7 on the target-bearing table; for
very large data, load a row sample (see `references/cell_anatomy.md`).
