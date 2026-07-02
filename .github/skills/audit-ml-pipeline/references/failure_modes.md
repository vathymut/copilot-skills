# Failure Modes — audit-ml-pipeline

Detailed recovery steps for every symptom.

## `project.get(key)` raises `KeyError` / `TypeError`

**Cause:** Lookup by key, not id; local vs hub shape differs.

**Recovery:** For hub mode, read the id from the URL printed by
`project.put()`:
`https://…/<workspace>/<project>/<type-plural>/<N>` → id is
`skore:report:<type-singular>:<N>` (URL segment is plural; id uses
the singular — drop the trailing `s`, e.g. `cross-validations` →
`cross-validation`, `estimators` → `estimator`). Hardcode
`REPORT_ID` in the audit file. For local mode, read the `"id"`
column of `project.summarize()` for the matching key row.

## `ModuleNotFoundError: No module named 'IPython'`

**Cause:** Agent feature not installed.

**Recovery:** Delegate to `python-env-manager`; never `pip install`
here. Request via `G-AGENT-FEATURE` (binary: install / skip); resume
only when python-env-manager returns "ready".

## Cell renders as `<Display object at 0x…>`

**Cause:** `*.summarize()` called without `.frame()`.

**Recovery:** Add `.frame()` to the call.

## `AttributeError` for a `report.*` accessor

**Cause:** Symbol from memory; skore version drift.

**Recovery:** Invoke `python-api` for the correct symbol name.
Recognition is not a lookup; names drift between releases.

## `RuntimeError: No report under key=...`

**Cause:** `put()` landed in a different Project.

**Recovery:** Verify the Project init block in the audit file
matches the experiment script byte-for-byte. Read
`experiments/<stem>.py` this turn and copy the literal init block.

## Report differs across runs with unchanged source

**Cause:** Non-deterministic step / different data slice.

**Recovery:** Not a bug in the audit. Surface to user.

## Hub mode: `skore.login()` auth error

**Cause:** Token expired / first-time login.

**Recovery:** Re-authenticate via `skore.login()` before
`skore.Project(...)`.

## Hub mode: `TypeError: workspace` kwarg

**Cause:** Hub form left local-mode kwarg.

**Recovery:** Use the hub-specific `workspace=` kwarg in
`skore.Project(...)`.

## Hub mode: report missing in `summarize()` after `put()`

**Cause:** Wrong hub workspace OR no read access.

**Recovery:** Verify the workspace matches what was used in
`project.put()`. Check read permissions on the hub.
