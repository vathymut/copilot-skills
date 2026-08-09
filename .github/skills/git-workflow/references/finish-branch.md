# Finish-branch — full procedure

Triggered by the user asking to finish/complete development work. The
branch's SKILL.md section carries the announce pattern, the
environment table, and red flags; this file carries steps 3–6 in full.

## Step 3: Determine base branch

```bash
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
```

Or ask: "This branch split from main — is that correct?"

## Step 4: Present options

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

## Step 5: Execute choice

- **1. Merge locally:** `git checkout <base-branch> && git pull && git merge <feature-branch>`; verify tests on merged result; cleanup worktree (Step 6); `git branch -d <feature-branch>`.
- **2. Push and create PR:** `git push -u origin <feature-branch>`; `gh pr create --title "..." --body "$(cat <<'EOF' ... EOF)"`. **Do NOT clean up worktree** (user needs it for PR feedback).
- **3. Keep as-is:** report, preserve worktree.
- **4. Discard:** require typed `discard` confirmation, then `git branch -D <feature-branch>` and cleanup worktree (Step 6).

## Step 6: Cleanup workspace (Options 1 & 4 only)

```bash
WORKTREE_PATH=$(git rev-parse --show-toplevel)
```

- `GIT_DIR == GIT_COMMON`: normal repo, nothing to clean up.
- Worktree under `.worktrees/` or `worktrees/` (or any directory this skill's instructions file declares as the worktree root): we own it —
  `cd "$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)" && git worktree remove "$WORKTREE_PATH" && git worktree prune`.
- Otherwise: harness owns it — do NOT remove; leave in place.
