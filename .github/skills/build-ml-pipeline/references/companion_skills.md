# Companion Skills — build-ml-pipeline

| Skill | Relationship |
|---|---|
| `python-api` | Authoritative lookup of sklearn / skrub / skore. Invoke whenever picking a symbol; cache hits first (Shape 0) |
| `evaluate-ml-pipeline` | Owns `skore.evaluate`, CV selection, metric defaults. Consumes the `split_kwargs` wired at the X marker |
| `smoke-test-ml-pipeline` | Executable proof of Rule 2's early-mark. Smoke failure → route back here; fix the topology, don't loosen the assertion |
| `test-ml-pipeline` | Router for `tests/`. Smoke test pairs 1:1 with the experiment script |
| `python-env-manager` | Detection + install commands. Invoke when `import skrub` raises |
| `python-code-style` | **Must be invoked** after writing or editing `pipeline.py` / `features.py` / `data.py`. Direct `pixi run ruff check` drops the NumPyDoc convention |
