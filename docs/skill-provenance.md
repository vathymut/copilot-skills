# Skill provenance

Provenance record for each skill in `.github/skills/` (19 skills). This manifest pins the best-known upstream source, adaptation status, and review notes.

**Status legend**
- **verified** — upstream repo/path compared directly in a review pass.
- **inferred** — upstream source inferred from catalog/git history/naming; path/ref not fully pinned.
- **adapted** — locally modified/consolidated from an upstream source (may differ substantially).
- **unknown** — upstream not confidently identified; treat as local/custom until verified.

Last updated: 2026-11-11

| Skill | Upstream source | Upstream path/ref | Status | Last reviewed/adapted | Notes |
|---|---|---|---|---|---|
| `code-review` | `github/awesome-copilot` (catalog), possibly influenced by multiple sources | — | unknown/adapted | 2026 (git: `2cebdfb` rewrite as thin router) | Local rewrite/consolidation; exact upstream file not pinned. |
| `data-access` | `duckdb/duckdb-skills` | Consolidated from skills such as `read-file`, `query`, `attach-db`, `duckdb-docs` (and local spatial additions) | inferred/adapted | 2026-11-11 (reviewed vs upstream skill patterns) | Major local consolidation/rewrite; direct 1:1 upstream mapping does not exist. |
| `documentation-writer` | `github/awesome-copilot` and/or `anthropics/skills` (catalog-level) | — | unknown/adapted | — | Needs per-skill provenance verification. |
| `domain-modeling` | `github/awesome-copilot` and/or local workflow sources (catalog-level) | — | unknown/adapted | — | Needs per-skill provenance verification. |
| `frontend-design` | `anthropics/skills` | `skills/frontend-design/SKILL.md` (main, checked 2026-11-11) | verified/adapted | 2026-11-11 reviewed | Local version is drastically different in scope/philosophy from upstream; decide resync vs intentional fork. |
| `frontend-slides` | `zarazhangrui/frontend-slides` | `SKILL.md` (main, checked 2026-11-11) | verified/adapted | 2026-11-11 reviewed | Local version is a condensed rewrite missing much of upstream workflow/tooling; likely overdue if tracking upstream. |
| `git-workflow` | `github/awesome-copilot` / `obra/superpowers` patterns (possible, catalog-level) | — | unknown/adapted | — | Consolidated local workflow skill; exact upstream file not pinned. |
| `grill-me` | `obra/superpowers` (inferred from git history) | — | inferred/adapted | 2026 (git: `66cd88e` restore from upstream) | Thin user-invoked dispatcher to `grilling`; upstream path/ref not pinned. |
| `grilling` | `obra/superpowers` (inferred from git history) | — | inferred/adapted | 2026 (git: `66cd88e` restore from upstream) | Restored from upstream then locally adjusted; upstream path/ref not pinned. |
| `internal-writing` | `anthropics/skills` / `github/awesome-copilot` (catalog-level) | — | unknown/adapted | — | Router-style consolidation; needs verification. |
| `ml-paper-writing` | `anthropics/skills` / research-writing sources (catalog-level) | — | unknown/adapted | — | Needs per-skill provenance verification. |
| `python-api` | local/original consolidation (catalog-level sources unclear) | — | unknown | — | Likely custom/local skill; confirm whether derived from upstream. |
| `python-pypi-package-builder` | `github/awesome-copilot` / packaging templates (catalog-level) | — | unknown/inferred | — | Needs per-skill provenance verification. |
| `python-stack-env` | local/original consolidation (catalog-level sources unclear) | — | unknown/adapted | — | Consolidates stack selection + env management; likely custom. |
| `refactor` | `obra/superpowers` / `github/awesome-copilot` influences possible (catalog-level) | — | unknown/adapted | — | Needs per-skill provenance verification. |
| `research` | local/original workflow (catalog-level) | — | unknown/adapted | — | Needs per-skill provenance verification. |
| `show-me` | `humanlayer/skills` | `plugins/show-me/skills/show-me/SKILL.md` (main, checked 2026-11-11) | verified | 2026-11-11 reviewed; added in git `435d242` | Local content matches checked upstream. |
| `tufte-data-viz` | `caylent/tufte-data-viz` | `SKILL.md` (main, checked 2026-11-11) | verified/adapted | 2026-11-11 reviewed | Core rules/checklist aligned with upstream; local adds routing/completion/related-skill notes. |
| `ui-screenshots` | local consolidation (possibly inspired by screenshot/annotation tooling skills) | — | unknown/adapted | — | Consolidated router (capture/annotate/gif/desktop); needs provenance verification. |

## How to maintain this manifest
- When adding or updating a skill, record: upstream repo, exact path, commit/tag/ref, adaptation date, and review date.
- Prefer pinning a commit SHA or release tag over `main`.
- If a skill is intentionally local-only or a heavy consolidation, mark `unknown`/`local` clearly rather than guessing.
- During upstream review passes, update `Status`, `Last reviewed/adapted`, and `Notes`.