# Strict Minutes Schema (Output Structure)

You **MUST** produce meeting minutes following this exact structure. If information is unavailable, use `TBD` or `Unknown` and explain how to obtain it.

## 1. Metadata

- **Title**:
- **Date (YYYY-MM-DD)**:
- **Start Time (UTC)**:
- **End Time (UTC) or Duration**:
- **Organizer**:
- **Location / Virtual Link**:
- **Minutes Author** (agent or person):
- **Distribution List** (who receives the minutes):

## 2. Attendance

- **Present**: [list of names + roles]
- **Regrets / Absent**: [list]
- **Notetaker / Recorder**: [name or "agent"]

## 3. Agenda

Bullet list of agenda items, in order:

- Item 1: short title
- Item 2: short title
- ...

## 4. Summary

A concise one-paragraph summary (1–3 sentences) of the meeting's objective and high-level outcome.

## 5. Decisions Made

Each as a separate bullet:

- **Decision 1**: statement of decision.
  - Who decided / approved: [name(s) or group]
  - Rationale (1–2 sentences): brief reason.
  - Effective date (if applicable): YYYY-MM-DD
- **Decision 2**: ...

## 6. Action Items

Table-style bullets; **must include owner and due date**:

- **[ID] Action**: short description
  - **Owner**: Name (team)
  - **Due**: YYYY-MM-DD or "ASAP" / timeframe
  - **Acceptance Criteria**: (what completes this action)
  - **Linked artifacts / tickets**: (optional URL or ticket id)

**Example:**

- [A1] Draft deployment runbook for feature X
  - Owner: Alex (Engineering)
  - Due: 2026-02-05
  - Acceptance Criteria: runbook includes steps for rollback, health checks, and monitoring links
  - Linked artifacts: https://github.com/owner/repo/issues/123

## 7. Notes by Agenda Item

Brief, factual, timestamp optional:

- **Agenda Item 1**: title
  - Key points:
    - Point A (timestamp 00:05)
    - Point B (timestamp 00:12)
  - Open issues / questions:
    - Q1: question text (owner if assigned)
- **Agenda Item 2**: ...

## 8. Parking Lot / Unresolved Items

- **Item**: short description
  - Why parked / next step:
  - Suggested owner or next meeting to resolve

## 9. Risks / Blockers (if any)

- **Risk 1**: short description, impact, mitigation owner
- **Risk 2**: ...

## 10. Next Meeting / Follow-up

- Proposed date/time (if any)
- Objectives for next meeting

## 11. Attachments / References

- Agenda document: URL
- Slides: URL
- Transcript / Recording: URL
- Related tickets: list of URLs or IDs

## 12. Version & Change Log

- **Version**: 1.0
- **Last updated**: YYYY-MM-DDTHH:MM:SSZ
- **Changes**: short notes on edits and who made them
