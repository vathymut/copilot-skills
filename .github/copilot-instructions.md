# Copilot Instructions

This repository is a **curated, versioned catalog of reusable skills and agents** consumed by two tools differently:

- `.github/skills/<name>/SKILL.md` — shared by GitHub Copilot and OpenCode.
- `.github/agents/*.agent.md` — GitHub Copilot only. OpenCode uses a different schema; never symlink these into OpenCode.
- `.github/instructions/` — shared instructions referenced explicitly by tooling.

## Project conventions

- Skills are the unit of work here. Each skill lives in its own directory with a `SKILL.md` (and optional `references/`, `scripts/`).
- Keep every `SKILL.md` frontmatter minimal and valid: `name` and `description` only. The `description` is the trigger — make it specific about when to use the skill.
- Agents are Copilot-only (`.agent.md`). Required frontmatter: `description`, `tools`, `model`.
- Instructions files (`.instructions.md`) must contain guidance only — no code snippets — and valid `applyTo` globs.
- Document provenance. Record upstream source and how a skill was adapted in commit messages and in `docs/catalog.md`.
- The Superpowers cache (`~/.cache/opencode/.../superpowers/skills`) is NOT canonical. Keep skills only in `.github/skills/`.

## Maintenance rules

- After adding/removing skills or agents, update `README.md` counts, badge, headline, and the domain tables in `docs/catalog.md`.
- Catch drift with the commands in `AGENTS.md` ("Maintenance gotchas").
- When editing a skill, preserve its established structure and the existing frontmatter contract.

## Tooling notes

- This repo carries a graphify knowledge graph in `graphify-out/`. For codebase questions, prefer `graphify query "<question>"` over raw `grep`. After editing code, run `graphify update .`.
- Never symlink `.github/agents/` into OpenCode.
