---
name: docs
description: User-invoked router for document-creation skills. Type this skill name to see which doc skill to use.
disable-model-invocation: true
---

# Docs Router

Index of document-creation skills. Invoke the right skill by name; high-frequency skills also auto-trigger.

| Skill | Use when |
|---|---|
| `prd` | Generate a Product Requirements Document, spec, or turn a conversation into a spec. |
| `writing-plans` | Write a multi-step implementation plan from a spec or requirements (before touching code). |
| `documentation-writer` | Write high-quality software documentation using the Diátaxis framework. |
| `create-architectural-decision-record` | Create an ADR for an architectural decision. |
| `internal-writing` | Meeting minutes, performance/peer/upward reviews, brag sheets, weekly updates, newsletters, FAQ answers, or other internal communications. |
| `ml-paper-writing` | Write publication-ready ML/AI papers (NeurIPS, ICML, ICLR, ACL, AAAI, COLM). |

Note: `create-specification` and `create-implementation-plan` were merged into
`prd` Branch B and Branch C. Use `prd` for spec writing and `writing-plans` for
implementation plans.
