---
name: web-design-reviewer
description: Use when inspecting a running website to find and fix design, layout, responsive, or accessibility issues at the source.
---

# Web Design Reviewer

Inspect a running website, identify visual and accessibility issues, then fix them in the source code. Screenshots are part of the workflow.

## Boundary

**Fixes an existing running site only.** This skill diagnoses and repairs live UI in source code — it does not design new UI from a blank brief. To *build* new components/pages from scratch, use `frontend-design`. Hold the same design bar as that skill: distinctive and intentional, **no generic AI-slop** (accidental gradients, fonts, layouts). When fixing, respect the existing aesthetic direction rather than inventing a new one.

## Workflow

1. **Gather context** — URL, framework (package.json, config files), styling method (tailwind, modules, scss, styled). No source access → report findings only.

2. **Capture screenshots** at 375px, 768px, 1280px, 1920px. Full-page first, then crop. `device_scale_factor=1`. Wait for async content. See `references/tooling.md` for browser setup and `references/screenshots/` for capture recipes.

3. **Inspect** layout, responsive behaviour, accessibility, and visual consistency. See `references/visual-checklist.md` for the full checklist.

4. **Fix** by impact: P1 (breaking) immediately, P2 (UX degradation) next, P3 (minor) if easy. Search source by selector/component/directory. Respect existing patterns. >3 attempts → consult user. See `references/framework-fixes.md`.

5. **Re-verify** — reload/HMR, re-capture affected viewports, compare before/after, check for regressions. Repeat from step 3 if issues remain.
