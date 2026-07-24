---
disable-model-invocation: true
name: to-tickets
description: Use when a plan, spec, or conversation needs breaking into tracker tickets with blocking edges in a single session
---

# To Tickets

Break a plan, spec, or conversation into **tickets** — tracer-bullet vertical
slices, each declaring the tickets that **block** it. The destination is clear;
you just want tracked, ordered work items.

## When to use

- A spec or design doc exists and needs task breakdown
- Work has clear scope but needs tracking
- Someone said "turn this into tickets"
- The route to the goal is clear; you just need it sliced and ordered

**Don't use when** the route to the destination is genuinely unclear — that's `wayfinder` (heavyweight multi-session mode).

## Steps

The issue tracker and triage label vocabulary should have been provided to you
— if no tracker config has been provided, ask the user where issue tracker
config / triage labels come from, or default to the local-markdown tracker.

### 1. Gather context

Work from the conversation; fetch any referenced spec or issue and read its full body and comments.

**Completion criterion:** you hold the spec, plan, or conversation the tickets will slice.

### 2. Explore the codebase (optional)

Use the project's domain glossary and respect ADRs; look for prefactoring opportunities.

### 3. Draft vertical slices

Each cuts a complete path through every layer (schema, API, UI, tests), demoable on its own, sized to one context window. Give each ticket its **blocking edges**. Wide refactors are the exception: sequence them expand–contract, each batch its own ticket blocked by the expand.

**Completion criterion:** every slice has a title, a "What to build", its blocking edges, and acceptance criteria.

### 4. Quiz the user

Present title / Blocked by / What it delivers. Iterate on granularity and edges until approved.

### 5. Publish

Local files under `.scratch/<feature-slug>/issues/<NN>-<slug>.md` (title, What to build, Blocked by, `Status: ready-for-agent`, acceptance criteria), or a real tracker using native blocking with the `ready-for-agent` label.

Work the frontier one at a time with TDD (RED-GREEN-REFACTOR per task).

## Completion criteria

- [ ] Context gathered from spec/conversation
- [ ] Each ticket is a vertical slice, demoable on its own
- [ ] Blocking edges wired between dependent tickets
- [ ] User approved the breakdown
- [ ] Tickets published to tracker or local files
