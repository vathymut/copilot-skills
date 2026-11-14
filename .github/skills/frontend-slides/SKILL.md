---
name: frontend-slides
description: Use when building a presentation as a single self-contained HTML file, converting PowerPoint to web, or enhancing an existing HTML deck.
---

# Frontend Slides

Create zero-dependency, animation-rich HTML presentations that run entirely in the browser. Single HTML files with inline CSS/JS, fixed 16:9 stage, no build tools.

## When NOT to use

- Need a data chart/figure with numeric comparison — use `tufte-data-viz`.
- Need a new web page/app beyond slides — use `frontend-design`.
- Need a quick throwaway deck — skip the design bar and ship a minimal single-file deck instead.

## Core invariants

- **Fixed 16:9 stage (1920×1080).** Every slide lives on a fixed canvas that scales uniformly to the viewport. It may letterbox/pillarbox; it must not reflow content for mobile.
- **Inline everything.** One self-contained HTML file with all CSS/JS included. Read and embed the full `viewport-base.css`.
- **Distinctive design.** No generic AI-slop patterns. Every deck should feel custom-crafted.
- **Progressive disclosure.** Read lightweight style indexes first; load full `design.md` files only after the user picks a direction.

See `references/design-aesthetics.md` for typography, color, motion, and background guidance.

## No external assets

Every deck is a single self-contained HTML file. **No** external scripts, stylesheets, images, or build tools; **no** `<link>` or `<script src>`; fonts via `@import` (e.g. Google Fonts) or data URIs — never shipped font files. Purge any HTML generator that emits `<script src="...">`, `<link rel="stylesheet" href="...">`, or separate assets. The file must work offline when opened from disk.

## Preamble requirement

Before generating any deck, `Read` the full `viewport-base.css` and embed it line-for-line as an inline `<style>` block. Do not summarize, minify, or omit. Cache the file content for the session — don't re-read it per slide.

## Flow

Three phases: **Discover** → **Generate** → **Deliver**.

## Phase 1: Discover

### Detect mode

- **New presentation:** continue below.
- **PPT conversion:** extract content with `scripts/extract-pptx.py <input.pptx> <output_dir>`, confirm with the user, then continue to style selection.
- **Enhance existing HTML:** read the file, then follow the Mode C modification rules below.

### Mode C: modification rules (enhancing existing decks)

Fixed-stage fitting is the biggest risk when editing:

1. **Before adding content:** count existing elements and check against density limits.
2. **Adding images:** fit them inside the 1920×1080 stage. If the slide already has max content, split into two slides first.
3. **Adding text:** max 4–6 bullets per slide; over the limit → continuation slides.
4. **After ANY modification, verify:** the stage remains 16:9, no text overflows its card, no panels overlap, and screenshots look correct at 1280×720 plus one phone viewport.
5. **Proactively reorganize:** if modifications will cause overflow, split content automatically and inform the user — don't wait to be asked.

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

**Preview mix rules:** default mix is 1 safe preset from `STYLE_PRESETS.md`, at least 1 bold template from `bold-template-pack/selection-index.json`, and 1 wildcard (second bold template or a self-generated custom design — pick whichever creates the strongest contrast for this occasion, audience, and mood). For conservative/high-stakes decks make the safe preset especially restrained and the wildcard authoritative rather than decorative; for expressive decks make the wildcard adventurous and context-specific. If bold-template matches feel weak, use the wildcard as a custom design instead of forcing a template.

**Bold template selection rules:** match purpose and mood against `mood`, `tone`, `best_for`, `avoid_for`, `formality`, `density`, and `scheme` (treat `best_for` examples as soft signals, not industry filters). After shortlisting candidates, read only those candidates' `preview.md` files (from the `preview_md` paths in the selection index) — and only for title-slide previews. Do not read any full `design.md` until the user picks the final template.

**Custom wildcard design rules:** no generic AI-slop patterns, no default font/color/layout choices, no purple-gradient-on-white clichés, no cookie-cutter card look. Match the user's stated occasion, audience, mood, and density — the design must feel authored for this deck. Commit to a visual thesis: distinctive typography, a committed palette, a recognizable layout system, one strong atmospheric device. Keep it feasible for a full deck (the preview must imply a system that expands into section/content/quote/closing slides).

**Preview authenticity rules (NON-NEGOTIABLE):**

- Every style preview must look like a real first slide from the user's deck, not a diagnostic card.
- Never render internal workflow text on a slide: no `preview`, `generated from`, `preview.md`, `template`, `preset`, `style option`, `Option A/B/C`, file names, paths, or source-doc labels.
- Never render template names or slug names on the slide itself — they belong only in the message to the user.
- Never render user requirement notes as slide content ("sharp and provocative", "safe option", "audience: …") unless the user explicitly wants that exact phrase in the deck.
- If the slide needs chrome, use real deck chrome only: deck title, section title, date, author, page number, or a genuine content phrase from the user's material.
- Before opening previews, inspect the visible text and revise if any internal metadata appears.

**Ask:** Which style do you prefer? A / B / C / mix elements / create a custom design.

### Custom design direction

If the user wants a custom design (or "mix elements"), treat their description plus the wildcard rules above as the design recipe: apply its colors and fonts consistently across the deck, and ensure contrast and readability.

## Phase 2: Generate

Generate the full presentation from the content and chosen style.

Before generating, read:

- `html-template.md` — HTML architecture and JS features
- `viewport-base.css` — mandatory CSS (include in full)
- `animation-patterns.md` — animation reference
- `references/generation-rules.md` — generation rules

Requirements: single self-contained HTML file, all CSS/JS inline (full `viewport-base.css` — Preamble above), fonts via `@import` or data URIs only (no external font files), detailed section comments. Respect `prefers-reduced-motion`.

## Phase 3: Deliver

1. Delete `.frontend-slides/slide-previews/` if it exists.
2. Open the HTML file.
3. Summarize: file location, style/theme, slide count, navigation, customization notes (`:root` variables, font links), and offer revisions/export.

Optional export/share: see `references/export-rules.md`.

## Completion criteria

- [ ] Preamble: full `viewport-base.css` embedded inline; no external `<link>`/`<script src>`
- [ ] Style chosen from `STYLE_PRESETS.md` / bold-template previews (or a custom design applied); previews pass the authenticity check; single HTML file only
- [ ] Content fits stage — no scroll/overflow/overlap; dense content split across slides
- [ ] `prefers-reduced-motion` respected; file opens offline from disk

## Supporting files

Author-facing docs for humans (not loaded by the agent): `README.md` — full workflow reference with examples.

## Related skills

- `frontend-design` — non-slide web pages/apps.
- `tufte-data-viz` — charts inside slides.
