---
name: python-code-style
description: >
  Owns Python code style for this stack: ruff for lint + format, numpydoc
  for docstrings. Runs ruff manually on touched files and contextualizes
  comments to the data-science problem.

  TRIGGER when (any of these):
  (1) a Python file was just created or edited via Write / Edit /
      MultiEdit — invoke this skill before declaring the task done so
      ruff is run AND the file's comments are contextualized to the
      problem;
  (2) a fresh ML workspace was just scaffolded by
      `organize-ml-workspace` and the project has no `ruff.toml` at
      its root yet — drop the bundled template;
  (3) the user asks about lint, format, docstring style, or reaches
      for `black` / `isort` / `flake8` / `pydocstyle` (redirect to
      ruff — the stack's canonical linter, owned by
      `data-science-python-stack` Tier 1).

  SKIP when: the project is non-Python; the only edits in this turn
  are to Markdown / TOML / JSON / YAML; the file lives in a
  third-party vendored directory the user doesn't own.

  HOW TO USE: run ruff manually on the files you just touched — do
  not configure a PostToolUse hook for this. **Read the "Stop
  conditions" block and emit the Pre-flight checklist as visible
  text in your response — both are mandatory before running ruff.**
---

# Python Code Style

Single owner of Python style in this stack: ruff (lint + format) and
numpydoc docstrings. Intentionally **manual** — Claude runs ruff on
files it has just touched, no hook involved.

## Stop conditions — read before anything else

- **Do not configure a PostToolUse / PreToolUse hook for ruff.** This
  skill is intentionally manual. A hook tightens the loop in ways
  that bite (every micro-edit triggers a fix cycle, partial files
  fail D-rule checks mid-write, retries can stall the turn). If the
  user explicitly asks for an automated hook later, redirect to
  `update-config` — but the default is "Claude runs ruff itself."
- **Do not substitute ruff with `black` / `isort` / `flake8` /
  `pydocstyle` / `pylint`.** Ruff is the canonical linter in this
  stack (`data-science-python-stack` Tier 1). If `import ruff` /
  `pixi run ruff --version` fails, route through `python-env-manager`
  to install — don't silently fall back.
- **One fix attempt per file, then surface.** If `ruff check`
  reports issues after Claude's first fix, address them once. If the
  *same* issue persists after the second pass, stop editing that
  file and surface the remaining diagnostics + diff to the user.
- **Don't lint files outside the user's code.** Scope is
  `src/<pkg>/`, `experiments/`, `audit/`, `data/eda.py`, top-level
  `*.py` scripts, and any package directory the user owns. Skip
  vendored paths, generated files, and anything under `.pixi/`,
  `.venv/`, `node_modules/`, etc.
- **Never write `ruff.toml` from memory.** The bundled
  `templates/ruff.toml` is the single source of truth — it encodes
  the per-file ignores (`experiments/**`), the numpydoc convention,
  and the rule selection this stack expects. Initial setup requires
  **`Read .agents/skills/python-code-style/templates/ruff.toml`**
  *this turn*, then `Write <project-root>/ruff.toml` verbatim.
- **Don't call `warnings.filterwarnings(...)` unless the user
  explicitly asks for it.** Same for `warnings.simplefilter`,
  `@pytest.mark.filterwarnings`, and `filterwarnings = [...]` in
  `pytest.ini` / `pyproject.toml`. Warnings are signal in this
  stack.
- **Documentation describes the problem, not the workflow.** A
  committed file's module docstring, header, and comments must
  describe the **data-science problem** and the file's role in it —
  never the skills, the gates (`G-*`), the cell runner, the run
  digest, or the journal / backlog / design-note machinery. When you
  touch a file that now carries **real content**, rewrite any leftover
  generic template or workflow prose into concise, problem-specific
  docs grounded in the current context. If the file is still an empty
  skeleton, leave its placeholder — the contextualization happens when
  the content lands. Details: references/comment-contextualization.md.

## Pre-flight — emit this checklist as visible text before running ruff

```
Pre-flight (python-code-style):
- [ ] ruff importable in the project's env (`pixi run ruff --version`
      succeeds, per `data-science-python-stack` Tier 1)
- [ ] `ruff.toml` present at project root.
      If absent AND stack + workspace are already set up: the
      bundled template MUST be read **this turn** before being
      written verbatim.
      Evidence: Read .agents/skills/python-code-style/templates/ruff.toml
                (this turn) + Write <project-root>/ruff.toml (this turn)
                | "n/a — ruff.toml already at project root"
      **Inline-authored ruff.toml from memory is NOT evidence.**
- [ ] File list ready: <abs paths of .py files touched this turn>
- [ ] Decision recorded: this is the first ruff pass on these files
      (proceed) | second pass (proceed but stop on persistent
      issues) | third pass on same warning (STOP, surface to user)
- [ ] One-fix-per-file rule acknowledged: max two passes per warning,
      then surface remaining diagnostics + diff to the user.
- [ ] Comments contextualized: each touched file with real content has
      problem-specific docs and NO workflow/skill/gate/runner/digest
      meta (references/comment-contextualization.md)
      Evidence: per file, "rewrote header to <problem context>" |
                "no leftover template/workflow prose" |
                "n/a — empty skeleton, no context yet"
```

## Scope

- **In scope:** running `ruff format` + `ruff check --fix` + `ruff
  check` on Python files Claude has just generated or edited;
  authoring numpydoc docstrings on public functions and classes;
  contextualizing each touched file's comments to the data-science
  problem and stripping workflow/process meta; dropping the
  `ruff.toml` template into a fresh project.
- **Out of scope:** type hints (mypy / pyright are not in the
  stack); naming conventions ruff doesn't enforce; setting up
  PostToolUse / PreToolUse hooks; linting non-Python files.

## What to run, in what order

For every Python file touched this turn, run inside the project's
environment manager (per `python-env-manager`):

```bash
pixi run ruff format <files>
pixi run ruff check --fix <files>
pixi run ruff check <files>
```

1. **`ruff format`** — applies the formatter. Idempotent.
2. **`ruff check --fix`** — auto-fixes: import sorting (`I`), legacy
   syntax (`UP`), bug patterns (`B`).
3. **`ruff check`** — final pass. Address reported issues (`D`, `F`,
   etc.), then re-run the trio. Apply the one-fix-per-file rule.

`D100`/`D103` warnings are expected for `# %%` cells under
`experiments/`, `audit/`, and `data/eda.py` — the bundled `ruff.toml`
per-file-ignores them. If you see them, the `ruff.toml` isn't loaded.

## Contextualize the comments

See references/comment-contextualization.md for the full pass.
After the ruff trio, for every touched file with **real content**,
rewrite any leftover template / workflow prose into concise,
problem-specific documentation. Files that are still empty skeletons
are skipped.

## Numpydoc

See references/numpydoc.md for the full docstring convention.
Public functions and classes carry numpydoc-format docstrings; the
`Parameters` / `Returns` (and `Raises` when applicable) sections are
mandatory — even on small functions. Private helpers are the only
exception.

## Initial setup — dropping the `ruff.toml` template

When invoked on a fresh project with no `ruff.toml` at root and the
stack + workspace already scaffolded:

1. **Read the bundled template** *this turn*:
   `Read .agents/skills/python-code-style/templates/ruff.toml`.
2. **Write the content verbatim** to `<project-root>/ruff.toml`.
   No edits, no "improvements", no rule additions.
3. **Verify ruff picks it up**: `pixi run ruff check --show-settings .`
   should report the `numpy` convention and the `select` list.

Do not fold ruff config into `pyproject.toml` automatically — the
standalone `ruff.toml` is unambiguous.

## Pre-existing warnings

Fix only the lines Claude touched. Mention pre-existing warnings
elsewhere so the user can decide, but don't drag them into scope.

## Companion skills

- **`data-science-python-stack`** — owns ruff as Tier 1 mandatory.
- **`python-env-manager`** — installs ruff for the project's manager.
- **`organize-ml-workspace`** — sets up the directory layout.
- **`audit-ml-pipeline`** / **`explore-ml-data`** — generate audit
  and EDA files; same `# %%` convention, same per-file ignores.
