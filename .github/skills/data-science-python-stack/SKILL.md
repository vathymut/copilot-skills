---
name: data-science-python-stack
description: Use when a Python import fails in a data-science or ML project, or when the stack offers two or more libraries for one job (tabular DL, plotting, serving) and a choice is needed.
---

# Data Science Python Stack

Opinionated stack — one library per job, four tiers plus agent feature:

## Stop conditions

- **No silent pick on a competing-library job.** Two+ libraries for the same job → `AskUserQuestion` before any import or install. Persist answer in `journal/JOURNAL.md` Status `Workspace decisions`. No silent default — "already pulled in transitively", "quick", "no preference" are NOT waivers.
- **Free-text resolution.** User names a listed option → resolves. "You pick" / "whatever" → does NOT resolve; fall through to `AskUserQuestion`.
- **No substitute when import fails.** `import skrub` fails → install, not `sklearn.Pipeline`. `import skore` fails → install, not `cross_val_score`. Surface the dep, invoke `python-env-manager`, wait for confirmation.
- **Harness hints do not waive gates.** See `ml-conventions:references/shared-ml-conventions.md`.
- **Post-hoc audit.** Verify each competing-library job invoked this turn has an `AskUserQuestion` answer or `Workspace decisions` row. Surface non-compliance.

## Competing libraries — general rule

Whenever the stack offers two+ libraries for one job:
1. `AskUserQuestion` before any import or install.
2. Persist in JOURNAL.md Status — re-read on future sessions, don't re-ask.
3. No silent default.
Every row in the Tier 2 table must name an explicit `Default-on-no-preference`.

## When to invoke

Two triggers: (1) a stack library import fails → install, never substitute. (2) a library choice has to be made (tabular, DL, plotting, serving, …).

## Library tiers

Full catalog with per-library scope and tradeoffs: `references/library-catalog.md`.

| Tier | Scope | Libraries |
|---|---|---|
| **1 — Mandatory** | Installed at project start, no exceptions | scikit-learn, skrub, skore, ruff, pytest |
| **2 — Competing** | User picks via AskUserQuestion | tabular DL, plotting, serving, experiment tracking |
| **3 — Optional** | Install on demand | interactive viz, reporting |
| **4 — Transitive** | Already pulled in, don't install | (e.g. by skore) |

## Agent feature (orthogonal)

`ipython` + `pyright` — agent-only tooling for audit cell runner and LSP. Install owned by `python-env-manager` § Agent feature. Not Tier 1–4.

## Conventions

- **Ownership split.** This skill = *what* and *why*. `python-env-manager` = *how* (manager detection, command syntax, feature scope).
- **Versions:** don't pin. Exception: `skore` and `skrub` must always be latest.
- **One tool per job.** Don't add a second library for a covered task.
- **`skore` / `skrub` latest always.** `mlflow>=3` pinned for skore mlflow mode.
