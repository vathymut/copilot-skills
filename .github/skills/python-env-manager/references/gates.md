# Gates this skill owns (extracted)

Load when a gate is about to fire.

## Gates this skill owns

### `G-ENV-MGR` — which manager

**Fires when**: detection returned `(nothing detected)` AND project is
fresh; OR detection returned a single manager but no
`Workspace decisions` row for `env manager` exists yet.

**AskUserQuestion**: single pick from the detection table. Default
*recommendation* on nothing-detected: `pixi`. Free-text resolves
only when it names a listed manager.

**Persists**: `env manager: <pick> — recorded: <date>` in
`journal/JOURNAL.md` Status `Workspace decisions`.

### `G-ENV-SCOPE` — only for ambiguous extras

**Fires when**: a requested dep doesn't match the § "Auto-routing
table" below (e.g. `optuna`, `xgboost`, `mlflow`).

**AskUserQuestion (binary)**:
1. **`default`** — fold into runtime deps. One step: `pixi add <pkg>`.
2. **New named feature `<X>`** — propose a name from the user's
   wording (`tracing` for `mlflow`, `tuning` for `optuna`, `dl` for
   `torch`).

Free-text resolution: explicit `default` or a feature name resolves;
"you pick" / "doesn't matter" does NOT.

#### When a new named feature `<X>` is picked — 6 steps, all required

**This is the load-bearing procedure smaller models forget.** Step
3 specifically is the one that silently breaks LSP integration.

1. **Install into the new feature**: `pixi add --feature <X> <pkg>`
   (manager-equivalents: `uv add --group <X> <pkg>`,
   `poetry add --group <X> <pkg>`).
2. **Confirm the feature block exists** in the manifest.
3. **APPEND `<X>` to the `lsp` env's features list** — pixi: edit
   `[environments]` → `lsp = { features = [..., "<X>"], ... }`;
   uv/poetry: covered by `--all-groups`/`--with`;
   hatch/conda/pip+venv: re-author the lsp env's dep list.
4. **Re-sync the lsp env**: pixi → `pixi install -e lsp`; uv →
   `uv sync --all-groups`; poetry → `poetry install --with <X>`;
   others → re-create.
5. **Update `JOURNAL.md`**: append `<X>` to `optional features:`.
6. **Verify**: `bash .github/skills/python-env-manager/scripts/verify_layout.sh`.

Skipping step 3 or 4 → pyright doesn't index `<X>` because `lsp`
doesn't compose it. User sees "unresolved import" on valid code.

### `G-AGENT-FEATURE` — install ipython + pyright

**Fires when**: an agent-only consumer (`evaluate-ml-pipeline § Audit` for audit
files, or `ml-eda` for `data/eda.py`) needs `ipython` /
`pyright` and the manifest doesn't expose them. Can fire as early as
**bootstrap** (the G-EDA run path).

**AskUserQuestion (binary)**: `install` | `skip`.
- `install` → run the bundled per-manager script (see § "Agent
  feature install").
- `skip` → block the calling skill; no silent degradation.

**Persists**: `agent feature: <installed | skipped> — recorded: <date>`.

No kernel registration — the audit runner is in-process.
→ next: § "Agent feature install" if `install`.

### Persistence lookup — read JOURNAL.md before any gate fires

Read `Workspace decisions` first:

- `env manager: <pixi | uv | poetry | hatch | conda | pip+venv> — recorded: <date>`
- `agent feature: <installed | skipped> — recorded: <date>`
- `optional features: <name1, name2, ... | none> — recorded: <date>`

If a row is recorded, **do not re-ask** — cite
`JOURNAL.md Status (Workspace decisions, recorded YYYY-MM-DD)` as
evidence. If `journal/JOURNAL.md` doesn't exist yet, gates fire
fresh and answers land in `Workspace decisions` once
`iterate-ml-experiment` writes the JOURNAL.

