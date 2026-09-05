---
name: ml-conventions
description: Use when authoring a new ML skill that needs shared gates, ruff/scratch conventions, or the ML pre-flight evidence contract.
---

> **Reference skill — not model-invoked.** This skill never auto-triggers on user tasks. Other ML skills load it via `ml-conventions:references/...` context pointers. Invoke directly only when authoring a new ML skill. Excluded from model routing; counts as 1 of 37 dirs but 0 of 36 auto-trigger skills.

## When NOT to use

- You are implementing a feature — consume this via `ml-conventions:references/...` from `iterate-ml-experiment`/`build-ml-pipeline` etc., not directly.
- You are the model routing a user task — this skill never auto-triggers.

# ML Conventions — Reference

Single source of truth for the rules repeated across the ML experiment
skills. Each ML skill names a rule and points here; this skill owns the
wording so the cluster stays consistent and each consuming skill stays
self-contained.

## Reference map

| Reference | Owns | Consumed by |
|---|---|---|
| `references/shared-ml-conventions.md` | Ruff, scratch/ execution, harness hints, missing-dependency contract, config-gate ownership | every ML skill |
| `references/ml-gates.md` | Canonical gate names, owners, valid answers, immutability & harness-override rules | `iterate-ml-experiment`, `ml-eda`, `build-ml-pipeline`, `evaluate-ml-pipeline` |
| `references/shared-preflight-evidence.md` | Pre-flight `Evidence:` row shapes + shared boxes + re-emission rule | `build-ml-pipeline`, `evaluate-ml-pipeline`, `ml-eda`, `iterate-ml-experiment`, `python-stack-env` |

## Conventions

### Ruff / scratch / harness hints / missing-dependency
See `references/shared-ml-conventions.md`. Do not restate these rules in consuming skills.

### Workspace gates
Canonical gates: G-PKG-NAME, G-ENV-MGR, G-TABULAR, G-SKORE-MODE, G-EDA, G-DESIGN, G-CV-SPLITTER, G-RUN.
See `references/ml-gates.md` for owners, valid answers, immutability, and harness-override rules.

### Pre-flight evidence
The shared `Evidence:` row contract is in `references/shared-preflight-evidence.md`.

## Common mistakes

- **Restating a rule inside a consuming skill.** Creates sediment and
  drift. Point here instead.
- **Treating a harness hint as a gate waiver.** See
  `references/shared-ml-conventions.md` § Harness hints —
  `AskUserQuestion` gates are part of the operating contract, not
  discretionary clarifications.
- **Inventing a new gate name.** Add to `references/ml-gates.md` first;
  do not silently introduce a `G-*` constant in a consuming skill.
## Related skills

- `iterate-ml-experiment` — primary consumer of gates.
- `build-ml-pipeline` / `evaluate-ml-pipeline` / `ml-eda` / `python-stack-env` / `python-api` — gate consumers.

## Completion criteria

- [ ] Consuming skill points here instead of restating rule
- [ ] No new `G-*` invented without updating `references/ml-gates.md`
