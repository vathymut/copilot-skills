# copilot-skills

> A curated, versioned local catalog of reusable skills and agents for GitHub Copilot Chat.

[![Skills](https://img.shields.io/badge/skills-30-blue?style=flat-square)](./.github/skills/)
[![Agents](https://img.shields.io/badge/agents-9-purple?style=flat-square)](./.github/agents/)

This repository is a practical, versioned workspace for curating the prompts, references, scripts, and agent definitions you actually use — distilled from multiple upstream sources into a lean, task-focused catalog.

`README.md` is the source of truth for the live catalog inventory. Use `SKILL-OVERLAP-REPORT.md` for pruning status and historical round summaries.

## What's Inside

### Skills

Skills are reusable instruction sets that extend Copilot Chat with specialized domain knowledge. This catalog contains **30 skills** grouped by domain:

| Domain | Skills |
|---|---|
| **Code Quality & Security** | `code-review`, `quality-playbook`, `pytest-coverage`, `refactor`, `ruff-recursive-fix`, `sql-code-review` |
| **Documentation & Specs** | `create-agentsmd`, `create-architectural-decision-record`, `create-implementation-plan`, `create-llms`, `create-readme`, `create-specification`, `docs-sync`, `documentation-writer`, `prd` |
| **Development Workflow** | `acquire-codebase-knowledge`, `git-commit`, `github-copilot-starter`, `grill-me`, `remember`, `repo-story-time`, `skill-creator`, `web-design-reviewer` |
| **Data & Cloud** | `python-expert`, `python-pypi-package-builder` |
| **Frontend & Creative** | `frontend-design`, `mermaid-diagram-specialist`, `theme-factory` |
| **Communication** | `internal-comms`, `meeting-minutes` |

### Agents

Agents are autonomous task runners with defined roles, tools, and personas. This catalog contains **9 agents**:

| Agent | Purpose |
|---|---|
| `address-comments` | Address pull request review comments |
| `context-architect` | Plan and execute multi-file changes |
| `debug` | Find and fix bugs in your application |
| `janitor` | Cleanup, simplification, and tech debt remediation |
| `principal-software-engineer` | Engineering excellence and technical leadership |
| `specification` | Generate or update specification documents |
| `swe-subagent` | Senior engineer subagent for implementation tasks |
| `Thinking-Beast-Mode` | Transcendent coding agent with quantum cognitive architecture and adversarial intelligence |
| `Ultimate-Transparent-Thinking-Beast-Mode` | Ultimate fusion of transparent thinking, creative overclocking, and maximum autonomous persistence |

## Repository Structure

```text
.github/
  skills/
    <skill-name>/
      SKILL.md
      scripts/      (optional)
      references/   (optional)
      assets/       (optional)
  agents/
    *.agent.md
README.md
SKILL-OVERLAP-REPORT.md
```

## Quick Start

Install a skill from a repository that follows a `skills/<name>/` layout:

```bash
gh skill install <owner>/<repo> <skill-name>
```

List skills available in an upstream repo:

```bash
gh api repos/<owner>/<repo>/contents/skills --jq '.[].name'
```

Install from common sources:

```bash
gh skill install github/awesome-copilot <skill-name>
gh skill install anthropics/skills <skill-name>
```

> [!NOTE]
> Some source repos use non-standard paths (not top-level `skills/`). For those, fetch the source subpath and copy manually into `.github/skills/<skill-name>/`.

## Daily Operations

**Add a skill manually** — create a folder and drop in a `SKILL.md`:

```bash
mkdir -p .github/skills/<skill-name>
# add SKILL.md (and optionally scripts/, references/, assets/)
```

**Remove a skill:**

```bash
rm -rf .github/skills/<skill-name>
```

**Count local skills:**

```bash
find .github/skills -mindepth 1 -maxdepth 1 -type d | wc -l
```

**List all skill entry files:**

```bash
find .github/skills -name SKILL.md
```

**List all agents:**

```bash
find .github/agents -name '*.agent.md'
```

## Update Strategy

When syncing from upstream repositories:

1. Pull only the skills you actively need.
2. Review diffs carefully before committing.
3. Record the source in your commit message for provenance.

## Catalog Maintenance

When removing skills from the local catalog:

1. Delete the skill directory under `.github/skills/`.
2. Recount the catalog and update the skills badge and headline count in `README.md`.
3. Remove the deleted skill from the relevant domain row in `README.md`.
4. Update totals and add a new round summary in `SKILL-OVERLAP-REPORT.md`.

> [!IMPORTANT]
> If a skill exists in multiple upstream sources, compare content before overwriting any local customizations.

> [!TIP]
> Prefer a smaller, focused catalog. Regularly audit and remove skills you no longer use — see [`SKILL-OVERLAP-REPORT.md`](./SKILL-OVERLAP-REPORT.md) for the current pruning status and deletion history.

## Upstream Sources

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
| `vercel/next.js` | Frontend and full-stack patterns |
