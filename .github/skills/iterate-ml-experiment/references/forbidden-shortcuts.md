# Forbidden Shortcuts — iterate-ml-experiment

Reference companion. Rules enforced in stop conditions are the
source of truth; this table spells out the common violations
verbatim so the agent can recognise them on sight.

## Table

| Shortcut | Why it's wrong |
|---|---|
| User said "quick baseline" → skip G-DESIGN | G-DESIGN is non-negotiable; "quick" never waives it. The design note is the postmortem's frozen Method |
| Scaffold + implement in one turn before G-DESIGN | Inverts the contract. Code that lands before approval has no Motivation/Risks the user signed off on |
| Skipped `evaluate-ml-pipeline` because `KFold(5)` "feels right" | Even empty `split_kwargs` is a justified pick the skill exists to surface. Bypass = user never got the choice |
| Bootstrap mode → skip ALL questions, not just the sourcing menu | Bootstrap forbids the sourcing menu only. G-PKG-NAME / G-ENV-MGR / G-TABULAR / G-SKORE-MODE / G-EDA / G-DESIGN / G-CV-SPLITTER / G-RUN still fire |
| Ambiguous "hmm interesting" / "I guess" read as approval | Approval is explicit. Ambiguity → re-ask, never silent yes |
| Auto-detect run finished via `reports/` mtime | § 4 is user-triggered (v1). The skill never auto-records |
| § 4 finishes recording → declare done, skip audit dispatch | § 4 audit dispatch is part of record-outcome, not optional. The audit digest carries the headline metrics for the JOURNAL row |
| Run experiment in same turn as G-RUN → declare done without § 4 | § 4 follows G-RUN in the same turn when the run completes successfully. Don't stop at "I ran it" — record the outcome |
| Pre-read every sibling SKILL.md file at session start | Read-set tracker is not a blocking gate. Open siblings just-in-time; emit pending list but proceed |

## § Scaffold violations

| Shortcut | Why it's wrong |
|---|---|
| `pixi` on PATH → run `pixi init` to get a manifest, then read the name back | Violates G-ENV-MGR (silent manager pick) AND G-PKG-NAME (name from folder via init side-effect). Circular: the agent created the manifest it now claims to read |
| Folder name = good name → skip the ask | Default *value* is fine; silent *pick* is not. G-PKG-NAME requires the structured ask even with folder as default |
| `pandas` already importable via skore → write `import pandas` in `data.py` | Transitive presence is not a pick. Violates G-TABULAR |
| Scaffold every skeleton in one turn, incl. `experiments/01_baseline.py` body | Scaffold stops at empty `journal/` placeholder. Experiment script content lands after design-note approval (§ 3) |
| Scaffold drops `audit/01_baseline.py` at workspace creation | Audit files placed by `evaluate-ml-pipeline § Audit` at § 4 record-outcome. Empty `audit/` at scaffold is correct |
| Forget `audit/` in the scaffold layout | Four-way stem pairing breaks |
| `pyproject.toml` exists with `name = <x>` → reuse without confirming | Always re-confirm via G-PKG-NAME |
| Batch G-TABULAR + G-PKG-NAME + G-ENV-MGR + G-SKORE-MODE into prose recommendations | The gates take structured `AskUserQuestion`. Prose followed by "let me know" does NOT resolve them |
| Skip G-SKORE-MODE because templates use `mode="local"` | Templates carry the `<SKORE_PROJECT_INIT>` marker, not a literal. The gate must fire |
| Pick `mode="hub"` without checking the workspace exists / user has access | Project init fails at first `put()` with an authorization error. Confirm during G-SKORE-MODE, not at execution time |
| Pick `mode="mlflow"` and invent / default the `tracking_uri=` | The tracking URI is server-specific; the agent cannot infer it. Ask the user at the G-SKORE-MODE follow-up. No silent `http://localhost:5000` |
| Folder has skore-hub config → present only `hub` (or `hub`+`local`), drop `mlflow` | Detected config is detection, not permission. The gate must always offer all three; config only sets the default highlight |
| Substitute `pip install "skore[hub]"` / `"skore[mlflow]"` based on agent guess | Install variant comes from G-SKORE-MODE's recorded answer. `python-stack-env` reads that row, not agent intuition |
| Silently change `skore mode:` mid-project to "fix" a broken init | Switching orphans existing reports. Always explicit `AskUserQuestion` first |
| Hub substitution but leaving a directory-style `workspace=str(PROJECT_ROOT / "reports")` | In hub mode `workspace=` carries the **Hub workspace name**, not an on-disk dir. mlflow rejects `workspace=` and uses `tracking_uri=` |
| mlflow substitution that keeps a `login(mode=...)` call | mlflow mode needs no skore login — auth is the MLflow server's concern. `login` belongs only to hub mode |
| Local `workspace="reports"` (relative) instead of `str(PROJECT_ROOT / "reports")` (absolute) | Relative resolves against CWD; runs from other dirs write the store somewhere unexpected |
| Putting `skore.login(mode="hub")` after `skore.Project(...)` | `Project(...)` requires authenticated session in hub mode. `login` first |
| Substituting `<SKORE_PROJECT_INIT>` in `audit/<stem>.py` independently of `experiments/<stem>.py` | Audit must open the same Project. Byte-identical copy from the experiment file is the rule |
| Hub workspace name contains `/` (e.g. `acme/datasci`) | `workspace=` is a single Hub workspace identifier, not a path; a `/` is invalid |
| `project.get(key)` raised `KeyError` → re-run `evaluate` + `put` to "recover" | Lookup shape wrong (`get` is by id). Use `summarize()` → `get(id)` |
