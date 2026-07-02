---
name: github-copilot-starter
description: >
  Set up complete GitHub Copilot configuration for a new project.
  Use when: scaffolding Copilot instructions, agents, skills, or workflows for a repo;
  user says "set up Copilot", "configure Copilot", or "create copilot config";
  another skill needs Copilot-ready project conventions.
---

Set up GitHub Copilot configuration — instructions, agents, skills, and optionally workflows — for a new project.

## 1. Detect the tech stack

Ask the user for (or infer from the repo):
1. Primary language/framework
2. Project type (web app, API, library, etc.)
3. Additional technologies (database, cloud, testing frameworks)
4. Development style (strict standards, flexible, specific patterns)
5. GitHub Actions usage (yes/no — determines workflow generation)

**Completion criterion:** all five items resolved.

## 2. Research existing patterns

Fetch from awesome-copilot before authoring anything:
- `https://github.com/github/awesome-copilot/tree/main/instructions`
- `https://github.com/github/awesome-copilot/tree/main/agents`
- `https://github.com/github/awesome-copilot/tree/main/skills`

Check for exact tech-stack matches, then general matches. Document all sources for attribution.

**Completion criterion:** at least one source checked per file type; attribution URLs recorded.

## 3. Generate configuration files

Create the directory structure and files. Reference templates in [`references/file-templates.md`](references/file-templates.md).

| File | Purpose |
|------|---------|
| `.github/copilot-instructions.md` | Repo-wide conventions |
| `.github/instructions/{language}.instructions.md` | Language-specific guidelines |
| `.github/instructions/testing.instructions.md` | Testing standards |
| `.github/instructions/security.instructions.md` | Security practices |
| `.github/instructions/documentation.instructions.md` | Documentation standards |
| `.github/instructions/performance.instructions.md` | Performance guidelines |
| `.github/instructions/code-review.instructions.md` | Code review standards |
| `.github/skills/*/SKILL.md` | Reusable skills (setup-component, write-tests, code-review, refactor-code, generate-docs, debug-issue) |
| `.github/agents/*.agent.md` | Specialized agents (software-engineer, architect, reviewer, debugger) |

If GitHub Actions is used, also create `.github/workflows/copilot-setup-steps.yml` from [`references/workflow-templates.md`](references/workflow-templates.md).

- Use awesome-copilot content when available; add attribution comments.
- When creating custom content, keep guidelines high-level (principles, patterns, preferences) — no code snippets or implementation details in `.instructions.md` files.

**Completion criterion:** every file in the target structure created with valid YAML frontmatter.

## 4. Validate

Verify:
- All `.instructions.md` files have correct `applyTo` frontmatter and contain guidelines only (no code examples)
- All `.agent.md` files have `description`, `tools`, `model` frontmatter
- Files reference each other where appropriate
- Workflow (if created) uses job name `copilot-setup-steps` and includes only essential steps
- Attribution comments present where awesome-copilot content was adapted

**Completion criterion:** zero formatting errors; quality checklist passes.

## Completion

After setup, provide the user with:
1. How to enable the files in VS Code
2. Usage examples for skills and agents
3. Customization tips
4. Testing recommendations
