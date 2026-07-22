---
name: git-workflow
description: Use when committing with Conventional Commits, resolving merge/rebase conflicts, setting up git worktrees, or finishing a development branch.
disable-model-invocation: true
allowed-tools: Bash
---

# Git Workflow

Pick the branch that matches the request. All branches are user-invoked.

- **commit** — conventional commit (with message-only mode)
- **merge-conflict** — resolve an in-progress merge or rebase
- **worktree** — set up an isolated workspace
- **finish-branch** — verify tests, then merge / PR / keep / discard

## Branch: commit

Create standardized, semantic git commits using the Conventional Commits
specification. Analyze the actual diff to determine type, scope, and message.
Also drafts commit messages on demand from raw diffs or change descriptions.

### Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Workflow

1. **Analyze diff**
   ```bash
   git diff --staged   # if files staged
   git diff            # else working tree
   git status --porcelain
   ```
2. **Stage files** (if needed): `git add <path>`, `git add -p`.
   **Never commit secrets** (.env, credentials.json, private keys).
3. **Generate message** — map the diff to a Conventional Commits type
   (→ `references/commit-types.md`); one-line summary, present tense,
   imperative mood, <72 chars. For logically separate changes, suggest
   splitting. Subject/body/footer rules in `references/conventional-commits-guide.md`.
4. **Execute**: `git commit -m "<type>[scope]: <description>"`.

**Completion criteria:** commit created, no staged secrets, message follows
conventional format.

### Message-only mode

If the user asks for a message but not a commit: map to a type, produce the
message in a copyable code block plus a one-line plain-English story summary,
and do **not** stage or commit.

**Conventions:** one logical change per commit; imperative mood; reference
issues (`Closes #123`, `Fixes #456`); description <72 chars.

**Safety:** NEVER update git config, run destructive commands (`--force`,
hard reset) without explicit request, skip hooks (`--no-verify`) unless asked,
or force-push to main/master. If a hook fails, fix and create a NEW commit
(don't amend).

## Branch: merge-conflict

Resolve an in-progress git merge or rebase. **Never `--abort` without explicit
user approval.**

1. **See current state.** Read `git status`, the conflicted files, and recent history.
2. **Find intent behind each side.** Read commit messages, PR/issue refs, and code to understand why each change was made.
3. **Resolve each hunk.** Preserve both intents when possible. When they conflict, pick the side matching the merge's goal and note the trade-off. Do **not** invent new behavior.
4. **Regenerate lockfiles** with the package manager if they conflict — do not hand-edit.
5. **Run automated checks.** Compile/typecheck, then tests, then lint/format. Fix anything the merge broke.
6. **Finalize.** Stage all resolved files and complete the merge/rebase; continue rebasing until done.

**Completion criteria:** no conflict markers remain; working tree builds and
relevant tests pass; resolution choices summarized for the user.

## Branch: worktree

Set up an isolated workspace — detect existing isolation (Step 0),
create via native tool or `git worktree add` fallback (Step 1), project
setup (Step 3), verify clean baseline (Step 4), and the red-flag rules.
The full Step 0–4 procedure with the detection snippets is in
`references/worktree.md` — load it when you actually set up the worktree.

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
