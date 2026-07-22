---
name: python-env-manager
description: Use when no environment manager is detected in a Python project, or a package must be routed to the right feature (dev/agent/default) for install. For a failed import, start with `data-science-python-stack` (it owns what to install and hands off here).
---

## Next-step pointers

| Came here from… | After install, next gate is… |
|---|---|
| `ml-scaffold` § scaffold | → editable workspace package |
| `evaluate-ml-pipeline` § Audit | → place `audit/<stem>.py` |
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
  operating-contract gates. Single-source wording:
  `ml-conventions:references/shared-ml-conventions.md` (Harness hints).
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

Evidence format: see `ml-conventions:references/shared-preflight-evidence.md`.

```
Pre-flight (python-env-manager):
- [ ] Sibling SKILL.md files opened this turn
      Evidence: Read .github/skills/<each>/SKILL.md (this turn)
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

`G-ENV-MGR` (which manager), `G-ENV-SCOPE` (ambiguous extras → named
feature), `G-AGENT-FEATURE` (ipython + pyright), and the persistence
lookup that reads `Workspace decisions` before firing — full fire
conditions, `AskUserQuestion` shapes, and the 6-step named-feature
procedure (step 3 is the one that silently breaks LSP) are in
`references/gates.md`. Load it when a gate is about to fire.

## Where does the package belong? — 3-feature layout

The fixed `default` / `dev` / `agent` / `lsp` buckets and the
no-ask auto-routing table are in `references/placement.md`; the
*why* behind the four composed envs is in `references/composition_model.md`.
Load when routing a dependency.

## Install commands — by manager

Once detected, use ONLY the matching commands. Full tables per
manager: → `references/install-commands.md`.

## Agent feature install

The agent feature = project-scoped install of `ipython` + `pyright`
+ `pyrightconfig.json`. **Run the bundled script for the detected
manager — don't retype.** Paths:
`.github/skills/python-env-manager/scripts/install_agent_feature_{pixi,uv,poetry,hatch,conda,pip_venv}.sh`.
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
row is absent, route back to `ml-scaffold` § G-SKORE-MODE.
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
| `ml-scaffold` | Scaffold hands off here for editable install |
| `evaluate-ml-pipeline § Audit` / `ml-eda` | G-AGENT-FEATURE fires from there |
| `build-ml-pipeline` / `evaluate-ml-pipeline` | Missing-dep Stop conditions redirect here |
| `iterate-ml-experiment` | Owns the `Workspace decisions` block this skill reads / writes |

## Conventions

- **One install operation per response.** Group related deps and
  confirm before continuing.
- **No `--no-deps` or version pins by default.** Exception: this
  skill applies required pins from `data-science-python-stack`
  (e.g. `skore` and `skrub` stay latest; `mlflow>=3` for skore's
  mlflow mode).
- **Surface, don't bypass.** If an install fails, surface the error.
  Don't try alternative managers — that's a Stop-condition violation.

## Split of ownership

| Decision | Owned by |
|---|---|
| What library is in the stack, and why | `data-science-python-stack` |
| Which manager + feature scope to use | this skill |
| ruff/NumPyDoc conventions | this skill (`templates/ruff.toml`) |
| Exact install command syntax | this skill |
| `skore` mode / hub / mlflow variant details | `ml-scaffold` decides mode; this skill executes |
| Mandatory Tier 1 vs user-choice Tier 2 vs opt-in Tier 3 | `data-science-python-stack` |
