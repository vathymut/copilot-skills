---
name: tufte-data-viz
description: Use when creating or reviewing data visualizations — charts and figures — and you want Tufte and screen-first principles applied.
allowed-tools: Read, Glob, Grep
---

# Tufte Data Visualization

Apply Edward Tufte's principles whenever generating or reviewing code that renders data visually. This skill covers chart generation, not slide/presentation design.

## Workflow

Follow these steps in order when creating any chart:

### Step 1: Identify the message

Before writing code, determine:
1. The key finding or trend the chart must make visible.
2. The comparison context — a baseline, prior period, target, or peer group. A number without context is meaningless.
3. The chart type that best fits the data structure (see Chart type guidance below).

### Step 2: Apply universal rules

Review the rules below. Every rule is a default — deviate only when the user explicitly requests otherwise.

### Step 3: Apply library-specific config

Use the Library quick reference table to find the essential overrides for the target library. For complete code examples and helper functions, read ONE rule file from `rules/` matching the library.

### Step 4: Validate

Run through the validation checklist at the bottom of this file before presenting the chart.

---

## Universal rules

The 22 universal rules (static principles, screen extensions, content/formatting) live in
`rules/universal-rules.md` — load them when you are authoring or auditing a chart.
The anti-pattern checklist and validation checklist below stay inline; the library
quick-reference, chart-type guidance, and color tables are summarized here and expanded
in `rules/`.

**Rule headlines (full text + examples in `rules/universal-rules.md`):**

1. Remove top/right borders · 2. Direct labels, not legends · 3. No gridlines by default
· 4. Range-frame axes · 5. No 3D · 6. No pie unless requested · 7. Aspect ~1.5:1
· 8. Gray first, accent selectively · 9. Off-white bg (`#fffff8`/`#151515`) · 10. Serif for data
· 11. No dual y-axes (use small multiples) · 12. Annotate the notable · 13. Show comparison context
· 14. Minimal tooltips · 15. Progressive disclosure over static density · 16. Accessible by default
· 17. Responsive, not just resized · 18. Animate to explain · 19. Dark mode first-class
· 20. Titles assert findings · 21. Format numbers for humans · 22. Don't chart what a sentence can say

---

## Library quick reference

The universal rules above are sufficient for most charts. For complete code examples and
library-specific helpers, read the appropriate rule file from the `rules/` directory in
this skill's folder. Only read ONE rule file per task. Essential config per library:

- **Recharts** → `rules/recharts.md` — `<CartesianGrid stroke="none" />`, remove `<Legend />`, `<YAxis axisLine={false} tickLine={false} />`, `<Line dot={false} strokeWidth={1.5} />`
- **ECharts** → `rules/echarts.md` — `splitLine: { show: false }`, `legend: { show: false }`, `grid: { show: false }`, `endLabel` on series
- **Chart.js** → `rules/chartjs.md` — `grid: { display: false }`, `border: { display: false }`, `plugins.legend.display: false`, `chartjs-plugin-datalabels`
- **matplotlib** → `rules/matplotlib.md` — `spines['top'].set_visible(False)`, `spines['right'].set_visible(False)`, `spines['bottom'].set_bounds(min, max)`, `font.family: serif`
- **Plotly** → `rules/plotly.md` — `showgrid=False`, `showlegend=False`, `plot_bgcolor='#fffff8'`, `zeroline=False`
- **D3/SVG/HTML** → `rules/svg-html.md` — `.domain { display: none }`, no `<rect>` backgrounds, `stroke-opacity: 0.1` gridlines

Chart-type guidance (line/bar/scatter/time series/small multiples/sparklines/tables/slopegraph/area/stacked/heatmap) and the color quick-reference table: see `rules/typography-and-color.md` (palettes, font stacks) and `rules/universal-rules.md` (rule 7/8).

---

## Anti-pattern detection

When reviewing existing chart code, check for: legends (→ direct labels), pie charts (→ horizontal bars), 3D effects (→ flat 2D), dual y-axes (→ small multiples), heavy gridlines (→ remove or 0.1 opacity), rainbow palettes (→ gray + accent), gauge widgets (→ number + sparkline), gradient fills (→ solid color), rotated labels (→ flip axes or abbreviate), pure white/black backgrounds (→ `#fffff8`/`#151515`), hover-only information (→ tap/focus fallback), missing text alternatives (→ `aria-label`), color-only encoding (→ add shape/pattern).

For the full table with per-library detection patterns and one-liner fixes, see `rules/anti-patterns.md`.

---

## Validation checklist

Before presenting any chart, verify:

- [ ] No top or right borders/spines
- [ ] No Legend component — series labeled directly on the chart
- [ ] Gridlines removed or horizontal-only at opacity <= 0.12
- [ ] Aspect ratio approximately 1.5:1
- [ ] Background is `#fffff8` (light) or `#151515` (dark), not pure white/black
- [ ] Serif font for data labels and titles
- [ ] Default series color is gray (`#666`); color used only for emphasis
- [ ] No 3D effects, no pie chart (unless explicitly requested)
- [ ] Axis lines span only the data range (range-frame)
- [ ] Notable data features annotated directly on chart
- [ ] Comparison context present (reference line, band, or second series)
- [ ] Tooltips are plain text with no decorative styling
- [ ] Interactive elements have tap/click/focus alternatives (no hover-only)
- [ ] Contrast ratios meet 3:1 (elements) / 4.5:1 (text) minimums
- [ ] Chart has a text alternative (aria-label, description, or data table)
- [ ] Animations respect `prefers-reduced-motion`
- [ ] Charts render usably at 320px and 1440px+ widths
- [ ] Title states the finding, not the axis description
- [ ] Numbers are formatted for readability (abbreviations, separators, consistent precision)
- [ ] A chart is warranted — the data couldn't be communicated as a sentence or table

---

## Additional resources

**Library rules** (read ONE per task): `rules/recharts.md`, `rules/echarts.md`, `rules/chartjs.md`, `rules/matplotlib.md`, `rules/plotly.md`, `rules/svg-html.md` — complete code examples, helpers, and theme registrations.

**Cross-cutting** (read when specifically needed):
- `rules/interactive-and-accessible.md` — progressive disclosure, WCAG, responsive, animation, dark mode
- `rules/typography-and-color.md` — font loading, full palette tables, old-style figures
- `rules/anti-patterns.md` — per-library detection heuristics and fixes
- `rules/small-multiples-sparklines.md` — layout patterns for small multiples, sparklines, slopegraphs

**Working examples** in `examples/` — one per library, plus an inline SVG sparkline.
