---
name: python-api
description: Use when you need a Python symbol's signature, docstring, or behaviour against the installed version — before writing code, debugging a KeyError/AttributeError, or resolving a version-specific rename.
---

## Next-step pointers

| Came here for… | After lookup, next is… |
|---|---|
| Symbol signature for code about to be written | → continue caller's flow (e.g. `build-ml-pipeline` § next step) |
| "Which library / which entry?" | → continue with the picked symbol; cache lands |
| Bootstrap turn (first workspace) | → required minimum cache lands; see `references/bootstrap_cache.md` |
| Failure debugging (KeyError / AttributeError) | → see Stop condition "Lookup failure ≠ artifact missing" |

## What kind of question? → Shape

Pick the shape **by question type** before picking a tool. Wrong
shape produces a wrong-looking cache file and burns a turn.

| The user's question is shaped like… | Shape |
|---|---|
| "What's in `scratch/api/<lib>/<version>/`?" (always check first) | **0** cache hit |
| "Which entry point for &lt;task&gt;?" | **Stack orientation** below, then Shape 1 / 1b to confirm |
| "What's the signature of X?" / "What args does X take?" / "What's the return type?" | **1b** LSP hover (fast) → fall through to **1** if hover is sparse |
| "What does X do?" / "Full docstring of X?" (need Parameters / Examples / See Also) | **1** symbol card (pydoc) |
| "What's in module Y?" (open-ended discovery) | **2** module surface |
| "Search for symbols matching `foo*` across the env" | **2b** LSP workspace symbol |
| "How does X work?" / "Which of A or B should I use?" | **3** narrative |
| **"What does X return when `<arg>` is `<value>`?"** | **3** narrative |
| "What's the recommended pattern for …?" | **3** narrative |

**Shape 3 is the right answer when the question depends on a
*condition* over an argument.** `help()` carries a `Returns`
section but typically does not enumerate dispatch behaviour under
each argument value — that lives in narrative docs.

**Shape 1b vs Shape 1.** Pyright hover gives the type signature
(richer inferred return types than `inspect.signature`) + the first
paragraph of the docstring — fast, no Python execution. Pydoc gives
the **full** docstring with all sections — slower but authoritative.
Default escalation: 1b first for "what's the signature"; fall
through to 1 if hover is empty / one-liner.

**Prerequisites for Shape 1b / 2b (LSP shapes).** Pyright available
via opencode LSP AND `pyrightconfig.json` pointing at the `lsp` env.
If either is missing, LSP shapes are unavailable — use Shape 1 / 2
directly. The `agent feature: installed` row in `JOURNAL.md`
Status `Workspace decisions` is the precondition; see
`python-env-manager` § Agent feature.

## Stop conditions — read before any lookup

- **No symbols from memory.** Every function / class / method / arg
  must come from a lookup *this turn* — `inspect.signature`, a
  `scratch/api/<lib>/<version>/` file, or a fresh WebFetch.
  Recognition does not count. Sticky named cases — full list in
  `references/named_traps.md`:
  - skrub: `tabular_learner` → `tabular_pipeline` in 0.7+.
  - skrub: `mark_as_y(target_column)` → signature dropped the
    positional arg in 0.9+; use `.skb.select("...")` before mark.
  - skore: `Project.get(...)` is by **id**, not user-facing `key`;
    enumerate via `project.summarize()` first.
- **Never fabricate a probe result.** If the probe hasn't executed,
  the `Signature` / `help()` sections must remain blank or marked
  `<pending probe execution>`. Same rule for Shape 3: do not
  paraphrase docs from memory; cache file holds verbatim extracts.
- **Version-correct first.** Resolve `<pkg>.__version__` before any
  lookup. The version subfolder is the cache freshness key.
- **Cache hit before fresh fetch.** List
  `scratch/api/<lib>/<version>/` before Shape 1 / 2 / 3.
- **Lookup failure ≠ artifact missing.** A `KeyError` /
  `AttributeError` on a registry-style API (`project.get(key)`,
  `getattr(obj, name)`, `dict[key]`) is almost always the **lookup
  shape** (id vs key, wrong accessor) — not a missing artifact.
  Named instance: `skore.Project.get(...)` resolves by **id**, not
  by user-facing `key`; `project.summarize()` enumerates
  `(key, id)` pairs. **Never substitute by re-creating the
  artifact** — that lands a duplicate row.
- **All Python execution goes to
  `scratch/<YYYY-MM-DD>_<HHMMSS>_<short>.py`. No exceptions.**
  Every Python command — `<env-prefix> python -c` (whatever
  env-manager `python-env-manager` detected for this project — e.g.
  `pixi run python -c`, `uv run python -c`, `poetry run python -c`,
  `hatch run python -c`, `conda run -n <project> python -c`,
  `.venv/bin/python -c`), `python -c`, heredoc-style
  `python << 'EOF'`, or any inline Python — is forbidden,
  regardless of length. Write to scratch first, then execute via
  `<env-prefix> python scratch/<ts>_<short>.py`. Applies to
  version checks, import smokes, signature lookups, module surface
  dumps, docstring extraction, anything. If you catch yourself
  typing `<env-prefix> python -c` for any manager — STOP and
  write the file.
- **`inspect.signature` / `dir(...)` / `pydoc.render_doc` /
  `help(...)` executed inline is NOT a python-api consultation.**
  These are the exact APIs this skill wraps. Running them via
  `python -c` does NOT satisfy the "python-api consulted"
  pre-flight row in sibling skills. The deliverable is a
  `scratch/api/<lib>/<version>/<topic>.md` file written this turn.
- **`pydoc.render_doc`, not `__doc__`.** `__doc__` is empty /
  misleading on properties, descriptors, decorated callables, and
  accessors — exactly the cases the cache disambiguates.
- **Narrative findings get cached.** A WebFetch result read and
  discarded is forbidden. Land it in
  `scratch/api/<lib>/<version>/<topic>.md` with the source URL on
  the first line.
- **A probe without a cache write is not a completed lookup.**
  Probe records the *investigation*; cache file records the
  *conclusion*. Turn end without
  `scratch/api/<lib>/<version>/<topic>.md` on disk = incomplete.

## First action — every turn that triggers this skill

1. **Resolve the version.** Write
   `scratch/<YYYY-MM-DD>_<HHMMSS>_version_<pkg>.py` with
   `import <pkg>; print(<pkg>.__version__)`, run via
   `<env-prefix> python scratch/<ts>_version_<pkg>.py` (the
   prefix `python-env-manager` detected for this project). **No
   inline `python -c` or `<env-prefix> python -c`.**
2. **List the cache:** `ls scratch/api/<lib>/<version>/`.
3. **Cache hit?** Read the matching file. Done.
4. **Cache miss?** Classify the question (table above) → run Shape
   1 / 1b / 2 / 2b / 3.
5. **Emit the pre-flight checklist** with each box marked.

## Pre-flight — emit before any lookup

```
Pre-flight (python-api):
- [ ] Package version resolved this turn: <lib> <version>
      Evidence: Write scratch/<ts>_version_<lib>.py (this turn) +
                `<env-prefix> python scratch/<ts>_version_<lib>.py` output
                (the prefix `python-env-manager` detected for this project).
                **Inline `<env-prefix> python -c "..."` is NOT evidence.**
- [ ] Cache listed this turn (Shape 0): `ls scratch/api/<lib>/<version>/`
      Evidence: tool output (paste the listing, even if empty)
- [ ] Question shape classified: signature | module surface | narrative
      Evidence: name the shape + one phrase from the question
- [ ] Lookup decision: cache hit (Read <file>) | Shape 1 | 1b | 2 | 2b | 3
      Evidence: name the file Read, probe script written, LSP
                operation requested, or URL fetched
- [ ] (Shape 1b / 2b only) LSP preconditions confirmed:
      `agent feature: installed` in JOURNAL.md AND
      `pyrightconfig.json` at project root pointing at the `lsp` env
      Evidence: Read journal/JOURNAL.md + Read pyrightconfig.json
                (this turn) | "n/a — not an LSP shape"
- [ ] Cache file lands on disk before turn end
      Evidence: Write scratch/api/<lib>/<version>/<topic>.md (this turn)
                | "n/a — cache hit, already on disk + Read this turn"
                | "n/a — Shape 2b ad-hoc discovery"
      **Inline `inspect.signature(...)` / `dir(...)` / `pydoc.render_doc(...)`
      WITHOUT a corresponding cache file is NOT evidence. Re-do as Shape 1.**
- [ ] If Shape 1 / 1b: Usage section filled in (Call / Don't call / Trap / Returns)
      Evidence: Edit scratch/api/<lib>/<version>/<topic>.md (this turn)
                | "n/a — cache hit / Shape 2 / 2b / 3"
- [ ] Pre-flight re-emitted with evidence before final message.
      Evidence: this checklist appears in the end-of-turn summary.
```

## The four shapes (lookup procedure)

The actual probe templates and per-shape steps — Shape 0 (cache hit),
Shape 1/1b (symbol card), Shape 2/2b (doc/usage), Shape 3 (source
verbatim) — live in `references/four-shapes.md`. Load it when you reach a
lookup; the question→shape mapping at the top of this skill tells you
which one to use.

## Cache file contract

Every cache file follows: `# <topic>` header, `Source:` line (inspect ref or docs URL), `Probed:` date, `## Signature` (Shape 1 only), `## help()` / `## Docs extract` / `## LSP hover` (verbatim, never paraphrase), `## Usage` (Call / Don't call / Trap / Returns). Bootstrap turns → `references/bootstrap_cache.md`.

**Version subfolder == `<pkg>.__version__` exactly** (`0.18.0` ≠ `0.18`). First line is the source URL or `inspect:` ref. Gitignored. Append-on-success; replace only on version bump. Shape 0 reads by version — stale subfolder content is invisible.

## Stack orientation — where things live

Tier-1 named entry points. Consult **before** a Shape 2 surface dump. → `references/stack_orientation.md` for full per-library surface map (sklearn / skrub / skore).

## References (load on demand)

- `references/probe_templates.md` — Shape 1 / 1b / 2 probe code
- `references/shape1b_lsp_setup.md` — Step 0 availability, footguns
- `references/stack_orientation.md` — per-library surface map
- `references/pre_mark_alignment.md` — skrub DataOps history pattern
- `references/skrub_interop.md` — SkrubLearner + skore.evaluate
- `references/bootstrap_cache.md` — required minimum cache for bootstrap turns
- `references/named_traps.md` — version-specific renames / deprecations
- `references/authoring_protocol.md` — new reference doc authoring (user-gated)
