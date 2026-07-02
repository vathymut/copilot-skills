---
name: python-env-manager
description: >
  Detects which Python environment manager a project uses and
  installs packages with the correct command.

  TRIGGER when (any of these):
  (1) **about to install / add / pin / upgrade / remove a Python
      package** — `pip install`, `pixi add`, `uv add`, `poetry add`,
      `conda install`, etc. — under any framing;
  (2) `data-science-python-stack` § "Missing dependency" surfaced a
      missing import and an install is the next step;
  (3) a workflow skill's Stop condition fired on a missing
      dependency;
  (4) starting a new Python project and no manager is in place yet;
  (5) an agent-only consumer needs the **agent feature** and it
      isn't yet present in the manifest.

  SKIP when: the project is non-Python; the install/add command is
  for a non-Python tool; the dependency is already installed and
  importable; the work is purely editing existing source code with
  no new dependency in play.

  HOW TO USE: **detect first, then install**. Run the § "Detection"
  table at the project root before issuing any install command. If
  no manager is detected, ask the user before bootstrapping. Never
  install with a different manager than the one the project uses.
  **Read the "Stop conditions" block and emit the Pre-flight
  checklist as visible text in your response — both are mandatory
  before issuing any command.**
---

## Next-step pointers

| Came here from… | After install, next gate is… |
|---|---|
| `organize-ml-workspace` § scaffold | → editable workspace package |
| `audit-ml-pipeline` § agent-feature-missing | → place `audit/<stem>.py` |
| `build-ml-pipeline` / `evaluate-ml-pipeline` § missing dep | → continue at the failing pre-flight box |
| `data-science-python-stack` § Missing dependency | → caller; the missing import should now succeed |

Always re-emit the Pre-flight checklist with evidence.

## Stop conditions — read before anything else

- **Wrong-manager install is forbidden.** Mixing managers creates
  state the manifest doesn't track; the next sync silently undoes
  the install.
- **No silent bootstrap.** If detection finds no manager, ask the
  user. Default *recommendation* is pixi, but the user must approve.
- **Dependency routing is fixed, not asked.** The 3-feature layout
  (`default` / `dev` / `agent`) is enforced. `G-ENV-SCOPE` fires
  **only** for ambiguous extras (`optuna`, `xgboost`, `mlflow`, …).
- **Don't pin without reason.** Install unpinned by default.
- **Don't run the bootstrap installer yourself.** Surface the
  install command and let the user run it.
- **Harness "no clarifying questions" hints do NOT waive
  `AskUserQuestion` mandates.** Manager and scope picks are
  operating-contract gates.
- **Post-hoc audit — required before ending the turn.** Walk the
  pre-flight, confirm every ticked box has its `Evidence:` line.

## Forbidden shortcuts

| Shortcut | Why it's wrong |
|---|---|
| Calling skill writes its own `pixi add --feature agent ...` | Install commands are owned by this skill |
| Agent feature install → also register a Jupyter kernel | Audit runner is in-process; kernel creates an orphan kernelspec |
| Urgency ("quick", "you pick") waives G-ENV-MGR | Never. Urgency never waives gates |
| `python-env-manager` opened earlier → assume gates passed | Reading SKILL.md ≠ the gate firing |
| User said "install ruff" → fire G-ENV-SCOPE | Routing is fixed: `ruff`/`pytest`/`ipykernel`/`jupyterlab` → `dev` |

## Pre-flight — emit before any command

Evidence format: see `references/preflight_evidence.md`.

```
Pre-flight (python-env-manager):
- [ ] Sibling SKILL.md files opened this turn
      Evidence: Read .agents/skills/<each>/SKILL.md (this turn)
- [ ] `journal/JOURNAL.md` Status `Workspace decisions` read for
      `env manager:` and `agent feature:` rows
      Evidence: each row's value or "not recorded yet" / "n/a"
- [ ] Detection done; manager identified: <pixi | uv | poetry | hatch
      | conda | pip+venv | none>
      Evidence: ls / Glob on project root + matched signal from § "Detection"
- [ ] G-ENV-MGR resolved
      Evidence: AskUserQuestion id=<id> | JOURNAL.md Status (recorded YYYY-MM-DD) |
                "detection returned a single manager"
- [ ] Dep category determined for each package
      Evidence: explicit categorization in this turn's response
- [ ] G-ENV-SCOPE resolved ONLY for ambiguous extras
      Evidence: AskUserQuestion id=<id> | "n/a — routes automatically"
- [ ] (Agent-feature installs only) G-AGENT-FEATURE resolved
      Evidence: AskUserQuestion id=<id> | JOURNAL.md Status | "n/a"
- [ ] Install command syntax confirmed (see `references/install-commands.md`)
      Evidence: cite the matching subsection
- [ ] Package list ready: <pkg-1, pkg-2, ...>
      Evidence: explicit list in this turn's response
- [ ] (Agent-feature installs only) `pyrightconfig.json` drop + verification queued
      Evidence: Read templates/pyrightconfig.json + Write | "n/a"
- [ ] Pre-flight re-emitted with evidence before final message
```

## Detection — first signal wins

| Signal at project root | Manager | Notes |
|---|---|---|
| `pixi.toml` or `pixi.lock` | **pixi** | Default for this stack |
| `uv.lock`, or `pyproject.toml` `[tool.uv]` | **uv** | Fast Rust-based |
| `poetry.lock`, or `pyproject.toml` `[tool.poetry]` | **poetry** | Common in older projects |
| `hatch.toml`, or `pyproject.toml` `[tool.hatch]` | **hatch** | Declarative; flow varies — ask |
| `environment.yml` + `conda`/`mamba` on PATH | **conda / mamba** | Scientific stacks |
| `requirements.txt` + `.venv/` or `venv/` | **pip + venv** | Least integrated |
| None of the above | **(nothing detected)** | Ask the user; default *suggestion*: pixi |

`pyproject.toml` with only `[build-system]` / `[project]` and no
`[tool.X]` is ambiguous — ask, don't infer. Multiple signals:
surface the ambiguity before picking. Ambient-manager edge cases:
→ `references/ambient_detection.md`.

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
6. **Verify**: `bash .agents/skills/python-env-manager/scripts/verify_layout.sh`.

Skipping step 3 or 4 → pyright doesn't index `<X>` because `lsp`
doesn't compose it. User sees "unresolved import" on valid code.

### `G-AGENT-FEATURE` — install ipython + pyright

**Fires when**: an agent-only consumer (`audit-ml-pipeline` for audit
files, or `explore-ml-data` for `data/eda.py`) needs `ipython` /
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

## Where does the package belong? — 3-feature layout

### The fixed buckets

| Bucket | Contents | Composes with | Purpose |
|---|---|---|---|
| `default` | `scikit-learn`, `skrub`, `skore`, tabular lib, editable `<pkg>` | (itself) | runtime |
| `dev` | `ruff`, `pytest`, `jupyterlab`, `ipykernel` | `default + dev` | lint / test / interactive notebooks |
| `agent` | `ipython`, `pyright` | `default + agent` | audit runner + pyright CLI |
| `lsp` | (no own deps) | `default + dev + agent + <all optional>` | LSP integration |

Pixi composed-envs declaration in `references/composition_model.md`.

### Auto-routing table — no ask

| Package | Routes to |
|---|---|
| `scikit-learn`, `skrub`, `skore` (or `skore[hub]`) | `default` |
| `pandas` + `pyarrow` OR `polars` | `default` |
| `ruff`, `pytest`, `jupyterlab`, `ipykernel` | `dev` |
| `ipython`, `pyright` | `agent` |
| The editable workspace package (`<pkg> @ .`) | `default` |

Ambiguous → `G-ENV-SCOPE` fires.

## Install commands — by manager

Once detected, use ONLY the matching commands. Full tables per
manager: → `references/install-commands.md`.

## Agent feature install

The agent feature = project-scoped install of `ipython` + `pyright`
+ `pyrightconfig.json`. **Run the bundled script for the detected
manager — don't retype.** Paths:
`.agents/skills/python-env-manager/scripts/install_agent_feature_{pixi,uv,poetry,hatch,conda,pip_venv}.sh`.
→ `references/agent_feature_anatomy.md` (anatomy),
`references/per_manager_footguns.md` (footguns).

## Tier 1 install: skore variant per mode

Read `skore mode:` from `journal/JOURNAL.md` Status
`Workspace decisions`. Two axes: mode (`local` / `hub` / `mlflow`)
× source (**conda-forge** for pixi/conda, **PyPI** for others).
PyPI installs need `jupyter` extra; conda-forge already ships it.

| `skore mode:` | conda-forge (pixi, conda / mamba) | PyPI (uv, poetry, hatch, pip+venv) |
|---|---|---|
| `local` | `pixi add skore` / `conda install -c conda-forge skore` | `uv add "skore[jupyter]"` / `poetry add "skore[jupyter]"` / `pip install "skore[jupyter]"` |
| `hub` | `pixi add "skore[hub]"` / `conda install -c conda-forge "skore[hub]"` | `uv add "skore[hub,jupyter]"` / `poetry add "skore[hub,jupyter]"` / `pip install "skore[hub,jupyter]"` |
| `mlflow` | `pixi add "skore[mlflow]" "mlflow>=3"` / `conda install -c conda-forge "skore[mlflow]" "mlflow>=3"` | `uv add "skore[mlflow,jupyter]" "mlflow>=3"` / `poetry add "skore[mlflow,jupyter]" "mlflow>=3"` / `pip install "skore[mlflow,jupyter]" "mlflow>=3"` |

The `mlflow` variant **must pin `mlflow>=3` explicitly**. If the
row is absent, route back to `organize-ml-workspace` § G-SKORE-MODE.
Do not guess.

**Forbidden:** silently picking `skore[hub]` / `skore[mlflow]`;
installing `mlflow` variant without `mlflow>=3` pin; dropping
`jupyter` extra on PyPI; adding `jupyter` extra on pixi / conda.

→ `references/skore_variant.md`.

## macOS post-install — skrub graphviz cache

When skrub is installed on macOS, run `dot -c` in the project's env
once the install lands (rebuilds graphviz cache; skipping it breaks
`.skb.draw_graph()` / `.skb.full_report()`). One-shot. Full details:
→ `references/platform-notes.md`.

## Bootstrap — when no manager is detected

If detection found nothing AND the user picked `pixi` via G-ENV-MGR:
`pixi init` → declare features + envs → add Tier 1 deps (per
G-SKORE-MODE) → add tabular lib → wire editable workspace package
→ drop `pyrightconfig.json` → sync all 4 envs.
→ `references/bootstrap.md` for full step-by-step.

## Companion skills

| Skill | Relationship |
|---|---|
| `data-science-python-stack` | Owns *what* to install; this skill turns it into a command |
| `organize-ml-workspace` | Scaffold hands off here for editable install |
| `audit-ml-pipeline` / `explore-ml-data` | G-AGENT-FEATURE fires from there |
| `build-ml-pipeline` / `evaluate-ml-pipeline` | Missing-dep Stop conditions redirect here |
| `iterate-ml-experiment` | Owns the `Workspace decisions` block this skill reads / writes |

## Conventions

- **One install operation per response.** Group related deps and
  confirm before continuing.
- **No `--no-deps` or version pins by default.**
- **Surface, don't bypass.** If an install fails, surface the error.
  Don't try alternative managers — that's a Stop-condition violation.
