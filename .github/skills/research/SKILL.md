---
name: research
description: Use when the user wants a topic investigated, docs or API facts gathered, or reading legwork delegated to a background agent.
allowed-tools: Read, Glob, Grep, Bash, Write
---

## When NOT to use

- The user wants a quick opinion or guess — research means delegation to a background agent with source verification.
- The question is about code already in the workspace that can be answered by reading the source directly.

## Workflow

Default: Use `Task` (general) when ≥2 independent sources; otherwise research inline via `Read`/`Grep`. Always save to `scratch/research/<slug>.md` (or `docs/research/` if repo convention exists). OpenCode/Copilot runners differ — don't hard-require `Task` when it is unavailable.

Spin up the researcher to do the work, so you keep working while it reads.

Its job:

1. Investigate the question against **primary sources** — official docs, source code, specs, first-party APIs — not a secondary write-up of them. Follow every claim back to the source that owns it.
2. Write the findings to a single Markdown file, citing each claim's source.
3. Save it where the repo already keeps such notes; match the existing convention, and if there is none, put it somewhere sensible and say where.

## Source trust

Primary (owns claim): official docs, source code, RFC/spec. Secondary: blog summarizing primary — follow link to primary. Tertiary (avoid): LLM summary, forum guess.

## Completion criteria

- [ ] Question investigated against primary sources
- [ ] Each claim cites its source
- [ ] Findings saved to a Markdown file in the repo
- [ ] User informed of the file location

## Related skills

- `brainstorming` — ideation before investigation.
- `ml-paper-writing` — academic source handling.
- `domain-modeling` — keep language consistent.
