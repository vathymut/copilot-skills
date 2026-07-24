---
name: internal-writing
description: Use when the user wants internal prose drafted — meeting minutes, performance/peer/upward reviews, brag sheets, weekly updates, newsletters, team updates, or FAQ answers.
disable-model-invocation: true
---

# Internal Writing

Draft internal communications and reviews.

## When NOT to use

- External/customer-facing communications
- Technical documentation, API docs, changelogs
- Marketing, sales, or press copy

## Context

| Branch | Use when |
|---|---|
| **meeting-minutes** | Meeting transcript, raw notes, or agenda needs concise minutes |
| **performance-review** | Self-assessment, peer review, upward feedback, brag sheet, promotion packet |
| **internal-comms** | Team update (3P), newsletter, FAQ answer, or other formatted internal message |

## Branch — meeting-minutes

Produce concise minutes for internal meetings, prioritizing decisions and action items.

### Output schema

Required sections:

- Metadata
- Attendance
- Decisions (with rationale)
- Action items (owner + due date + acceptance criteria)
- Parking lot for unresolved items

See `references/minutes-schema.md` for full structure.

### Style rules

- Keep it under one page for 30-minute meetings, two pages for 60-minute meetings.
- Use plain language and bullets.
- No speculation; label uncertain items `TBD`.
- No personal opinions.
- Link to artifacts when available.

### Completion criteria

- [ ] Required sections are present.
- [ ] Every action item has an owner and due date/timeframe.
- [ ] Decisions include rationale.
- [ ] Uncertain items are labeled `TBD`.

## Branch — performance-review

Draft self-assessments, peer reviews, upward feedback, and evidence-backed brag sheets or weekly updates. Enforces a 3-part impact contract: action → result → evidence.

### Review types

| Type | Who it's about | Tone |
|---|---|---|
| Self-assessment | Yourself | Confident, evidence-backed, growth-oriented |
| Peer review | A colleague | Specific, constructive, balanced |
| Upward feedback | Your manager | Diplomatic, honest, forward-looking |
| Brag sheet / weekly update | Yourself | Short, impact-first entries grouped by week/theme |
| Promotion packet / annual review | Yourself | Narrative + STAR, tied to scope and impact |

### Workflow

1. Gather context — review type, subject, period.
2. Surface evidence — pull metrics or git/GitHub PRs; never fabricate.
3. Draft — STAR for achievements, impact-first bullets for brag sheets.
4. Output — present with evidence summary, mark `[NEEDS DETAIL]`, save to `outputs/<year>/<month>/`.

### Output schemas

See `references/output-schemas.md` for self-assessment, peer review, and upward feedback templates.

### Important rules

- Never submit reviews — only draft files.
- Keep peer/upward feedback focused on observable behaviours, not personality.
- Decline dishonest or personal-attack framing; offer constructive reframing.
- Respect confidentiality.

## Branch — internal-comms

Write internal communications following the formats in `examples/`.

1. Identify the communication type from the request.
2. Load the matching guideline from `examples/`:
   - `examples/3p-updates.md` — Progress/Plans/Problems team updates
   - `examples/company-newsletter.md` — company-wide newsletters
   - `examples/faq-answers.md` — answering frequently asked questions
   - `examples/general-comms.md` — anything else
3. Follow the specific instructions for formatting, tone, and content gathering.
4. Ask for clarification if the type doesn't match any guideline.

### Completion criteria

- The draft matches the selected guideline's formatting and tone.
- All required sections are present.
- The user confirms the draft is ready to send.
