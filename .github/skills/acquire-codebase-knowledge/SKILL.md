---
name: acquire-codebase-knowledge
description: 'Map, document, or onboard into an existing codebase. Use when the user explicitly asks to map this codebase, document this architecture, onboard me, or create codebase docs.'
license: MIT
argument-hint: 'Optional focus: "architecture only", "testing and concerns"'
---

# Acquire Codebase Knowledge

Produce seven `docs/codebase/` documents. Document only what is verifiable from files or terminal output — never infer.

Do not trigger for routine feature work unless the user asks for repo-level discovery.

## Output contract

Before finishing, all of these must be true:

1. These files exist in `docs/codebase/`: `STACK.md`, `STRUCTURE.md`, `ARCHITECTURE.md`, `CONVENTIONS.md`, `INTEGRATIONS.md`, `TESTING.md`, `CONCERNS.md`.
2. Every claim traces to a source file, config, or terminal output.
3. Unknowns are marked `[TODO]`; intent gaps are marked `[ASK USER]`.
4. Every document lists concrete evidence file paths.
5. The final response lists `[ASK USER]` items and any intent-vs-reality divergences.

## Workflow

1. **Scan and read intent.** Run `scripts/scan.py`, then read README/ROADMAP/SPEC/DESIGN files. Summarise stated intent before reading source.
2. **Investigate.** Use the scan output and [`references/inquiry-checkpoints.md`](references/inquiry-checkpoints.md) to answer questions for each template. Load [`references/stack-detection.md`](references/stack-detection.md) only if the stack is ambiguous.
3. **Populate templates.** Copy files from `assets/templates/` into `docs/codebase/` in this order:
   - `STACK.md` — language, runtime, frameworks, dependencies
   - `STRUCTURE.md` — layout, entry points, key files
   - `ARCHITECTURE.md` — layers, patterns, data flow
   - `CONVENTIONS.md` — naming, formatting, error handling, imports
   - `INTEGRATIONS.md` — APIs, databases, auth, monitoring
   - `TESTING.md` — frameworks, file organization, mocking
   - `CONCERNS.md` — tech debt, bugs, security, perf
4. **Validate.** Confirm no unsupported claims, no empty required sections, and all `[ASK USER]`/`[TODO]` markers are intentional. Repeat until all seven docs pass.

## Focus-area mode

If the user asks for a focus area (e.g. "architecture only"):
- Still run Phase 1 fully.
- Complete the focus documents first.
- Keep required sections present in non-focus documents and mark unknowns as `[TODO]`.
- Still run the Phase 4 validation loop on all seven documents.

## Gotchas

- **Monorepos:** root `package.json` may be empty of source — check `workspaces`, `packages/`, `apps/`.
- **Outdated README:** cross-reference README claims with actual file structure.
- **TypeScript path aliases:** map `tsconfig.json` `paths` to real directories before documenting structure.
- **Generated output:** never document `dist/`, `build/`, `generated/`, `.next/`, `out/`, `__pycache__/`.
- **`.env.example`:** read it to discover required environment variables.
- **`devDependencies` ≠ production stack:** document dev tooling separately.
- **Test TODOs:** coverage gaps, not production debt.
- **High-churn files:** note them in `CONCERNS.md`.

## Anti-patterns

| ❌ Don't | ✅ Do instead |
|---|---|
| "Uses Clean Architecture" when no such directories exist | State only what the directory structure shows |
| "This is a Next.js project" without checking `package.json` | Check `dependencies` first |
| Guess the database from a variable name | Check the manifest |
| Document build-output naming | Source files only |

## Assets

| Asset | When to load |
|---|---|
| `scripts/scan.py` | Phase 1 |
| `references/inquiry-checkpoints.md` | Phase 2 |
| `references/stack-detection.md` | Phase 2, only if stack is ambiguous |
| `assets/templates/*.md` | Phase 3 |
