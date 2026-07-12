---
name: performance-review-writer
description: 'Draft performance reviews, self-assessments, peer reviews, upward feedback, brag sheets, weekly updates, and promotion packets in your own voice. Trigger for: "write my performance review", "self-assessment", "peer review", "360 feedback", "annual review", "mid-year review", "upward feedback", "brag sheet", "what did I ship", "help me commit work accomplishments".'
---

# Performance Review Writer

Draft self-assessments, peer reviews, upward feedback, and evidence-backed brag
sheets or weekly updates that sound like you — not corporate boilerplate. Uses
WorkIQ when available; otherwise mines git/PRs or falls back to a guided
interview. Enforces a 3-part impact contract: action → result → evidence.

## Review types

| Type | Who it's about | Tone |
|---|---|---|
| **Self-assessment** | Yourself | Confident, evidence-backed, growth-oriented |
| **Peer review** | A colleague | Specific, constructive, balanced |
| **Upward feedback** | Your manager | Diplomatic, honest, forward-looking |
| **Brag sheet / weekly update** | Yourself | Short, impact-first entries grouped by week/theme |
| **Promotion packet / annual review** | Yourself | Narrative + STAR, tied to scope and impact |

## Common prompts

- "Write my self-assessment for Jan–Dec 2025."
- "Draft a peer review for Sarah Chen."
- "Help me write upward feedback for my manager Tom."
- "Brag sheet / what did I ship last quarter?"
- "My annual review is due and I can't remember what I did."

## Workflow

### Step 1 — Gather context

Ask the user (max 3 clarifying questions if not already provided):

1. **Review type** — self-assessment, peer review, upward feedback, brag sheet,
   weekly update, promotion packet?
2. **Subject** — who is the review about? (for peer/upward: name and role)
3. **Review period** — what time range? (e.g. Jan–Dec 2025, last 6 months,
   this week)

If all are provided, proceed.

### Step 2 — Surface evidence

| Review type | Evidence strategy |
|---|---|
| Self-assessment / promotion packet / annual review | Pull WorkIQ contributions (emails, meetings, praise). If unavailable, mine git + GitHub PRs (`gh pr list`); otherwise ask for 3–5 bullets. |
| Peer review | Pull WorkIQ interactions with the subject; if unavailable, ask the user for a few specific situations. |
| Upward feedback | Pull WorkIQ communications with the manager; if unavailable, ask. |
| Brag sheet / weekly update | Mine git/PRs/Copilot session logs when available; otherwise interview. Group related commits into single entries. |

Do **not** fabricate numbers, team sizes, or impact. If a metric is missing,
write `"(evidence needed)"` or keep the entry qualitative. Qualitative evidence
with context beats invented numbers.

### Step 3 — Draft

Use the format matching the review type (see `references/output-schemas.md`):

- **STAR** for achievement statements: Situation, Task, Action, Result.
- **Impact-first contract** for brag sheets: `Did [action] → [result/impact] → [evidence]`.

Tone rules:

- Be specific — name projects, outcomes, and people.
- Be honest — don't oversell or undersell.
- Be forward-looking — end with growth or next steps.
- Avoid filler: "goes above and beyond", "team player", "hard worker".

### Step 4 — Output

1. Present the draft with a brief note on the evidence used. Summarize and
   redact — no raw excerpts, attendee lists, or sensitive personal details.
2. Highlight sections marked `[NEEDS DETAIL]`.
3. Save final drafts to `outputs/<year>/<month>/` with descriptive filenames
   (e.g. `2025-review-self-assessment.md`, `2025-peer-review-alex-chen.md`).
4. For brag sheets, output pasteable markdown grouped by week and category.

## Brag-sheet specifics

When the user asks "what did I do last week" or requests a brag sheet:

- Confirm the time range.
- Scan available sources: `git`, `gh`, `~/.copilot/session-state/` (if present).
- Group related commits/PRs into one entry.
- Assign categories: `pr`, `bugfix`, `infrastructure`, `investigation`,
  `collaboration`, `tooling`, `oncall`, `design`, `documentation`.
- Show entries before any save. Never auto-save without confirmation.

## Anti-patterns

| Don't | Do instead |
|---|---|
| "Fixed a bug in auth" | "Fixed token refresh race → eliminated 401s affecting 12% of API calls → PR #247" |
| "Worked on dashboards" | "Built latency dashboard → on-call detects P95 spikes in <2min → deployed to prod" |
| Invent a metric | Ask: "Do you have a rough estimate, or keep it qualitative?" |
| Passive voice | Active voice with ownership |
| List technologies | State the outcome |

## Important rules

- Never submit reviews — only draft files.
- Keep peer/upward feedback focused on observable behaviours, not personality.
- Decline dishonest or personal-attack framing; offer constructive reframing.
- Respect confidentiality.

## Output schemas

See `references/output-schemas.md` for self-assessment, peer review, and upward
feedback templates.
