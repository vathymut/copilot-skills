# Catalog reference

This document lists the skills and agents in this repository. It is a reference: use it to find a specific skill or agent by name or domain.

The catalog is intentionally compact. Skills and agents are sourced from upstream repositories and then edited, consolidated, or rewritten to match my own workflows and preferences. See [Upstream sources](#upstream-sources) for the main origins.

## Skills

| Domain | Skills |
|---|---|
| **Code Quality & Security** | `ponytail`, `pytest-coverage`, `refactor`, `sql-code-review` |
| **Documentation & Specs** | `create-architectural-decision-record`, `documentation-writer`, `prd` |
| **Research & Academic** | `academic-plotting`, `brainstorming`, `exam-ready`, `ml-paper-writing`, `research` |
| **ML Experimentation** | `audit-ml-pipeline`, `build-ml-pipeline`, `data-science-python-stack`, `evaluate-ml-pipeline`, `explore-ml-data`, `iterate-ml-experiment`, `organize-ml-workspace`, `python-api`, `python-code-style`, `python-env-manager`, `smoke-test-ml-pipeline`, `test-ml-pipeline` |
| **Development Workflow** | `fix-merge-conflicts`, `finishing-a-development-branch`, `git-commit`, `github-copilot-starter`, `graphify`, `grill-with-docs`, `remember`, `skill-creator`, `using-git-worktrees`, `web-design-reviewer`, `writing-great-skills` |
| **Engineering Discipline** | `code-review`, `codebase-design`, `dispatching-parallel-agents`, `domain-modeling`, `executing-plans`, `implement`, `prototype`, `receiving-code-review`, `requesting-code-review`, `subagent-driven-development`, `systematic-debugging`, `test-driven-development`, `to-tickets`, `triage`, `verification-before-completion`, `wayfinder`, `writing-plans`, `writing-skills` |
| **Data Engineering & Packaging** | `python-expert`, `python-pypi-package-builder`, `xlsx` |
| **DuckDB & Data Files** | `attach-db`, `data-access`, `duckdb-docs`, `duckdb`, `install-duckdb`, `query`, `read-memories`, `spatial` |
| **Frontend & Creative** | `frontend`, `frontend-design`, `frontend-slides`, `image-annotations`, `mermaid-diagram-specialist`, `screen-recording`, `theme-factory`, `tufte-data-viz`, `ui-screenshots` |
| **Visualization** | `visualization`, `academic-plotting` |
| **Communication** | `internal-writing` |
| **Routers & Media** | `docs`, `duckdb`, `git-workflow`, `media`, `memory`, `planning` |
| **Documents & Files** | `pdf` |
| **Skills Meta** | `deslop.deprecated`, `using-superpowers` |

To read a skill's full instructions, open the matching file under [`.github/skills/<skill-name>/SKILL.md`](../.github/skills/).

## Agents

| Agent | Purpose |
|---|---|
| `debug` | Find and fix bugs in your application |
| `janitor` | Cleanup, simplification, and tech debt remediation |
| `swe-subagent` | Senior engineer subagent for implementation tasks |

Agent definitions live under [`.github/agents/`](../.github/agents/).

## Upstream sources

Skills and agents in this catalog are adapted from the following sources:

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

## Counts

- **83 skills** in `.github/skills/`
- **3 agents** in `.github/agents/`

To update these counts, run:

```bash
find .github/skills -mindepth 1 -maxdepth 1 -type d | wc -l
find .github/agents -maxdepth 1 -type f | wc -l
```
