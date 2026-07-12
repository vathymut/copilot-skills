---
name: meeting-minutes
description: 'Generate concise, actionable meeting minutes for internal meetings. Use when asked to write up a meeting, transcript, or notes.'
---

# Meeting Minutes

Produce concise minutes for internal meetings, prioritizing decisions and action items.

## Intake

Gather before writing:

- Title, date, duration, organizer
- Attendees and absentees
- Source: agenda, transcript, recording, or raw notes

Ask up to three clarifying questions if anything is missing.

## Output schema

Follow [references/minutes-schema.md](references/minutes-schema.md) for the full structure. Required sections:

- Metadata
- Attendance
- Decisions (with rationale)
- Action items (owner + due date + acceptance criteria)
- Parking lot for unresolved items

## Style rules

- Keep it under one page for 30-minute meetings, two pages for 60-minute meetings.
- Use plain language and bullets.
- No speculation; label uncertain items `TBD`.
- No personal opinions.
- Link to artifacts when available.

## Completion criteria

- [ ] Required sections are present.
- [ ] Every action item has an owner and due date/timeframe.
- [ ] Decisions include rationale.
- [ ] Uncertain items are labeled `TBD`.
