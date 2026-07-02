---
name: iterate-ml-experiment
description: >
  Drives the propose → approve → implement → record loop on top of
  an ML workspace. Drafts per-experiment design notes in
  `journal/NN_*.md`, enforces approval before any code, and dispatches
  to `iterate-from-skore` / `iterate-from-user` for sourcing.

  TRIGGER — any of:
  - A session opens in an ML workspace (missing/placeholder → bootstrap).
  - User says "what's next", "resume", "where were we", "let's iterate".
  - About to create a new `experiments/NN_*.py` (design note must exist first).
  - User wants to record an outcome or compare past experiments.

  SKIP when: no workspace scaffold (→ `organize-ml-workspace`);
  mechanical edits to `pipeline.py` / `evaluate.py` (→ sibling skills);
  symbol lookup (`python-api`); diagnosing a single report without a
  "what next" framing (`evaluate-ml-pipeline`).

  HOW TO USE: read `journal/JOURNAL.md` first, classify via the
  **Mode picker**, then read only the matching section. Sibling skills
  open just-in-time — do not pre-read all at session start.
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
   │                                          ├─► G-EDA (explore-ml-data: run | skip)
   │                                          │
   │                                          └─► design note → G-DESIGN → § 3 implement
   │
   ├── "what's next?" with ≥1 done row ───► § 1 → § 2 (sourcing) → § 3 implement
   │
   ├── "run finished" ─────────────────────► § 4 record outcome
   │                                          │
   │                                          └─► dispatch audit-ml-pipeline
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
| Not scaffolded (no `src/`, no `experiments/`) | **Bootstrap → handoff** | → `organize-ml-workspace`, then § 0 |
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
- **Three skills, in order, after G-DESIGN**: build-ml-pipeline →
  evaluate-ml-pipeline (owns CV-strategy) → test-ml-pipeline.
  Only then assemble `experiments/NN_*.py`.
- **Harness hints do NOT waive gates.**
- **Post-hoc audit required** before ending the turn.

## Pre-flight — emit before any design-note write

Compact checklist; Evidence-format spec in
`references/preflight_evidence.md`.

```
Pre-flight (iterate-ml-experiment):
- [ ] Mode: bootstrap | iterate-propose | iterate-record | read-only
- [ ] Last experiment + status: <NN_name> | n/a — bootstrap
- [ ] (Bootstrap) Config gates fired: G-PKG-NAME, G-ENV-MGR,
      G-TABULAR, G-SKORE-MODE
- [ ] (Bootstrap) G-EDA fired: run / skip
- [ ] Design note drafted or Backlog enriched
- [ ] G-DESIGN: user approved
- [ ] (§ 3) Three-skill chain ran: build → evaluate → test
- [ ] (§ 3) G-CV-SPLITTER resolved at evaluate step
- [ ] (§ 3) G-RUN resolved: run now | leave for later
- [ ] (§ 4) Artifacts: Status + JOURNAL row + Backlog + audit
- [ ] python-api consulted for any new symbol
- [ ] Pre-flight re-emitted with evidence before final message.
```

## § 0 Bootstrap (first session only)

Workspace is in bootstrap mode when `journal/JOURNAL.md` is missing,
placeholder, or has 0 History rows.

**Procedure (compact — full version in `references/bootstrap.md`):**

1. **Scaffold first if needed.** No `src/` / `experiments/` /
   `journal/` → hand off to `organize-ml-workspace`, return when
   the placeholder `JOURNAL.md` exists.
2. **Rewrite `JOURNAL.md` from `templates/JOURNAL.md`**.
3. **Derive the goal default from `data/README.md`** *before*
   asking. Propose one sentence; user confirms or amends.
4. **Explore the data BEFORE designing the model (G-EDA).** Dispatch
   to `explore-ml-data`. Gate: **run** / **skip**. Run executes
   `data/eda.py`, writes `data/eda.md` + HTML, fills the
   `## Data understanding (EDA)` JOURNAL section. Run path needs
   `ipython` (may trigger `G-AGENT-FEATURE`). Skip records
   `Status: skipped`.
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
| `G-PKG-NAME` | `src/<pkg>/` name | `organize-ml-workspace` | before manifest |
| `G-ENV-MGR` | Env manager | `python-env-manager` | before install |
| `G-TABULAR` | Tabular library | `data-science-python-stack` | before `data.py` |
| `G-SKORE-MODE` | Skore Project mode + URI | `organize-ml-workspace` | before `pyproject.toml` |
| `G-EDA` | Run / skip | `explore-ml-data` | before baseline draft |
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

### The sourcing menu — surface VERBATIM

Every time § 2 runs in iterate mode, surface this menu with the
Backlog table. **Never silently default.**

```
How would you like me to source the next experiment?

  skore    — read the audit digest; draft Backlog rows, re-present
  user     — article URL, GitHub issue, spec, or free text
  my-pick  — I synthesize 2–4 candidates; you pick one
  B<N>     — promote a Backlog row directly

Backlog (pick by index):
<paste JOURNAL.md Backlog table here>
```

Use `AskUserQuestion` for the pick. Plain-text enumeration only if
unavailable.

### Free-text handling — first match wins

| User said… | Resolves to |
|---|---|
| Exact label / `B2` / "let's do B2" | that pick / `B<N>` |
| Scientific article URL | `user` → article-link |
| GitHub issue URL / spec path | `user` → resource-link |
| "give me ideas" / "you decide" | `my-pick` |
| "let me try X" / "use Y instead" | `user` → free-text |
| Ambiguous / off-menu | fire `AskUserQuestion`, don't guess |

### Branches

- **`skore`** → `iterate-from-skore`. Returns Backlog-candidate
  rows + summary. Re-present sourcing menu. *No design note.*
- **`user`** → `iterate-from-user`. Returns a Proposal. Draft into
  `journal/NN_short_name.md`.
- **`my-pick`** → inline. Synthesize 2–4 candidates via
  `AskUserQuestion`. Draft the design note on pick.
- **`B<N>`** → promote the row. Remove from Backlog on approval.

For `user` / `my-pick` / `B<N>`: write draft to
`journal/NN_short_name.md` using `templates/experiment_design.md`.
`NN` is the next free integer; `short_name` is the user's call.

→ next: § 3.

## § 3 Iterate on the design note + implement

- Surface the draft: file path + 3–5 line summary.
- **Mid-iteration feedback** is free-text. Edit `journal/NN_*.md`
  in place; loop here.
- **Final approval gate** is `AskUserQuestion`: **approved** →
  flip status, add History row, hand off to three-skill chain.
  **more changes** → back to amendment loop. Ambiguous → re-ask.
- **Do not create `experiments/NN_*.py`** during iteration.

### Three-skill implementation chain — non-skippable

After G-DESIGN passes, dispatch in order:

1. `build-ml-pipeline` → `src/<pkg>/{pipeline,features,data}.py`
2. `evaluate-ml-pipeline` → `src/<pkg>/evaluate.py`. **Owns
   CV-strategy via `AskUserQuestion`.**
3. `test-ml-pipeline` → `smoke-test-ml-pipeline` → smoke test

Only then assemble `experiments/NN_*.py`. Confirm signatures via
`python-api`, not memory.

### G-RUN — post-smoke run gate

Once `tests/smoke/` passes (new test AND all prior): ask via
`AskUserQuestion`:

- **run now** — `pixi run python experiments/NN_<short_name>.py`
- **leave for later** — stop. Surface Status + Backlog verbatim.

If run completed this turn → continue to § 4.

## § 4 Record outcome

**Trigger**: user says "the run finished" / "log it", OR the
agent ran the experiment in the same turn (G-RUN = run now) and it
completed successfully. **Do NOT auto-detect via `reports/` mtime.**

**Procedure (compact — full version in `references/record_outcome.md`):**

1. **Audit-first**: dispatch `audit-ml-pipeline` →
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
| "mine the report" / "what does skore see?" | `iterate-from-skore`. No design note this turn. |
| "I want to try X" / article URL / issue | `iterate-from-user`. Pass pre-resolved branch if available |
| "give me ideas" / "you decide" | `my-pick` — inline, AskUserQuestion |
| Open-ended "what's next?" | Present sourcing menu + Backlog. No silent default |

The strategy skills *source*; this skill *drafts*. `skore` requires
a prior experiment with a report — bootstrap can't use it.

**Zero candidates from `iterate-from-skore`**: append one-liner to
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

Run experiments, explore data (`explore-ml-data`), edit pipeline
code (`build-ml-pipeline`), decide workspace layout
(`organize-ml-workspace`), write commits/PRs, or pick a sourcing
strategy on the user's behalf.

## Companion skills

- `organize-ml-workspace` — scaffold + stem-pairing rule
- `explore-ml-data` — § 0 fires G-EDA; findings seed Method/Risks
- `iterate-from-user` / `iterate-from-skore` — sourcing branches
- `build-ml-pipeline` / `evaluate-ml-pipeline` / `test-ml-pipeline` — implementation chain
- `audit-ml-pipeline` — § 4 dispatch; carries headline metrics
- `python-api` / `python-env-manager` — symbol lookups, agent feature

## References (load on demand)

- `references/bootstrap.md` — full bootstrap procedure, config gates
- `references/forbidden-shortcuts.md` — common shortcut violations
- `references/journal-shape.md` — JOURNAL.md and design-note shapes
- `references/preflight_evidence.md` — Evidence-format spec
- `references/record_outcome.md` — full § 4 procedure
- `references/maintenance_modes.md` — overview / compare / pivot / abandon / re-runs

## Templates

- `templates/JOURNAL.md` — four-section index skeleton
- `templates/experiment_design.md` — design note with Status block

Copy, don't rewrite.
