---
name: web-design-reviewer
description: Use when inspecting a running website to find and fix design, layout, responsive, or accessibility issues at the source.
---

# Web Design Reviewer

Inspect a running website, identify visual and accessibility issues, then fix them in the source code. Screenshots are part of the workflow.

## When NOT to use

- Greenfield design from a brief — use `frontend-design`.
- Need only a screenshot/GIF with no review — use `ui-screenshots`.
- Data chart/figure critique — use `tufte-data-viz`.

## Boundary

**Fixes an existing running site only** — repairs live UI in source code; it does not design new UI from a blank brief (use `frontend-design` for that). Hold the same design bar: distinctive and intentional, **no generic AI-slop**; when fixing, respect the existing aesthetic direction rather than inventing a new one.

## Workflow

1. **Gather context** — URL, framework (package.json, config files), styling method (tailwind, modules, scss, styled). No source access → report findings only.

2. **Capture screenshots** at 375px, 768px, 1280px, 1920px — delegate capture to `ui-screenshots` (full-page first, then crops; desktop/Electron targets too). Inspect the DOM and console via the browser tooling in `references/tooling.md`.

3. **Inspect** layout, responsive behaviour, accessibility, and visual consistency. See `references/visual-checklist.md` for the full checklist.

4. **Fix** by impact: P1 (breaking) immediately, P2 (UX degradation) next, P3 (minor) if easy. Search source by selector/component/directory. Respect existing patterns. >3 attempts → consult user. See `references/framework-fixes.md`.

5. **Re-verify** — reload/HMR, re-capture affected viewports, compare before/after, check for regressions. Repeat from step 3 if issues remain.

## Completion criteria

- [ ] Screenshots captured at 375/768/1280/1920 via `ui-screenshots`; DOM/console inspected
- [ ] Issues triaged P1→P2→P3 per `references/visual-checklist.md`; P1 fixed immediately
- [ ] Source fixes respect existing patterns; >3 failed attempts escalated
- [ ] Re-capture shows fix at affected viewports with no regressions

## Related skills

- `ui-screenshots` — delegation for capture/crops/before-after.
- `frontend-design` — use for greenfield instead of fixing.
- `tufte-data-viz` — chart-specific critique.
