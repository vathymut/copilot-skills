---
name: create-specification
description: 'Create an AI-optimized specification file for solution components.'
---

# Create Specification

## Steps

### 1. Gather Inputs

Collect from the user or conversation context:

- **Purpose**: What this specification defines
- **Scope**: Components, interfaces, or systems covered
- **Requirements**: Functional and non-functional requirements
- **Constraints**: Technical, business, or regulatory limitations

If missing, ask before proceeding. **Completion**: all inputs collected.

### 2. Determine Spec Type

Choose filename prefix: `schema`, `tool`, `data`, `infrastructure`, `process`, `architecture`, `design`.

**Completion**: prefix set.

### 3. Fill Template

Read `references/spec-template.md` and populate every section. Use coded identifiers (`REQ-001`, `SEC-001`, `AC-001`, etc.) for requirements and acceptance criteria.

**Completion**: all sections populated.

### 4. Validate

- No placeholder text (`[Bracket]` tokens)
- All acronyms defined in §2 Definitions
- Acceptance criteria in §5 are testable (Given-When-Then or similar)

**Completion**: validation passes.

### 5. Save

Write to `/spec/spec-[type]-[name].md` — type prefix from step 2, name in descriptive kebab-case.

**Completion**: file written.

## Rules

- Precise, unambiguous language
- Structured formatting (headings, lists, tables)
- All acronyms and domain terms defined in §2
- Self-contained — no external context dependencies
- Acceptance criteria must be testable
