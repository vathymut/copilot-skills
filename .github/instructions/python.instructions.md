---
applyTo: "**/*.py"
description: "Python development standards for samesame"
---

# Python Coding Standards

Apply the repository-wide guidance from `../copilot-instructions.md` to all code.

## General Guidelines

- Target Python 3.12+; use modern syntax features (union types with `|`, `match` statements where appropriate, `tomllib`, etc.).
- Prefer idiomatic Python: list/dict/set comprehensions, generator expressions, and `itertools` over manual loops where clarity is maintained.
- Keep modules focused: each file should have a single well-defined responsibility.
- Avoid side effects at import time; module-level code should only define names, not run logic.

## Type Annotations

- All public function and method signatures must have full type annotations (PEP 484/526).
- Use `samesame._types` for domain types (`TestResult`, `SubgroupResult`, etc.) rather than repeating raw types.
- Prefer `numpy.typing.ArrayLike` and `numpy.typing.NDArray` for NumPy array parameters.
- Use `typing.TypeAlias` for complex reusable type definitions.

## API Design

- Public functions that accept array inputs should validate them at the boundary and raise `ValueError` or `TypeError` with descriptive messages.
- Parameter defaults should follow sklearn conventions where applicable (e.g., `random_state`, `n_splits`).
- Return named result objects (dataclasses or named tuples) rather than bare tuples for multi-valued returns.
- Experimental modules must document their status in the module-level docstring; do not use `warnings.warn` at import time.

## Numeric and Scientific Code

- Prefer `numpy` vectorised operations over Python loops for array computations.
- Use `numpy.random.default_rng` (Generator API) rather than the legacy `numpy.random.*` functions.
- Validate that inputs are numeric and finite before passing to statistical routines.
- Avoid mutation of input arrays; work on copies when in-place modification would surprise callers.

## Code Style

- Ruff enforces line-length 88, pyupgrade (`UP`), and isort (`I`) rules — do not bypass these.
- Private helpers and internal modules are prefixed with `_`.
- Constants are `UPPER_SNAKE_CASE`; module-level mutable state is strongly discouraged.
