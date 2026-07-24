---
name: wayfinder
description: Use when a piece of work is too large for one agent session and the route to the goal is genuinely unclear
disable-model-invocation: true
---

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

1. **Name the destination.** Run a `brainstorming` and `domain-modeling` session to pin down what this map is finding its way to — the spec, decision, or change. The destination fixes the scope, so it's settled first.
2. **Map the frontier.** Grill again, **breadth-first** this time: fan out across the whole space rather than deep on any one thread, surfacing the open decisions and the first steps takeable now. **If this surfaces no fog** — the way to the destination is already clear, the whole journey small enough for one session — you don't need a map. Stop and ask the user how they'd like to proceed.
3. **Create the map** (label `wayfinder:map`): Destination and Notes filled in, Decisions-so-far empty, the fog sketched into **Not yet specified**.
4. **Create the tickets you can specify now** as child issues of the map — then wire blocking edges in a **second pass** (issues need ids before they can reference each other). Wiring sorts them into the frontier and the blocked; everything you can't yet specify stays in the fog — the **Not yet specified** section.
5. Stop — charting the map is one session's work; do not also resolve tickets.

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
2. **Choose the ticket.** If the user named one, use it. Otherwise take the first frontier ticket in order. **Claim it**: assign it to yourself before any work.
3. **Resolve it** — **zoom as needed**: fetch the full body of any related or closed ticket on demand; invoke the skills the `## Notes` block names. If in doubt, use `brainstorming` and `domain-modeling`.
4. **Record the resolution:** post the answer as a **resolution comment**, **close** the issue, and **append a context pointer** to the map's Decisions-so-far.
5. **Add newly-surfaced tickets** (create-then-wire); graduate any fog the answer has made specifiable, clearing each graduated patch from **Not yet specified** so it lives only as its new ticket. If the answer reveals a ticket — this one or another — sits beyond the destination, **rule it out of scope** rather than resolving it on the route. If the decision invalidates other parts of the map, update or delete those tickets.

The user may run unblocked tickets in parallel, so expect other sessions to be editing the tracker concurrently.

---

## Cross-mode rules

### Plan, don't do
Wayfinder is **planning** by default: each ticket resolves a decision, and the map is done when the way is clear — nothing left to decide before someone goes and does the thing. The pull to just do the work is usually the signal you've reached the edge of the map and it's time to hand off. An effort can override this in its **Notes** — carrying execution into the map itself — but absent that, produce decisions, not deliverables.

### Refer by name
Every map and ticket is an issue, so it has a **name** — its title. In everything the human reads — narration, the map's Decisions-so-far — refer to it by that name, never by a bare id, number, or slug. A wall of `#42, #43, #44` is illegible; names read at a glance. The id and URL don't vanish — a name wraps its link — but they ride *inside* the name, never stand in for it.

### The Map
The map is a single issue on this repo's issue tracker, labelled `wayfinder:map` — the canonical artifact. Its tickets are child issues of the map. The map is an **index**, not a store.

**Where the map, its child tickets, blocking, and frontier queries physically live is tracker-specific.** The issue tracker should have been provided to you — if not, ask the user where issue tracker / triage labels come from, or default to the local-markdown tracker. Consult the tracker doc's "Wayfinding operations" section for how _this_ repo expresses them.

> Map templates (map-body template, ticket template, ticket types, Fog-of-war, Out-of-scope conventions) live in `references/map-conventions.md` — load on demand.
