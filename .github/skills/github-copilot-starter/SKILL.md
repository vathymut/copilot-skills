---
name: github-copilot-starter
description: Use when the user says 'set up Copilot', 'configure Copilot', or 'create copilot config' for a new project.
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
   - Fetch community Copilot patterns from public sources (e.g. the
     user's own preferred awesome-copilot fork, or any community
     collection of instructions / agents / skills).
   - Record attribution for every source you copy from.

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
