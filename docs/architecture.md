# Catalog architecture

This document explains how the catalog is organized, how GitHub Copilot and OpenCode consume it, and how the different kinds of skills relate to each other.

## Why one repo for two tools

Both GitHub Copilot and OpenCode can read the same skill definitions. Keeping one source of truth avoids divergence and makes maintenance easier. The tradeoff is that some files are tool-specific:

| File type | Shared? | Notes |
|---|---|---|
| `.github/skills/<name>/SKILL.md` | Yes | Copilot fields are ignored by OpenCode |
| `.github/instructions/*.md` | Mostly | Paths differ; OpenCode config references them explicitly |

## Skill layout

Each skill is a directory:

```text
.github/skills/<skill-name>/
  SKILL.md           # required skill definition
  scripts/           # optional helper scripts
  references/        # optional reference material
  assets/            # optional images or attachments
```

`SKILL.md` contains the skill instructions and frontmatter. GitHub Copilot uses fields like `description` and `allowed-tools`. OpenCode reads `name` and `description` and ignores the rest, so the same file works in both tools.

## Skill kinds

The catalog contains three kinds of skills:

1. **User-invoked routers** — called directly by name, dispatch the user to the right leaf skill. A router earns its place only when it points at *user-invoked* leaf skills (which the agent can't auto-discover). The catalog currently has a small number of user-invoked/branching skills; former routers such as `planning`, `docs`, `duckdb`, and `frontend` were retired or consolidated (as was `grill-me`, which dispatched to `grilling`).
2. **Model-invoked skills** — triggered automatically by matching requests, often based on `description` frontmatter. Examples: `refactor`, `code-review`, `data-access`.
3. **Orchestrators/branch routers** — skills that do light routing or coordination and then hand off to references/subskills (for example `git-workflow`, `data-access`, `internal-writing`, `ui-screenshots`).

Most skills are leaf skills: they execute the task themselves.

## The OpenCode difference

OpenCode treats skills, agents, and instructions as separate discovery types:

- Skills are discovered from `~/.config/opencode/skills/`, `.opencode/skills/`, `.claude/skills/`, and `.agents/skills/`.
- Agents use a `description`, `mode`, `model`, `permission`, and `prompt` frontmatter. This catalog does not define agents; create them individually with `opencode agent create` if needed.
- Instructions are referenced from `~/.config/opencode/opencode.json`.

Because of these differences, only the skills directory is symlinked directly from this repo into OpenCode, and instructions must be referenced by path.

## Catalog maintenance considerations

- Keep the README inventory accurate. Counts and domain tables are manual.
- Prefer upstream skills that follow the standard `skills/<name>/SKILL.md` layout.
- Avoid duplicating skills from the Superpowers cache into `.github/skills/`.
- When a skill exists in multiple upstream sources, keep the version that best matches your team's conventions.

## Tracker fallback (local vs hosted)

- When no tracker is configured, tickets live as local files at `.scratch/<feature-slug>/issues/<NN>-<slug>.md`; otherwise use native blocking with `ready-for-agent`.
- See `.github/instructions/issue-tracker.instructions.md` for per-tracker bindings.
