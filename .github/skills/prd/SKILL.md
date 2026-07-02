---
name: prd
description: 'Generate Product Requirements Documents for software systems and AI features.'
license: MIT
---

# Product Requirements Document (PRD)

## When to Use

- Starting new product or feature development
- Translating a vague idea into a concrete specification
- Defining requirements for AI-powered features
- User asks to "write a PRD" or "plan a feature"

---

## Workflow

### Phase 1: Discovery

Interrogate the user to fill knowledge gaps. Do not assume context.

**Ask about:**
- **Core Problem**: Why are we building this now?
- **Success Metrics**: How do we know it worked?
- **Constraints**: Budget, tech stack, or deadline?

**Completion:** All knowledge gaps filled or explicitly marked TBD.

### Phase 2: Analysis & Scoping

Synthesize user input. Identify dependencies and hidden complexities.
- Map the **User Flow**
- Define **Non-Goals** to protect the timeline
- Identify external dependencies

**Completion:** User flow mapped, non-goals listed, dependencies identified.

### Phase 3: Technical Drafting

Generate the document using the schema below.

**Completion:** All schema sections populated with concrete, measurable criteria.

---

## Strict PRD Schema

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
