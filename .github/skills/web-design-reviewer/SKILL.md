---
name: web-design-reviewer
description: 'Inspect a running website to identify and fix design, layout, responsive, and accessibility issues at the source. Captures screenshots as part of the workflow.'
---

# Web Design Reviewer

Inspect a running website, identify visual and accessibility issues, then fix them in the source code. Screenshots are part of the workflow.

## Workflow

1. **Gather context:** URL, framework, styling method, review scope.
2. **Capture** screenshots at mobile (375px), tablet (768px), desktop (1280px), and wide (1920px).
3. **Inspect** layout, responsive behaviour, accessibility, and visual consistency.
4. **Fix** source code, prioritised by impact.
5. **Re-verify** by re-capturing and comparing.

## 1. Gather context

If the URL is not provided, ask for it. Detect the tech stack from workspace files:

- Framework: `package.json`, `next.config`, `nuxt.config`, `vite.config`, `tsconfig.json`
- Styling: `tailwind.config.*`, `*.module.css`, `*.scss`, `styled.`, `@emotion`
- Source dirs: `src/`, `app/`, `components/`, `pages/`

If you don't have source access, report findings only.

## 2. Capture screenshots

Use browser automation. Playwright is the default; the specific MCP/tooling setup is in `references/tooling.md`.

Key practices:

- Capture full-page first, then crop with PIL to avoid repeated browser launches.
- Use `device_scale_factor=1` for consistent pixels.
- Wait for async content (charts, animations) before capturing.
- For interactive states (hover, selected, tooltip), trigger the state first, move the pointer away if needed, then capture.
- Save before-state screenshots before making changes.

See `references/screenshots/` for full capture recipes, including desktop and Electron variants.

## 3. Inspect

Check the categories below. Load `references/visual-checklist.md` for the full checklist.

- **Layout:** overflow, overlap, alignment, spacing, text clipping.
- **Responsive:** breakpoint issues, touch-target size, readability on small screens.
- **Accessibility:** contrast, focus states, missing alt text, keyboard navigation, heading hierarchy.
- **Visual consistency:** fonts, colours, spacing, component reuse.

## 4. Fix

Find the source of each issue:

1. Search by class/ID selector.
2. Identify the component from text or structure.
3. Filter by likely source directories.

Apply minimal source changes, respecting existing patterns. See `references/framework-fixes.md` for framework-specific examples.

Prioritise by impact:

- **P1:** layout or functionality breaking — fix immediately
- **P2:** clear UX degradation — fix next
- **P3:** minor inconsistency — fix if easy

If more than 3 attempts are needed for one issue, consult the user.

## 5. Re-verify

Reload or wait for HMR. Re-capture the affected viewports and compare before/after. Check for regressions elsewhere. If issues remain, repeat from Step 3.

## Output

Summarise:

- Target URL, detected framework and styling method, tested viewports
- Issues detected, fixed, and unfixed (with reason)
- Files changed and what changed
- Recommended next steps
