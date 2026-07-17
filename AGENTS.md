# AGENTS.md

Compact guidance for OpenCode sessions in this repo.

## What this repo is

A versioned catalog of reusable skills and agents, consumed by two tools differently:

- `.github/skills/<name>/SKILL.md` — shared by GitHub Copilot and OpenCode (OpenCode ignores Copilot-only frontmatter fields).
- `.github/agents/*.agent.md` — GitHub Copilot only. OpenCode uses a different schema (`opencode agent create`); never symlink these into OpenCode.
- `.github/instructions/` — referenced explicitly from `opencode.json`.

Install wires `.github/skills` into `~/.config/opencode/skills` via symlink. See `README.md` for the exact commands and the Windows/agent caveats.

## Repo-local tooling

- `graphify-out/` holds a knowledge graph. For codebase questions run `graphify query "<question>"` first (scoped subgraph, smaller than `GRAPH_REPORT.md`). Use `graphify path "<A>" "<B>"` and `graphify explain "<concept>"`. After editing code, run `graphify update .` (AST-only, no API cost).
- A graphify reminder hook is registered in `.opencode/opencode.json` via `.opencode/plugins/graphify.js`. The plugin file is intentionally free of backticks/`$(...)`; do not add them to the reminder string (they trigger shell command substitution in the injected `echo`).
- Graphify rules for agents live in `.github/instructions/graphify.md` (referenced by both OpenCode and GitHub Copilot).

## Maintenance gotchas (these drift and need manual fixes)

- The skill/agent counts and domain tables in `README.md` and `docs/catalog.md` are maintained by hand and go stale after consolidation. Catch drift with:
  ```bash
  comm -23 <(ls .github/skills | sort) <(grep -oE '`[a-z0-9-]+`' docs/catalog.md | tr -d '`' | sort -u)
  echo "skills: $(find .github/skills -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"
  echo "agents: $(find .github/agents -maxdepth 1 -type f | wc -l | tr -d ' ')"
  ```
- When adding/removing skills, also update the README counts, badge, headline, and domain tables.
- Skill provenance is recorded in commit messages. The Superpowers cache (`~/.cache/opencode/.../superpowers/skills`) is NOT canonical here; keep skills only in `.github/skills/`.

## Where to look

- `docs/architecture.md` — how the two tools consume the catalog and skill kinds.
- `docs/install.md`, `docs/use.md`, `docs/maintain.md` — operational detail.
- `docs/catalog.md` — full inventory, provenance, and upstream sources.
