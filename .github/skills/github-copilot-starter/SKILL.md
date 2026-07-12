---
name: github-copilot-starter
description: 'Set up GitHub Copilot configuration (instructions, agents, skills, workflows) for a new project. Use when the user says "set up Copilot", "configure Copilot", or "create copilot config".'
---

# GitHub Copilot Starter

Scaffold Copilot configuration for a new project.

## Steps

1. **Detect tech stack**
   - Primary language/framework
   - Project type (web app, API, library)
   - Additional tech (database, cloud, testing)
   - Development style
   - GitHub Actions usage (yes/no)

2. **Research patterns**
   - Fetch from GitHub's awesome-copilot repo for instructions, agents, and skills.
   - Document attribution sources.

3. **Generate files**
   - `.github/copilot-instructions.md`
   - `.github/instructions/{language,testing,security,documentation,performance,code-review}.instructions.md`
   - `.github/skills/*/SKILL.md`
   - `.github/agents/*.agent.md`
   - `.github/workflows/copilot-setup-steps.yml` if Actions are used

   Use templates from [`references/file-templates.md`](references/file-templates.md) and [`references/workflow-templates.md`](references/workflow-templates.md). Keep `.instructions.md` files high-level — no code snippets.

4. **Validate**
   - `.instructions.md` files have valid `applyTo` frontmatter and guidelines only.
   - `.agent.md` files have `description`, `tools`, and `model` frontmatter.
   - Workflow uses job name `copilot-setup-steps`.
   - Attribution comments are present where content was adapted.

## Completion

Provide the user with:
- How to enable the files in VS Code
- Usage examples for skills and agents
- Customization tips
- Testing recommendations
