---
applyTo: "src/**/*.py"
description: "Performance guidelines for samesame"
---

# Performance Guidelines

Apply the repository-wide guidance from `../copilot-instructions.md` to all code.

## Vectorisation

- Prefer NumPy vectorised operations over Python loops for any computation over arrays.
- Avoid creating unnecessary intermediate arrays; use in-place operations or generators where memory is a concern.
- Use `scipy.stats` and `sklearn` routines rather than reimplementing statistical algorithms — they are optimised and battle-tested.

## Algorithmic Complexity

- Be explicit about time and space complexity in docstrings `Notes` sections when it is non-obvious.
- For methods that scale with `n_splits`, document the expected runtime (e.g., O(n_splits × n_samples)).
- Avoid quadratic or worse complexity in functions that operate on sample arrays — prefer sorting or hashing based approaches.

## Memory Management

- Avoid storing full copies of large arrays across repeated bootstrap iterations; reuse pre-allocated buffers where appropriate.
- When accepting `ArrayLike` inputs, convert to NumPy arrays once at the boundary and pass the array through, not the original input.
- Do not hold references to large arrays in long-lived closures or class attributes unnecessarily.

## Slow Tests

- Tests that involve many bootstrap iterations or large datasets must be marked `@pytest.mark.slow` and excluded from the default run.
- Provide a `n_splits` or similar parameter to reduce work in unit tests without changing the tested logic.

## Profiling

- Profile with `cProfile` or `line_profiler` before optimising; do not micro-optimise without evidence.
- Benchmark critical paths against representative sample sizes (e.g., n=500, n=5000, n=50000) and document in PR descriptions when performance is a stated goal.
