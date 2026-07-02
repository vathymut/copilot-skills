---
name: remember
description: 'Store lessons learned as domain-organized memory instructions. Syntax: `/remember [>domain [scope]] lesson clue` where scope is `global` (default), `user`, `workspace`, or `ws`.'
---

# Memory Keeper

Store and retrieve domain-organized memory instructions that persist
across sessions. Auto-categorizes learnings by domain and creates new
memory files as needed.

## Scopes

- **Global** (`global` or `user`) — `<global-prompts>` (`vscode-userdata:/User/prompts/`), applies to all projects
- **Workspace** (`workspace` or `ws`) — `<workspace-instructions>` (`<workspace-root>/.github/instructions/`), applies to current project only

Default: **global**.

## Syntax

```
/remember [>domain-name [scope]] lesson content
```

- `>domain-name` — Optional. Explicitly target a domain (e.g., `>clojure`)
- `[scope]` — Optional. `global`, `user`, `workspace`, or `ws`. Default: `global`
- `lesson content` — Required. The lesson to remember

**Examples:**
- `/remember >shell-scripting now we've forgotten about using fish syntax too many times`
- `/remember >clojure prefer passing maps over parameter lists`
- `/remember avoid over-escaping`
- `/remember >clojure workspace prefer threading macros for readability`

## Memory File Structure

- **Description Frontmatter** — general domain responsibility
- **ApplyTo Frontmatter** — glob patterns targeting relevant files
- **Main Headline** — `# <Domain Name> Memory`
- **Tag Line** — succinct capture of core patterns
- **Learnings** — each distinct lesson gets its own `##` heading

## Process

1. **Parse input** — extract domain (if `>domain-name`) and scope
2. **Glob and read** existing memory/instruction files:
   - Global: `<global-prompts>/*-memory.instructions.md`, `<global-prompts>/*.instructions.md`
   - Workspace: `<workspace-instructions>/*-memory.instructions.md`, `<workspace-instructions>/*.instructions.md`
3. **Analyze** the lesson from user input and chat session
4. **Categorize**: new gotcha, enhancement, best practice, or process improvement
5. **Determine target domain(s)**:
   - User specified `>domain-name` → confirm if ambiguous
   - Otherwise, match to existing domain or create new one
   - Universal learnings → `memory.instructions.md` in scope
   - Domain-specific → `{domain}-memory.instructions.md`
6. **Read domain files** to avoid redundancy
7. **Update or create** memory files per Memory File Structure
8. **Write** instructions that are:
   - Succinct, clear, and actionable
   - Generalized from specific instances
   - Positive (focus on correct patterns, not "don't"s)
   - Concrete with code examples when relevant

**Completion criteria:** memory file updated/created, no redundant entries, instructions are scannable and actionable.

## Update Triggers

- Repeatedly forgetting the same shortcuts or commands
- Discovering effective workflows
- Learning domain-specific best practices
- Finding reusable problem-solving approaches
- Coding style decisions and rationale
- Cross-project patterns that work well
