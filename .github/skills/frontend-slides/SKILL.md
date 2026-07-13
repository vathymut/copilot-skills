---
name: frontend-slides
description: User-invoked: Create zero-dependency, animation-rich HTML presentations from scratch or by converting PowerPoint files. Use when the user wants to create or convert a presentation.
disable-model-invocation: true
---

# Frontend Slides

Create zero-dependency, animation-rich HTML presentations that run entirely in the browser.

## Core Principles

1. **Zero Dependencies** — Single HTML files with inline CSS/JS. No npm, no build tools.
2. **Show, Don't Tell** — Generate visual previews, not abstract choices.
3. **Distinctive Design** — No generic "AI slop." Every presentation must feel custom-crafted.
4. **Progressive Disclosure** — Read lightweight style indexes first. Load full `design.md` only after the user picks a template.
5. **Fixed 16:9 Stage (NON-NEGOTIABLE)** — Every deck uses a 1920×1080 slide canvas scaled as a whole to the viewport. Do not reflow slide content to fit the device.

See [references/design-aesthetics.md](references/design-aesthetics.md) for typography, color, motion, and background guidance.

## Fixed Stage Rules

These invariants apply to EVERY slide in EVERY presentation:

- Every deck has a viewport wrapper that fills the browser window.
- Every slide is authored inside a fixed 1920×1080 stage.
- The stage scales uniformly to fit the viewport. It may letterbox/pillarbox; it must not re-layout content.
- Do not use responsive breakpoints to rearrange slide content for phones.
- Use fixed internal slide measurements at the 1920×1080 design size.
- Slide visibility must be controlled by `.active` / `.visible` using `visibility`, `opacity`, and `pointer-events` from `viewport-base.css`. Do not use `display: none` / `display: block` for slide switching.
- Use `clamp()` only for non-slide UI outside the stage, or for small fallback previews where a full stage is impractical.
- Include `prefers-reduced-motion` support.
- Never negate CSS functions directly (`-clamp()`, `-min()`, `-max()` are silently ignored) — use `calc(-1 * clamp(...))` instead.

**When generating, read `viewport-base.css` and include its full contents in every presentation.**

### Content Density Modes

Ask whether this is a reading deck or a speaking deck:

| Density mode | Best for | Design behavior |
| ------------- | -------- | --------------- |
| **Low density / speaker-led** | Public talks, keynotes | One idea per slide, large type, generous negative space, 1-3 bullets max |
| **High density / reading-first** | Reports, handouts, async review | Self-contained slides, grids/tables, 4-8 bullets or 4-6 cards |

No scrolling, no overflow, no overlapping panels, no text below comfortable reading size. If content exceeds the selected density, split into more slides.

---

## Phase 0: Detect Mode

- **Mode A: New Presentation** — Go to Phase 1.
- **Mode B: PPT Conversion** — Go to Phase 4.
- **Mode C: Enhancement** — Read existing HTML, enhance. Follow Mode C rules below.

### Mode C: Modification Rules

Fixed-stage fitting is the biggest risk when enhancing:

1. Before adding content: count existing elements, check against density limits
2. Adding images: fit inside 1920×1080. If max content, split into two slides
3. Adding text: max 4-6 bullets per slide. Exceeds limits? Split into continuation slides
4. After ANY modification: verify 16:9 stage, no overflow, no overlap, screenshots at 1280×720 + phone
5. Proactively reorganize: if overflow, split and inform user

---

## Phase 1: Content Discovery

**Ask ALL questions together** so the user fills everything out at once:

1. **Purpose:** Pitch deck / Teaching-Tutorial / Conference talk / Internal presentation
2. **Length:** Short 5-10 / Medium 10-20 / Long 20+
3. **Content:** All content ready / Rough notes / Topic only
4. **Density:** Low density / speaker-led or High density / reading-first

**Do not ask about inline editing during Phase 1.** Inline editing is a post-draft affordance.

If user has content, ask them to share it.

### Step 1.2: Image Evaluation

If user provides an image folder: scan, inspect each image (usability, concept, dominant colors), co-design the outline around both text and images, confirm outline with user.

**Logo in previews:** If a usable logo was identified, embed it (base64) into each style preview.

---

## Phase 2: Style Discovery

**"Show, don't tell" phase.** Generate 3 distinct single-slide HTML previews showing typography, colors, animation, and aesthetic.

Read [STYLE_PRESETS.md](STYLE_PRESETS.md) and [bold-template-pack/selection-index.json](bold-template-pack/selection-index.json) (if it exists). Do not read `design.md` files yet.

| Mood                | Suggested Presets                                  |
| ------------------- | -------------------------------------------------- |
| Impressed/Confident | Bold Signal, Electric Studio, Dark Botanical       |
| Excited/Energized   | Creative Voltage, Neon Cyber, Split Pastel         |
| Calm/Focused        | Notebook Tabs, Paper & Ink, Swiss Modern           |
| Inspired/Moved      | Dark Botanical, Vintage Editorial, Pastel Geometry |

See [references/presentation-rules.md](references/presentation-rules.md) for preview mix rules, custom wildcard rules, bold template selection rules, and preview authenticity rules.

Save previews to `.frontend-slides/slide-previews/` (style-a.html, style-b.html, style-c.html). Open each automatically for the user.

### Step 2.1: User Picks

Ask: Which style preview do you prefer? Style A / Style B / Style C / Mix elements

---

## Phase 3: Generate Presentation

Generate the full presentation using content from Phase 1 and style from Phase 2.

Apply the user's density choice throughout the deck. If mixed needs, choose the closer mode: live persuasion → low-density; async review → high-density.

See [references/generation-rules.md](references/generation-rules.md) for bold template and custom wildcard generation rules.

**Before generating, read these supporting files:**

- [html-template.md](html-template.md) — HTML architecture and JS features
- [viewport-base.css](viewport-base.css) — Mandatory CSS (include in full)
- [animation-patterns.md](animation-patterns.md) — Animation reference

**Key requirements:** single self-contained HTML file, all CSS/JS inline, include FULL viewport-base.css, use Fontshare/Google Fonts, detailed section comments.

---

## Phase 4: PPT Conversion

1. **Extract content** — `python scripts/extract-pptx.py <input.pptx> <output_dir>` (install python-pptx if needed)
2. **Confirm with user** — Present extracted slide titles, content summaries, and image counts
3. **Style selection** — Proceed to Phase 2
4. **Generate HTML** — Convert to chosen style, preserving all text, images, slide order, and speaker notes

---

## Phase 5: Delivery

1. **Clean up** — Delete `.frontend-slides/slide-previews/` if it exists
2. **Open** — `open [filename].html`
3. **Summarize:**
   - File location, style name, slide count
   - Navigation: Arrow keys, Space, swipe/tap
   - Customize: `:root` CSS variables, font link, `.reveal` class
   - Inline editing: Hover top-left or press E, click text to edit, Ctrl+S to save
   - Offer revisions, text edits, or export/share

---

## Phase 6: Share & Export (Optional)

Ask: _"Would you like to share this presentation? I can deploy it to a live URL or export it as a PDF."_

Options: Deploy to URL / Export to PDF / Both / No thanks

See [references/export-rules.md](references/export-rules.md) for deployment and PDF export details.

---

## Supporting Files

| File | Purpose |
| --- | --- |
| [STYLE_PRESETS.md](STYLE_PRESETS.md) | 12 curated visual presets |
| [bold-template-pack/selection-index.json](bold-template-pack/selection-index.json) | Bold template metadata |
| [viewport-base.css](viewport-base.css) | Mandatory fixed-stage CSS |
| [html-template.md](html-template.md) | HTML structure and JS features |
| [animation-patterns.md](animation-patterns.md) | CSS/JS animation snippets |
| [scripts/extract-pptx.py](scripts/extract-pptx.py) | PPT content extraction |
| [scripts/deploy.sh](scripts/deploy.sh) | Deploy to Vercel |
| [scripts/export-pdf.sh](scripts/export-pdf.sh) | Export to PDF |
