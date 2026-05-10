# samesame — Copilot Instructions

## Project Overview

`samesame` is a Python scientific library for statistical distribution shift detection, model monitoring, and data validation. It provides non-parametric hypothesis tests (`test_shift`, `test_adverse_shift`) and importance-weighted comparison utilities for comparing a **source** sample (e.g. training data) against a **target** sample (e.g. production data). Two experimental RCT-validation modules are also in development: `samesame.subgroup` and `samesame.model_selection`.

## Tech Stack

- **Language**: Python 3.12+
- **Core dependencies**: NumPy ≥ 1.21, SciPy ≥ 1.15, scikit-learn
- **Build backend**: `uv_build` (via `uv`)
- **Testing**: pytest, pytest-cov (doctests enabled)
- **Linting/formatting**: Ruff (line-length 88, pyupgrade + isort rules)
- **Documentation**: MkDocs Material + mkdocstrings-python, NumPy docstring convention

## Conventions

- **Naming**: `snake_case` for functions, methods, variables and modules; `PascalCase` for classes and named tuples/dataclasses. Public test functions are prefixed `test_` (e.g. `test_shift`). Private helpers are prefixed `_`.
- **Structure**: Source lives under `src/samesame/`. Public API is re-exported from `__init__.py`. Internal helpers in `_utils.py`, `_types.py`, etc. Each logical domain gets its own module file.
- **Docstrings**: Follow the NumPy docstring format (validated by `numpydoc`). Every public function and class requires a docstring with at minimum `Parameters`, `Returns`, and a `Examples` section containing a runnable doctest.
- **Error handling**: Raise built-in Python exceptions (`ValueError`, `TypeError`) with descriptive messages at public API boundaries. Do not swallow exceptions internally; let them propagate.
- **Type hints**: All public function signatures must have full type annotations (PEP 484/526). Use types from `samesame._types` where they exist.

## Workflow

- **Branching**: Feature branches off `main`; branch names follow `feat/<topic>`, `fix/<topic>`, `docs/<topic>`.
- **Commits**: Conventional Commits format (`feat:`, `fix:`, `docs:`, `test:`, `refactor:`, `chore:`).
- **PRs**: Require passing pytest suite (including doctests) and Ruff lint/format checks.

### Instruction References

- Python guidelines: `.github/instructions/python.instructions.md`
- Testing: `.github/instructions/testing.instructions.md`
- Security: `.github/instructions/security.instructions.md`
- Documentation: `.github/instructions/documentation.instructions.md`
- Performance: `.github/instructions/performance.instructions.md`
- Code review: `.github/instructions/code-review.instructions.md`
