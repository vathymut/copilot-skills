---
name: python-expert
description: >
  Review or write Python code for correctness, type safety, performance, and style.
  Use when: reviewing Python code quality, writing Python functions/classes,
  implementing type hints, debugging issues, optimizing performance,
  or user mentions PEP 8, type hints, or Python best practices.
---

Review or write Python code by checking correctness, type safety, performance, and style — in priority order.

## 1. Read the code

Understand the code's purpose, structure, and context. Identify the problem domain and key data flows.

**Completion criterion:** can describe what the code does and why.

## 2. Check correctness (CRITICAL)

Scan for bugs and logical errors:
- Mutable default arguments (`def f(items=[])`)
- Bare `except:` clauses that swallow errors silently
- Missing edge cases or input validation
- Unhandled error paths

Fix before anything else. See [`references/style-rules.md`](references/style-rules.md) for patterns.

**Completion criterion:** no mutable defaults, no bare excepts, all edge cases handled.

## 3. Check type safety (HIGH)

Ensure type hints are present and correct:
- All function signatures have parameter and return type annotations
- Use `Optional`, `Union`, `TypeVar` where appropriate
- Data containers use `@dataclass` instead of manual `__init__`
- Generic types used for reusable functions

**Completion criterion:** every public function has complete type annotations.

## 4. Check performance (HIGH)

Look for unnecessary overhead:
- Replace loops with list comprehensions where readable
- Use generators for large data streams
- Use context managers for all resource handling
- Leverage built-ins (`sum`, `any`, `all`, `Counter`) over manual implementations

**Completion criterion:** no obvious performance anti-patterns remain.

## 5. Check style (MEDIUM)

Verify conventions:
- PEP 8 naming (`snake_case` functions/variables, `PascalCase` classes)
- Docstrings on public functions (Google or NumPy format)
- Meaningful variable names
- Comments only for complex logic

**Completion criterion:** code passes a style check; docstrings present on public API.

## 6. Present findings

Structure output by severity:
1. **Critical** — bugs, data corruption, security issues (fix immediately)
2. **High** — correctness risks, resource leaks (fix before merge)
3. **Medium** — style violations, missing docs (fix or accept with TODO)

For each finding: file path, line number, issue description, and corrected code.

**Completion criterion:** every finding has a concrete fix with code.

## Style and formatting branch

When the task is specifically about linting, formatting, or docstring conventions in the data-science Python stack, delegate to `python-code-style`. Use it after editing Python files or when the user asks for ruff/numpydoc help. `python-code-style` owns the manual ruff workflow, numpydoc, and bundled `ruff.toml` template.
