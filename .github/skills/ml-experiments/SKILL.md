---
name: ml-experiments
description: User-invoked router for ML-experiment skills. Type this skill name to see which ML skill to use.
disable-model-invocation: true
---

# ML Experiments Router

Index of the ML-workspace skill family. Invoke the right skill by name;
high-frequency skills also auto-trigger on their own descriptions.

## Which skill for the job

| Need | Skill |
|---|---|
| Scaffold a new experiment workspace (dirs, four-way stem pairing, config gates) | `ml-scaffold` |
| One-time bootstrap EDA (`data/eda.py`, `data/eda.md`, HTML report) | `ml-eda` |
| Declare the pipeline as a skrub DataOps graph | `build-ml-pipeline` |
| CV strategy, smoke test, read-only audit digest | `evaluate-ml-pipeline` |
| Run the propose → approve → implement → record loop | `iterate-ml-experiment` |
| Decide *what* to install (tiers, competing-library gates) | `data-science-python-stack` |
| Decide *how* to install (manager detection, feature layout) | `python-env-manager` |
| Look up installed-version API symbols | `python-api` |

## Ownership & dispatch map

Canonical relationships between the eight ML-workspace skills. Each skill
is standalone; this map exists only so a maintainer can see who owns what
and what depends on what.

| Skill | Owns | Consumes / dispatches to |
|---|---|---|
| `ml-scaffold` | Directory layout, four-way stem pairing, bootstrap config gates (`G-PKG-NAME`, `G-SKORE-MODE`) | `python-env-manager` (G-ENV-MGR), `data-science-python-stack` (G-TABULAR, skore mode), `python-api` (signatures) |
| `ml-eda` | One-time bootstrap EDA: `data/eda.py`, `data/eda.md`, HTML report, shared cell runner | `python-env-manager` (G-AGENT-FEATURE), `python-api` (skrub symbols) |
| `build-ml-pipeline` | `src/<pkg>/{pipeline,features,data}.py` as a skrub DataOps graph | `python-api` (skrub/sklearn symbols), `python-env-manager` (missing deps) |
| `evaluate-ml-pipeline` | `src/<pkg>/evaluate.py`; CV strategy; `skore.evaluate` calls; smoke test; read-only audit digest | `build-ml-pipeline` (split_kwargs from X marker), `python-api` (skore/sklearn splitter symbols), `ml-eda` (shared cell runner) |
| `iterate-ml-experiment` | Propose → approve → implement → record loop; design notes; `JOURNAL.md` | `ml-scaffold`, `ml-eda`, `build-ml-pipeline`, `evaluate-ml-pipeline`, `python-api`, `python-env-manager` |
| `data-science-python-stack` | *What* to install, when, and why; tiers; competing-library gates | `python-env-manager` (install commands) |
| `python-env-manager` | *How* to install; manager detection; 3-feature layout + lsp composition | `data-science-python-stack` (stack decisions), `ml-scaffold` |
| `python-api` | Installed-version API lookup and cache | — (utility skill consumed by the skills above) |
