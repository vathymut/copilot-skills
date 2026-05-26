# copilot-skills

> A curated, versioned local catalog of reusable skills and agents for GitHub Copilot Chat.

[![Skills](https://img.shields.io/badge/skills-56-blue?style=flat-square)](./.github/skills/)
[![Agents](https://img.shields.io/badge/agents-3-purple?style=flat-square)](./.github/agents/)

This repository is a practical, versioned workspace for curating the prompts, references, scripts, and agent definitions you actually use — distilled from multiple upstream sources into a lean, task-focused catalog.

`README.md` is the source of truth for the live catalog inventory.

## What's Inside

### Skills

Skills are reusable instruction sets that extend Copilot Chat with specialized domain knowledge. This catalog contains **56 skills** grouped by domain:

| Domain | Skills |
|---|---|
| **Code Quality & Security** | `pytest-coverage`, `refactor`, `refactor-plan`, `ruff-recursive-fix`, `sql-code-review` |
| **Documentation & Specs** | `create-architectural-decision-record`, `create-implementation-plan`, `create-specification`, `documentation-writer`, `prd` |
| **Research & Academic** | `academic-plotting`, `brainstorming-research-ideas`, `exam-ready`, `ml-paper-writing` |
| **ML Experimentation** | `build-ml-pipeline`, `data-science-python-stack`, `evaluate-ml-pipeline`, `iterate-from-skore`, `iterate-from-user`, `iterate-ml-experiment`, `organize-ml-workspace`, `python-api`, `python-code-style`, `python-env-manager`, `smoke-test-ml-pipeline`, `test-ml-pipeline` |
| **Development Workflow** | `acquire-codebase-knowledge`, `commit-message-storyteller`, `git-commit`, `github-copilot-starter`, `grill-me`, `grill-with-docs`, `improve-codebase-architecture`, `remember`, `skill-creator`, `web-design-reviewer` |
| **Data & Cloud** | `python-expert`, `python-pypi-package-builder` |
| **DuckDB & Data Files** | `attach-db`, `convert-file`, `duckdb-docs`, `install-duckdb`, `query`, `read-file`, `read-memories`, `s3-explore`, `spatial` |
| **Frontend & Creative** | `frontend-design`, `mermaid-diagram-specialist`, `theme-factory` |
| **Communication** | `brag-sheet`, `internal-comms`, `meeting-minutes`, `performance-review-writer` |
| **Document Formats** | `pdf`, `xlsx` |

### Agents

Agents are autonomous task runners with defined roles, tools, and personas. This catalog contains **3 agents**:

| Agent | Purpose |
|---|---|
| `debug` | Find and fix bugs in your application |
| `janitor` | Cleanup, simplification, and tech debt remediation |
| `swe-subagent` | Senior engineer subagent for implementation tasks |

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
gh skill install probabl-ai/skills <skill-name>
```

> [!TIP]
> For parent-repository discovery, enable the `chat.useCustomizationsInParentRepositories` setting to also discover customizations from the parent repository. See: <https://code.visualstudio.com/docs/copilot/customization/overview#_parent-repository-discovery>.

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
4. Update totals and domain rows in `README.md`.

> [!IMPORTANT]
> If a skill exists in multiple upstream sources, compare content before overwriting any local customizations.

> [!TIP]
> Prefer a smaller, focused catalog. Regularly audit and remove skills you no longer use, then sync counts and domain rows in `README.md`.

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
| `probabl-ai/skills` | ML experimentation and PyData workflow skills |
| `vercel/next.js` | Frontend and full-stack patterns |
| `duckdb/duckdb-skills` | DuckDB-powered data skills |

## Global Installation for All VS Code Sessions

Recommended: use the personal Copilot folder (`~/.copilot`) as the canonical global location for skills, agents, and instructions.

### macOS/Linux

```bash
mkdir -p "$HOME/.copilot"
rm -rf "$HOME/.copilot/skills" "$HOME/.copilot/agents" "$HOME/.copilot/instructions"
ln -s "$PWD/.github/skills" "$HOME/.copilot/skills"
ln -s "$PWD/.github/agents" "$HOME/.copilot/agents"
ln -s "$PWD/.github/instructions" "$HOME/.copilot/instructions"
```

### Windows

1. Open Command Prompt as Administrator.
2. Run the following commands (replace `<repo-path>` with the absolute path to your repo):

```cmd
if not exist "%USERPROFILE%\.copilot" mkdir "%USERPROFILE%\.copilot"
rmdir /S /Q "%USERPROFILE%\.copilot\skills"
rmdir /S /Q "%USERPROFILE%\.copilot\agents"
rmdir /S /Q "%USERPROFILE%\.copilot\instructions"
mklink /D "%USERPROFILE%\.copilot\skills" "<repo-path>\.github\skills"
mklink /D "%USERPROFILE%\.copilot\agents" "<repo-path>\.github\agents"
mklink /D "%USERPROFILE%\.copilot\instructions" "<repo-path>\.github\instructions"
```

> **Note:**
> - These symlinks keep this repo as the single source of truth while making customizations global.
> - If a destination already exists, remove it first (as shown above) before creating the link.
> - VS Code can also discover user-profile customizations from its profile user-data location. If you use that path too, keep `~/.copilot/*` as the canonical source and point profile-specific paths to it.
> - After setup, custom skills, agents, and instructions are available across VS Code sessions for your user profile.
