---
applyTo: "tests/**/*.py, src/**/*.py"
description: "Testing standards for samesame"
---

# Testing Standards

Apply the repository-wide guidance from `../copilot-instructions.md` to all tests.

## General Principles

- Every public function and class must have unit tests covering its contract.
- Tests are located in `tests/` and mirror the structure of `src/samesame/`.
- Doctests in module source are enabled (`--doctest-modules`); keep them runnable and minimal.
- Use `pytest` fixtures and `conftest.py` for shared setup; avoid global mutable state.

## Test Naming and Structure

- Test functions are named `test_<behaviour_being_tested>` — describe what the function *should do*, not which function is being called.
- Follow Arrange-Act-Assert: set up data, call the function under test, assert the result.
- Each test should verify exactly one behaviour; split compound assertions into separate tests when they represent different concerns.

## Statistical Tests

- For deterministic numeric assertions use `numpy.testing.assert_allclose` with an explicit `rtol` or `atol`.
- For randomised behaviour, fix `random_state` or `rng` in test inputs and assert on distributional properties (e.g., p-value is in `(0, 1)`, result shape is correct), not exact values.
- Calibration tests (Type I error rate under the null) should use a sufficient number of simulations and a sufficiently loose threshold — see `CONTEXT.md` for the canonical threshold guidance.

## Fixtures and Data

- Small synthetic arrays created with `numpy.random.default_rng(seed).normal(...)` are preferred over loading files.
- Fixtures that are expensive to compute (large datasets, model fits) should be marked `@pytest.fixture(scope="session")`.
- Slow tests are marked `@pytest.mark.slow` and excluded from the default run.

## Coverage

- Aim for full branch coverage on public API functions.
- Do not write tests solely to hit coverage numbers; every test must assert something meaningful.
- Run `pytest --cov samesame --cov-report term-missing` locally to identify gaps before submitting.
