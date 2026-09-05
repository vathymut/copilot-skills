# Catalog reference

This is the reference list of every skill and agent in this repository. Use it to find a skill by domain or name, and to see at a glance what each one does.

Skills and agents are sourced from upstream repositories and then edited, consolidated, or rewritten to match my own workflows. See [Upstream sources](#upstream-sources) for the main origins.

## How to read this catalog

- **Routers** are user-invoked dispatchers. Type the router name to be pointed at the right leaf skill — use them when you know the area but not the exact skill.
- **Leaf skills** do the actual work. Many are also triggered automatically by OpenCode or Copilot based on your request.
- **Agents** are autonomous Copilot Chat personas given a goal, not a single task.

## Routers

Three catalog skills act as branch routers internally and were narrowed in this pass: `data-access` (6 commands now routed per-table), `git-workflow` (Conventional Commits / worktree / finish-branch routed), `ui-screenshots` / `internal-writing` (mutually-exclusive branches). The former `planning` router was folded into `brainstorming` (now the default planning entry point), and the earlier `docs`, `duckdb`, and `frontend` routers were retired during catalog consolidation.

## Code Quality & Security

| Skill | What it does |
|---|---|
| `ponytail` | Forces the laziest minimal solution for any coding task, with optional intensity levels and a throwaway prototype mode |
| `refactor` | Improves code structure without changing behavior — cleans up, breaks down large functions, removes code smells |

## Development Workflow & Git

| Skill | What it does |
|---|---|
| `git-workflow` | Git workflow in one skill: commit (Conventional Commits), resolve merge/rebase conflicts, set up worktrees, and finish a development branch |
| `github-copilot-starter` | Sets up Copilot configuration (instructions, agents, skills, workflows) for a new project |

## Engineering Discipline

| Skill | What it does |
|---|---|
| `code-review` | Reviews code, workflow, and feedback; can request a reviewer subagent |
| `domain-modeling` | Builds and sharpens a project's domain model, ubiquitous language, and architectural decisions (ADRs) |
| `systematic-debugging` | Structured debugging workflow for any bug or test failure, before proposing fixes |
| `test-driven-development` | Drives implementation via tests, before writing implementation code |
| `writing-plans` | Turns a spec or requirements into a multi-step implementation plan |

## Documentation & Specs

| Skill | What it does |
|---|---|
| `documentation-writer` | Writes software docs using the Diátaxis framework (tutorial, how-to, reference, explanation) |

## Research & Academic

| Skill | What it does |
|---|---|
| `brainstorming` | Explores intent and design before creative work; default planning/development-workflow entry point (folded-in `planning` router points at plans and subagents) |
| `ml-paper-writing` | Writes publication-ready ML/AI papers for top venues |
| `research` | Investigates a question against high-trust primary sources and captures findings as Markdown |

## Python Stack & Environment

| Skill | What it does |
|---|---|
| `python-api` | Looks up and caches installed Python package APIs against the installed version |
| `python-stack-env` | Opinionated Python stack (library tiers, competing-library contract) plus environment management (manager detection, feature routing, installs) |

## Data Engineering & Packaging

| Skill | What it does |
|---|---|
| `python-pypi-package-builder` | Builds, tests, lints, versions, and publishes a Python library to PyPI |
| `xlsx` | Creates, edits, analyzes, and cleans spreadsheet files |

## DuckDB & Data Files

| Skill | What it does |
|---|---|
| `data-access` | Reads, profiles, converts, and queries local or remote data files with DuckDB; also spatial/geographic queries (distances, GeoJSON, Overture Maps) and DuckDB extension/CLI installation |

## Frontend & Creative

| Skill | What it does |
|---|---|
| `frontend-design` | Creates distinctive, production-grade frontend interfaces and artifacts |
| `frontend-slides` | Builds animation-rich HTML presentations from scratch or from PowerPoint |
| `mermaid-diagram-specialist` | Creates flowcharts, sequence diagrams, ERDs, and architecture visualizations as Mermaid |
| `tufte-data-viz` | Applies Tufte principles for clean, screen-first data visualizations |
| `ui-screenshots` | Captures web/Electron/desktop screenshots and annotates them with callouts; assembles GIF demos |

## Communication

| Skill | What it does |
|---|---|
| `internal-writing` | Writes internal prose: minutes, reviews, brag sheets, updates, FAQs |

## Documents & Files

| Skill | What it does |
|---|---|
| `pdf` | Reads, merges, splits, rotates, creates, watermarks, encrypts, or OCRs PDFs |

---

To read a skill's full instructions, open the matching file under [`.github/skills/<skill-name>/SKILL.md`](../.github/skills/).

## Agents

Autonomous Copilot Chat personas. Invoked with `@<agent-name>` and given a goal.

| Agent | Purpose | Loads skills |
|---|---|---|
| `debug` | Finds and fixes bugs in your application | `systematic-debugging` → `test-driven-development` |
| `janitor` | Cleanup, simplification, and tech-debt remediation | `refactor` + `ponytail` |
| `swe-subagent` | Senior engineer subagent for implementation tasks | `test-driven-development` + `systematic-debugging` |

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

- **25 skills** in `.github/skills/` (25 model-invoked; plus 3 internal branch-routers: `data-access`, `git-workflow`, `ui-screenshots`/`internal-writing`)
- **3 agents** in `.github/agents/`

To update these counts, run:

```bash
find .github/skills -mindepth 1 -maxdepth 1 -type d | wc -l
find .github/agents -maxdepth 1 -type f | wc -l
```
