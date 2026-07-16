---
name: brainstorming
description: Use when a piece of work needs routing across planning, design, or development-workflow skills — or the user wants to explore intent and design before building, write a PRD/spec, or generate research directions. This is the default planning entry point (replaces the former `planning` router).
---

# Brainstorming Ideas Into Designs

Help turn ideas into fully formed designs, specs, or research proposals through
natural collaborative dialogue. Two branches share the same core loop: explore
→ question → propose → approve.

## Which skill? (routing)

Route the work before invoking a sibling skill:

- **New feature request** → `brainstorming` first (this skill; intent/design gate), then `writing-plans` (multi-step plan).
- **Large or uncertain effort, route unclear** → `wayfinder` (tickets with blocking edges, or a multi-session map).
- **Plan already written** → `subagent-driven-development` (one subagent per task + two-stage review).
- **Question to investigate** → `research` (primary sources → repo Markdown).
- **Issues / external PRs to sort** → `triage` (state machine + agent-ready briefs).
- **Throwaway design prototype** → `ponytail` (prototype mode).

## Branches

| Branch | Trigger | Leads to |
|---|---|---|
| **Design brainstorming** | "build X", "add feature Y", "modify Z" | `writing-plans` implementation plan |
| **Product requirements (PRD / spec)** | "write a PRD", "create a spec", "turn this into a spec" | `writing-plans` implementation plan |
| **Research ideation** | "research ideas", "high-impact directions", "stuck on current project" |see § Research Ideation |

## Hard gate

Do NOT invoke any implementation skill, write any code, scaffold any project, or
take any implementation action until you have presented a design or research
proposal and the user has approved it. This applies to every project regardless
of perceived simplicity.

## Anti-pattern: "This is too simple to need a design"

Every project goes through this process. "Simple" projects are where
unexamined assumptions cause the most wasted work. The design can be short, but
you must present it and get approval.

## Design brainstorming checklist

Complete these in order:

1. **Explore project context** — check files, docs, recent commits.
2. **Offer visual companion** (if visual questions ahead) — own message, not combined with a question. See § Visual Companion.
3. **Ask clarifying questions** — one at a time; understand purpose, constraints, success criteria.
4. **Propose 2-3 approaches** — with trade-offs and a recommendation.
5. **Present design** — scaled by complexity; get approval after each section.
6. **Write design doc** — `docs/specs/YYYY-MM-DD-<topic>-design.md` (or user-preferred location).
7. **Spec self-review** — placeholders, contradictions, ambiguity, scope.
8. **User reviews written spec**.
9. **Transition** — invoke `writing-plans`.

The **only** skill you invoke after design brainstorming is `writing-plans`.

## The design process

- Check current state first. If the request spans multiple independent
  subsystems, decompose before detailing.
- One question per message; multiple-choice when possible.
- Propose 2-3 approaches; lead with your recommendation.
- Scale sections: a few sentences for simple parts, 200-300 words for nuanced
  ones. Cover architecture, components, data flow, error handling, testing.
- Design for isolation: each unit has one clear purpose, defined interface, and
  independent testability.
- In existing codebases, follow existing patterns and include targeted
  improvements only when they serve the current goal.

## After the design

See the source `brainstorming` skill body for:

- Spec self-review checklist (placeholders, consistency, scope, ambiguity).
- User review gate language.
- Visual Companion offer and usage rules.

## Product requirements (PRD / spec)

Use this branch when the user wants a PRD, product spec, feature spec, or to
turn the current conversation into a spec. It produces the same kind of design
doc as design brainstorming, driven by a requirements interview (or by
synthesis from the conversation) rather than a "build X" intent.

### Phase 1 — Discovery

Interrogate to fill gaps; never assume context.

- **Core Problem**: why build this now?
- **Success Metrics**: how do we know it worked?
- **Constraints**: budget, stack, deadline?
- **Completion**: gaps filled or explicitly marked TBD.

### Phase 2 — Analysis & scoping

Synthesize: map the user flow, list non-goals, identify dependencies.
**Completion**: user flow mapped, non-goals listed, dependencies identified.

### Phase 3 — Draft

Populate the schema below with concrete, measurable criteria (avoid
"fast"/"easy"/"intuitive"; label unknowns `TBD`):

1. **Executive Summary** — problem, solution, 3–5 success KPIs.
2. **User Experience** — personas, `As a … I want … so that …` stories, acceptance criteria, non-goals.
3. **Technical Specs** — architecture, integrations, security/privacy.
4. **Risks & Roadmap** — phased rollout, technical risks.

### Phase 4 — Machine-readable spec (optional)

When the user wants an agent-consumable spec file: choose a prefix
(`schema`/`tool`/`data`/`infrastructure`/`process`/`architecture`/`design`),
populate `references/spec-template.md` with no placeholders, validate (no
`[Bracket]` tokens, acronyms defined, testable acceptance criteria), and save
to `/spec/spec-[type]-[name].md`.

### Phase 5 — Conversation-to-spec (optional)

When the user says "turn this into a spec": do NOT re-interview — synthesize
from the conversation and codebase, sketch the test seams, and publish to the
issue tracker with the `ready-for-agent` label.

### Transition

Save the spec to `docs/specs/YYYY-MM-DD-<topic>-design.md` (or user-preferred
location) and hand off to `writing-plans`.

## Research ideation

Use this branch when the user asks for research ideas, wants high-impact
research directions, is stuck on a current project, or is evaluating a
half-formed research idea. Read `references/research-ideation.md` for the full
workflow. In brief:

1. Identify starting point: exploring a new area, stuck on current project, or
   evaluating an idea.
2. Pick 2-3 frameworks from the selection guide based on the starting point.
3. Diverge to generate 10-20 raw candidates without filtering.
4. Converge to 3-5 strongest using filters: Explain-It Test, Problem-First Check,
   Simplicity Test, Stakeholder Check, Feasibility.
5. Refine the winner into a concrete research plan: two-sentence pitch, core
   tension, abstraction level, 3 validation experiments, strongest objection,
   2-week pilot.

Do **not** use research ideation when the user already has a well-defined
research question and needs execution guidance, experimental design, or a
literature review.

## Key principles

- One question at a time.
- Multiple choice preferred.
- YAGNI ruthlessly.
- Explore alternatives.
- Incremental validation (approval before moving on).
- Be flexible — go back and clarify when needed.
