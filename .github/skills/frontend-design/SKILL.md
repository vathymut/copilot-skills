---
name: frontend-design
description: Use when building new web components, pages, applications, posters, or interactive artifacts from scratch or a brief.
allowed-tools: Read, Glob, Grep, Bash, Write
---

# Frontend Design

Build production-grade frontend components, pages, applications, or interactive artifacts with a distinctive, intentional aesthetic.

## When NOT to use

- **Quick prototypes / throwaway code** — this skill enforces a design bar that adds overhead for disposable work. Ship minimal markup directly instead.
- **Third-party design systems** (Material UI, Ant Design, Shadcn) — the skill's aesthetic-intentionality mandate conflicts with using pre-built component libraries. Use the library's own theming guide instead.
- **Fixing an existing running site** — this skill is for greenfield creation only. Capture with `ui-screenshots`, review with `code-review`, then fix.

## Tech-stack conventions (optional reference)

When a framework or stack is specified, apply these defaults:
- **HTML/CSS/JS** — vanilla, no build step unless stated
- **React** — functional components, CSS modules or Tailwind
- **Vue** — SFCs with `<script setup>`, scoped styles
- **Accessibility** — WCAG 2.1 AA minimum, semantic HTML, focus management
- **Responsive** — mobile-first breakpoints, fluid typography

## Steps

### 1. Gather requirements

Clarify:

- Purpose and audience
- Framework or stack (HTML/CSS/JS, React, Vue, etc.)
- Technical constraints (build tool, delivery format, accessibility needs)
- Content, data, or interactions required
- Aesthetic direction — explicit or inferred from context

### 2. Choose an aesthetic direction

Pick a clear direction and commit to it intentionally. Examples: brutally minimal, maximalist, retro-futuristic, organic, luxury/refined, playful, editorial, brutalist, art deco, soft/pastel, industrial/utilitarian.

Intentionality matters more than intensity. Every visual choice should serve the direction.

### 3. Plan tokens, then review against the brief

Work in two passes. First, brainstorm a compact token plan from the brief:

- **Color** — the core base palette as 4–6 named hex values.
- **Type** — the typefaces and their roles (one family or two, clearly distinct; type treatment as an active part of the design, not a neutral delivery vehicle).
- **Layout** — a layout concept in one-sentence prose plus ASCII wireframes; include alignment guidance (left/center/justified).
- **Principles** — the high-level guidance for what makes this page unique.

Then review the plan against the brief before writing code: if any part reads like the generic default you would produce for any similar page — rather than a choice made for this specific brief — revise that part and say what changed and why. Only start implementing once the plan holds up.

For calibration, AI-generated design clusters around these default traits. All are legitimate for some briefs, but they are defaults rather than choices. Where the brief pins down a visual direction, follow it exactly (the brief's own words win, even when it asks for one of these looks); where it leaves an axis free, don't spend that freedom on one of these defaults:

1. Warm cream background (near `#F4F1EA`) with a high-contrast serif display and a terracotta/warm-clay accent (often near `#D97757` — reads as a tell on someone else's brief).
2. Near-black background with a single bright acid-green or vermilion accent.
3. Broadsheet-style layout: hairline rules, zero border-radius, dense newspaper-like columns.
4. The SaaS-card kit: content chopped into identical rounded cards, one border-radius on everything regardless of hierarchy, the same soft grey shadow (`rgba(0,0,0,.1)`) under each, gradient washes as decoration.
5. Template chrome whatever the subject: a tracked-out ALL-CAPS eyebrow label above every heading; meta strings joined with middle dots (`A · B · C`); labels built as `WORD — fragment` with a spaced em dash; tinted near-black (`#0B0B0B`, `#111`) standing in for black; a monospace face for small data labels; a `→` appended to link and button text.

Typography carries the personality of the page — default to line lengths under 80 characters, and give serif body text slightly more line-height than a sans-serif. Structural devices (outlines, borders, numbering, eyebrows, labels) must encode information, not decorate: numbered markers (01/02/03) only when the content actually is a sequence. Use non-user-triggered motion sparingly: one orchestrated moment — a single page-load sequence or reveal — beats scattered per-card hover fades.

### 4. Implement

Write functional, production-grade code:

- Distinctive typography and cohesive colour palette
- Purposeful motion for high-impact moments
- Clear spatial composition
- Responsive and accessible baseline
- No generic AI-slop defaults (gradients, fonts, layouts that feel accidental)

Match implementation complexity to the direction. Maximalist calls for detail; minimalist calls for restraint. Spend your boldness in one place: one element is the memorable thing, everything around it stays quiet. Build to a quality floor without announcing it: responsive down to mobile, visible keyboard focus, reduced motion respected.

### 5. Verify

- Functionality works across target viewports
- Design is cohesive end-to-end
- Every detail is intentional
- Accessibility basics are met (contrast, focus states, semantic markup)

### 6. Test

- **Visual regression:** capture a screenshot of the built output and compare against the brief or reference design
- **Accessibility audit:** run axe-core or Lighthouse for contrast, ARIA, focus-order issues
- **Responsive check:** test at min 3 breakpoints (mobile, tablet, desktop)

## Completion criteria

- Code is functional and production-grade
- Aesthetic is distinctive, intentional, and cohesive
- No accidental/generic patterns remain — the token plan survived the review-against-the-brief pass
- Typography, colour, motion, and composition serve the chosen direction
- Visual regression and accessibility audit passed

## Related skills

- `ui-screenshots` — capture verification.
- `tufte-data-viz` — charts inside pages.
