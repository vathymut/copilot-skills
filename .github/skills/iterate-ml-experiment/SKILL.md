---
name: iterate-ml-experiment
description: Use when managing the ML experiment loop — proposing the next experiment, recording a finished run, or comparing and pivoting experiments in an ml-scaffold workspace.
---

# Iterate ML Experiment

The loop on top of `experiments/`: what to try next, why, what counts as a result, how the trail is recorded.

## Flow at a glance

| Signal | Mode | Section |
|---|---|---|
| JOURNAL.md missing / placeholder / 0 History rows | Bootstrap | § 0 |
| Not scaffolded (no `src/`, no `experiments/`) | Bootstrap → handoff | → `ml-scaffold`, then § 0 |
| "what's next?" / "let's iterate" with ≥1 done row | Iterate (propose) | §§ 1–3 |
| User names a Backlog row (`B2`) | Promote directly | → § 3 (no strategy skill) |
| "mine the report" / "what does skore see?" | Skore source | `references/source-from-skore.md` |
| "I want to try X" / article URL / issue | User source | `references/source-from-user.md` |
| "give me ideas" / "you decide" | My-pick inline | AskUserQuestion, draft design note |
| Open-ended "what's next?" | Present sourcing menu | `references/sourcing-menu.md` |
| "the run finished" / "log the result" | Iterate (record) | § 4 |
| "where are we?" / "status?" / "compare X Y" | Read-only | `references/maintenance_modes.md` |
| "let's pivot" / "abandon X" / "re-run X" | Pivot / Abandon | `references/maintenance_modes.md` |

If two modes seem to match, pick the **read** mode first. Re-entering § 1 is a separate turn.

## First action

1. Read `journal/JOURNAL.md`. Missing/placeholder → § 0.
2. Check `Workspace decisions` block for pre-recorded gates.
3. Emit Pre-flight.

## Stop conditions

- **No design note, no script.** Never create `experiments/NN_*.py` until `journal/NN_*.md` is approved.
- **JOURNAL.md read at session start, not improvised.**
- **Strategy is picked, not assumed.** Name it in every proposal.
- **Approval is explicit.** Ambiguous → re-ask. Never silent yes.
- **Outcomes recorded, not narrated.** Land in JOURNAL.md + Status.
- **Prior experiments stay reproducible.** Smoke test going red = broken.
- **After G-DESIGN, dispatch in order:** `build-ml-pipeline` → `evaluate-ml-pipeline` § Evaluate → § Smoke → assemble `experiments/NN_*.py`.
- **Harness hints do NOT waive gates.**
- **Post-hoc audit required before end of turn.**

## Pre-flight

```
Pre-flight (iterate-ml-experiment):
- [ ] Mode: bootstrap | iterate-propose | iterate-record | read-only
- [ ] Last experiment + status: <NN_name> | n/a — bootstrap
- [ ] (Bootstrap) Config gates fired: G-PKG-NAME, G-ENV-MGR, G-TABULAR, G-SKORE-MODE
- [ ] (Bootstrap) G-EDA fired: run / skip
- [ ] Design note drafted or Backlog enriched
- [ ] G-DESIGN: user approved
- [ ] (§ 3) Build → evaluate → smoke chain ran
- [ ] (§ 3) G-CV-SPLITTER resolved; G-RUN resolved
- [ ] (§ 4) Status + JOURNAL row + Backlog + audit
- [ ] python-api consulted for any new symbol
- [ ] Pre-flight re-emitted with evidence before final message.
```

## § 0 Bootstrap (first session)

`JOURNAL.md` missing/placeholder/0 History rows. Full procedure: `references/bootstrap.md`.

1. Scaffold first if needed (no `src/`/`experiments/`/`journal/`) → `ml-scaffold`, return when placeholder exists.
2. Rewrite `JOURNAL.md` from `templates/JOURNAL.md`.
3. Derive goal from `data/README.md`; propose one sentence.
4. G-EDA: dispatch `ml-eda`. Gate: run / skip (skip records `Status: skipped`).
5. Auto-draft `journal/01_baseline.md` (learner default, metric default). Do NOT fix splitter.
6. User approves or amends — not invent.
7. Exit once baseline approved. Audit lands at § 4.

**Bootstrap skips sourcing menu — NOT config gates.** Gate table (G-PKG-NAME, G-ENV-MGR, G-TABULAR, G-SKORE-MODE, G-EDA, G-AGENT-FEATURE, G-DESIGN, G-CV-SPLITTER, G-RUN): `references/bootstrap.md`. Free-text "quick baseline" / "you pick" do NOT resolve any gate.

## § 1 Session start (iterate mode)

Read JOURNAL.md. Summarize dataset/goal/last experiment/Backlog (2–3 lines). Ask: **resume** (last still planned), **record outcome** (last ran → § 4), or **propose next** (last done/abandoned → § 2).

## § 2 Propose next experiment

Surface sourcing menu verbatim (`references/sourcing-menu.md`). Branches:
- **`skore`** → `references/source-from-skore.md`. No design note this turn.
- **`user`** → `references/source-from-user.md`. Output: Proposal block. Draft into `journal/NN_short_name.md`.
- **`my-pick`** → inline: AskUserQuestion with 2–4 candidates. Draft on pick.
- **`B<N>`** → promote row, remove from Backlog on approval.

Use `templates/experiment_design.md`. `NN` = next free int; `short_name` = user's call.

## § 3 Design note + implement

- Surface draft (path + 3–5 line summary). Edit in place. Final approval: `AskUserQuestion` — **approved** → flip status, add History row, dispatch. **more changes** → loop.
- Do **not** create `experiments/NN_*.py` during iteration.

### Implementation chain (non-skippable, in order)

1. `build-ml-pipeline` → `src/<pkg>/{pipeline,features,data}.py`
2. `evaluate-ml-pipeline` § Evaluate → `src/<pkg>/evaluate.py` + `experiments/NN_<short_name>.py` (owns G-CV-SPLITTER)
3. `evaluate-ml-pipeline` § Smoke → `tests/smoke/test_NN_<short_name>.py`

Confirm signatures via `python-api`, not memory.

### G-RUN — post-smoke run gate

`tests/smoke/` passes (new + prior) → `AskUserQuestion`: **run now** (`<env-prefix> python experiments/NN_<short_name>.py`) or **leave for later** (surface Status + Backlog). Completed this turn → § 4.

## § 4 Record outcome

**Trigger:** user says "the run finished" / "log it", or agent ran experiment (G-RUN = run now). Do NOT auto-detect via mtime.

Full procedure: `references/record_outcome.md`.

1. Audit-first: `evaluate-ml-pipeline` § Audit → read digest.
2. Fill Status: State (done/abandoned), Approved by, Headline result, Implication.
3. Smoke-test gate: all `tests/smoke/` must pass before `done`.
4. Append headline to JOURNAL.md History.
5. Backlog hygiene: delete/strikethrough resolved.
6. (Opt-in) GitHub issue close-the-loop — ask.

Stop. Surface implication → ask: **draft it now** (re-enter § 1) or **not yet** (record in Backlog).

## Files and pairing rule

Four-way hard pairing: `journal/NN_<short_name>.md` ↔ `experiments/NN_<short_name>.py` ↔ `tests/smoke/test_NN_<short_name>.py` ↔ `audit/NN_<short_name>.py`, identical stems. Shapes: `references/journal-shape.md`.

## What this skill does NOT do

Run experiments, explore data (`ml-eda`), edit pipeline code (`build-ml-pipeline`), decide layout (`ml-scaffold`), write commits/PRs, or pick sourcing strategy for the user.

## Companion skills

- `ml-scaffold` — layout + stem-pairing
- `ml-eda` — bootstrap EDA
- `build-ml-pipeline` / `evaluate-ml-pipeline` — implementation chain
- `evaluate-ml-pipeline` § Audit — § 4 digest
- `python-api` / `python-env-manager` — symbols, installs, agent feature

## References

- `references/bootstrap.md` — full bootstrap + config gate table
- `references/sourcing-menu.md` — sourcing menu verbatim
- `references/source-from-skore.md` — skore source branch
- `references/source-from-user.md` — user source branch
- `references/record_outcome.md` — full § 4 procedure
- `references/maintenance_modes.md` — compare/pivot/abandon/re-run
- `references/journal-shape.md` — artifact shapes
- `references/forbidden-shortcuts.md` — common violations
- `ml-conventions:references/shared-preflight-evidence.md` — evidence format

## Templates

- `templates/JOURNAL.md` — index skeleton
- `templates/experiment_design.md` — design note with Status block. Copy, don't rewrite.
