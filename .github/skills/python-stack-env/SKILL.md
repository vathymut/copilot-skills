---
name: python-stack-env
description: Use when a Python import fails in a data-science or ML project, two or more libraries compete for one job (tabular DL, plotting, serving) and a choice is needed, no environment manager is detected, or a package must be routed to the right feature (dev/agent/default) for install.
---

# Python Stack & Environment Manager

Opinionated Python stack (one library per job) **and** environment management (manager detection, feature routing, install commands). This skill owns *what*, *why*, and *how*.

## Next-step pointers

| Came here from… | After install, next is… |
|---|---|
| `iterate-ml-experiment` § 0.5 | → editable workspace package (`references/editable_workspace.md`) |
| `evaluate-ml-pipeline` § Audit | → place `audit/<stem>.py` |
| `build-ml-pipeline` / `evaluate-ml-pipeline` § missing dep | → continue at failing pre-flight box |
| Stack question / missing dep | → caller; import should now succeed |

## Stop conditions

- **No silent pick on a competing-library job.** Two+ libraries for the same job → `AskUserQuestion` before any import or install. Persist answer in `journal/JOURNAL.md` Status `Workspace decisions`. "Already pulled in transitively", "quick", "no preference" are NOT waivers.
- **Free-text resolution.** User names a listed option → resolves. "You pick" / "whatever" → does NOT resolve; fall through to `AskUserQuestion`.
- **No substitute when import fails.** `import skrub` fails → install, not `sklearn.Pipeline`. `import skore` fails → install, not `cross_val_score`. Surface the dep, invoke this skill, wait for confirmation.
- **Wrong-manager install forbidden.** Mixing managers creates untracked state.
- **No silent bootstrap.** Detection finds nothing → ask user. Default suggestion: pixi.
- **Dependency routing fixed, not asked.** 3-feature layout (`default`/`dev`/`agent`) enforced. `G-ENV-SCOPE` fires **only** for ambiguous extras.
- **Don't pin without reason.** Install unpinned by default. Exception: `skore`/`skrub` latest always, `mlflow>=3`.
- **Don't run bootstrap installer yourself.** Surface command, let user run it.
- **Harness hints do not waive gates:** `ml-conventions:references/shared-ml-conventions.md`.
- **Post-hoc audit.** Walk pre-flight, confirm every box has `Evidence:`.

## When to invoke

Three triggers: (1) a stack library import fails → install, never substitute. (2) a library choice has to be made (tabular, DL, plotting, serving, …). (3) manager detection / package routing / install.

## Library tiers

Full catalog with per-library scope and tradeoffs: `references/library-catalog.md`.

| Tier | Scope | Libraries |
|---|---|---|
| **1 — Mandatory** | Installed at project start, no exceptions | scikit-learn, skrub, skore, ruff, pytest |
| **2 — Competing** | User picks via AskUserQuestion | tabular DL, plotting, serving, experiment tracking |
| **3 — Optional** | Install on demand | interactive viz, reporting |
| **4 — Transitive** | Already pulled in, don't install | (e.g. by skore) |

**Agent feature (orthogonal):** `ipython` + `pyright` — agent-only tooling for audit cell runner and LSP. Install owned by § Agent feature install. Not Tier 1–4.

## Forbidden shortcuts

| Shortcut | Why |
|---|---|
| Calling skill writes own `pixi add --feature agent ...` | Install commands owned by this skill |
| Agent feature install → also register Jupyter kernel | Orphan kernelspec |
| Urgency waives G-ENV-MGR | Never |
| Opened earlier → assume gates passed | Reading ≠ firing |
| User said "install ruff" → fire G-ENV-SCOPE | Routing fixed: ruff/pytest/ipykernel → `dev` |

## Pre-flight

```
Pre-flight (python-stack-env):
- [ ] Detection done; manager: <pixi | uv | poetry | hatch | conda | pip+venv | none>
- [ ] G-ENV-MGR resolved
- [ ] Dep category determined for each package
- [ ] G-ENV-SCOPE resolved ONLY for ambiguous extras
- [ ] Tier 1/2/3 classification done for contested libraries
- [ ] Install command syntax confirmed (references/install-commands.md)
- [ ] Package list ready
- [ ] (Agent-feature only) G-AGENT-FEATURE + pyrightconfig.json
- [ ] Pre-flight re-emitted with evidence
```

Evidence format: `ml-conventions:references/shared-preflight-evidence.md`.

## Detection — first signal wins

| Signal | Manager |
|---|---|
| `pixi.toml` / `pixi.lock` | pixi |
| `uv.lock` / `[tool.uv]` | uv |
| `poetry.lock` / `[tool.poetry]` | poetry |
| `hatch.toml` / `[tool.hatch]` | hatch |
| `environment.yml` + conda/mamba | conda / mamba |
| `requirements.txt` + `.venv/` | pip + venv |
| None | ask (suggestion: pixi) |

`pyproject.toml` with only `[build-system]` is ambiguous → ask. Multiple signals → surface ambiguity. Edge cases: `references/ambient_detection.md`.

## Gates

`G-ENV-MGR`, `G-ENV-SCOPE`, `G-AGENT-FEATURE` — fire conditions and `AskUserQuestion` shapes in `references/gates.md`.

## Package routing

Fixed 3-feature layout (`default`/`dev`/`agent`/`lsp`): `references/placement.md`. Why: `references/composition_model.md`.

## Install commands

Per-manager tables: `references/install-commands.md`. Run prefixes (`<env-prefix>`, `<agent-env-prefix>`): `references/env_prefixes.md`.

## Agent feature install

`ipython` + `pyright` + `pyrightconfig.json`. Run bundled script for detected manager: `scripts/install_agent_feature_{manager}.sh`. Anatomy: `references/agent_feature_anatomy.md`. Footguns: `references/per_manager_footguns.md`.

## skore variant per mode

Read `skore mode:` from JOURNAL.md Status. Table by mode × source: `references/skore_variant.md`. `mlflow` variant must pin `mlflow>=3`. If row absent → route back to `iterate-ml-experiment` § 0.5 (G-SKORE-MODE).

## macOS post-install

skrub installed on macOS → run `dot -c` once in project env (rebuilds graphviz cache). Details: `references/platform-notes.md`.

## Bootstrap

Detection found nothing + user picked pixi: `pixi init` → features + envs → Tier 1 deps → tabular lib → editable workspace → `pyrightconfig.json` → sync. Full steps: `references/bootstrap.md`.

## Conventions

- One install operation per response. Group and confirm.
- No `--no-deps` or version pins by default. Exception: `skore`/`skrub` latest, `mlflow>=3`.
- One tool per job. Don't add a second library for a covered task.
- Surface errors; don't switch managers.

## Ownership

| Decision | Owner |
|---|---|
| Library tiers, competing-library contract, ruff/NumPyDoc config | this skill (`templates/ruff.toml`, `references/ruff.md`) |
| Manager + feature scope + install command syntax | this skill |
| skore mode variant | `iterate-ml-experiment` decides mode; this skill executes |
| Gate registry wording | `ml-conventions` |
