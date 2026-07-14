---
name: frontend-slides
description: "Create zero-dependency, animation-rich HTML presentations from scratch, from PowerPoint, or by enhancing an existing deck. Includes built-in theme presets and custom theme support."
disable-model-invocation: true
---

# Frontend Slides

Create zero-dependency, animation-rich HTML presentations that run entirely in the browser. Single HTML files with inline CSS/JS, fixed 16:9 stage, no build tools.

## Core invariants

- **Fixed 16:9 stage (1920×1080).** Every slide lives on a fixed canvas that scales uniformly to the viewport. It may letterbox/pillarbox; it must not reflow content for mobile.
- **Inline everything.** One self-contained HTML file with all CSS/JS included. Read and embed the full `viewport-base.css`.
- **Distinctive design.** No generic AI-slop patterns. Every deck should feel custom-crafted.
- **Progressive disclosure.** Read lightweight style indexes first; load full `design.md` files only after the user picks a direction.

See `references/design-aesthetics.md` for typography, color, motion, and background guidance.

## Flow

Three phases: **Discover** → **Generate** → **Deliver**.

## Phase 1: Discover

### Detect mode

- **New presentation:** continue below.
- **PPT conversion:** extract content with `scripts/extract-pptx.py <input.pptx> <output_dir>`, confirm with the user, then continue to style selection.
- **Enhance existing HTML:** read the file, then follow the same rules while preserving the fixed stage. Before adding content, check density limits; if overflow is likely, split into new slides.

### Content questions

Ask all at once:

1. **Purpose:** pitch / teaching / conference / internal
2. **Length:** short (5–10), medium (10–20), long (20+)
3. **Content:** ready / rough notes / topic only
4. **Density:** low/speaker-led or high/reading-first

No scrolling, no overflow, no overlapping panels. If content exceeds the chosen density, split into more slides.

### Style selection

Generate 3 distinct single-slide HTML previews showing typography, colors, animation, and aesthetic.

Read `STYLE_PRESETS.md` and `bold-template-pack/selection-index.json` (if it exists). Do not read full `design.md` files yet.

| Mood | Suggested presets |
|---|---|
| Impressed/Confident | Bold Signal, Electric Studio, Dark Botanical |
| Excited/Energized | Creative Voltage, Neon Cyber, Split Pastel |
| Calm/Focused | Notebook Tabs, Paper & Ink, Swiss Modern |
| Inspired/Moved | Dark Botanical, Vintage Editorial, Pastel Geometry |

Save previews to `.frontend-slides/slide-previews/` (style-a.html, style-b.html, style-c.html) and open them for the user.

**Ask:** Which style do you prefer? A / B / C / mix elements / create a custom theme.

### Custom themes

If the user wants a custom theme, or wants to apply one of the built-in theme palettes from `themes/` / `theme-showcase.pdf`:

1. Read the chosen `themes/<name>.md` file (or the custom description).
2. Apply its colors and fonts consistently across the deck.
3. Ensure contrast and readability.

## Phase 2: Generate

Generate the full presentation from the content and chosen style.

Before generating, read:

- `html-template.md` — HTML architecture and JS features
- `viewport-base.css` — mandatory CSS (include in full)
- `animation-patterns.md` — animation reference
- `references/generation-rules.md` — generation rules

Requirements: single self-contained HTML file, all CSS/JS inline, include full `viewport-base.css`, use external fonts, detailed section comments. Respect `prefers-reduced-motion`.

## Phase 3: Deliver

1. Delete `.frontend-slides/slide-previews/` if it exists.
2. Open the HTML file.
3. Summarize: file location, style/theme, slide count, navigation, customization notes (`:root` variables, font links), and offer revisions/export.

Optional export/share: see `references/export-rules.md`.

## Supporting files

| File | Purpose |
|---|---|
| `STYLE_PRESETS.md` | 12 curated visual presets |
| `bold-template-pack/selection-index.json` | Bold template metadata |
| `themes/` | Built-in color/font themes |
| `theme-showcase.pdf` | Visual theme catalog |
| `viewport-base.css` | Mandatory fixed-stage CSS |
| `html-template.md` | HTML structure and JS features |
| `animation-patterns.md` | Animation snippets |
| `references/design-aesthetics.md` | Aesthetic guidance |
| `references/generation-rules.md` | Generation rules |
| `references/export-rules.md` | Deployment and PDF export |
| `scripts/extract-pptx.py` | PPT content extraction |
| `scripts/deploy.sh` | Deploy to Vercel |
| `scripts/export-pdf.sh` | Export to PDF |
