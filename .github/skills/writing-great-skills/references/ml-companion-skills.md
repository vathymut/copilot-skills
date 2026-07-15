# ML Workspace Companion Skills

Canonical map of the ML-workspace family. Five skills: setup, EDA,
declaration, validation, and the iteration loop.

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
