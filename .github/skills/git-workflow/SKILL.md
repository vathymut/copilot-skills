---
name: git-workflow
description: Use when committing with Conventional Commits, resolving merge/rebase conflicts, setting up git worktrees, or finishing a development branch.
disable-model-invocation: true
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

Types map (`references/commit-types.md`). One logical change per commit; imperative mood, <72‑char description. Reference issues (`Closes #123`).

### Message-only mode

User asks for a message but not a commit → produce a copyable code block + plain‑English story summary. Do not stage or commit.

**Safety:** never update git config, run `--force`/hard reset without explicit request, skip hooks (`--no-verify`) unless asked, or force‑push to main. If a hook fails, fix and create a NEW commit (don't amend).

## Fixup / squash (interactive rebase)

```bash
git commit --fixup <SHA>   # mark as fixup
GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash <base>
```

The `GIT_SEQUENCE_EDITOR=true` trick auto‑accepts the autosquash ordering without opening an editor. Verify with `git log --oneline` afterward.

## Branch: finish-branch

Guide completion of development work by presenting clear options and handling
the chosen workflow. **Announce:** "I'm using the git-workflow skill
(finish-branch) to complete this work."

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

### Step 3: Determine base branch

```bash
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
```
Or ask: "This branch split from main — is that correct?"

### Step 4: Present options

**Normal repo / named-branch worktree — exactly these 4:**
```
Implementation complete. What would you like to do?
1. Merge back to <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
4. Discard this work
Which option?
```
**Detached HEAD — exactly these 3:** (1) Push as new branch and create a PR,
(2) Keep as-is, (3) Discard.

### Step 5: Execute choice

- **1. Merge locally:** `git checkout <base-branch> && git pull && git merge <feature-branch>`; verify tests on merged result; cleanup worktree (Step 6); `git branch -d <feature-branch>`.
- **2. Push and create PR:** `git push -u origin <feature-branch>`; `gh pr create --title "..." --body "$(cat <<'EOF' ... EOF)"`. **Do NOT clean up worktree** (user needs it for PR feedback).
- **3. Keep as-is:** report, preserve worktree.
- **4. Discard:** require typed `discard` confirmation, then `git branch -D <feature-branch>` and cleanup worktree (Step 6).

### Step 6: Cleanup workspace (Options 1 & 4 only)

```bash
WORKTREE_PATH=$(git rev-parse --show-toplevel)
```
- `GIT_DIR == GIT_COMMON`: normal repo, nothing to clean up.
- Worktree under `.worktrees/` or `worktrees/` (or any directory this skill's instructions file declares as the worktree root): we own it —
  `cd "$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)" && git worktree remove "$WORKTREE_PATH" && git worktree prune`.
- Otherwise: harness owns it — do NOT remove; leave in place.

**Red flags:** never proceed with failing tests; never merge without verifying
tests on the result; never delete work without typed confirmation; never
force-push without explicit request; never remove a worktree you didn't create;
never run `git worktree remove` from inside the worktree (cd to main root first).
