---
name: tufte-data-viz
description: Use when creating or reviewing data visualizations — charts and figures — where Tufte and screen-first principles should apply.
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Write
---

## When NOT to use

- Doc diagram (flowchart/ERD/sequence) — use a Mermaid snippet inline instead; this skill is for data charts.
- Slide deck with fixed stage — use `frontend-slides` (charts inside decks still use this skill for chart logic).

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

## Universal rules (5 most-violated inline)

1. **Data-ink max** — erase non-data ink (gridlines, borders) unless needed.
2. **No chartjunk / 3D** — never use 3D or decorative gradients.
3. **No truncated axes** — bar baselines at zero; line axes show context.
4. **No dual axes** — split into small multiples instead.
5. **Direct labeling** — label data in place, not via distant legend.

Full 22 rules: `rules/universal-rules.md` — load that file when authoring/auditing (don't inline all here).

## Chart type guidance

| Type | Key settings |
|---|---|
| **Line** | 1.5–2px stroke, no dots unless <7 points (then r=2), direct label at rightmost point |
| **Bar** | Prefer horizontal for categories, sort by value descending, direct value labels, `#7a7a7a` default fill |
| **Scatter** | Gray dots `#999` r=3, highlight key cluster/outlier with accent, regression line if meaningful (dashed, thin) |
| **Time series** | Label events on chart ("Recession", "Launch"), range-frame x-axis, YoY via opacity (current solid, prior 30%) |
| **Small multiples** | Same scale ALL panels, shared axis labels (x on bottom row, y on left column), no panel borders |
| **Sparklines** | ~80x20px, no axes/labels/gridlines, min/max dots r=1.5, embed inline in text or table cells |
| **Data tables** | No zebra striping, whitespace + thin rules every 3–5 rows, right-align numbers, `font-feature-settings: 'onum' 1` |
| **Slopegraph** | Before/after categories, label both endpoints (value + name), gray default + highlight key slopes |
| **Area** | Prefer lines. If area: fillOpacity 0.03–0.08, no gradient, direct labels at endpoints |
| **Stacked bar** | Avoid — use small multiples instead. If forced: sort by total, direct labels per segment, max 4 segments |
| **Heatmap** | Sequential or diverging palette only, value labels in cells, companion data table for accessibility |

Small-multiple, sparkline, and slopegraph implementation patterns: `rules/small-multiples-sparklines.md`.

## Library quick reference

For complete code examples and library-specific helpers, read **one** rule file from `rules/` matching the target library. Quick pointers:

- **Recharts** → `rules/recharts.md`
- **ECharts** → `rules/echarts.md`
- **Chart.js** → `rules/chartjs.md`
- **matplotlib** → `rules/matplotlib.md`
- **Plotly** → `rules/plotly.md`
- **D3/SVG/HTML** → `rules/svg-html.md`

Chart-type guidance and color tables: `rules/typography-and-color.md` + `rules/universal-rules.md`. Cross-cutting: `rules/interactive-and-accessible.md`, `rules/small-multiples-sparklines.md`. Examples in `examples/`.

---

## Anti-pattern detection

When reviewing existing chart code, consult `rules/anti-patterns.md` — the full per-library detection table with one-liner fixes.

---

## Completion criteria (Validation checklist)

The 22 checks mirror `rules/universal-rules.md` one-to-one — this is the completion criterion. Load the checklist from `rules/universal-rules.md` § Validation and verify all 22 before presenting any chart. Do not present until all pass; on failure follow § Fix loop above.


## Related skills

- `frontend-slides` / `frontend-design` — charts inside pages/decks.
- `data-access` — query data before visualizing.
