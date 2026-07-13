---
name: academic-plotting
description: Generates publication-quality figures for ML papers. Two workflows: architecture diagrams via Gemini, data charts via matplotlib/seaborn. Use when creating any figure for a confere
version: 1.0.0
author: Orchestra Research
license: MIT
tags: [Academic Writing, Visualization, Matplotlib, Seaborn, Plotting, Figures, Diagrams, NeurIPS, ICML, ICLR, LaTeX]
dependencies: [matplotlib>=3.8.0, seaborn>=0.13.0, numpy, google-genai>=1.0.0]---

# Academic Plotting for ML Papers

Two distinct workflows:

1. **Diagram figures** (architecture, system design, workflows) — AI image generation via Gemini
2. **Data figures** (line charts, bar charts, scatter, heatmaps) — matplotlib/seaborn

## When to Use Which

| Figure Type | Tool | Why |
|-------------|------|-----|
| Architecture / system diagram | Gemini (Workflow 1) | Complex spatial layouts with boxes, arrows |
| Workflow / pipeline / lifecycle | Gemini (Workflow 1) | Multi-step processes with connections |
| Bar chart, line plot, scatter | matplotlib (Workflow 2) | Precise numerical data, reproducible |
| Heatmap, confusion matrix | matplotlib/seaborn (Workflow 2) | Structured grid data |
| Ablation table as chart | matplotlib (Workflow 2) | Grouped bars or line comparisons |
| Training curves | matplotlib (Workflow 2) | Loss/accuracy over steps/epochs |

**Rule of thumb**: Numerical axes → matplotlib. Boxes and arrows → Gemini.

---

## Step 0: Context Analysis & Extraction

| Input Type | What to Extract |
|-----------|-----------------|
| Full paper / section draft | System components, relationships, data flow |
| Description paragraph | Key entities, hierarchy, connections |
| Raw results / data table | Metrics, methods, comparison structure |
| CSV / JSON data | Variables, trends, grouping dimensions |
| Vague request | Read surrounding context to infer content |

### For diagrams

1. **Identify visual entities** — main components/modules/stages (>8 → group into sections)
2. **Identify relationships** — data flow (solid arrow), control flow (gray), error path (dashed red)
3. **Determine layout** — sequential→left-to-right, layered→horizontal bands, hub-and-spoke→central node, hierarchical→top-down
4. **Assign colors** — one accent color per logical group
5. **Write every label exactly** — extract exact terminology from paper text

### For data charts

1. **Identify dimensions** — what's compared (categorical axis), what's the metric (value axis), time dimension (line plot), multiple metrics (multi-panel)
2. **Choose chart type** automatically:
   - Step/time axis → **line plot**
   - N methods × M benchmarks → **grouped bar chart**
   - Single ranking → **horizontal bar** (leaderboard)
   - Correlation between continuous variables → **scatter plot**
   - Square matrix → **heatmap**
   - Proportional breakdown → **stacked bar** (avoid pie)
3. **Highlight "our method"** — distinct color

---

## Workflow 1: Architecture & System Diagrams (Gemini)

### Checklist

- [ ] **Extract from context**: identify entities and relationships
- [ ] **Choose visual style** (A/B/C/D) — see → `references/styles-and-templates.md`
- [ ] **Choose color palette** — see → `references/styles-and-templates.md`
- [ ] Obtain Gemini API key (`GEMINI_API_KEY` env var)
- [ ] Write prompt: 6-section structure (FRAMING / VISUAL STYLE / COLOR PALETTE / LAYOUT / CONNECTIONS / CONSTRAINTS)
- [ ] Generate script at `figures/gen_fig_<name>.py`, run for 3 attempts
- [ ] Review, select best, save as `figures/fig_<name>.png`

### Prompt Structure

Every Gemini prompt must include these sections in order:

```
1. FRAMING (5 lines): "Create a [STYLE_NAME]-style technical diagram for a
   [VENUE] paper. The diagram should feel [ADJECTIVES]..."

2. VISUAL STYLE (20-30 lines): Copy the full style block from
   references/styles-and-templates.md (A/B/C/D).

3. COLOR PALETTE (10 lines): Exact hex codes for every color used.

4. LAYOUT (50-150 lines): Every component, box, section — exact text, spatial
   arrangement, and grouping. Be exhaustively specific.

5. CONNECTIONS (30-80 lines): Every arrow individually — source, target, style,
   label, routing direction.

6. CONSTRAINTS (10 lines): What NOT to include.
```

### Key Rules

- **Always 3 attempts** — quality varies significantly between runs
- **Style block is mandatory** — without it, Gemini defaults to generic corporate look
- **Never hardcode API keys** — use `os.environ.get("GEMINI_API_KEY")`
- **Save generation scripts** — reproducibility is critical
- **Specify every label exactly** — Gemini may misspell or rearrange text

**Full prompt examples per style**: See [references/diagram-generation.md](references/diagram-generation.md)

---

## Workflow 2: Data-Driven Charts (matplotlib/seaborn)

### Checklist

- [ ] **Extract from context**: identify methods, metrics, comparison structure
- [ ] **Auto-select chart type** based on data dimensions
- [ ] Prepare data (CSV, dict, or inline arrays)
- [ ] Apply publication styling — see → `references/styles-and-templates.md`
- [ ] Highlight "our method" with a distinct color
- [ ] Export as both PDF (vector) and PNG (300 DPI)
- [ ] Verify LaTeX font compatibility
- [ ] Save script at `figures/gen_fig_<name>.py`

**Code templates** (line, bar, heatmap, horizontal bar): See → `references/styles-and-templates.md`

---

## Publication Style Quick Reference

| Venue | Single Col | Full Width | Font |
|-------|-----------|------------|------|
| NeurIPS | 5.5 in | 5.5 in | Times |
| ICML | 3.25 in | 6.75 in | Times |
| ICLR | 5.5 in | 5.5 in | Times |
| ACL | 3.3 in | 6.8 in | Times |
| AAAI | 3.3 in | 7.0 in | Times |

**Venue-specific details, LaTeX integration, font matching**: See [references/style-guide.md](references/style-guide.md)

---

## Common Issues

| Issue | Solution |
|-------|----------|
| Fonts look wrong in LaTeX | Export PDF, set `text.usetex=True`, or use `font.family=serif` |
| Figure too large for column | Check venue width limits, use `figsize` in inches |
| Colors indistinguishable in print | Use colorblind-safe palette + different line styles/markers |
| Gemini misspells labels | Spell out every label exactly in prompt, add "SPELL EXACTLY" constraint |
| Gemini ignores style | Add more negative constraints, be more specific about hex colors |
| Blurry figures in PDF | Export as PDF (vector), not PNG; or use 300+ DPI for PNG |
| Legend overlaps data | Use `bbox_to_anchor`, `loc="upper left"`, or external legend |
| Too many tick labels | Use `ax.xaxis.set_major_locator(MaxNLocator(5))` |

## When to Use vs Alternatives

| Need | This Skill | Alternative |
|------|-----------|-------------|
| Architecture diagrams | Gemini generation | TikZ (manual), draw.io (interactive), Mermaid (simple) |
| Data charts | matplotlib/seaborn | Plotly (interactive), R/ggplot2 (statistics-heavy) |
| Full paper writing | Use with `ml-paper-writing` | — |
| Poster figures | Larger fonts, wider | `latex-posters` skill |
| Presentation figures | Larger text, fewer details | PowerPoint/Keynote export |

## File Naming Convention

```
figures/
├── gen_fig_<name>.py      # Generation script (always save for reproducibility)
├── fig_<name>.pdf         # Final vector output (for LaTeX)
├── fig_<name>.png         # Raster output (300 DPI, for AI-generated or fallback)
└── fig_<name>_attempt*.png # Gemini attempts (keep for comparison)
```
