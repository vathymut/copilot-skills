---
name: python-api
description: Use when a Python symbol's signature, docstring, or behaviour against the installed version is needed — before writing code, debugging a KeyError/AttributeError, or resolving a version-specific rename.
---

## When NOT to use

- Need to choose between competing libraries (plotting, serving, tabular DL) — use `python-stack-env`.
- Need to read/query data files — use `data-access`.
- Import just failed — use `python-stack-env` to install; return here after.

## Entry table — question → shape → next step

Pick shape by question type. Wrong shape burns a turn.

| Question | Shape | After lookup |
|---|---|---|
| Check cache first (`ls scratch/api/<lib>/<version>/`) | **0** cache hit | read file, done |
| "Which entry point for <task>?" | Stack orientation → Shape 1/1b | continue caller flow |
| "Signature of X?" / "Args / return type?" | **1b** LSP hover → **1** if sparse | continue caller flow |
| "What does X do?" / full docstring | **1** symbol card (pydoc) | cache lands |
| "What's in module Y?" | **2** module surface | cache lands |
| "Search symbols matching `foo*`" | **2b** LSP workspace symbol | ad-hoc |
| "How does X work?" / "Which of A or B?" / "What does X return when arg=V?" | **3** narrative (WebFetch) | cache lands |

Shape 1b (fast, type sig + first paragraph) → Shape 1 (full pydoc) fallthrough. Shape 3 when question depends on a *condition* over an argument. LSP shapes (1b/2b) require pyright + `pyrightconfig.json`; see `python-stack-env` § Agent feature. LSP footguns: `references/shape1b_lsp_setup.md`.

## Stop conditions — read before any lookup

- **No symbols from memory.** Every symbol must come from a lookup *this turn* — cache file, probe, or WebFetch. Recognition does not count. Named traps: `references/named_traps.md`.
- **All Python execution goes to `scratch/<ts>_<short>.py`.** See `ml-conventions:references/shared-ml-conventions.md` § All Python execution goes to scratch/ (don't duplicate that contract here).
- **A probe without a cache write is not a completed lookup.** Turn must produce `scratch/api/<lib>/<version>/<topic>.md` on disk. Inline `inspect.signature` / `pydoc.render_doc` / `help()` does NOT satisfy "python-api consulted".
- **`pydoc.render_doc`, not `__doc__`.** `__doc__` is empty/misleading on properties, descriptors, and decorated callables.
- **Never fabricate probe results.** Blank or `<pending>` until executed. Shape 3: verbatim extracts only, no paraphrase.
- **Version-correct first.** Resolve `<pkg>.__version__` before any lookup. Version subfolder is the cache freshness key.
- **Cache hit before fresh fetch.** List `scratch/api/<lib>/<version>/` before Shape 1/2/3.
- **Lookup failure ≠ artifact missing.** `KeyError` on registry APIs (`project.get(key)`) is usually wrong lookup shape (id vs key). Never re-create the artifact.

## First action

1. Resolve version via `scratch/<ts>_version_<pkg>.py` (inline `-c` forbidden).
2. List cache: `ls scratch/api/<lib>/<version>/`.
3. Cache hit → read file, done.
4. Cache miss → classify question (entry table above) → run Shape.
5. Emit pre-flight.

## Pre-flight

Shared gates → `ml-conventions:references/shared-preflight-evidence.md` (don't duplicate that contract here).

```
Pre-flight (python-api):
- [ ] Package version resolved: <lib> <version>
      Evidence: Write + run scratch/<ts>_version_<lib>.py
- [ ] Cache listed (Shape 0): ls scratch/api/<lib>/<version>/
- [ ] Shape classified: signature | module surface | narrative
- [ ] Lookup decision: cache hit | Shape 1 | 1b | 2 | 2b | 3
- [ ] Cache file on disk: scratch/api/<lib>/<version>/<topic>.md
- [ ] Plus shared gates; re-emit with evidence before final message.
```

## Shapes (lookup procedure)

Per-shape probe templates (Shape 0–3) live in `references/four-shapes.md`; probe code snippets: `references/probe_templates.md`. Load them when you reach a lookup.

## Cache file contract

Format: `# <topic>` header, `Source:` line, `Probed:` date, `## Signature` (Shape 1), `## help()` / `## Docs extract` (verbatim), `## Usage` (Call / Don't call / Trap / Returns). Version subfolder = `<pkg>.__version__` exactly. Gitignored. Bootstrap turns → `references/bootstrap_cache.md`. New-reference authoring: `references/authoring_protocol.md`.

## Stack orientation

Tier-1 named entry points per library: `references/stack_orientation.md`. Consult before Shape 2. Interop notes (SkrubLearner + skore.evaluate, DataOps history pattern): `references/skrub_interop.md`, `references/pre_mark_alignment.md`.


## Related skills

- `python-stack-env` — install + env before lookup.
- `build-ml-pipeline` / `evaluate-ml-pipeline` — verify estimators via this skill.

## Completion criteria

- [ ] Version resolved and cache listed (Shape 0)
- [ ] Probe executed and cache file written to `scratch/api/<lib>/<version>/<topic>.md`
- [ ] No symbol from memory — every name backed by lookup this turn
