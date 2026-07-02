# Companion Skills — audit-ml-pipeline

| Skill | Relationship |
|---|---|
| `iterate-ml-experiment` | Caller. § 4 dispatches here FIRST; the digest feeds the `JOURNAL.md` Status + History update |
| `iterate-from-skore` | Downstream consumer of this skill's digest. `audit-ml-pipeline` opens the Project and renders the digest; `iterate-from-skore` parses the digest as text and drafts Backlog rows from each surfaced check. Never opens the Project itself |
| `evaluate-ml-pipeline` | Producer side. `skore.evaluate` + `project.put` live only in `experiments/NN_*.py` |
| `organize-ml-workspace` | Workspace layout; four-way stem pairing |
| `python-env-manager` | Agent feature install (G-AGENT-FEATURE). This skill requests; that skill installs |
| `python-api` | skore symbol lookups. Cache hits first |
| `python-code-style` | ruff after writing/editing `audit/<stem>.py` |
| `data-science-python-stack` | Catalogues `ipython` + `pyright` under the agent feature |
