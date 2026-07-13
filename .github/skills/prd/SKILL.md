---
name: prd
description: 'Generate product requirements and specs. Use when the user wants a PRD, product spec, feature specification, AI-optimized spec file, or to turn the current conversation into a spec.'
license: MIT
---

# Product Requirements Document (PRD)

## When to use

- Starting new product or feature development.
- Translating a vague idea into a concrete specification.
- Defining requirements for AI-powered features.
- The user asks to "write a PRD", "plan a feature", or "create a spec".

## Branches

### Branch A — PRD / Product spec (default)

This branch also covers what the former `create-specification` skill did for
human-readable specs. If the user asks for a "spec file" or "solution spec"
rather than a named PRD, still use this branch unless they explicitly request
machine-readable structure (Branch B).

Use this when the user wants a human-readable product requirements document.

#### Phase 1: Discovery

Interrogate the user to fill knowledge gaps. Do not assume context.

**Ask about:**
- **Core Problem**: Why are we building this now?
- **Success Metrics**: How do we know it worked?
- **Constraints**: Budget, tech stack, or deadline?

**Completion:** All knowledge gaps filled or explicitly marked TBD.

#### Phase 2: Analysis & Scoping

Synthesize user input. Identify dependencies and hidden complexities.
- Map the **User Flow**
- Define **Non-Goals** to protect the timeline
- Identify external dependencies

**Completion:** User flow mapped, non-goals listed, dependencies identified.

#### Phase 3: Technical Drafting

Generate the document using the schema in the next section.

**Completion:** All schema sections populated with concrete, measurable criteria.

### Branch B — AI-optimized specification file

This branch replaces the standalone `create-specification` skill. Use it when
the user explicitly wants a machine-readable spec file for agent consumption.

1. Gather inputs: purpose, scope, requirements, constraints.
2. Choose a filename prefix: `schema`, `tool`, `data`, `infrastructure`, `process`, `architecture`, or `design`.
3. Populate [references/spec-template.md](references/spec-template.md) with no placeholders.
4. Validate:
   - No `[Bracket]` tokens remain.
   - All acronyms are defined in §2.
   - Acceptance criteria are testable (Given-When-Then or equivalent).
5. Save to `/spec/spec-[type]-[name].md`.

### Branch C — Conversation-to-spec (formerly `to-spec`)

Use when the user says "turn this into a spec", "publish this conversation as a spec", "write the spec from our discussion", or similar — i.e., the spec should be synthesized from the current conversation rather than discovered via interview.

1. Do NOT interview the user. Synthesize what you already know from the conversation and codebase.
2. Explore the repo if you haven't already. Use the project's domain glossary and ADRs.
3. Sketch the seams at which the feature will be tested. Prefer existing seams; the ideal number is one. Confirm with the user if scope is unclear.
4. Write the spec using this template, then publish it to the project issue tracker with the `ready-for-agent` label:

- **Problem Statement**
- **Solution**
- **User Stories** (numbered list, extensive)
- **Implementation Decisions** (modules, interfaces, schema, API contracts; no file paths or code snippets)
- **Testing Decisions** (seams, prior art)
- **Out of Scope**
- **Further Notes**

### 1. Executive Summary
- **Problem Statement**: 1-2 sentences on the pain point.
- **Proposed Solution**: 1-2 sentences on the fix.
- **Success Criteria**: 3-5 measurable KPIs.

### 2. User Experience & Functionality
- **User Personas**: Who is this for?
- **User Stories**: `As a [user], I want to [action] so that [benefit].`
- **Acceptance Criteria**: Bulleted "Done" definitions for each story.
- **Non-Goals**: What are we NOT building?

### 3. AI System Requirements (If Applicable)
- **Tool Requirements**: What tools and APIs are needed?
- **Evaluation Strategy**: How to measure output quality and accuracy.

### 4. Technical Specifications
- **Architecture Overview**: Data flow and component interaction.
- **Integration Points**: APIs, DBs, and Auth.
- **Security & Privacy**: Data handling and compliance.

### 5. Risks & Roadmap
- **Phased Rollout**: MVP -> v1.1 -> v2.0.
- **Technical Risks**: Latency, cost, or dependency failures.

---

## Quality Rules

- Use concrete, measurable criteria. Avoid "fast", "easy", or "intuitive".
- For AI systems, specify how to test and validate output quality.
- Present a draft and iterate on feedback.
- Never skip discovery — ask at least 2 clarifying questions first.
- Never hallucinate constraints — label unknowns as `TBD`.

**STOP if user cannot articulate the core problem** — ask them to define it first.

## References

- [Example PRD](references/example.md) — Intelligent Search System walkthrough
