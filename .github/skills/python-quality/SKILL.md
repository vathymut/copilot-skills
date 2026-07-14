---
name: python-quality
description: "Own Python code quality: manual lint/format runs (ruff is the stack default), numpydoc docstrings, and expert review of correctness, type safety, performance, and style."
---

# Python Quality

Two branches:

- **Branch A — Stack style** (default): manual lint/format + numpydoc after editing Python files, plus recursive clean-up when asked.
- **Branch B — Expert review**: correctness, type safety, performance, and style review of Python code.

Default to Branch A after any Python file edit; use Branch B when the user asks for a Python code review or expert check.

## Branch A — Stack style

**This stack uses ruff for lint/format and numpydoc for docstrings.** On projects with different tooling, adapt the command names but keep the same workflow: manual, no substitution, one fix attempt then surface.

### Stop conditions

- **Do not configure a PostToolUse / PreToolUse hook for the linter.** Manual runs only. Hooks trigger on every micro-edit and stall partial files.
- **Do not silently substitute the canonical tool.** If this stack expects ruff, don't fall back to `black` / `isort` / `flake8` / `pydocstyle`. If the tool is missing, invoke `python-env-manager` to install.
- **One fix attempt per file, then surface.** Address the issue once; if the *same* issue persists after a second pass, stop editing and show the diagnostics + diff to the user.
- **Lint only project-owned Python files.** Skip vendored, generated, and virtual-environment paths.
- **Never write linter config from memory.** If the project ships a bundled template, read it this turn and write it verbatim.
- **Don't globally suppress warnings** unless the user explicitly asks.
- **Comments describe the domain problem, not the workflow.** Strip skill/gate/runner/digest meta from committed headers.

### Pre-flight — emit this checklist before running the linter

```
Pre-flight (python-quality):
- [ ] Tool importable in the project's env (e.g. `ruff --version` succeeds)
- [ ] Config present at project root (or template read this turn and written verbatim)
- [ ] File list ready: <abs paths of .py files touched this turn>
- [ ] Pass count recorded: first | second (proceed but stop on persistent issues) | third (STOP, surface)
- [ ] Comments contextualized: each touched file with real content has domain-specific docs and no workflow meta
```

### Post-edit run

For every Python file touched this turn, run inside the project's environment manager (per `python-env-manager`):

```bash
pixi run ruff format <files>
pixi run ruff check --fix <files>
pixi run ruff check <files>
```

1. **Format** — idempotent.
2. **Check --fix** — auto-fix imports, legacy syntax, bug patterns.
3. **Check** — final pass. Address remaining issues, then re-run. Apply the one-fix-per-file rule.

If `D100`/`D103` warnings appear for `# %%` notebook cells, the per-file ignores in the bundled config are not loaded.

### Recursive clean-up

When the user asks to "clean all ruff/lint issues" or similar, read `references/recursive-ruff.md` and run the workflow there. In short:

1. Resolve the linter command once and reuse it.
2. Baseline check, classify findings.
3. Safe fix pass; format; re-check.
4. Unsafe fix pass (if enabled); format; re-check.
5. Manual remediation for what remains.
6. Loop until clean, blocked, or no progress. Ask on ambiguity.

Use `# noqa` only when justified and line-scoped. Report scope, iterations, fixes, suppressions, and blockers.

### Numpydoc

Public functions and classes carry numpydoc docstrings with `Parameters` and `Returns` (and `Raises` when applicable). Private helpers are the exception. See `references/numpydoc.md`.

### Initial setup

When invoked on a fresh project with no linter config at root:

1. Read the bundled template this turn (e.g. `templates/ruff.toml`).
2. Write it verbatim to the project root; no ad-hoc edits.
3. Verify the tool picks it up (`ruff check --show-settings .`).

### Pre-existing warnings

Fix only lines Claude touched. Mention pre-existing warnings so the user can decide. This rule applies to post-edit runs; recursive clean-up scope is whatever the user asked to clean.

## Branch B — Expert review

Review Python code in this priority order:

1. **Correctness (CRITICAL)** — mutable defaults, bare `except`, missing edge cases, unhandled error paths. Fix first. See `references/style-rules.md`.
2. **Type safety (HIGH)** — complete annotations on public functions; `Optional`/`Union`/`TypeVar` where appropriate; `@dataclass` for data containers; generics for reusable functions.
3. **Performance (HIGH)** — list comprehensions where readable, generators for large streams, context managers for resources, built-ins over manual loops.
4. **Style (MEDIUM)** — PEP 8 naming, numpydoc docstrings, meaningful names, comments only for complex logic.

### Present findings

Group by severity:

1. **Critical** — bugs, data corruption, security.
2. **High** — correctness risks, resource leaks.
3. **Medium** — style violations, missing docs.

For each finding include: file path, line number, issue, and corrected code.

## Companion skills

- **`data-science-python-stack`** — owns ruff/pytest as Tier 1 in ML workspaces.
- **`python-env-manager`** — installs the right tool for the project's package manager.
- **`organize-ml-scaffold`** — sets up the directory layout this skill often touches.

For the ML-workspace family, see `writing-great-skills:references/ml-companion-skills.md`.
