# File Templates

YAML frontmatter and structure templates for Copilot configuration files.

## Instructions (.instructions.md)

```md
---
applyTo: "**/*.{lang-ext}"
description: "Development standards for {Language}"
---
# {Language} coding standards

Apply the repository-wide guidance from `../copilot-instructions.md` to all code.

## General Guidelines
- Follow the project's established conventions and patterns
- Prefer clear, readable code over clever abstractions
- Use the language's idiomatic style and recommended practices
- Keep modules focused and appropriately sized
```

## Skills (SKILL.md)

```md
---
name: {skill-name}
description: {Brief description of what this skill does}
---

# {Skill Name}

{One sentence describing what this skill does. Always follow the repository's established patterns.}

Ask for {required inputs} if not provided.

## Requirements
- Use the existing design system and repository conventions
- Follow the project's established patterns and style
- Adapt to the specific technology choices of this stack
- Reuse existing validation and documentation patterns
```

## Agents (.agent.md)

```md
---
description: Generate an implementation plan for new features or refactoring existing code.
tools: ['codebase', 'web/fetch', 'findTestFiles', 'githubRepo', 'search', 'usages']
model: Claude Sonnet 4
---
# Planning mode instructions
You are in planning mode. Your task is to generate an implementation plan for a new feature or for refactoring existing code.
Don't make any code edits, just generate a plan.

The plan consists of a Markdown document that describes the implementation plan, including the following sections:

* Overview: A brief description of the feature or refactoring task.
* Requirements: A list of requirements for the feature or refactoring task.
* Implementation Steps: A detailed list of steps to implement the feature or refactoring task.
* Testing: A list of tests that need to be implemented to verify the feature or refactoring task.
```

## Attribution

When using content from awesome-copilot, add at the top of the file:
```md
<!-- Based on/Inspired by: https://github.com/github/awesome-copilot/blob/main/[path] -->
```
