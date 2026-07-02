---
name: git-commit
description: 'Execute git commit with conventional commit message analysis, staging, and message generation. Use when user asks to commit changes or mentions "/commit".'
license: MIT
allowed-tools: Bash
---

# Git Commit with Conventional Commits

Create standardized, semantic git commits using the Conventional Commits
specification. Analyze the actual diff to determine type, scope, and message.

## Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Workflow

### 1. Analyze Diff

```bash
# If files are staged, use staged diff
git diff --staged

# If nothing staged, use working tree diff
git diff

# Also check status
git status --porcelain
```

### 2. Stage Files (if needed)

```bash
git add path/to/file1 path/to/file2
git add *.test.*
git add -p
```

**Never commit secrets** (.env, credentials.json, private keys).

### 3. Generate Commit Message

Analyze the diff to determine:
- **Type**: What kind of change? (→ `references/commit-types.md`)
- **Scope**: What area/module is affected?
- **Description**: One-line summary, present tense, imperative mood, <72 chars

### 4. Execute Commit

```bash
git commit -m "<type>[scope]: <description>"
```

**Completion criteria:** commit created, no staged secrets, message follows conventional format.

## Conventions

- One logical change per commit
- Present tense: "add" not "added"
- Imperative mood: "fix bug" not "fixes bug"
- Reference issues: `Closes #123`, `Refs #456`
- Description under 72 characters

## Safety

- NEVER update git config
- NEVER run destructive commands (--force, hard reset) without explicit request
- NEVER skip hooks (--no-verify) unless user asks
- NEVER force push to main/master
- If commit fails due to hooks, fix and create NEW commit (don't amend)
