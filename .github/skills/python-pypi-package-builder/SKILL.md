---
name: python-pypi-package-builder
description: Use when building, testing, linting, versioning, or publishing a production-grade Python library to PyPI.
---

# Python PyPI Package Builder Skill

---

## Quick Navigation

| Section in this file | What it covers |
|---|---|
| [1. Skill Trigger](#1-skill-trigger) | When to load this skill |
| [2. Package Type Decision](#2-package-type-decision) | Identify what you are building |
| [3. Folder Structure Decision](#3-folder-structure-decision) | src/ vs flat vs monorepo |
| [4. Build Backend Decision](#4-build-backend-decision) | setuptools / hatchling / flit / poetry |
| [5. PyPA Packaging Flow](#5-pypa-packaging-flow) | The canonical publish pipeline |
| [6. Project Structure Templates](#6-project-structure-templates) | Full layouts for every option |
| [7. Versioning Strategy](#7-versioning-strategy) | PEP 440, semver, dynamic vs static |

| Reference file | What it covers |
|---|---|
| `references/pyproject-toml.md` | All four backend templates, `setuptools_scm`, `py.typed`, tool configs |
| `references/library-patterns.md` | OOP/SOLID, type hints, core class design, factory, protocols, CLI |
| `references/testing-quality.md` | `conftest.py`, unit/backend/async tests, ruff/mypy/pre-commit |
| `references/ci-publishing.md` | `ci.yml`, `publish.yml`, Trusted Publishing, TestPyPI, CHANGELOG, release checklist |
| `references/community-docs.md` | README, docstrings, CONTRIBUTING, SECURITY, anti-patterns, master checklist |
| `references/architecture-patterns.md` | Backend system (plugin/strategy), config layer, transport layer, CLI, backend injection |
| `references/versioning-strategy.md` | PEP 440, SemVer, pre-release, setuptools_scm deep-dive, flit static, decision engine |
| `references/release-governance.md` | Branch strategy, branch protection, OIDC, tag author validation, prevent invalid tags |
| `references/tooling-ruff.md` | Ruff-only setup (replaces black/isort), mypy config, pre-commit, asyncio_mode=auto |

**Scaffold script:** run `python skills/python-pypi-package-builder/scripts/scaffold.py --name your-package-name`
to generate the entire directory layout, stub files, and `pyproject.toml` in one command.

---

## 1. Skill Trigger

Load this skill whenever the user wants to:

- Create, scaffold, or publish a Python package or library to PyPI
- Build a pip-installable SDK, utility, CLI tool, or framework extension
- Set up `pyproject.toml`, linting, mypy, pre-commit, or GitHub Actions for a Python project
- Understand versioning (`setuptools_scm`, PEP 440, semver, static versioning)
- Understand PyPA specs: `py.typed`, `MANIFEST.in`, `RECORD`, classifiers
- Publish to PyPI using Trusted Publishing (OIDC) or API tokens
- Refactor an existing package to follow modern Python packaging standards
- Add type hints, protocols, ABCs, or dataclasses to a Python library
- Apply OOP/SOLID design patterns to a Python package
- Choose between build backends (setuptools, hatchling, flit, poetry)

**Also trigger for phrases like:** "build a Python SDK", "publish my library", "set up PyPI CI",
"create a pip package", "how do I publish to PyPI", "pyproject.toml help", "PEP 561 typed",
"setuptools_scm version", "semver Python", "PEP 440", "git tag release", "Trusted Publishing".

---

## 2. Package Type Decision

Identify what the user is building **before** writing any code. Each type has distinct patterns.

### Decision Table

| Type | Core Pattern | Entry Point | Key Deps | Example Packages |
|---|---|---|---|---|
| **Utility library** | Module of pure functions + helpers | Import API only | Minimal | `arrow`, `humanize`, `boltons`, `more-itertools` |
| **API client / SDK** | Class with methods, auth, retry logic | Import API only | `httpx` or `requests` | `boto3`, `stripe-python`, `openai` |
| **CLI tool** | Command functions + argument parser | `[project.scripts]` or `[project.entry-points]` | `click` or `typer` | `black`, `ruff`, `httpie`, `rich` |
| **Framework plugin** | Plugin class, hook registration | `[project.entry-points."framework.plugin"]` | Framework dep | `pytest-*`, `django-*`, `flask-*` |
| **Data processing library** | Classes + functional pipeline | Import API only | Optional: `numpy`, `pandas` | `pydantic`, `marshmallow`, `cerberus` |
| **Mixed / generic** | Combination of above | Varies | Varies | Many real-world packages |

**Decision Rule:** Ask the user if unclear. A package can combine types (e.g., SDK with a CLI
entry point) — use the primary type for structural decisions and add secondary type patterns on top.

For implementation patterns of each type, see `references/library-patterns.md`.

### Package Naming Rules

- PyPI name: all lowercase, hyphens — `my-python-library`
- Python import name: underscores — `my_python_library`
- Check availability: https://pypi.org/search/ before starting
- Avoid shadowing popular packages (verify `pip install <name>` fails first)

---

## 3. Folder Structure Decision

### Decision Tree

```
Does the package have 5+ internal modules OR multiple contributors OR complex sub-packages?
├── YES → Use src/ layout
│         Reason: prevents accidental import of uninstalled code during development;
│         separates source from project root files; PyPA-recommended for large projects.
│
├── NO → Is it a single-module, focused package (e.g., one file + helpers)?
│         ├── YES → Use flat layout
│         └── NO (medium complexity) → Use flat layout, migrate to src/ if it grows
│
└── Is it multiple related packages under one namespace (e.g., myorg.http, myorg.db)?
          └── YES → Use namespace/monorepo layout
```

### Quick Rule Summary

| Situation | Use |
|---|---|
| New project, unknown future size | `src/` layout (safest default) |
| Single-purpose, 1–4 modules | Flat layout |
| Large library, many contributors | `src/` layout |
| Multiple packages in one repo | Namespace / monorepo |
| Migrating old flat project | Keep flat; migrate to `src/` at next major version |

---

## 4. Build Backend Decision

### Decision Tree

```
Does the user need version derived automatically from git tags?
├── YES → Use setuptools + setuptools_scm
│         (git tag v1.0.0 → that IS your release workflow)
│
└── NO → Does the user want an all-in-one tool (deps + build + publish)?
          ├── YES → Use poetry (v2+ supports standard [project] table)
          │
          └── NO → Is the package pure Python with no C extensions?
                    ├── YES, minimal config preferred → Use flit
                    │   (zero config, auto-discovers version from __version__)
                    │
                    └── YES, modern & fast preferred → Use hatchling
                        (zero-config, plugin system, no setup.py needed)

Does the package have C/Cython/Fortran extensions?
└── YES → MUST use setuptools (only backend with full native extension support)
```

### Backend Comparison

| Backend | Version source | Config | C extensions | Best for |
|---|---|---|---|---|
| `setuptools` + `setuptools_scm` | git tags (automatic) | `pyproject.toml` + optional `setup.py` shim | Yes | Projects with git-tag releases; any complexity |
| `hatchling` | manual or plugin | `pyproject.toml` only | No | New pure-Python projects; fast, modern |
| `flit` | `__version__` in `__init__.py` | `pyproject.toml` only | No | Very simple, single-module packages |
| `poetry` | `pyproject.toml` field | `pyproject.toml` only | No | Teams wanting integrated dep management |

For all four complete `pyproject.toml` templates, see `references/pyproject-toml.md`.

---

## 5. PyPA Packaging Flow

This is the canonical end-to-end flow from source code to user install.
**Every step must be understood before publishing.**

```
1. SOURCE TREE
   Your code in version control (git)
   └── pyproject.toml describes metadata + build system

2. BUILD
   python -m build
   └── Produces two artifacts in dist/:
       ├── *.tar.gz   → source distribution (sdist)
       └── *.whl      → built distribution (wheel) — preferred by pip

3. VALIDATE
   twine check dist/*
   └── Checks metadata, README rendering, and PyPI compatibility

4. TEST PUBLISH (first release only)
   twine upload --repository testpypi dist/*
   └── Verify: pip install --index-url https://test.pypi.org/simple/ your-package

5. PUBLISH
   twine upload dist/*          ← manual fallback
   OR GitHub Actions publish.yml  ← recommended (Trusted Publishing / OIDC)

6. USER INSTALL
   pip install your-package
   pip install "your-package[extra]"
```

### Key PyPA Concepts

| Concept | What it means |
|---|---|
| **sdist** | Source distribution — your source + metadata; used when no wheel is available |
| **wheel (.whl)** | Pre-built binary — pip extracts directly into site-packages; no build step |
| **PEP 517/518** | Standard build system interface via `pyproject.toml [build-system]` table |
| **PEP 621** | Standard `[project]` table in `pyproject.toml`; all modern backends support it |
| **PEP 639** | `license` key as SPDX string (e.g., `"MIT"`, `"Apache-2.0"`) — not `{text = "MIT"}` |
| **PEP 561** | `py.typed` empty marker file — tells mypy/IDEs this package ships type information |

For complete CI workflow and publishing setup, see `references/ci-publishing.md`.

---


## 6. Project Structure Templates

The full `src/` layout, flat layout, package-with-CLI, and
compat-module templates with per-file annotations live in
`references/structure-templates.md` — load it when you scaffold files.

## 7. Versioning Strategy

PEP 440 canonical forms, SemVer mapping, dynamic (`setuptools_scm`) vs static versioning, version-specifier best practices for dependencies, and the version-bump → release flow all live in `references/versioning-strategy.md` — load it when the user asks about versioning.

**Two rules worth keeping inline (commonly missed):**

- **`setuptools_scm` CI:** always set `fetch-depth: 0` in every checkout step. Without full git history, tags aren't found and the version silently falls back to `0.0.0+dev`.
- **Library deps:** prefer `"httpx>=0.24"` (minimum). Never pin exactly (`==`) or use `~=` in a library's `[project] dependencies — it breaks downstream resolution.

For complete `pyproject.toml` templates for all four backends, see `references/pyproject-toml.md`.

---

## Where to Go Next

Each decision above points at its reference file in the **Quick Navigation**
table at the top of this skill — load the one you need (e.g.
`references/pyproject-toml.md` for backend config, `references/ci-publishing.md`
for Trusted Publishing, `references/tooling-ruff.md` for lint/format). The
scaffold script generates the full layout in one command:

```bash
python skills/python-pypi-package-builder/scripts/scaffold.py --name your-package-name
```
