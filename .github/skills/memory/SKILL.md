---
name: memory
description: Use when the user wants to save a lesson or decision for future sessions, or recall prior decisions and context from past session logs.
disable-model-invocation: true
allowed-tools: Bash
argument-hint: "write [>domain [scope]] <lesson> | read <keyword> [--here]"
---

# Memory

Persist lessons learned across sessions (write) and recall prior decisions from
session logs (read). Two branches; pick by the request.

## Branch: write

Store domain-organized memory instructions that persist across sessions.

### Syntax

```
/memory write [>domain-name [scope]] lesson content
```

- `>domain-name` — optional domain target (e.g., `>clojure`)
- `scope` — `global` (default) or `workspace`/`ws`
- `lesson content` — the lesson to remember

Examples:
- `/memory write >clojure prefer passing maps over parameter lists`
- `/memory write workspace use uv for this repo`

### Targets

| Scope | Location | Applies to |
|---|---|---|
| Global | `<global-prompts>/*.instructions.md` | all projects |
| Workspace | `<workspace-root>/.github/instructions/*.instructions.md` | current project only |

Domain-specific files are named `{domain}-memory.instructions.md`. Universal lessons go in `memory.instructions.md`.

### Process

1. Parse domain and scope.
2. Read existing memory files in the target scope.
3. Categorize the lesson: gotcha, best practice, workflow, style decision.
4. Update or create the target memory file: `description` and `applyTo` frontmatter, one `##` heading per distinct lesson, succinct actionable text with code examples when useful.
5. Avoid redundant entries.

**Completion criteria:** memory file updated/created; no redundant entries; instructions scannable and actionable.

## Branch: read

Search past session logs silently — do NOT narrate the process. Absorb the
results and continue with enriched context.

`$0` is the keyword. Pass `--here` as `$1` to scope to the current project only.

### Step 1 — Query

```bash
duckdb :memory: -c "
SELECT
  regexp_extract(filename, 'projects/([^/]+)/', 1) AS project,
  strftime(timestamp::TIMESTAMPTZ, '%Y-%m-%d %H:%M') AS ts,
  message.role AS role,
  left(message.content::VARCHAR, 500) AS content
FROM read_ndjson('<SEARCH_PATH>', auto_detect=true, ignore_errors=true, filename=true)
WHERE message::VARCHAR ILIKE '%<KEYWORD>%'
  AND message.role IS NOT NULL
ORDER BY timestamp
LIMIT 40;
"
```

Search paths:
- All projects: `$HOME/.claude/projects/*/*.jsonl`
- Current only (`--here`): `$HOME/.claude/projects/$(echo "$PWD" | sed 's|[/_]|-|g')/*.jsonl`

Replace `<SEARCH_PATH>` and `<KEYWORD>` before running.

### Step 2 — Internalize

From the results, extract decisions, patterns, unresolved TODOs, and user
corrections. Use this to inform your current response — do not repeat raw logs
to the user.
