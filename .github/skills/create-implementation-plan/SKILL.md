---
name: create-implementation-plan
description: 'Create a machine-readable implementation plan for features, refactoring, or upgrades.'
---

# Create Implementation Plan

## Steps

### 1. Gather Inputs

Collect from the user or conversation context:

- **Purpose**: What this plan achieves (feature, refactor, upgrade, etc.)
- **Scope**: Components, modules, or systems affected
- **Constraints**: Technical limitations, deadlines, dependencies

If missing, ask the user before proceeding.

**Completion**: All inputs collected.

### 2. Determine Plan Type and Version

- **Prefix**: One of `upgrade`, `refactor`, `feature`, `data`, `infrastructure`, `process`, `architecture`, `design`
- **Version**: Start at `1`; increment on rewrites

**Completion**: Prefix and version set.

### 3. Fill Template Phases

Read `references/plan-template.md` and populate all sections. Break work into atomic phases with measurable completion criteria. Each task gets a unique `TASK-NNN` identifier.

- Use `REQ-`, `SEC-`, `CON-`, `GUD-`, `PAT-` for requirements
- Use `GOAL-NNN` for phase goals
- Use `TASK-NNN` for individual tasks
- Use `ALT-`, `DEP-`, `FILE-`, `TEST-`, `RISK-`, `ASSUMPTION-` as needed

**Completion**: All phases populated with tasks.

### 4. Validate Identifiers

Run `references/validate-identifiers.sh <plan-file>` to check for duplicate declarations. Re-number any duplicates and re-run until checks 1 and 2 pass.

**Completion**: Zero duplicate declarations.

### 5. Save

Write the file to `/plan/[purpose]-[component]-[version].md`.

**Completion**: File written to disk.

## File Naming

```
/plan/[purpose]-[component]-[version].md
```

- Purpose: `upgrade|refactor|feature|data|infrastructure|process|architecture|design`
- Component: descriptive kebab-case name
- Version: integer starting at 1
- Examples: `upgrade-system-command-4.md`, `feature-auth-module-1.md`

## Requirements

- Machine-readable, zero-ambiguity language
- All tasks independently processable unless dependencies declared
- No placeholder text in final output
- Valid Markdown with proper front matter
- Status must be one of: `Completed`, `In progress`, `Planned`, `Deprecated`, `On Hold`
