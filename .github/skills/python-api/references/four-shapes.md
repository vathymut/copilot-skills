## The four shapes

### Shape 0 — cache hit

```bash
ls scratch/api/<lib>/<version>/ 2>/dev/null
```

Topic-matching file present → `Read` it. First line carries the
source URL or `inspect:` ref; re-verify against live docs if a file
looks suspicious. Cache miss → Shape 1 / 2 / 3.

### Shape 1 — symbol card (pydoc → cache file)

One probe script does both: introspects the symbol AND writes the
cache file in a single execution. Small follow-up `Edit` fills the
`Usage` bullets (Call / Don't call / Trap / Returns).

Probe template: → `references/probe_templates.md` § Shape 1.

**Multi-symbol consolidation.** Several symbols sharing a topic
(e.g. `Project.put` / `Project.get` / `Project.summarize` under
`project_local`) → iterate over a tuple of dotted paths inside the
probe and concatenate sections into one `<topic>.md`. **One topic
file per *topic*, not per symbol.**

**No inline carve-out for single-signature checks.** Even when a
cache exists and you want to re-confirm one arg, run a fresh probe
(or Read the existing cache).

### Shape 1b — LSP hover (no Python execution)

Pyright via opencode LSP returns type signature + first docstring
paragraph at a `file:line:character` position. **First stop for
"what's the signature"** when available; fall through to Shape 1
if hover is sparse.

**Step 0 — probe LSP availability** (mandatory, once per session).
LSP reads `pyrightconfig.json` once at startup — mid-session edits
don't reload. If every external import shows `Unknown`, Shape 1b is
unavailable this session → use Shape 1. Full probe procedure +
footguns → `references/shape1b_lsp_setup.md`.

**After availability confirmed:** write probe file (under `tests/` or
`src/<pkg>/`, not `scratch/`), call `lsp(operation="hover", ...)`,
cache result. Template → `references/probe_templates.md` § Shape 1b.
Escalate to Shape 1 if hover is empty / one-liner.

### Shape 2 — module surface

Scratch probe that dumps both top-level surface and submodule list,
then writes `surface.md` directly. No inline `python -c`.

Probe template: → `references/probe_templates.md` § Shape 2.

One topic per file. Replace only on a version bump.

### Shape 2b — LSP workspace symbol (cross-package search)

Given a query string, return all matching symbols across the `lsp`
env's site-packages. Use for discovery before committing to a
dotted path; faster than `dir()` on every candidate module.

```
lsp(
    operation="workspaceSymbol",
    filePath="<any-existing-Python-file>",
    line=1, character=1,
    query="<symbol substring>",
)
```

(`filePath`/`line`/`character` are ignored by pyright for
`workspaceSymbol`; only used to select the LSP server.)

Return: list of `(name, kind, location)` tuples. NOT a Shape-2
replacement (doesn't enumerate a full module surface). Use as a
**discovery aid** before running Shape 1 / Shape 2 on the right
dotted path. Cache only if the search becomes recurring.

### Shape 3 — narrative

Conceptual questions where the signature alone doesn't answer it —
"how does X work?", "which of A/B should I use?", "what does X
return when `<arg>` is `<value>`?". Procedure:

1. **WebSearch** for the versioned docs URL. Query:
   `<library> <MAJOR.MINOR> docs <topic>`. Don't construct URLs
   from memory.
2. **WebFetch** the most relevant result whose URL contains the
   installed version (`/0.18/`, `/0.18.0/`). **Reject** any URL
   with `/latest/` or `/stable/` — those drift on republish.
3. **Cache verbatim** to `scratch/api/<lib>/<version>/<topic>.md`:

   ```markdown
   # <topic>

   Source: <full URL>
   Fetched: <YYYY-MM-DD>

   <paste salient sections verbatim — do NOT paraphrase from
   memory. Skip nav chrome; keep prose that answers the question.>
   ```

Cache filename: snake_case mirror of the docs URL slug. One topic
per file. Replace only on version bump.

