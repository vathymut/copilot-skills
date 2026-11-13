# Catalog reference

This is the reference list of every skill and agent in this repository. Use it to find a skill by domain or name, and to see at a glance what each one does.

Skills and agents are sourced from upstream repositories and then edited, consolidated, or rewritten to match my own workflows. See [Upstream sources](#upstream-sources) for the main origins.

## How to read this catalog

- **Leaf skills** do the actual work. Many are triggered automatically by OpenCode or Copilot based on your request.
- **User-invoked / routing skills** can be invoked directly and may dispatch to a more specific workflow or reference (for example `grill-me` → `grilling`, and branch-routing inside `data-access`, `git-workflow`, `internal-writing`, `ui-screenshots`).
- **Agents** are autonomous Copilot Chat personas given a goal, not a single task.

## Code Quality & Security

| Skill | What it does |
|---|---|
| `code-review` | Reviews code, workflow, and feedback; can request a reviewer subagent |
| `refactor` | Improves code structure without changing behavior — cleans up, breaks down large functions, removes code smells |

## Development Workflow & Git

| Skill | What it does |
|---|---|
| `git-workflow` | Git workflow in one skill: commit (Conventional Commits), resolve merge/rebase conflicts, set up worktrees, and finish a development branch |

## Engineering Discipline

| Skill | What it does |
|---|---|
| `domain-modeling` | Builds and sharpens a project's domain model, ubiquitous language, and architectural decisions (ADRs) |
| `grill-me` | User-invoked entry point that sharpens a plan via the `grilling` interview |
| `grilling` | Relentlessly interviews the user round-by-round to stress-test a plan or decision |

## Documentation & Specs

| Skill | What it does |
|---|---|
| `documentation-writer` | Writes software docs using the Diátaxis framework (tutorial, how-to, reference, explanation) |

## Research & Academic

| Skill | What it does |
|---|---|
| `ml-paper-writing` | Writes publication-ready ML/AI papers for top venues |
| `research` | Investigates a question against high-trust primary sources and captures findings as Markdown |

## Python Stack & Environment

| Skill | What it does |
|---|---|
| `python-api` | Looks up and caches installed Python package APIs against the installed version |
| `python-pypi-package-builder` | Builds, tests, lints, versions, and publishes a Python library to PyPI |
| `python-stack-env` | Opinionated Python stack (library tiers, competing-library contract) plus environment management (manager detection, feature routing, installs) |

## DuckDB & Data Files

| Skill | What it does |
|---|---|
| `data-access` | Reads, profiles, converts, and queries local or remote data files with DuckDB; also spatial/geographic queries (distances, GeoJSON, Overture Maps) and DuckDB extension/CLI installation |

## Frontend & Creative

| Skill | What it does |
|---|---|
| `frontend-design` | Creates distinctive, production-grade frontend interfaces and artifacts |
| `frontend-slides` | Builds animation-rich HTML presentations from scratch or from PowerPoint |
| `show-me` | Explains the current topic visually — pseudocode, call/component trees, Mermaid, diff-shape sketches, focused HTML artifacts |
| `tufte-data-viz` | Applies Tufte principles for clean, screen-first data visualizations |
| `ui-screenshots` | Captures web/Electron/desktop screenshots and annotates them with callouts; assembles GIF demos |

## Communication

| Skill | What it does |
|---|---|
| `internal-writing` | Writes internal prose: minutes, reviews, brag sheets, updates, FAQs |

---

To read a skill's full instructions, open the matching file under [`.github/skills/<skill-name>/SKILL.md`](../.github/skills/).

## Agents

Autonomous Copilot Chat personas. Invoked with `@<agent-name>` and given a goal.

| Agent | Purpose | Loads skills |
|---|---|---|
| `debug` | Finds and fixes bugs in your application | (systematic debug workflow; no skill dependencies) |
| `janitor` | Cleanup, simplification, and tech-debt remediation | `refactor` |
| `swe-subagent` | Senior engineer subagent for implementation tasks | `refactor` |

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
| `duckdb/duckdb-skills` | DuckDB-powered data skills |
| `mattpocock/skills` | Skill-writing principles and reference vocabulary |
| `zarazhangrui/frontend-slides` | HTML presentation creation and PPT conversion |
| `caylent/tufte-data-viz` | Edward Tufte's data visualization principles for clean charts |
| `humanlayer/skills` | Visual-explanation skill (`show-me`: diagrams, code-shape sketches, HTML artifacts) |

## Counts

- **19 skills** in `.github/skills/`
- **3 agents** in `.github/agents/`

To update these counts, run:

```bash
find .github/skills -mindepth 1 -maxdepth 1 -type d | wc -l
find .github/agents -maxdepth 1 -type f | wc -l
```
