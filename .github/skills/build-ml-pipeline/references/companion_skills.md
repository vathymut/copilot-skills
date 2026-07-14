# Companion Skills — build-ml-pipeline

Canonical ownership map is at
`writing-great-skills:references/ml-companion-skills.md`. This local table
only lists relationships that are load-bearing for this skill body.

| Skill | Relationship |
|---|---|
| `python-api` | Authoritative lookup of sklearn / skrub / skore. Invoke whenever picking a symbol; cache hits first (Shape 0) |
| `evaluate-ml-pipeline` | Owns `skore.evaluate`, CV selection, the smoke test, and the audit digest. Consumes the `split_kwargs` wired at the X marker |
| `python-env-manager` | Detection + install commands. Invoke when `import skrub` raises |
| `python-quality` | **Must be invoked** after writing or editing `pipeline.py` / `features.py` / `data.py`. Direct `pixi run ruff check` drops the NumPyDoc convention |
