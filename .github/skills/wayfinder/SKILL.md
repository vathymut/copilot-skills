---
name: wayfinder
description: Use when a piece of work is too large for one agent session and the route to the goal is genuinely unclear
---

## When NOT to use

- Route is clear and tracable — use `to-tickets` (lightweight single session).
- Single-feature plan — use `writing-plans`.

> **Reach for the lightest mode that fits.**
> - **Lightweight** — break a plan/spec into tracer-bullet tickets with blocking edges, in one session. Use `to-tickets`.
> - **Heavyweight (this skill)** — chart a shared, multi-session ticket map when the work is too big for one session *and* the route to the destination is genuinely unclear. Reach for it last.

---

## Mode 1: Chart the map

**Use when:** User invokes with a loose idea and the route to the destination isn't visible yet.

**Goal:** Produce a labelled `wayfinder:map` issue with child tickets that chart the fog.

**Completion criteria:**
- [ ] Destination named and scoped (via brainstorming + domain-modeling)
- [ ] Frontier mapped breadth-first; if no fog surfaced, map is not needed — confirmed with user
- [ ] Map issue created with label `wayfinder:map`, Destination and Notes filled, Decisions-so-far empty
- [ ] All specifiable tickets created as child issues
- [ ] Blocking edges wired in a second pass
- [ ] Charting stops at end of session — no tickets resolved

### Steps

1. **Name the destination** (criterion 1): run `brainstorming` + `domain-modeling` to pin the spec, decision, or change the map finds its way to.
2. **Map the frontier** (criterion 2): grill **breadth-first** — fan out, don't go deep on any one thread. No fog surfaced → map not needed; stop, report "route is clear — use `to-tickets` or `writing-plans` instead" and ask how to proceed (do not force a `wayfinder:map` issue).
3. **Create the map** (criteria 3–4): issue labelled `wayfinder:map`, Destination and Notes filled, Decisions-so-far empty, fog sketched into **Not yet specified**; specifiable tickets created as child issues.
4. **Wire blocking edges** (criterion 5): second pass, once issues have ids; sorts tickets into frontier and blocked — everything else stays in **Not yet specified**.
5. **Stop** (criterion 6): charting is one session's work; do not also resolve tickets.

---

## Mode 2: Work through the map

**Use when:** User invokes with an existing map (URL or number).

**Goal:** Resolve one ticket per session, updating the map as fog clears.

**Completion criteria:**
- [ ] One ticket resolved per session (never more)
- [ ] Resolution posted as comment; ticket closed
- [ ] Context pointer appended to map's Decisions-so-far
- [ ] Newly-surfaced tickets created; graduated fog removed from Not yet specified
- [ ] Out-of-scope discoveries ruled out, not resolved

### Steps

1. **Load the map** — the low-res view, not every ticket body.
2. **Choose the ticket** (criterion 1): user-named, else first frontier in order. **Claim it**: assign to yourself before any work.
3. **Resolve it** — **zoom as needed**: fetch the full body of any related or closed ticket on demand; invoke the skills the `## Notes` block names. If in doubt, use `brainstorming` and `domain-modeling`.
4. **Record the resolution** (criteria 2–3): post a **resolution comment**, **close** the issue, **append a context pointer** to Decisions-so-far.
5. **Update the map** (criteria 4–5): create-then-wire newly-surfaced tickets; graduate fog the answer made specifiable, clearing it from **Not yet specified** so it lives only as its new ticket. A ticket — this one or another — beyond the destination → **rule out of scope**, don't resolve. Invalidated map parts → update or delete those tickets.

The user may run unblocked tickets in parallel, so expect other sessions to be editing the tracker concurrently.

---

## Cross-mode rules

### Plan, don't do
Wayfinder is **planning** by default: the map is done when the way is clear — nothing left to decide before someone goes and does it. The pull to just do the work signals you've reached the map's edge; hand off. An effort can override in its **Notes**, carrying execution into the map — but absent that, produce decisions, not deliverables.

### Refer by name
Every map and ticket is an issue, so it has a **name** — its title. In everything the human reads — narration, the map's Decisions-so-far — refer to it by that name, never by a bare id, number, or slug. A wall of `#42, #43, #44` is illegible; names read at a glance. The id and URL don't vanish — a name wraps its link — but they ride *inside* the name, never stand in for it.

### The Map
The map is a single issue on this repo's issue tracker, labelled `wayfinder:map` — the canonical artifact. Its tickets are child issues of the map. The map is an **index**, not a store.

**Where the map, its child tickets, blocking, and frontier queries physically live is tracker-specific.** Resolve the tracker per `.github/instructions/issue-tracker.instructions.md`, then consult the tracker doc's "Wayfinding operations" section for how _this_ repo expresses them.

> Map templates (map-body template, ticket template, ticket types, Fog-of-war, Out-of-scope conventions) live in `references/map-conventions.md` — load on demand.

## Related skills

- `to-tickets` — when route is clear, use lighter `to-tickets`.
- `brainstorming` + `domain-modeling` — pin destination before mapping.
- `triage` — tracker conventions.

## Completion criteria (top-level)

- [ ] Mode chosen (chart map vs work map); lightest mode that fits
- [ ] Map issue exists with `wayfinder:map` label and Decisions-so-far
- [ ] All specifiable tickets created; blocking edges wired in second pass
