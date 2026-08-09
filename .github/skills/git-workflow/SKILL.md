---
name: git-workflow
description: Use when committing with Conventional Commits, resolving merge/rebase conflicts, setting up git worktrees, or finishing a development branch.
allowed-tools: Bash
---

# Git Workflow

Opinionated conventions and workflows. Standard git operations (add, commit, diff, merge, rebase, log, status) are agent defaults and not documented here.

## Conventional Commits

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Types map (`references/commit-types.md`). One logical change per commit; imperative mood, <72‑char description. Reference issues (`Closes #123`). Full spec walkthrough: `references/conventional-commits-guide.md`.

### Message-only mode

User asks for a message but not a commit → produce a copyable code block + plain‑English story summary. Do not stage or commit.

**Safety:** never update git config, run `--force`/hard reset without explicit request, skip hooks (`--no-verify`) unless asked, or force‑push to main. If a hook fails, fix and create a NEW commit (don't amend).

## Fixup / squash (interactive rebase)

```bash
git commit --fixup <SHA>   # mark as fixup
GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash <base>
```

The `GIT_SEQUENCE_EDITOR=true` trick auto‑accepts the autosquash ordering without opening an editor. Verify with `git log --oneline` afterward.

## Branch: worktree-setup

Set up an isolated workspace for development work. Full procedure (detect existing isolation → native tools → git fallback, submodule guard): `references/worktree.md`.

## Branch: finish-branch

Guide completion of development work by presenting clear options and handling
the chosen workflow. **Announce:** "I'm using the git-workflow skill
(finish-branch) to complete this work." Full steps 3–6 (base branch, options,
execute, cleanup): `references/finish-branch.md`.

**Core principle:** verify tests → detect environment → present options →
execute choice → clean up.

### Step 1: Verify tests

Run the project's test suite. If tests fail, stop and report — cannot proceed
to merge/PR until they pass. If they pass, continue.

### Step 2: Detect environment

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
```

| State | Menu | Cleanup |
|-------|------|---------|
| `GIT_DIR == GIT_COMMON` (normal repo) | Standard 4 options | No worktree to clean up |
| `GIT_DIR != GIT_COMMON`, named branch | Standard 4 options | Provenance-based (Step 6) |
| `GIT_DIR != GIT_COMMON`, detached HEAD | Reduced 3 options (no merge) | No cleanup (externally managed) |

**Red flags:** never proceed with failing tests; never merge without verifying
tests on the result; never delete work without typed confirmation; never
force-push without explicit request; never remove a worktree you didn't create;
never run `git worktree remove` from inside the worktree (cd to main root first).
