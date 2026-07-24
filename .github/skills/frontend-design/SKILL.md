---
name: frontend-design
description: Use when building new web components, pages, applications, posters, or interactive artifacts from scratch or a brief.
license: Complete terms in LICENSE.txt
disable-model-invocation: true
---

# Frontend Design

Build production-grade frontend components, pages, applications, or interactive artifacts with a distinctive, intentional aesthetic.

## When NOT to use

- **Quick prototypes / throwaway code** — this skill enforces a design bar that adds overhead for disposable work.
- **Third-party design systems** (Material UI, Ant Design, Shadcn) — the skill's aesthetic-intentionality mandate conflicts with using pre-built component libraries. Use the library's own theming guide instead.
- **Fixing an existing running site** — use `web-design-reviewer` instead. This skill is for greenfield creation only.

## Boundary

**Greenfield creation only.** This skill builds new UI from scratch or from a brief. To *fix* an existing running site (layout, responsive, accessibility, visual-consistency issues in live code), use `web-design-reviewer` instead. Both share the same design bar: distinctive and intentional, **no generic AI-slop** (accidental gradients, fonts, layouts).

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

### 3. Implement

Write functional, production-grade code:

- Distinctive typography and cohesive colour palette
- Purposeful motion for high-impact moments
- Clear spatial composition
- Responsive and accessible baseline
- No generic AI-slop defaults (gradients, fonts, layouts that feel accidental)

Match implementation complexity to the direction. Maximalist calls for detail; minimalist calls for restraint.

### 4. Verify

- Functionality works across target viewports
- Design is cohesive end-to-end
- Every detail is intentional
- Accessibility basics are met (contrast, focus states, semantic markup)

### 5. Test

- **Visual regression:** capture a screenshot of the built output and compare against the brief or reference design
- **Accessibility audit:** run axe-core or Lighthouse for contrast, ARIA, focus-order issues
- **Responsive check:** test at min 3 breakpoints (mobile, tablet, desktop)

## Completion criteria

- Code is functional and production-grade
- Aesthetic is distinctive, intentional, and cohesive
- No accidental/generic patterns remain
- Typography, colour, motion, and composition serve the chosen direction
- Visual regression and accessibility audit passed
