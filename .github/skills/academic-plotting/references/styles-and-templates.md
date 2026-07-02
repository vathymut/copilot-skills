# Academic Plotting — Styles, Palettes & Code Templates

Reference material extracted from `SKILL.md`. Load on demand.

## Visual Styles

Pick one style per paper (all figures should be consistent).

### Style A: "Sketch / 简笔画" (Hand-Drawn)

Warm, approachable, memorable. Ideal for overview figures and system introductions. Looks like a whiteboard sketch refined by a designer.

```
VISUAL STYLE — HAND-DRAWN SKETCH:
- Slightly irregular, hand-drawn line quality — lines wobble gently, not perfectly straight
- Rounded, soft shapes with visible pen strokes (like drawn with a thick felt-tip marker)
- Warm off-white background (#FAFAF7), NOT pure white
- Fill colors are soft watercolor-like washes: muted blue (#D6E4F0), soft peach (#F5DEB3),
  light sage (#D4E6D4), pale lavender (#E6DFF0)
- Borders are dark charcoal (#2C2C2C) with 2-3px line weight, slightly uneven
- Arrows are hand-drawn with slight curves, ending in simple open arrowheads (not filled triangles)
- Text uses a rounded sans-serif font (like Comic Neue or Architects Daughter feel)
- Small doodle-style icons inside boxes: a tiny gear ⚙ for processing, a lightbulb 💡 for ideas,
  a magnifying glass 🔍 for search — rendered as simple line drawings, NOT emoji
- Overall feel: a carefully drawn whiteboard diagram, clean but with personality
- NO clip art, NO stock icons, NO photorealistic elements
```

### Style B: "Modern Minimal" (Clean & Bold)

Confident, authoritative. Best for method figures where precision matters.

```
VISUAL STYLE — MODERN MINIMAL:
- Ultra-clean geometric shapes with crisp edges
- Bold color blocks as backgrounds for sections — NOT just accent bars, but full section fills
  using desaturated tones: slate blue (#E8EDF2), warm sand (#F5F0E8), cool mint (#E8F2EE)
- Component boxes have ROUNDED CORNERS (12px radius), NO visible border — they float on
  the section background using subtle shadow (1px, 4px blur, rgba(0,0,0,0.06))
- ONE accent color per section used sparingly on key elements: Deep blue (#2563EB),
  Emerald (#059669), Amber (#D97706), Rose (#E11D48)
- Arrows are thin (1.5px), dark gray (#6B7280), with small filled circle at source
  and clean arrowhead at target — NOT thick colored arrows
- Typography: Inter or system sans-serif, title 600 weight, body 400 weight
- Labels INSIDE boxes, not beside them
- Generous whitespace — at least 24px between elements
- NO decorative elements, NO icons — let the structure speak
```

### Style C: "Illustrated Technical" (Icon-Rich)

Engaging, explanatory. Good for tutorial-style papers and figures that need to be self-explanatory.

```
VISUAL STYLE — ILLUSTRATED TECHNICAL:
- Each major component has a small MEANINGFUL ICON drawn in a consistent line-art style
  (single color, 2px stroke, ~24x24px): brain icon for reasoning, database cylinder for storage,
  arrow-loop for iteration, network nodes for communication
- Components sit inside soft rounded rectangles with a LEFT COLOR STRIP (4px wide)
- Background is pure white, but each logical group has a very faint colored region behind it
  (#F8FAFC for blue group, #FFF8F0 for orange group)
- Connections use CURVED bezier paths (not straight lines), colored by SOURCE component
- Key data flows are THICKER (3px) than secondary flows (1px, dashed)
- Small annotation badges on arrows: "×N" for repeated operations, "optional" in italics
- Title labels are ABOVE each section in small caps, letter-spaced
- Overall: like a well-designed API documentation diagram
```

### Style D: "Accent Bar" (Classic Academic)

The default academic style. Safe for any venue, works well in grayscale.

```
VISUAL STYLE — CLASSIC ACCENT BAR:
- Horizontal section bands stacked vertically, pale gray (#F7F7F5) fill
- Thick colored LEFT ACCENT BAR (8px) distinguishes each section
- Content boxes: white fill, thin #DDD border, 4px rounded corners
- Section palette: Blue #4A90D9, Teal #5BA58B, Amber #D4A252, Slate #7B8794
- Sans-serif typography (Helvetica/Arial), bold titles, regular body
- Colored arrows match their SOURCE section
- Clean, flat, zero decoration
```

## Curated Color Palettes

**"Ocean Dusk"** (professional, calming — default recommendation):
`#264653` deep teal, `#2A9D8F` teal, `#E9C46A` gold, `#F4A261` sandy orange, `#E76F51` burnt coral

**"Ink & Wash"** (for 简笔画 style):
`#2C2C2C` charcoal ink, `#D6E4F0` washed blue, `#F5DEB3` washed wheat, `#D4E6D4` washed sage, `#E6DFF0` washed lavender

**"Nord"** (for modern minimal):
`#2E3440` polar night, `#5E81AC` frost blue, `#A3BE8C` aurora green, `#EBCB8B` aurora yellow, `#BF616A` aurora red

**"Okabe-Ito"** (universal colorblind-safe, required for data charts):
`#E69F00` orange, `#56B4E9` sky blue, `#009E73` green, `#F0E442` yellow, `#0072B2` blue, `#D55E00` vermillion, `#CC79A7` pink

## Publication Styling Template

```python
import matplotlib.pyplot as plt
import numpy as np

# --- Publication defaults (polished, not generic) ---
plt.rcParams.update({
    "font.family": "serif", "font.serif": ["Times New Roman", "DejaVu Serif"],
    "font.size": 10, "axes.titlesize": 11, "axes.titleweight": "bold",
    "axes.labelsize": 10, "legend.fontsize": 8.5, "legend.frameon": False,
    "figure.dpi": 300, "savefig.dpi": 300, "savefig.bbox": "tight",
    "axes.spines.top": False, "axes.spines.right": False,
    "axes.grid": True, "grid.alpha": 0.15, "grid.linestyle": "-",
    "lines.linewidth": 1.8, "lines.markersize": 5,
})

# --- "Ocean Dusk" palette (professional, distinctive, colorblind-safe) ---
COLORS = ["#264653", "#2A9D8F", "#E9C46A", "#F4A261", "#E76F51",
          "#0072B2", "#56B4E9", "#8C8C8C"]
OUR_COLOR = "#E76F51"       # coral — warm, stands out
BASELINE_COLOR = "#B0BEC5"  # cool gray — recedes
FIG_SINGLE, FIG_FULL = (3.25, 2.5), (6.75, 2.8)
```

## Common Chart Patterns

**Line plot (training curves)** — with markers and confidence bands:

```python
fig, ax = plt.subplots(figsize=FIG_SINGLE)
markers = ["o", "s", "^", "D", "v"]
for i, (method, (mean, std)) in enumerate(results.items()):
    color = OUR_COLOR if method == "Ours" else COLORS[i]
    ax.plot(steps, mean, label=method, color=color,
            marker=markers[i % 5], markevery=max(1, len(steps)//8),
            markersize=4, zorder=3)
    ax.fill_between(steps, mean - std, mean + std, color=color, alpha=0.12)
ax.set_xlabel("Training Steps")
ax.set_ylabel("Accuracy (%)")
ax.legend(loc="lower right")
fig.savefig("figures/fig_training.pdf")
fig.savefig("figures/fig_training.png", dpi=300)
```

**Grouped bar chart (ablation)** — with value labels:

```python
fig, ax = plt.subplots(figsize=FIG_FULL)
x = np.arange(len(categories))
n = len(methods)
width = 0.7 / n
for i, (method, scores) in enumerate(methods.items()):
    color = OUR_COLOR if method == "Ours" else COLORS[i]
    offset = (i - n / 2 + 0.5) * width
    bars = ax.bar(x + offset, scores, width * 0.9, label=method, color=color,
                  edgecolor="white", linewidth=0.5)
    for bar, s in zip(bars, scores):
        ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.3,
                f"{s:.1f}", ha="center", va="bottom", fontsize=7, color="#444")
ax.set_xticks(x)
ax.set_xticklabels(categories)
ax.set_ylabel("Score")
ax.legend(ncol=min(n, 4))
fig.savefig("figures/fig_ablation.pdf")
```

**Heatmap** — with diverging colormap and clean borders:

```python
import seaborn as sns
fig, ax = plt.subplots(figsize=(4, 3.5))
sns.heatmap(matrix, annot=True, fmt=".2f", cmap="YlOrRd", ax=ax,
            cbar_kws={"shrink": 0.75, "aspect": 20},
            linewidths=1.5, linecolor="white",
            annot_kws={"size": 8, "weight": "medium"})
ax.set_xlabel("Predicted")
ax.set_ylabel("Actual")
fig.savefig("figures/fig_confusion.pdf")
```

**Horizontal bar (leaderboard)** — with "our method" highlight:

```python
fig, ax = plt.subplots(figsize=FIG_SINGLE)
y_pos = np.arange(len(models))
colors = [BASELINE_COLOR] * len(models)
colors[our_idx] = OUR_COLOR
bars = ax.barh(y_pos, scores, color=colors, height=0.55,
               edgecolor="white", linewidth=0.5)
ax.set_yticks(y_pos)
ax.set_yticklabels(models)
ax.set_xlabel("Accuracy (%)")
ax.invert_yaxis()
for bar, s in zip(bars, scores):
    ax.text(bar.get_width() + 0.3, bar.get_y() + bar.get_height()/2,
            f"{s:.1f}", va="center", fontsize=8, color="#444")
fig.savefig("figures/fig_leaderboard.pdf")
```

**Full pattern library** (scaling laws, violin plots, multi-panel, radar): See [data-visualization.md](data-visualization.md).

## Generation Script Template

```python
#!/usr/bin/env python3
"""Generate [FIGURE_NAME] diagram using Gemini image generation."""
import os, sys, time
from google import genai

API_KEY = os.environ.get("GEMINI_API_KEY")
if not API_KEY:
    print("ERROR: Set GEMINI_API_KEY environment variable.")
    print("  Get a key at: https://aistudio.google.com/apikey")
    sys.exit(1)

MODEL = "gemini-3-pro-image-preview"
OUTPUT_DIR = os.path.dirname(os.path.abspath(__file__))
client = genai.Client(api_key=API_KEY)

PROMPT = """
[PASTE YOUR 6-SECTION PROMPT HERE]
"""

def generate_image(prompt_text, attempt_num):
    print(f"\n{'='*60}\nAttempt {attempt_num}\n{'='*60}")
    try:
        response = client.models.generate_content(
            model=MODEL,
            contents=prompt_text,
            config=genai.types.GenerateContentConfig(
                response_modalities=["IMAGE", "TEXT"],
            ),
        )
        output_path = os.path.join(OUTPUT_DIR, f"fig_NAME_attempt{attempt_num}.png")
        for part in response.candidates[0].content.parts:
            if part.inline_data:
                with open(output_path, "wb") as f:
                    f.write(part.inline_data.data)
                print(f"Saved: {output_path} ({os.path.getsize(output_path):,} bytes)")
                return output_path
            elif part.text:
                print(f"Text: {part.text[:300]}")
        print("WARNING: No image in response")
        return None
    except Exception as e:
        print(f"ERROR: {e}")
        return None

def main():
    results = []
    for i in range(1, 4):
        if i > 1:
            time.sleep(2)
        path = generate_image(PROMPT, i)
        if path:
            results.append(path)
    if not results:
        print("All attempts failed!")
        sys.exit(1)
    print(f"\nGenerated {len(results)} attempts. Review and pick the best.")

if __name__ == "__main__":
    main()
```
