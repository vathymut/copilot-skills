---
name: python-stack-env
description: Use when a Python import fails or you need to choose between competing libraries (plotting, serving, tabular DL) or route a package to the correct feature (dev/agent/default).
---

# Python Stack & Environment Manager

Opinionated Python stack (one library per job) **and** environment management (manager detection, feature routing, install commands). This skill owns *what*, *why*, and *how*; detailed contracts live in the reference map below.

## When NOT to use

- Need API signature/docstring for an already-installed package — use `python-api`.
- Need to read/query a data file — use `data-access`.
- Building/deploying a non-Python service.


## Gates (one-line)

| Gate | Owner | Meaning |
|---|---|---|
| G-PKG-NAME | `iterate-ml-experiment` §0.5 | Python package name |
| G-ENV-MGR | `python-stack-env` | Env manager (pixi/uv/poetry/…) |
| G-TABULAR | `iterate-ml-experiment` §0.5 | `pandas` vs `polars` |
| G-SKORE-MODE | `iterate-ml-experiment` §0.5 | `local`/`hub`/`mlflow` |
| G-EDA | `ml-eda` / `iterate-ml-experiment` §0 | `run`/`skip` |
| G-DESIGN | `iterate-ml-experiment` §3 | Design note approved? |
| G-CV-SPLITTER | `evaluate-ml-pipeline` §Evaluate | Splitter derived from `split_kwargs` |
| G-RUN | `iterate-ml-experiment` §3 | Run now vs leave for later |

Full wording: `ml-conventions:references/ml-gates.md`. Harness hints never waive `AskUserQuestion` gates.

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
- **Wrong-manager install forbidden.** Mixing managers creates untracked state. Don't run the bootstrap installer yourself — surface the command, let the user run it.
- **No silent bootstrap.** Detection finds nothing → ask user. Default suggestion: pixi.
- **Routing fixed, not asked.** 3-feature layout (`default`/`dev`/`agent`) enforced; `G-ENV-SCOPE` fires **only** for ambiguous extras — never for `ruff`/`pytest`/`ipykernel` (→ `dev`).
- **Don't pin without reason.** Install unpinned by default. Exception: `skore`/`skrub` latest always, `mlflow>=3`.
- **Agent feature install does not register a Jupyter kernel** (orphan kernelspec).
- **Opened earlier ≠ gates passed.** Reading this skill is not firing it.
- **Harness hints do not waive gates:** `ml-conventions:references/shared-ml-conventions.md`.
- **Post-hoc audit.** Walk pre-flight, confirm every box has `Evidence:`.
- **Harness / non-interactive default.** When `AskUserQuestion` cannot run (CI/harness), use non-interactive defaults: `matplotlib` for plotting, `FastAPI` for serving, `skrub`/`sklearn` for tabular, and persist the choice in `journal/JOURNAL.md` with `source: harness-default` (do not treat as user approval).

## Library tiers

Full catalog with per-library scope and tradeoffs: `references/library-catalog.md`.

| Tier | Scope | Libraries |
|---|---|---|
| **1 — Mandatory** | Installed at project start, no exceptions | scikit-learn, skrub, skore, ruff, pytest |
| **2 — Competing** | User picks via AskUserQuestion | tabular DL, plotting, serving, experiment tracking |
| **3 — Optional** | Install on demand | interactive viz, reporting |
| **4 — Transitive** | Already pulled in, don't install | (e.g. by skore) |

**Agent feature (orthogonal):** `ipython` + `pyright` — agent-only tooling for audit cell runner and LSP. Install owned by Agent feature install (§ map below). Not Tier 1–4.

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

## Reference map

| Reference | Owns |
|---|---|
| `references/ambient_detection.md` | Detection edge cases (ambiguous `pyproject.toml`, multiple signals). Base detection: first signal wins — pixi → uv → poetry → hatch → conda → pip+venv → none (ask) |
| `references/gates.md` | `G-ENV-MGR`, `G-ENV-SCOPE`, `G-AGENT-FEATURE` — fire conditions + `AskUserQuestion` shapes |
| `references/placement.md` | Fixed 3-feature layout (`default`/`dev`/`agent`/`lsp`) |
| `references/composition_model.md` | Why the 3-feature layout |
| `references/install-commands.md` | Per-manager install tables |
| `references/env_prefixes.md` | Run prefixes (`<env-prefix>`, `<agent-env-prefix>`) |
| `references/agent_feature_anatomy.md` | Agent feature install (`scripts/install_agent_feature_{manager}.sh`); footguns: `references/per_manager_footguns.md` |
| `references/skore_variant.md` | skore mode × source table. Read `skore mode:` from JOURNAL.md Status; `mlflow` variant pins `mlflow>=3`; row absent → back to `iterate-ml-experiment` § 0.5 (G-SKORE-MODE) |
| `references/platform-notes.md` | macOS post-install: skrub → run `dot -c` once in project env |
| `references/bootstrap.md` | Full pixi bootstrap (init → features → Tier 1 → tabular → editable workspace → pyrightconfig → sync) |
| `references/editable_workspace.md` | Editable workspace package (post-scaffold) |
| `references/ruff.md` | Ruff rationale + config (`templates/ruff.toml`) |
| `ml-conventions:references/shared-ml-conventions.md` | Cross-cutting rules: scratch/, harness hints, missing-dep contract, gate ownership |

## Ownership

| Decision | Owner |
|---|---|
| Library tiers, competing-library contract, ruff/NumPyDoc config | this skill (`templates/ruff.toml`, `references/ruff.md`) |
| Manager + feature scope + install command syntax | this skill |
| skore mode variant | `iterate-ml-experiment` decides mode; this skill executes |
| Gate registry wording | `ml-conventions` |

## Related skills

- `python-api` — verify symbols after install.
- `iterate-ml-experiment` — delegates G-ENV-MGR here.
- `ml-eda` — delegate agent feature install.

## Completion criteria

- [ ] Manager detected (`pixi→uv→poetry→...→none`); `G-ENV-MGR` resolved
- [ ] Tier classification correct; competing libs gated via `AskUserQuestion` (or harness default noted)
- [ ] Install command surfaced (not run if bootstrap); rerun pre-flight with `Evidence:`
