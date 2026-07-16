# Branch: worktree — setup procedure (extracted)

Load when setting up an isolated workspace.

## Branch: worktree

Ensure work happens in an isolated workspace. **Core principle:** detect
existing isolation first, then use native tools, then fall back to git. Never
fight the harness. **Announce:** "I'm using the git-workflow skill (worktree)
to set up an isolated workspace."

### Step 0: Detect existing isolation

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
BRANCH=$(git branch --show-current)
```

**Submodule guard:** `GIT_DIR != GIT_COMMON` is also true inside submodules.
Verify you are not in a submodule before concluding "already in a worktree":
```bash
git rev-parse --show-superproject-working-tree 2>/dev/null   # path → submodule, not worktree
```

- **`GIT_DIR != GIT_COMMON` (and not a submodule):** already in a linked worktree. Report state and skip to Step 3.
- **`GIT_DIR == GIT_COMMON` (or submodule):** normal repo. Ask consent before creating a worktree ("Would you like me to set up an isolated worktree? It protects your current branch from changes."). If declined, work in place and skip to Step 3.

### Step 1: Create isolated workspace

1a. **Native worktree tools (preferred).** If a tool exists (`EnterWorktree`,
`WorktreeCreate`, `/worktree`, `--worktree`), use it and skip to Step 3. Using
`git worktree add` when a native tool exists creates phantom state the harness
can't manage.

1b. **Git worktree fallback** (only if no native tool). Directory priority:
existing `.worktrees/` > existing `worktrees/` > instruction-file preference >
default `.worktrees/`. **Verify ignored before creating** (project-local only):
```bash
git check-ignore -q .worktrees 2>/dev/null || git check-ignore -q worktrees 2>/dev/null || { echo "add to .gitignore + commit"; }
```
```bash
git worktree add "$path" -b "$BRANCH_NAME" && cd "$path"
```
Sandbox permission error → tell the user, work in place.

### Step 3: Project setup

Auto-detect and run setup: `npm install` (package.json), `cargo build`
(Cargo.toml), `pip install -r requirements.txt` / `poetry install` (Python),
`go mod download` (go.mod).

### Step 4: Verify clean baseline

Run the project's test command. If tests fail, report and ask whether to
proceed or investigate.

**Red flags:** never create a worktree when Step 0 detects existing isolation;
never `git worktree add` when a native tool exists; never skip ignore
verification; never proceed with failing tests without asking.
