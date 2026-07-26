# AGENTS.md

Compact guidance for OpenCode sessions in this repo.

## What this repo is

A versioned catalog of reusable skills and agents, consumed by two tools differently:

- `.github/skills/<name>/SKILL.md` — shared by GitHub Copilot and OpenCode (OpenCode ignores Copilot-only frontmatter fields).
- `.github/agents/*.agent.md` — GitHub Copilot only. OpenCode uses a different schema (`opencode agent create`); never symlink these into OpenCode.
- `.github/instructions/` — referenced explicitly from `opencode.json`.

Install wires `.github/skills` into `~/.config/opencode/skills` via symlink. See `README.md` for the exact commands and the Windows/agent caveats.

## Maintenance gotchas (these drift and need manual fixes)

- The skill/agent counts and domain tables in `README.md` and `docs/catalog.md` are maintained by hand and go stale after consolidation. Catch drift with:
  ```bash
  comm -23 <(ls .github/skills | sort) <(grep -oE '`[a-z0-9-]+`' docs/catalog.md | tr -d '`' | sort -u)
  echo "skills: $(find .github/skills -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"
  echo "agents: $(find .github/agents -maxdepth 1 -type f | wc -l | tr -d ' ')"
  ```
- When adding/removing skills, also update the README counts, headline, and domain tables.
- Skill provenance is recorded in commit messages. The Superpowers cache (`~/.cache/opencode/.../superpowers/skills`) is NOT canonical here; keep skills only in `.github/skills/`.

## Where to look

- `docs/architecture.md` — how the two tools consume the catalog and skill kinds.
- `docs/install.md`, `docs/use.md`, `docs/maintain.md` — operational detail.
- `docs/catalog.md` — full inventory, provenance, and upstream sources.

## MCP Tools: code-review-graph

**IMPORTANT: This project has a knowledge graph. ALWAYS use the
code-review-graph MCP tools BEFORE using Grep/Glob/Read to explore
the codebase.** The graph is faster, cheaper (fewer tokens), and gives
you structural context (callers, dependents, test coverage) that file
scanning cannot.

### When to use graph tools FIRST

- **Exploring code**: `semantic_search_nodes_tool` or `query_graph_tool` instead of Grep
- **Understanding impact**: `get_impact_radius_tool` instead of manually tracing imports
- **Code review**: `detect_changes_tool` + `get_review_context_tool` instead of reading entire files
- **Finding relationships**: `query_graph_tool` with callers_of/callees_of/imports_of/tests_for
- **Architecture questions**: `get_architecture_overview_tool` + `list_communities_tool`

Fall back to Grep/Glob/Read **only** when the graph doesn't cover what you need.

### Key Tools

| Tool | Use when |
| ------ | ---------- |
| `detect_changes_tool` | Reviewing code changes — gives risk-scored analysis |
| `get_review_context_tool` | Need source snippets for review — token-efficient |
| `get_impact_radius_tool` | Understanding blast radius of a change |
| `get_affected_flows_tool` | Finding which execution paths are impacted |
| `query_graph_tool` | Tracing callers, callees, imports, tests, dependencies |
| `semantic_search_nodes_tool` | Finding functions/classes by name or keyword |
| `get_architecture_overview_tool` | Understanding high-level codebase structure |
| `refactor_tool` | Planning renames, finding dead code |

### Workflow

1. The graph auto-updates on file changes (via hooks).
2. Use `detect_changes_tool` for code review.
3. Use `get_affected_flows_tool` to understand impact.
4. Use `query_graph_tool` pattern="tests_for" to check coverage.
