---
name: git-commit
description: 'Execute git commit with conventional commit message analysis, staging, and message generation. Also generates narrative commit messages from diffs or change descriptions. Use when user asks to commit changes, mentions "/commit", or says "write a commit message", "summarize my diff", "what should I commit this as".'
license: MIT
allowed-tools: Bash
---

# Git Commit with Conventional Commits

Create standardized, semantic git commits using the Conventional Commits
specification. Analyze the actual diff to determine type, scope, and message.
Also drafts commit messages on demand from raw diffs or change descriptions.

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

Analyze the diff or change description to determine:
- **Type**: What kind of change? (→ `references/commit-types.md`)
- **Scope**: What area/module is affected?
- **Description**: One-line summary, present tense, imperative mood, <72 chars

When the user only wants a message (not an actual commit), output the message in
a copyable code block followed by a one-line plain-English explanation of the
story it tells. For logically separate changes in one diff, suggest splitting
into multiple commits.

Subject-line rules:

- Imperative mood: "add", "fix", "remove" — not "added" or "fixes".
- Max 72 characters.
- No period at the end.
- Lowercase after the colon.

Body rules:

- Explain the *why*, not the *what* (the diff shows the what).
- Describe the problem that existed before the change.
- Mention alternatives considered if relevant.
- Keep lines under 100 characters; separate from subject with a blank line.

Footer rules:

- Reference issues: `Closes #123`, `Fixes #456`, `Refs #789`.
- Mark breaking changes: `BREAKING CHANGE: <description>`.

### 4. Execute Commit

```bash
git commit -m "<type>[scope]: <description>"
```

**Completion criteria:** commit created, no staged secrets, message follows
conventional format.

## Message-only mode

If the user says "write a commit message", "summarize my diff", or similar but
does not ask to create a commit:

1. Gather context from `git diff`, `git diff --staged`, or a description.
2. Map to a Conventional Commits type.
3. Produce the message in a code block plus a one-line story summary.
4. Do not stage or commit.

See `references/commit-types.md` for the type-to-change mapping.

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
