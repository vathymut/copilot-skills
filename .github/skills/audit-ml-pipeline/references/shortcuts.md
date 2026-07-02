# Forbidden Shortcuts — audit-ml-pipeline

| Shortcut | Why it's wrong |
|---|---|
| `report = project.get(REPORT_ID); print(repr(report))` | Runner captures bare expressions via `result.result`, not stdout. `print(repr(...))` mixes stdout and output sections. Use `report` on its own line |
| Drop `.frame()` from `report.checks.summarize()` / `report.metrics.summarize()` | `__repr__` of the Display objects is `<…Display at 0x…>`. `.frame()` returns a DataFrame whose repr carries the actual values |
| `project.get(KEY)` raised `KeyError` → re-run `evaluate` + `put` "to refresh" | Lookup shape is wrong (get is by id, not key). Hub: read the id from the URL printed by `put()`. Local: read `summary["id"]` for the matching key row. Never re-run `evaluate` + `put` to recover |
| Write `pixi add --feature agent ipython pyright` directly from this skill | Install commands owned by `python-env-manager`. This skill **requests** via G-AGENT-FEATURE; it does not install |
| Dump the audit `.py` into `scratch/audit/<stem>/` | `.py` is durable in git; `scratch/` is gitignored. Source in `audit/`; digest in `scratch/audit/<stem>/` |
| Register a Jupyter kernel "to be safe" | Current runner is in-process; no kernel. Registering creates an orphan kernelspec |
| Add a fix-up cell that mutates `data/` or `reports/` | Audit files are read-only. State mutations belong in a `scratch/<ts>_*.py` probe or the experiment script |
| Substitute `<SKORE_PROJECT_INIT>` in `audit/<stem>.py` without reading `experiments/<stem>.py` first | Audit must open the same Project. Always Read experiments/<stem>.py this turn and copy the literal Project init block byte-identical (modulo formatting) |
| Hub mode: put `skore.login(mode="hub")` after `skore.Project(...)` | `Project(...)` constructor authenticates at init time; without prior `login`, fails. Order is fixed: login first, Project second |
| § 4 dispatched audit → write scratch probe first to "double-check metrics" | The audit IS the metric-extraction step in § 4. Scratch probes for metrics are the anti-pattern this dispatch replaces |
