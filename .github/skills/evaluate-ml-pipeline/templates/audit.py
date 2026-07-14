# %% [markdown]
"""
# Audit for `experiments/NN_<short_name>.py`

Read-only digest of the skore report.

Allowed:
- `skore.Project(...)`, `summarize()`, `get(id)`, `report.*` accessors
- read-only imports from `<pkg>`

Forbidden:
- `skore.evaluate(...)`, `project.put(...)`, workspace mutations
"""

# %%
import skore

from <pkg> import PROJECT_ROOT

# %%
# <SKORE_PROJECT_INIT>
project

# %%
summary = project.summarize()
summary

# %%
REPORT_ID = "<read from summary['id'] or hub URL>"
report = project.get(REPORT_ID)
report

# %%
report.checks.summarize().frame()

# %%
report.metrics.summarize().frame()
