# §6 Project Structure Templates (extracted from SKILL.md)

Load when you actually scaffold a project's files.

## 6. Project Structure Templates

### A. src/ Layout (Recommended default for new projects)

```
your-package/
├── src/
│   └── your_package/
│       ├── __init__.py           # Public API: __all__, __version__
│       ├── py.typed              # PEP 561 marker — EMPTY FILE
│       ├── core.py               # Primary implementation
│       ├── client.py             # (API client type) or remove
│       ├── cli.py                # (CLI type) click/typer commands, or remove
│       ├── config.py             # Settings / configuration dataclass
│       ├── exceptions.py         # Custom exception hierarchy
│       ├── models.py             # Data classes, Pydantic models, TypedDicts
│       ├── utils.py              # Internal helpers (prefix _utils if private)
│       ├── types.py              # Shared type aliases and TypeVars
│       └── backends/             # (Plugin pattern) — remove if not needed
│           ├── __init__.py       # Protocol / ABC interface definition
│           ├── memory.py         # Default zero-dep implementation
│           └── redis.py          # Optional heavy implementation
├── tests/
│   ├── __init__.py
│   ├── conftest.py               # Shared fixtures
│   ├── unit/
│   │   ├── __init__.py
│   │   ├── test_core.py
│   │   ├── test_config.py
│   │   └── test_models.py
│   ├── integration/
│   │   ├── __init__.py
│   │   └── test_backends.py
│   └── e2e/                      # Optional: end-to-end tests
│       └── __init__.py
├── docs/                         # Optional: mkdocs or sphinx
├── scripts/
│   └── scaffold.py
├── .github/
│   ├── workflows/
│   │   ├── ci.yml
│   │   └── publish.yml
│   └── ISSUE_TEMPLATE/
│       ├── bug_report.md
│       └── feature_request.md
├── .pre-commit-config.yaml
├── pyproject.toml
├── CHANGELOG.md
├── CONTRIBUTING.md
├── SECURITY.md
├── LICENSE
├── README.md
└── .gitignore
```

### B. Flat Layout (Small / focused packages)

```
your-package/
├── your_package/         # ← at root, not inside src/
│   ├── __init__.py
│   ├── py.typed
│   └── ... (same internal structure)
├── tests/
└── ... (same top-level files)
```

### C. Namespace / Monorepo Layout (Multiple related packages)

```
your-org/
├── packages/
│   ├── your-org-core/
│   │   ├── src/your_org/core/
│   │   └── pyproject.toml
│   ├── your-org-http/
│   │   ├── src/your_org/http/
│   │   └── pyproject.toml
│   └── your-org-cli/
│       ├── src/your_org/cli/
│       └── pyproject.toml
├── .github/workflows/
└── README.md
```

Each sub-package has its own `pyproject.toml`. They share the `your_org` namespace via PEP 420
implicit namespace packages (no `__init__.py` in the namespace root).

### Internal Module Guidelines

| File | Purpose | When to include |
|---|---|---|
| `__init__.py` | Public API surface; re-exports; `__version__` | Always |
| `py.typed` | PEP 561 typed-package marker (empty) | Always |
| `core.py` | Primary class / main logic | Always |
| `config.py` | Settings dataclass or Pydantic model | When configurable |
| `exceptions.py` | Exception hierarchy (`YourBaseError` → specifics) | Always |
| `models.py` | Data models / DTOs / TypedDicts | When data-heavy |
| `utils.py` | Internal helpers (not part of public API) | As needed |
| `types.py` | Shared `TypeVar`, `TypeAlias`, `Protocol` definitions | When complex typing |
| `cli.py` | CLI entry points (click/typer) | CLI type only |
| `backends/` | Plugin/strategy pattern | When swappable implementations |
| `_compat.py` | Python version compatibility shims | When 3.9–3.13 compat needed |

---
