---
applyTo: "**"
description: "Code review standards for samesame"
---

<!-- Based on/Inspired by: https://github.com/github/awesome-copilot/blob/main/instructions/code-review-generic.instructions.md -->

# Code Review Standards

Apply the repository-wide guidance from `../copilot-instructions.md` during all reviews.

## Review Priorities

### 🔴 CRITICAL (Block merge)
- Security vulnerabilities, exposed secrets, or invalid input handling at API boundaries
- Logic errors in statistical computations that would produce incorrect p-values or test results
- Breaking changes to the public API without a corresponding version bump and changelog entry
- Failing tests or doctests

### 🟡 IMPORTANT (Requires discussion)
- Missing docstrings or doctests on new public functions
- Type annotation gaps in public signatures
- New public symbols not exported from `__init__.py`
- Tests that only assert truthiness rather than specific values
- Code that diverges from the domain language defined in `CONTEXT.md`

### 🟢 SUGGESTION (Non-blocking)
- Simplifications, readability improvements, or minor style deviations
- Additional edge-case tests
- Wording improvements in docstrings or documentation

## What to Check

- **Correctness**: Statistical logic matches the referenced paper or algorithm; edge cases (empty arrays, single-element arrays, all-identical values) are handled.
- **API consistency**: Parameter names, defaults, and return types follow existing conventions; `random_state` and `n_splits` follow sklearn conventions.
- **Docstrings**: NumPy format, all parameters documented, runnable doctest present.
- **Tests**: New behaviour has tests; tests are deterministic and assert specific values.
- **Ruff compliance**: No lint or format violations (`ruff check` and `ruff format --check` pass).
- **Domain language**: Terminology aligns with `CONTEXT.md`; terms listed under _Avoid_ are not used in public-facing names or documentation.

## Review Principles

- Be specific: reference exact files and lines.
- Provide context: explain *why* something is an issue, not just that it is.
- Suggest fixes: show corrected code when applicable.
- Be constructive: the goal is better code, not criticism.
- Acknowledge good work: note well-written sections.
