---
name: python-env-manager
description: Use when no environment manager is detected in a Python project, or a package must be routed to the right feature (dev/agent/default) for install.
---

## Next-step pointers

| Came here from… | After install, next is… |
|---|---|
| `ml-scaffold` § scaffold | → editable workspace package |
| `evaluate-ml-pipeline` § Audit | → place `audit/<stem>.py` |
| `build-ml-pipeline` / `evaluate-ml-pipeline` § missing dep | → continue at failing pre-flight box |
| `data-science-python-stack` § Missing dependency | → caller; import should now succeed |

## Stop conditions

- **Wrong-manager install forbidden.** Mixing managers creates untracked state.
- **No silent bootstrap.** Detection finds nothing → ask user. Default suggestion: pixi.
- **Dependency routing fixed, not asked.** 3-feature layout (`default`/`dev`/`agent`) enforced. `G-ENV-SCOPE` fires **only** for ambiguous extras.
- **Don't pin without reason.** Install unpinned by default.
- **Don't run bootstrap installer yourself.** Surface command, let user run it.
- **Harness hints do not waive `AskUserQuestion` mandates.**
- **Post-hoc audit.** Walk pre-flight, confirm every box has `Evidence:`.

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
Pre-flight (python-env-manager):
- [ ] Detection done; manager: <pixi | uv | poetry | hatch | conda | pip+venv | none>
- [ ] G-ENV-MGR resolved
- [ ] Dep category determined for each package
- [ ] G-ENV-SCOPE resolved ONLY for ambiguous extras
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

`ipython` + `pyright` + `pyrightconfig.json`. Run bundled script for detected manager: `.github/skills/python-env-manager/scripts/install_agent_feature_{manager}.sh`. Anatomy: `references/agent_feature_anatomy.md`. Footguns: `references/per_manager_footguns.md`.

## skore variant per mode

Read `skore mode:` from JOURNAL.md Status. Table by mode × source: `references/skore_variant.md`. `mlflow` variant must pin `mlflow>=3`. If row absent → route back to `ml-scaffold` § G-SKORE-MODE.

## macOS post-install

skrub installed on macOS → run `dot -c` once in project env (rebuilds graphviz cache). Details: `references/platform-notes.md`.

## Bootstrap

Detection found nothing + user picked pixi: `pixi init` → features + envs → Tier 1 deps → tabular lib → editable workspace → `pyrightconfig.json` → sync. Full steps: `references/bootstrap.md`.

## Conventions

- One install operation per response. Group and confirm.
- No `--no-deps` or version pins by default. Exception: `skore`/`skrub` latest, `mlflow>=3`.
- Surface errors; don't switch managers.

## Ownership

| Decision | Owner |
|---|---|
| What library, why | `data-science-python-stack` |
| Manager + feature scope | this skill |
| ruff/NumPyDoc config | this skill (`templates/ruff.toml`) |
| Install command syntax | this skill |
| skore mode variant | `ml-scaffold` decides mode; this skill executes |
| Tier 1 vs 2 vs 3 | `data-science-python-stack` |
