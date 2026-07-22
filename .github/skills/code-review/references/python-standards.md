# Python Standards

Reference for `code-review` Branch A — Standards axis, when the change is
Python. This file is the single source of truth for Python quality
conventions: lint/format (ruff), docstrings (NumPyDoc), and the review
checklist below. `code-review` itself stays stack-agnostic; the mechanics
live here.

## Ruff — lint + format

ruff is the single-tool lint + format (replaces `black` / `isort` /
`flake8` / `pydocstyle`). Conventions and the canonical config are owned
here, not by any particular stack skill.

### Config location

The config can live in either:

- `ruff.toml` at the project root, **or**
- the `[tool.ruff]` table inside `pyproject.toml`.

Both are equivalent to ruff; use whichever the project already has and never
hand-roll config from memory. A canonical starting point ships in
`templates/ruff.toml` — read it this turn and write it verbatim (to
`ruff.toml`, or the `[tool.ruff]` table of `pyproject.toml`), no ad-hoc
edits. Verify with `ruff check --show-settings .`.

### Stop conditions

- **Do not configure a PostToolUse / PreToolUse hook for the linter.**
  Manual runs only — hooks stall partial files.
- **Do not silently substitute the tool.** If the project uses ruff, don't
  fall back to `black` / `isort` / `flake8` / `pydocstyle`. If ruff is
  missing, install it via the environment manager.
- **One fix attempt per file, then surface.** Re-apply once; if the same
  issue persists, stop and show diagnostics + diff.
- **Lint only project-owned Python.** Skip vendored, generated, and
  virtual-environment paths.
- **Never write linter config from memory.** Read the bundled template and
  write it verbatim.
- **Don't globally suppress warnings** unless asked.
- **Comments describe the domain problem, not the workflow.** Strip
  skill/gate/runner meta from committed headers (see
  `references/comment-contextualization.md`).

### Post-edit run ("the ruff trio")

For every Python file touched this turn, inside the project's environment
manager, run the three-step sequence below in order. This sequence is
referred to elsewhere in this skill as **"the ruff trio"** — for example
in `references/comment-contextualization.md`, which is the documentation
pass that follows the trio.

```bash
ruff format <files>
ruff check --fix <files>
ruff check <files>
```

1. **Format** — idempotent. 2. **Check --fix** — auto-fix imports, legacy
syntax, bug patterns. 3. **Check** — final pass; apply the one-fix-per-file
rule. If `D100`/`D103` warnings appear for `# %%` notebook cells, the
per-file ignores in the config are not loaded.

### NumPyDoc

Public functions and classes carry NumPyDoc docstrings (`Parameters` /
`Returns`, `Raises` when applicable). See `references/numpydoc.md`.

### Recursive clean-up

When asked to "clean all ruff/lint issues": read
`references/recursive-ruff.md` and run that workflow (baseline → safe fix →
format → unsafe fix → manual → loop until clean/blocked). Use `# noqa` only
when justified and line-scoped. Mention pre-existing warnings so the user can
decide.

## Review checklist (correctness → style)

Priority-ordered rules for Python code quality. Report findings grouped by
severity (Critical / High / Medium).

## Correctness (CRITICAL)

### Mutable Default Arguments
```python
# Wrong
def add_item(item, items=[]):  # BUG: [] shared across calls
    items.append(item)

# Right
def add_item(item: str, items: list[str] | None = None) -> list[str]:
    if items is None:
        items = []
    items.append(item)
    return items
```

### Error Handling
```python
# Wrong
try:
    result = risky_operation()
except:
    pass

# Right
try:
    config = json.loads(config_file.read())
except json.JSONDecodeError as e:
    logger.error(f"Invalid JSON: {e}")
    config = get_default_config()
except FileNotFoundError:
    config = get_default_config()
```

## Type Safety (HIGH)

### Type Hints
```python
# Wrong
def get_user(id):
    return users.get(id)

# Right
def get_user(user_id: int) -> Optional[Dict[str, Any]]:
    return users.get(user_id)
```

### Dataclasses
```python
# Wrong — manual __init__, __repr__, __eq__
class User:
    def __init__(self, id, name, email): ...

# Right
@dataclass
class User:
    id: int
    name: str
    email: str
```

## Performance (HIGH)

### List Comprehensions
```python
# Wrong
squares = []
for x in range(10):
    squares.append(x ** 2)

# Right
squares = [x ** 2 for x in range(10)]
evens = [x for x in range(20) if x % 2 == 0]
```

### Context Managers
```python
# Wrong
f = open('file.txt')
data = f.read()
f.close()

# Right
with open('file.txt') as f:
    data = f.read()
```

## Style (MEDIUM)

### PEP 8
```python
# Wrong
def CalculateTotal(itemPrice,qty):
  return itemPrice*qty

# Right
def calculate_total(item_price: float, quantity: int) -> float:
    return item_price * quantity
```

### Docstrings
```python
def process_user_data(data: Dict[str, Any], config: ProcessConfig) -> ProcessResult:
    """Process user data according to configuration.

    Args:
        data: Raw user data with 'user_id' and 'email' keys.
        config: Processing configuration with transformations and rules.

    Returns:
        ProcessResult with transformed data and validation warnings.

    Raises:
        ValidationError: If required fields are missing.
    """
```
