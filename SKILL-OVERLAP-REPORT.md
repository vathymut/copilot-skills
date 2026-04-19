# Skill Overlap Report

Current-state pruning snapshot for the local Copilot skills catalog. This file tracks the active catalog size, retained focus areas, and the deletion rounds that produced the current repo shape.

**Generated:** 2026-04-18  
**Last updated:** 2026-04-18  
**Total skills (initial):** 178  
**Total skills (current):** 31  
**Deleted so far:** 147  
**Current agents:** 9

---

## Current State

- Source of truth for the live inventory: `README.md`
- Current skill directories: 31
- Current agent definitions: 9
- Catalog strategy: keep a smaller, high-signal set of broadly reusable skills and remove narrow, redundant, or superseded entries

### Retained Focus Areas

- Durable general-purpose skills such as `code-review`, `refactor`, `create-specification`, `create-readme`, `python-expert`, and `frontend-design`
- High-value workflow helpers such as `acquire-codebase-knowledge`, `git-commit`, `github-copilot-starter`, `skill-creator`, and `web-design-reviewer`
- Niche-but-justified keepers from the pruning passes: `repo-story-time`, `mkdocs-translations`, `grill-me`, `ruff-recursive-fix`, `python-pypi-package-builder`

### Current Skill Inventory by Domain

| Domain | Count | Skills |
|---|---:|---|
| Code Quality & Security | 6 | `code-review`, `quality-playbook`, `pytest-coverage`, `refactor`, `ruff-recursive-fix`, `sql-code-review` |
| Documentation & Specs | 9 | `create-agentsmd`, `create-architectural-decision-record`, `create-implementation-plan`, `create-llms`, `create-readme`, `create-specification`, `docs-sync`, `documentation-writer`, `prd` |
| Development Workflow | 8 | `acquire-codebase-knowledge`, `git-commit`, `github-copilot-starter`, `grill-me`, `remember`, `repo-story-time`, `skill-creator`, `web-design-reviewer` |
| Data & Cloud | 2 | `python-expert`, `python-pypi-package-builder` |
| Frontend & Creative | 3 | `frontend-design`, `mermaid-diagram-specialist`, `theme-factory` |
| Communication | 2 | `internal-comms`, `meeting-minutes` |
| DevOps | 1 | `mkdocs-translations` |

---

## Deletion Round Summary

| Round | Result | Skills removed | Notes |
|---|---:|---:|---|
| Rounds 1-2 | 70 -> 54 | 16 | Removed major overlap clusters and narrow one-off skills |
| Round 3 | 54 -> 47 | 7 | Removed additional frontend, agent-security, and narrow skills |
| Round 4 | 47 -> 44 | 3 | Removed document-format skills |
| Round 5 | 44 -> 36 | 8 | Removed AI/agent, workflow, communication, data, and DevOps stragglers |
| Round 6 | 36 -> 32 | 4 | Removed security-oriented skills |
| Round 7 | 32 -> 31 | 1 | Removed `openapi-to-application-code` |

---

## Detailed Round Log

### Rounds 1-2

Removed 16 skills across the early overlap clusters, including README/doc helpers, epic breakdown variants, blueprint generators, Oracle-to-Postgres migration sets, Qdrant sets, React migration sets, GTM sets, structured autonomy variants, prompt-building variants, suggestion helpers, frontend/UI duplicates, SQL/PostgreSQL duplicates, Linux triage sets, Dataverse Python sets, several test helpers, `update-llms`, `memory-merger`, `conventional-commit`, codebase-exploration duplicates, code-education helpers, `roundup-setup`, and TypeSpec-specific skills.

### Round 3

- Deleted `web-coder`
- Deleted `agent-governance`, `agent-owasp-compliance`, `agent-supply-chain`
- Deleted `add-educational-comments`, `quasi-coder`, `roundup`

### Round 4

- Deleted `docx`, `pdf`, `pptx`

### Round 5

- Deleted `autoresearch`, `microsoft-agent-framework`, `semantic-kernel`
- Deleted `dependabot`
- Deleted `mentoring-juniors`
- Deleted `cosmosdb-datamodeling`
- Deleted `brainstorming`, `editorconfig`

### Round 6

- Deleted `gdpr-compliant`, `secret-scanning`, `security-review`, `threat-model-analyst`

### Round 7

- Deleted `openapi-to-application-code`

---

## Notes

- This document is intentionally current-state oriented. It summarizes what remains and how the repo reached this shape.
- Earlier exploratory candidate analysis is no longer kept inline here. Use git history if you need the superseded proposal text.
