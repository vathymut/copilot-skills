---
disable-model-invocation: true
name: remember
description: 'Store lessons learned as domain-organized memory instructions. Syntax: `/remember [>domain [scope]] lesson` where scope is `global` (default) or `workspace`.'
---

# Remember

Store domain-organized memory instructions that persist across sessions.

## Syntax

```
/remember [>domain-name [scope]] lesson content
```

- `>domain-name` — optional domain target (e.g., `>clojure`)
- `scope` — `global` (default) or `workspace`/`ws`
- `lesson content` — the lesson to remember

Examples:
- `/remember >clojure prefer passing maps over parameter lists`
- `/remember workspace use uv for this repo`

## Targets

| Scope | Location | Applies to |
|---|---|---|
| Global | `<global-prompts>/*.instructions.md` | all projects |
| Workspace | `<workspace-root>/.github/instructions/*.instructions.md` | current project only |

Domain-specific files are named `{domain}-memory.instructions.md`. Universal lessons go in `memory.instructions.md`.

## Process

1. Parse domain and scope.
2. Read existing memory files in the target scope.
3. Categorize the lesson: gotcha, best practice, workflow, style decision.
4. Update or create the target memory file:
   - `description` and `applyTo` frontmatter
   - One `##` heading per distinct lesson
   - Succinct, positive, actionable text with code examples when useful
5. Avoid redundant entries.

## Completion criteria

- [ ] Memory file updated or created.
- [ ] No redundant entries.
- [ ] Instructions are scannable and actionable.
