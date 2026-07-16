## Universal rules

Rules 1–14 cover static principles; 15–19 extend them for screens; 20–22 address content and formatting.

### 1. Remove top and right borders

No chart should have top or right axis lines, borders, or spines. The bottom and left axes are sufficient. Top and right lines are pure chartjunk.

### 2. Direct labels, not legends

Label each data series directly — at the endpoint of a line, on or beside a bar, next to a cluster. Remove the `<Legend>` component entirely. If there is only one series, the chart title provides that context; no label is needed.

### 3. No gridlines by default

The default is zero gridlines. For static charts where users need to read precise values, add horizontal-only gridlines at very low opacity (0.08–0.12). For interactive charts, prefer a contextual crosshair on hover instead (see rule 15). Never add vertical gridlines.

### 4. Range-frame axes

Axis lines should span only the range of the data, not from zero to some arbitrary maximum. The axis starts at (or near) the minimum data value and ends at the maximum.

### 5. No 3D effects

No perspective, no depth, no shadows on chart elements. Two-dimensional data gets two-dimensional representation.

### 6. No pie charts unless explicitly requested

Default to a horizontal bar chart sorted by value. If the user explicitly asks for a pie chart: maximum 4 slices, 2D only, start at 12 o'clock, direct percentage labels on each slice.

### 7. Aspect ratio ~1.5:1

Charts should be approximately 50% wider than tall. Standard sizes: 600x400, 750x500, 900x600. Exception: sparklines and small multiples may be more compact.

### 8. Gray first, highlight selectively

The default data series color is medium gray (`#666`). Use a single accent color to highlight the most important series or data point. Never use more than 4 distinct colors. Choose the right palette type: **categorical** (4-color muted) for unordered groups, **sequential** (single-hue ramp) for ordered magnitude, **diverging** (two-hue from center) for deviation from a midpoint. See `rules/typography-and-color.md` for hex values.

### 9. Off-white background

Light mode: `#fffff8`. Dark mode: `#151515`. Never use pure white (`#ffffff`) or pure black (`#000000`).

### 10. Serif fonts for data

Use serif fonts for data labels, annotations, and chart titles: `"ET Book", "Palatino Linotype", Palatino, "Book Antiqua", Georgia, serif`. Sans-serif (system-ui, sans-serif) is acceptable only for small axis tick labels (11-12px).

### 11. No dual y-axes

Two y-axes on one chart create false implied correlations. Use small multiples instead — two charts stacked vertically with shared x-axis.

### 12. Annotate the notable

If the data contains a peak, trough, inflection point, or event boundary, add a text annotation pointing to it directly on the chart. Place annotations in the nearest clear space — offset from the data point with a short leader line if needed. When multiple annotations compete for space, keep only the most important; move others to a footnote or tooltip.

### 13. Show comparison context

Include at least one reference element: a reference line (average, target, prior period), a shaded band, or a second series. A chart showing one line with no context fails the "Compared to what?" test.

### 14. Minimal tooltips

Tooltips should be plain text with the data value and label. No colored background, no border, no arrow pointer, no shadow.

### 15. Progressive disclosure over static density

Default to the Tufte-clean overview — high data-ink, minimal chrome. Layer details through hover, tap, and click (values, annotations, comparisons). Don't frontload everything onto a single static view. A contextual crosshair on hover replaces permanent gridlines.

### 16. Accessible by default

3:1 contrast ratio minimum for chart elements against their background; 4.5:1 for text in charts. Never use color as the sole differentiator — pair with shape, pattern, or direct label. Provide a text alternative for every chart (`aria-label` with key finding, or companion data table). Interactive charts must be keyboard-navigable.

### 17. Responsive, not just resized

Charts must have a responsive strategy — fluid (percentage width + viewBox), adaptive (breakpoint-based layout changes), or hybrid. At narrow viewports, change chart type or layout (horizontal bars for categories, reduced tick density, abbreviated labels), don't just shrink.

### 18. Animate to explain, not to decorate

Transitions for data changes (sorting, filtering, time progression) are good — they help the viewer track transformations. Gratuitous entrance animations, bouncing, and decorative motion are chartjunk. Duration: 200–500ms, ease-out. Always respect `prefers-reduced-motion`.

### 19. Dark mode as first-class citizen

Design both light and dark palettes intentionally. Never invert colors. Reduce saturation in dark mode (bright colors "vibrate" on dark backgrounds). Respect `prefers-color-scheme`. Use semantic color tokens (`--tufte-bg`, `--tufte-text`, `--tufte-series-default`) so charts adapt automatically.

### 20. Titles assert findings

The chart title states the key insight, not the axis description. "Revenue Surged 23% in Q3" not "Revenue by Quarter, 2024". The subtitle can provide context ("vs. prior year, USD millions"). If the data has no clear finding, the chart may not be needed (see rule 22).

### 21. Format numbers for humans

Abbreviate large numbers: $1.2M not $1,200,000. Use thousand separators for mid-range numbers (12,450 not 12450). Match decimal precision to significance (don't show $4.2391M when $4.2M suffices). Right-align numbers in tables. Use consistent units and state them once (in the axis label or title), not on every data point.

### 22. Don't chart what a sentence can say

If the data is 1–2 numbers, write a sentence with inline context ("Revenue was $4.2M, up 23% from Q2"). If the data is a simple ranking of 3–5 items, consider a table. Charts earn their space by revealing patterns, trends, or distributions that text and tables cannot. A chart of two bars is almost always worse than a sentence.

