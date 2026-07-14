# Catalog architecture

This document explains how the catalog is organized, how GitHub Copilot and OpenCode consume it, and how the different kinds of skills relate to each other.

## Why one repo for two tools

Both GitHub Copilot and OpenCode can read the same skill definitions. Keeping one source of truth avoids divergence and makes maintenance easier. The tradeoff is that some files are tool-specific:

| File type | Shared? | Notes |
|---|---|---|
| `.github/skills/<name>/SKILL.md` | Yes | Copilot fields are ignored by OpenCode |
| `.github/agents/*.agent.md` | No | Copilot only. OpenCode uses a different schema |
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

1. **User-invoked routers** — called directly by name, dispatch the user to the right leaf skill. Examples: `docs`, `duckdb`, `git-workflow`, `media`, `memory`, `planning`, `visualization`.
2. **Model-invoked skills** — triggered automatically by matching requests, often based on `description` frontmatter. Examples: `systematic-debugging`, `test-driven-development`.
3. **Orchestrators** — model-invoked skills that do light work and then hand off to a subskill. Example: `iterate-ml-experiment` dispatches to `evaluate-ml-pipeline` for the audit stage.

Most skills are leaf skills: they are invoked by name and execute the task themselves.

## Agent layout

Agents live under `.github/agents/` as `.agent.md` files:

```text
.github/agents/
  debug.agent.md
  janitor.agent.md
  swe-subagent.agent.md
```

These files define personas, tools, and goals for autonomous Copilot Chat agents. They are not shared with OpenCode because the frontmatter schemas are incompatible.

## The OpenCode difference

OpenCode treats skills, agents, and instructions as separate discovery types:

- Skills are discovered from `~/.config/opencode/skills/`, `.opencode/skills/`, `.claude/skills/`, and `.agents/skills/`.
- Agents use a `description`, `mode`, `model`, `permission`, and `prompt` frontmatter.
- Instructions are referenced from `~/.config/opencode/opencode.json`.

Because of these differences, only the skills directory is symlinked directly from this repo into OpenCode. Agents must be recreated in OpenCode format, and instructions must be referenced by path.

## Catalog maintenance considerations

- Keep the README inventory accurate. Counts and domain tables are manual.
- Prefer upstream skills that follow the standard `skills/<name>/SKILL.md` layout.
- Avoid duplicating skills from the Superpowers cache into `.github/skills/`.
- When a skill exists in multiple upstream sources, keep the version that best matches your team's conventions.
