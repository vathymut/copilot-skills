# Artifact Shapes — iterate-ml-experiment

Reference companion for the two artifacts this skill owns.

## `JOURNAL.md` shape

1. **Status** — 2-3 lines: dataset, goal, last experiment + status.
2. **Data understanding (EDA)** — short summary + link to
   `data/eda.md`. Owned by `explore-ml-data` (written at the G-EDA
   bootstrap step); this skill only reserves the section.
3. **History** (chronological) — one row per experiment: stem,
   intent, status, headline, design-note link.
4. **Backlog** (forward-looking) — indexed table; columns `#`,
   `Item`, `Source` (`skore:<stem>` / `my-pick:<stem>` / `user`).

Template: `templates/JOURNAL.md`. These four are the only sanctioned
sections — don't invent others.

## Per-experiment design-note shape

Template: `templates/experiment_design.md`. Sections:

- **Question / hypothesis** — one sentence.
- **Motivation** — pulled from sourcing strategy; cite
  concretely.
- **Method** — what changes vs. previous, in prose. Mechanics live
  in `build-ml-pipeline` / `evaluate-ml-pipeline`.
- **Risks** — what would make the metric move for the wrong reason.
- **Status block** — `planned` → `approved` → `done | abandoned`.

**No "Success criteria" section.** The user judges post-run.
