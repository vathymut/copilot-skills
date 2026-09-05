---
name: github-copilot-starter
description: Use when the user says 'set up Copilot', 'configure Copilot', or 'create copilot config' for a new project.
---

# GitHub Copilot Starter

Scaffold Copilot configuration for a new project.

## When NOT to use

- The project already has custom Copilot/OpenCode config — this skill would overwrite it. Check for `.github/copilot-instructions.md`, `.opencode/opencode.json`, or `~/.config/opencode/skills/` first.
- The user is not on GitHub (GitLab, Bitbucket, etc.) — Copilot config structure differs per platform.

## Steps

1. **Detect tech stack**
   - Primary language/framework
   - Project type (web app, API, library)
   - Additional tech (database, cloud, testing)
   - Development style
   - GitHub Actions usage (yes/no)

2. **Research patterns**
    - Search for Copilot patterns from these concrete sources (verify URLs still resolve — if one 404s, skip and note it):
      - `awesome-copilot` — https://github.com/github/awesome-copilot
      - GitHub's official `copilot-docs` — https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions-for-github-copilot
      - GitHub Marketplace Copilot actions — https://github.com/marketplace?type=actions&query=copilot
      - User's own `awesome-copilot` fork or internal patterns repo
    - Record attribution for every source you copy from.

3. **Generate files**
   - `.github/copilot-instructions.md`
   - `.github/instructions/{language,testing,security,documentation,performance,code-review}.instructions.md`
   - `.github/skills/<new-skill>/SKILL.md` — **only** when creating a *new* skill; never overwrite the catalog at `.github/skills/` when this repo *is* the catalog (ask first if `.github/skills/` already exists)
   - `.github/agents/*.agent.md` — only for *new* agents; skip if `.github/agents/` exists unless user confirms overwrite
   - `.github/workflows/copilot-setup-steps.yml` if Actions are used

   Use templates from [`references/file-templates.md`](references/file-templates.md) and [`references/workflow-templates.md`](references/workflow-templates.md). Keep `.instructions.md` files high-level — no code snippets.

4. **Validate**
   - `.instructions.md` files have valid `applyTo` frontmatter and guidelines only.
   - `.agent.md` files have `description`, `tools`, and `model` frontmatter.
   - Workflow uses job name `copilot-setup-steps`.
   - Attribution comments are present where content was adapted.
   - **Functional validation:** Open a file in VS Code and verify Copilot Chat loads the instruction files (check `.github/copilot-instructions.md` is referenced in the Copilot status indicator). For agents, confirm the agent appears in the Copilot Chat agent dropdown.

## Completion criteria

- [ ] No existing Copilot/OpenCode config overwritten without user confirmation
- [ ] Files generated from `references/file-templates.md` + `references/workflow-templates.md` with `applyTo` frontmatter
- [ ] Validation checks above pass (instructions, agents, workflow, attribution, functional VS Code check)

## Completion

Provide the user with:
- How to enable the files in VS Code
- Usage examples for skills and agents
- Customization tips
- Testing recommendations

## Related skills

- `writing-great-skills` — author skills installed here.
- `documentation-writer` — instructions are guidance, not code.
