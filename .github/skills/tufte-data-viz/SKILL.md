---
name: tufte-data-viz
description: Use when creating or reviewing data visualizations — charts and figures — where Tufte and screen-first principles should apply.
allowed-tools:
  - Read
  - Glob
  - Grep
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

### Step 5: Fix loop (repeat until clean)

If any validation check fails, do NOT output the chart. Instead:

1. **Audit** — report which checks failed, quoting the offending code/hunk.
2. **Suggest fixes** — present concrete code changes (one per failed check).
3. **User approves** — wait for approval before applying. Do not batch unapproved changes.
4. **Apply** — make the approved edits.
5. **Re-audit** — re-run the validation checklist. If any check still fails, loop back to step 1.

The chart is ready only when all 22 checks pass.

---

## Universal rules

The 22 universal rules (static principles, screen extensions, content/formatting) live in
`rules/universal-rules.md` — load them when you are authoring or auditing a chart.
The anti-pattern checklist and validation checklist below stay inline; the library
quick-reference, chart-type guidance, and color tables are summarized here and expanded
in `rules/`.

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

Chart-type guidance (line/bar/scatter/time series/small multiples/sparklines/tables/slopegraph/area/stacked/heatmap) and the color quick-reference table: see `rules/typography-and-color.md` (palettes, font stacks) and `rules/universal-rules.md` (rule 7/8). Cross-cutting: `rules/interactive-and-accessible.md` (progressive disclosure, WCAG, animation), `rules/small-multiples-sparklines.md` (layout patterns). Working examples in `examples/` — one per library, plus an inline SVG sparkline.

---

## Anti-pattern detection

When reviewing existing chart code, consult `rules/anti-patterns.md` — the full per-library detection table with one-liner fixes.

---

## Validation checklist

The 22 checks mirror the 22 universal rules in `rules/universal-rules.md` one-to-one (rule number in parens) — this checklist is the completion criterion for that file. Before presenting any chart, verify:

- [ ] (1) No top or right borders/spines
- [ ] (2) No Legend component — series labeled directly on the chart
- [ ] (3) Gridlines removed or horizontal-only at opacity <= 0.12
- [ ] (4) Axis lines span only the data range (range-frame)
- [ ] (5) No 3D effects
- [ ] (6) No pie chart unless explicitly requested
- [ ] (7) Aspect ratio approximately 1.5:1
- [ ] (8) Default series color is gray (`#666`); color used only for emphasis
- [ ] (9) Background is `#fffff8` (light) or `#151515` (dark), not pure white/black
- [ ] (10) Serif font for data labels and titles
- [ ] (11) No dual y-axes
- [ ] (12) Notable data features annotated directly on chart
- [ ] (13) Comparison context present (reference line, band, or second series)
- [ ] (14) Tooltips are plain text with no decorative styling
- [ ] (15) Progressive disclosure over static density
- [ ] (16) Accessible: contrast 3:1 (elements) / 4.5:1 (text), no color-only differentiation, text alternative, keyboard-navigable
- [ ] (17) Charts render usably at 320px and 1440px+ widths
- [ ] (18) Animations respect `prefers-reduced-motion`
- [ ] (19) Dark mode styled first-class: palette parity and contrast, not white-UI-in-a-dark-shell
- [ ] (20) Title states the finding, not the axis description
- [ ] (21) Numbers are formatted for readability (abbreviations, separators, consistent precision)
- [ ] (22) A chart is warranted — the data couldn't be communicated as a sentence or table

