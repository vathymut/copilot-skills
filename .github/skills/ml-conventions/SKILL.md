---
name: ml-conventions
description: Use when authoring or running ML workflow skills (`data-science-python-stack`, `ml-scaffold`, `build-ml-pipeline`, `evaluate-ml-pipeline`, `iterate-ml-experiment`, `ml-eda`, `python-api`, `python-env-manager`) that share cross-cutting rules — ruff config, the scratch/ execution rule, harness-hint handling, the missing-dependency contract, the workspace gate registry, and the pre-flight evidence format. Other ML skills name the rule and point here instead of restating it.
---

# ML Conventions

Single source of truth for the rules repeated across the ML experiment
skills. Each ML skill names a rule and points here; this skill owns the
wording so the cluster stays consistent and each consuming skill stays
self-contained.

## When to use

- An ML skill needs the ruff/scratch/harness-hint/missing-dependency
  wording — point to `references/shared-ml-conventions.md` instead of
  restating.
- An ML skill needs the canonical list of workspace gates (G-PKG-NAME,
  G-ENV-MGR, G-TABULAR, G-SKORE-MODE, G-EDA, G-DESIGN, G-CV-SPLITTER,
  G-RUN) and their owners — point to `references/ml-gates.md`.
- An ML skill's pre-flight checklist needs the shared `Evidence:` row
  contract — point to `references/shared-preflight-evidence.md`.

## When NOT to use

- Standalone Python projects with no ML-experiment workflow — the
  cross-cutting rules do not apply.
- A skill's own domain boxes (which gate fires when) — each consuming
  skill keeps its own checklist; only the format lives here.

## Reference map

| Reference | Owns | Consumed by |
|---|---|---|
| `references/shared-ml-conventions.md` | Ruff, scratch/ execution, harness hints, missing-dependency contract, config-gate ownership | every ML skill |
| `references/ml-gates.md` | Canonical gate names, owners, valid answers, immutability & harness-override rules | `ml-scaffold`, `ml-eda`, `build-ml-pipeline`, `evaluate-ml-pipeline`, `iterate-ml-experiment` |
| `references/shared-preflight-evidence.md` | Pre-flight `Evidence:` row shapes + re-emission rule | `iterate-ml-experiment`, `python-env-manager` |

## Common mistakes

- **Restating a rule inside a consuming skill.** Creates sediment and
  drift. Point here instead.
- **Treating a harness hint as a gate waiver.** See
  `references/shared-ml-conventions.md` § Harness hints —
  `AskUserQuestion` gates are part of the operating contract, not
  discretionary clarifications.
- **Inventing a new gate name.** Add to `references/ml-gates.md` first;
  do not silently introduce a `G-*` constant in a consuming skill.