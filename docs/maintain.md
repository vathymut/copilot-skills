# Maintain the catalog

This guide covers the routine tasks for keeping the skill and agent catalog useful and up to date.

## Add a skill manually

Create a directory and add a `SKILL.md`:

```bash
mkdir -p .github/skills/<skill-name>
```

Add optional subdirectories as needed:

```text
.github/skills/<skill-name>/
  SKILL.md
  scripts/       # helper scripts invoked by the skill
  references/    # reference files the skill can read
  assets/        # images or other assets
```

Follow the conventions in `writing-great-skills` when authoring new skills.

## Add an agent

Add a file under `.github/agents/<name>.agent.md`. Use the frontmatter schema expected by GitHub Copilot:

```yaml
---
name: <name>
description: <short description>
tools: []
---
```

Do not symlink this file into OpenCode. OpenCode agents use a different frontmatter schema. See [Install the catalog](./install.md) for how to create OpenCode agents.

## Remove a skill

Delete the skill directory:

```bash
rm -rf .github/skills/<skill-name>
```

Then update the README:

1. Recount the skills using `find .github/skills -mindepth 1 -maxdepth 1 -type d | wc -l`.
2. Update the skills badge and headline count in `README.md`.
3. Remove the skill from the relevant domain table in `README.md`.

> [!TIP]
> Remove skills you no longer use. A smaller catalog is easier to navigate and faster to load.

## Sync skills from upstream

When refreshing from upstream repositories:

1. Pull only the skills you actively need.
2. Review diffs carefully before committing.
3. Record the source in your commit message for provenance.
4. Resolve duplicate copies. The Superpowers cache at `~/.cache/opencode/packages/.../superpowers/skills` is not canonical for this repo. Keep skills in `.github/skills/` only.

> [!IMPORTANT]
> If a skill exists in multiple upstream sources, compare content before overwriting any local customizations.

## Audit the catalog

Periodically review the catalog for:

- Unused or obsolete skills
- Duplicate content across upstream sources
- Incorrect skill counts in `README.md`
- Broken symlinks in `~/.copilot` or `~/.config/opencode`

After any audit that changes the catalog, update the README inventory, badges, and domain tables.

### Detect drift automatically

The catalog tables and counts in `README.md` and `docs/catalog.md` are maintained by hand and drift after consolidation. Run this to catch mismatches between the filesystem and the catalog:

```bash
# Skills present on disk but missing from the catalog tables
comm -23 \
  <(ls .github/skills | sort) \
  <(grep -oE '`[a-z0-9-]+`' docs/catalog.md | tr -d '`' | sort -u)

# Counts (should match README and catalog "Counts")
echo "skills: $(find .github/skills -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"
echo "agents: $(find .github/agents -maxdepth 1 -type f | wc -l | tr -d ' ')"
```

If either list is non-empty, add or remove rows in `docs/catalog.md` and update the counts in both `docs/catalog.md` and `README.md`.

## Upstream sources

| Source | Notes |
|---|---|
| `github/awesome-copilot` | Primary source for general-purpose skills |
| `anthropics/skills` | Claude-oriented patterns and workflows |
| `obra/superpowers` | Specialized agent and agentic workflow skills |
| `wshobson/agents` | Domain-focused agent definitions |
| `davila7/claude-code-templates` | Code-focused templates |
| `Shubhamsaboo/awesome-llm-apps` | LLM application patterns |
| `agno-agi/agno` | Agno framework skills |
| `openai/openai-agents-python` | OpenAI agents SDK patterns |
| `probabl-ai/skills` | ML experimentation and PyData workflow skills |
| `vercel/next.js` | Frontend and full-stack patterns |
| `DietrichGebert/ponytail` | YAGNI-first lazy senior dev philosophy and over-engineering review |
| `duckdb/duckdb-skills` | DuckDB-powered data skills |
| `mattpocock/skills` | Skill-writing principles and reference vocabulary |
| `zarazhangrui/frontend-slides` | HTML presentation creation and PPT conversion |
| `caylent/tufte-data-viz` | Edward Tufte's data visualization principles for clean charts |
