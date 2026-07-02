---
name: pytest-coverage
description: 'Run pytest tests with coverage, discover lines missing coverage, and increase coverage to 100%.'
---

## Steps

### 1. Generate coverage report

pytest --cov --cov-report=annotate:cov_annotate

If you are checking for coverage of a specific module, you can specify it like this:

pytest --cov=your_module_name --cov-report=annotate:cov_annotate

You can also specify specific tests to run, for example:

pytest tests/test_your_module.py --cov=your_module_name --cov-report=annotate:cov_annotate

### 2. Review uncovered lines

Open the `cov_annotate` directory. For each file with less than 100% coverage, review the annotated source. Lines starting with `!` are not covered.

### 3. Add missing tests

Write tests covering the `!` lines. Keep running pytest + coverage until all lines are covered.

**Stop when:** coverage report shows 0 uncovered lines, or further gains require architectural changes (flag to user).
