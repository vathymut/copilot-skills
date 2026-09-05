---
name: ml-conventions
---

> **This is a reference document consumed by other ML skills — not a standalone workflow.**
> No `description` — this skill is **user-invoked only** (zero context load). Other ML skills load it via `ml-conventions:references/...` context pointers. Do not invoke directly unless authoring a new ML skill.

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