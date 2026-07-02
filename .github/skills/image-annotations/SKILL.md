---
name: image-annotations
description: >-
  Annotate screenshots, diagrams, and images with callout rectangles, arrows,
  labels, and color-coded highlights using PIL. Use when adding visual callouts
  to PR screenshots, before/after diffs, architecture diagrams, or animated GIF
  demo frames.
---

# Image Annotations

Add visual callouts to screenshots and diagrams — highlights what changed or what to look at, so reviewers don't have to guess.

## Prerequisites

```bash
pip install Pillow numpy
```

## Color rules

- **Orange (`#FF9F1C`)** — highlights, new features, "look here"
- **Red (`#E63946`)** — only for bugs, errors, or removed things
- Never use red just because it's eye-catching

## Step 1: Identify annotation targets

Determine what needs highlighting — specific UI elements, changed regions, or areas of interest. Check image dimensions first (`Image.open(path).size`) since HiDPI screenshots are larger than they appear.

**Completion criterion:** All target elements identified with bounding box coordinates.

## Step 2: Select annotation approach

- **Single element**: use the reference snippet (rounded rect + leader line + label)
- **Multiple elements**: use `annotate_image()` from [`references/annotate.py`](references/annotate.py) for automatic placement
- **Before/after diff**: use `diff_images()` to find changed regions, then annotate

For unfamiliar images, always run `grid_image()` first to get precise coordinates.

**Completion criterion:** Approach chosen, `references/annotate.py` copied alongside script if using algorithmic placement.

## Step 3: Write annotations

**Single-element snippet:**

```python
from PIL import Image, ImageDraw, ImageFont

font = ImageFont.truetype('Inkfree.ttf', 36)  # or load_default()
color = '#FF9F1C'
draw = ImageDraw.Draw(img)
draw.rounded_rectangle([x1-18, y1-18, x2+18, y2+18], radius=14, outline=color, width=5)
draw.line([x2+18, cy, x2+58, cy-30], fill=color, width=5)
draw.text((x2+63, cy-60), 'label', fill=color, font=font, stroke_width=1, stroke_fill=color)
```

**Multi-element algorithmic placement:**

```python
from annotate import annotate_image
result = annotate_image('screenshot.png', [
    {'elem': (560, 275, 635, 390), 'label': 'button', 'draw_box': True},
    {'elem': (105, 453, 236, 470), 'label': 'status text'},
], debug=True)
result.save('annotated.png')
```

**Completion criterion:** Annotations placed, labels readable, no overlapping elements.

## Step 4: Verify visual clarity

- Run with `debug=True` on first annotation of a new image
- Check that labels are close to their targets (short arrows, 25-80px)
- Confirm all elements use consistent line thickness (~5px)
- Verify rendering in the target platform

For animated GIFs: use 2-frame pop-in fade at 10fps, variable frame duration (fast action: 100ms, pauses: 600-800ms), and place labels adjacent to targets.

**Completion criterion:** Annotations clear, readable, and consistent.
