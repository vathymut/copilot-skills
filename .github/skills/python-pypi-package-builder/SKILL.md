---
name: python-pypi-package-builder
description: Use when building, testing, linting, versioning, or publishing a production-grade Python library to PyPI.
---

# Python PyPI Package Builder

Create, scaffold, or publish a Python package to PyPI. Also: set up `pyproject.toml`, CI, linting, versioning.

## Decision chain

Load the referenced file at each step before proceeding.

### 1 — Package type

| Type | Entry point | Patterns |
|---|---|---|
| Utility library | Import API | `references/library-patterns.md` |
| API client / SDK | Import API | `references/library-patterns.md` |
| CLI tool | `[project.scripts]` | `references/library-patterns.md` |
| Framework plugin | `[project.entry-points]` | `references/library-patterns.md` |
| Mixed | primary type + secondary | `references/library-patterns.md` |

### 2 — Folder layout

| Situation | Layout |
|---|---|
| New project, unknown size | `src/` layout (safest default) |
| Single-purpose, 1–4 modules | Flat |
| Large, many contributors | `src/` |
| Multiple packages in one repo | Namespace/monorepo |

Templates: `references/structure-templates.md`.

### 3 — Build backend

| Condition | Backend | Config template |
|---|---|---|
| C/Cython extensions OR git-tag versioning | setuptools + setuptools_scm | `references/pyproject-toml.md` |
| All-in-one deps + build + publish | poetry (v2+) | `references/pyproject-toml.md` |
| Minimal config, pure Python | flit | `references/pyproject-toml.md` |
| Modern, fast, pure Python | hatchling | `references/pyproject-toml.md` |

Backend comparison, naming rules, PyPA concepts: `references/pyproject-toml.md`.

### 4 — Config + publish

Scaffold script: `python skills/python-pypi-package-builder/scripts/scaffold.py --name your-package-name`.

- `references/pyproject-toml.md` — all four backend templates, `py.typed`, tool configs
- `references/ci-publishing.md` — Trusted Publishing, TestPyPI, CHANGELOG, release checklist
- `references/versioning-strategy.md` — PEP 440, semver, setuptools_scm
- `references/testing-quality.md` — ruff/mypy/pre-commit
- `references/release-governance.md` — branch protection, OIDC, tag validation
- `references/tooling-ruff.md` — Ruff-only lint/format
- `references/community-docs.md` — README, CONTRIBUTING, docstrings

**Two inline rules:**
- `setuptools_scm` CI: `fetch-depth: 0` in every checkout (else version silently falls back to `0.0.0+dev`).
- Library deps: prefer `"httpx>=0.24"` (minimum). Never pin `==` or `~=` in a library's `[project] dependencies.

## Stop conditions

- **Don't infer the package type.** Ask the user if unclear.
- **Don't skip TestPyDI for first release.**
- **Don't publish without CI (Trusted Publishing recommended).**
