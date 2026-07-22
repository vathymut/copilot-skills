---
name: iterate-ml-experiment
description: Use when managing the ML experiment loop — proposing the next experiment, recording a finished run, or comparing and pivoting experiments in an ml-scaffold workspace.
---

# Iterate ML Experiment

The loop on top of `experiments/`: what to try next, why, what
counts as a result, how the trail is recorded. Pipeline / evaluation
mechanics live in sibling skills.

## Next-step pointers — flow at a glance

```
session open
   │
   ├── JOURNAL.md missing / placeholder ──► § 0 Bootstrap
   │                                          │
   │                                          ├─► G-EDA (ml-eda: run | skip)
   │                                          │
   │                                          └─► design note → G-DESIGN → § 3 implement
   │
   ├── "what's next?" with ≥1 done row ───► § 1 → § 2 (sourcing) → § 3 implement
   │
   ├── "run finished" ─────────────────────► § 4 record outcome
   │                                          │
   │                                          └─► dispatch evaluate-ml-pipeline § Audit
   │
   └── "status?" / "compare X Y" ──────────► references/maintenance_modes.md
```

## First action — read state

Open sibling SKILL.md **just-in-time** when a step calls for it.
Then:

1. **Read `journal/JOURNAL.md`.** Missing/placeholder → bootstrap (§ 0).
2. **Check `Workspace decisions` block** for pre-recorded gates.
3. **Emit the Pre-flight checklist** with each box filled.
4. **Use the Mode picker** to find which section to read.

## Mode picker — read this before navigating the body

You read **one** mode section per turn. Match the user's signal,
then jump.

| Signal / workspace state | Mode | Section |
|---|---|---|
| `JOURNAL.md` missing / placeholder / 0 History rows | **Bootstrap** | § 0 |
| Not scaffolded (no `src/`, no `experiments/`) | **Bootstrap → handoff** | → `ml-scaffold`, then § 0 |
| "what's next?" / "let's iterate" with ≥1 done row | **Iterate (propose)** | §§ 1–3 + Dispatch table |
| "the run finished" / "log the result" | **Iterate (record)** | § 4 |
| "where are we?" / "status?" | **Project overview** | `references/maintenance_modes.md` |
| "compare X and Y" / "X vs Y" | **Compare (read-only)** | `references/maintenance_modes.md` |
| "let's pivot" / "abandon X" / "re-run X" | **Pivot / Abandon / Re-run** | `references/maintenance_modes.md` |

If two modes seem to match ("compare X and Y, then propose"), pick
the **read** mode first, stop. Re-entering § 1 is a separate turn.

## Stop conditions — read before anything else

- **No design note, no script.** Never create/edit
  `experiments/NN_*.py` until `journal/NN_*.md` is filled and
  approved.
- **JOURNAL.md is read at session start, not improvised.**
- **Strategy is picked, not assumed.** Name it in every proposal.
  Exception: bootstrap — baseline forced by defaults.
- **Approval is explicit.** Ambiguous → re-ask. Never silent yes.
- **Outcomes are recorded, not narrated.** Land in JOURNAL.md AND
  Status block before moving on.
- **Prior experiments stay reproducible.** Touching `src/<pkg>/`
  preserves existing shape. Smoke test going red = broken.
- **After G-DESIGN, dispatch in order:** `build-ml-pipeline` →
  `evaluate-ml-pipeline` § Evaluate → `evaluate-ml-pipeline` § Smoke.
  Only then assemble `experiments/NN_*.py`.
- **Harness hints do NOT waive gates.** See
  `ml-conventions:references/shared-ml-conventions.md` (Harness hints) for the
  single-source wording.
- **Post-hoc audit required** before ending the turn.

## Pre-flight — emit before any design-note write

Compact checklist. Evidence-format spec:
`ml-conventions:references/shared-preflight-evidence.md`.

```
Pre-flight (iterate-ml-experiment):
- [ ] Mode: bootstrap | iterate-propose | iterate-record | read-only
- [ ] Last experiment + status: <NN_name> | n/a — bootstrap
- [ ] (Bootstrap) Config gates fired: G-PKG-NAME, G-ENV-MGR,
      G-TABULAR, G-SKORE-MODE
- [ ] (Bootstrap) G-EDA fired: run / skip
- [ ] Design note drafted or Backlog enriched
- [ ] G-DESIGN: user approved
- [ ] (§ 3) Build → evaluate → smoke chain ran
- [ ] (§ 3) G-CV-SPLITTER resolved at evaluate step
- [ ] (§ 3) G-RUN resolved: run now | leave for later
- [ ] (§ 4) Artifacts: Status + JOURNAL row + Backlog + audit
- [ ] python-api consulted for any new symbol
- [ ] Pre-flight re-emitted with evidence before final message.
```

## § 0 Bootstrap (first session only)

Workspace is in bootstrap mode when `journal/JOURNAL.md` is missing,
placeholder, or has 0 History rows. Full procedure:
`references/bootstrap.md`.

1. **Scaffold first if needed.** No `src/` / `experiments/` /
   `journal/` → hand off to `ml-scaffold`, return when
   the placeholder `JOURNAL.md` exists.
2. **Rewrite `JOURNAL.md` from `templates/JOURNAL.md`**.
3. **Derive the goal default from `data/README.md`** *before*
   asking. Propose one sentence; user confirms or amends.
4. **Explore the data BEFORE designing the model (G-EDA).** Dispatch
   to `ml-eda`. Gate: **run** / **skip**. Skip records `Status: skipped`.
5. **Auto-draft `journal/01_baseline.md`** informed by EDA findings:
   learner default (`build-ml-pipeline`), metric default
   (`python-api`). **Do NOT fix a splitter** — CV strategy decided
   at evaluation step (`G-CV-SPLITTER`). Conflicts → flag in
   **Risks**.
6. **User's role in bootstrap is approve or amend** — not invent.
7. **Exit bootstrap** once the baseline is approved and recorded.
   Audit file lands at first § 4 record-outcome.

### Bootstrap skips the sourcing menu — NOT the config gates

**Skipped**: sourcing menu, § 1 resume/record/propose pick.

**Still fires**:

| Gate ID | Picks | Owner | When |
|---|---|---|---|
| `G-PKG-NAME` | `src/<pkg>/` name | `ml-scaffold` | before manifest |
| `G-ENV-MGR` | Env manager | `python-env-manager` | before install |
| `G-TABULAR` | Tabular library | `data-science-python-stack` | before `data.py` |
| `G-SKORE-MODE` | Skore Project mode + URI | `ml-scaffold` | before `pyproject.toml` |
| `G-EDA` | Run / skip | `ml-eda` | before baseline draft |
| `G-AGENT-FEATURE` | Install ipython + pyright | `python-env-manager` | conditional (G-EDA=run) |
| `G-DESIGN` | Approve baseline note | this skill | before § 3 chain |
| `G-CV-SPLITTER` | CV family | `evaluate-ml-pipeline` | inside § 3, after G-DESIGN |
| `G-RUN` | Run now / later | this skill | before execution |

Free-text "quick baseline" / "you pick" do NOT resolve any of
these — fall through to structured `AskUserQuestion`.

→ next: G-DESIGN, then § 3 implementation chain.

## § 1 Session start (iterate mode)

- Read `JOURNAL.md`. Summarize: dataset, goal, last experiment,
  what's ripe in Backlog (2–3 lines).
- **Ask** — three options, no silent default: **resume** (last
  experiment still planned/approved), **record outcome** (last ran;
  → § 4), **propose next** (last done/abandoned; → § 2).

## § 2 Propose the next experiment

Surface the **sourcing menu verbatim** and handle free-text picks exactly
as specified in `references/sourcing-menu.md` — load it when § 2 runs.

### Branches

- **`skore`** → run § "Source from skore". Returns Backlog-candidate
  rows + summary. Re-present sourcing menu. *No design note.*
- **`user`** → run § "Source from user". Returns a Proposal. Draft into
  `journal/NN_short_name.md`.
- **`my-pick`** → inline. Synthesize 2-4 candidates via
  `AskUserQuestion`. Draft the design note on pick.
- **`B<N>`** → promote the row. Remove from Backlog on approval.

For `user` / `my-pick` / `B<N>`: write draft to
`journal/NN_short_name.md` using `templates/experiment_design.md`.
`NN` is the next free integer; `short_name` is the user's call.

→ next: § 3.

## § 2a Source from skore

Read the audit digest at `scratch/audit/<stem>/audit.md` (produced by
`evaluate-ml-pipeline` § Audit) and convert actionable checks into Backlog-candidate rows.
Full procedure, output contract, and stop conditions are in
`references/source-from-skore.md` — load it when this branch runs.

Output: a set of **Backlog-candidate rows** + a short human summary. The
parent writes rows to `JOURNAL.md` Backlog and re-presents the sourcing menu.

## § 2b Source from user

Source the next experiment proposal from the user — directly or via something
they point at (article, issue, spec, repo). Full procedure, output contract,
and stop conditions are in `references/source-from-user.md` — load it when this
branch runs.

Output: a user-confirmed **Proposal block**:

```
Proposal (from: user via <article-link | resource-link | free-text>):
  Question:        <one sentence>
  Motivation:      <quote / URL / file path + the why-now reason>
  Source:          <article URL with claim | gh issue URL | spec file:line | user quote>
  Method outline:  <prose; which file in src/<pkg>/ is touched>
  Open gaps:       <transfer risks, dep questions, domain assertions needing confirmation>
```

## § 3 Iterate on the design note + implement

- Surface the draft: file path + 3–5 line summary.
- **Mid-iteration feedback** is free-text. Edit `journal/NN_*.md`
  in place; loop here.
- **Final approval gate** is `AskUserQuestion`: **approved** →
  flip status, add History row, hand off to implementation chain.
  **more changes** → back to amendment loop. Ambiguous → re-ask.
- **Do not create `experiments/NN_*.py`** during iteration.

### Implementation chain — non-skippable

After G-DESIGN passes, dispatch in order:

1. `build-ml-pipeline` → `src/<pkg>/{pipeline,features,data}.py`
2. `evaluate-ml-pipeline` § Evaluate → `src/<pkg>/evaluate.py` +
   `experiments/NN_<short_name>.py`. **Owns CV strategy via
   `G-CV-SPLITTER` AskUserQuestion.**
3. `evaluate-ml-pipeline` § Smoke → `tests/smoke/test_NN_<short_name>.py`

Only then run the experiment. Confirm signatures via `python-api`,
not memory.

### G-RUN — post-smoke run gate

Once `tests/smoke/` passes (new test AND all prior): ask via
`AskUserQuestion`:

- **run now** — `<env-prefix> python experiments/NN_<short_name>.py`
  (the prefix `python-env-manager` detected for this project; full
  table at `python-env-manager:references/env_prefixes.md`)
- **leave for later** — stop. Surface Status + Backlog verbatim.

If run completed this turn → continue to § 4.

## § 4 Record outcome

**Trigger**: user says "the run finished" / "log it", OR the
agent ran the experiment in the same turn (G-RUN = run now) and it
completed successfully. **Do NOT auto-detect via `reports/` mtime.**

Full procedure: `references/record_outcome.md`.

1. **Audit-first**: dispatch `evaluate-ml-pipeline` § Audit →
   `audit/NN_<short_name>.py`. Read the digest (replaces scratch probes).
   If agent feature missing → `python-env-manager` § Agent feature.
2. **Fill Status-block fields**: State (`done` / `abandoned`),
   Approved by user on, Headline result, Implication for next.
3. **Smoke-test gate** — all `tests/smoke/` must pass before
   `done`. Prior failures → `build-ml-pipeline` § Reproducibility.
4. **Append headline** to `JOURNAL.md` History.
5. **Backlog hygiene**: delete / strikethrough resolved items.
6. **(Opt-in)** GitHub issue close-the-loop — ask before posting.

**Stop here.** Surface the implication, ask via `AskUserQuestion`:

- **draft it now** — re-enter § 1 with the implication as seed.
- **not yet** — record in Backlog, stop.

The user controls cadence; this skill records, it doesn't
propose-and-record in one breath.

## Dispatch table — which iterate-from-* skill

| Situation | Action |
|---|---|
| **No prior experiment** (bootstrap) | § 0 forces baseline. No strategy skill |
| User names a Backlog row (`B2`) | Promote directly. No strategy skill |
| "mine the report" / "what does skore see?" | the skore source branch. No design note this turn. |
| "I want to try X" / article URL / issue | the user source branch. Pass pre-resolved branch if available |
| "give me ideas" / "you decide" | `my-pick` — inline, AskUserQuestion |
| Open-ended "what's next?" | Present sourcing menu + Backlog. No silent default |

The strategy skills *source*; this skill *drafts*. `skore` requires
a prior experiment with a report — bootstrap can't use it.

**Zero candidates from the skore source branch**: append one-liner to
JOURNAL Status. No History row. Re-present menu.

## Maintenance modes

Read-only or rare. Full procedures in
`references/maintenance_modes.md`.

## Files and pairing rule

Pairing rule (hard, four-way): `journal/NN_<short_name>.md` ↔
`experiments/NN_<short_name>.py` ↔
`tests/smoke/test_NN_<short_name>.py` ↔
`audit/NN_<short_name>.py`, identical stems, 1:1.

Artifact shapes — see `references/journal-shape.md`.

## What this skill does NOT do

Run experiments, explore data (`ml-eda`), edit pipeline
code (`build-ml-pipeline`), decide workspace layout
(`ml-scaffold`), write commits/PRs, or pick a sourcing
strategy on behalf of the user.

## Companion skills

- `ml-scaffold` — layout + stem-pairing rule
- `ml-eda` — bootstrap EDA
- `build-ml-pipeline` / `evaluate-ml-pipeline` — implementation chain
- `evaluate-ml-pipeline` § Audit — § 4 digest
- `python-api` / `python-env-manager` — symbols, installs, agent feature

## References (load on demand)

- `ml-conventions:references/shared-preflight-evidence.md` —
  evidence-format spec shared across ML skills.
- `references/bootstrap.md` — full bootstrap procedure, config gates
- `references/forbidden-shortcuts.md` — common shortcut violations
- `references/journal-shape.md` — JOURNAL.md and design-note shapes
- `references/record_outcome.md` — full § 4 procedure
- `references/maintenance_modes.md` — overview / compare / pivot / abandon / re-runs

## Templates

- `templates/JOURNAL.md` — four-section index skeleton
- `templates/experiment_design.md` — design note with Status block

Copy, don't rewrite.
