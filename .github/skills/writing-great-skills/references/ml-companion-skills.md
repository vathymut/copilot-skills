# ML Workspace Companion Skills

Canonical map of the ML-workspace family. Each skill links to the others it
touches. Individual skills should reference this table rather than repeating
their own variant.

| Skill | Owns | Consumes / dispatches to |
|---|---|---|
| `organize-ml-workspace` | Directory layout, four-way stem pairing, scaffold templates | `python-env-manager` (G-ENV-MGR), `data-science-python-stack` (G-TABULAR, skore mode), `python-api` (signatures), `python-code-style` (ruff.toml) |
| `explore-ml-data` | EDA script `data/eda.py`, `data/eda.md`, HTML report, JOURNAL EDA section | `python-env-manager` (G-AGENT-FEATURE for ipython) |
| `iterate-ml-experiment` | Propose → approve → implement → record loop; design notes; JOURNAL.md | `organize-ml-workspace`, `explore-ml-data`, `build-ml-pipeline`, `evaluate-ml-pipeline`, `test-ml-pipeline`, `audit-ml-pipeline`, `python-api`, `python-env-manager` |
| `build-ml-pipeline` | `src/<pkg>/{pipeline,features,data}.py` as a skrub DataOps graph | `python-api` (skrub/sklearn symbols), `python-env-manager` (missing deps), `python-code-style` |
| `evaluate-ml-pipeline` | `src/<pkg>/evaluate.py`; CV strategy; `skore.evaluate` calls | `build-ml-pipeline` (split_kwargs from X marker), `python-api` (skore/sklearn splitter symbols), `smoke-test-ml-pipeline` (paired structural check) |
| `test-ml-pipeline` | `tests/` layout and stem-pairing rule; router to category subskills | `smoke-test-ml-pipeline` (smoke body), `iterate-ml-experiment` (design-note approval) |
| `smoke-test-ml-pipeline` | Body of `tests/smoke/test_NN_*.py`: diagnostic fixture + structural assertions | `build-ml-pipeline` (X-marker rule), `iterate-ml-experiment` (done-gate), `python-api` (predicting-package symbols) |
| `audit-ml-pipeline` | `audit/NN_*.py` read-only digest of a finished run | `python-env-manager` (agent feature), `skore` Project (read-only via `summarize` → `get(id)`) |
| `data-science-python-stack` | *What* to install, when, and why; tier structure; competing-library gates | `python-env-manager` (turns decisions into install commands) |
| `python-env-manager` | *How* to install; manager detection; 3-feature layout + lsp composition | `data-science-python-stack` (stack decisions), `organize-ml-workspace` |
| `python-code-style` | ruff + NumPyDoc; post-edit runs; recursive clean-up | `data-science-python-stack` (ruff as Tier 1), `python-env-manager` (installation) |
| `python-api` | Installed-version API lookup and cache | — (utility skill consumed by many above) |
