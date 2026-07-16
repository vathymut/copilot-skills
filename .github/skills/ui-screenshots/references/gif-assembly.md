# Animated GIF assembly — command blocks

Verbatim code for the "Animated GIF demos" section of `ui-screenshots/SKILL.md`.
Load just-in-time. Prereqs: `pip install playwright Pillow imageio numpy scipy mss -q && playwright install chromium`.

## 1. Capture frames

Step through the interaction with Playwright and screenshot each step (reuse the capture workflow above):

```python
from playwright.async_api import async_playwright

async def record_frames(url, steps, width=1400, height=900):
    """
    steps: list of dicts with 'action' (async callable taking page)
           and 'name' (frame filename)
    """
    async with async_playwright() as p:
        browser = await p.chromium.launch()
        page = await browser.new_page(viewport={"width": width, "height": height})
        await page.goto(url, wait_until="networkidle")
        for step in steps:
            if step.get("action"):
                await step["action"](page)
                await page.wait_for_timeout(step.get("wait", 500))
            await page.screenshot(path=step["name"])
        await browser.close()
```

## 2. Assemble the GIF with imageio

Use **imageio, not PIL**, for GIF writing — PIL's encoder merges visually similar frames and kills the animation.

```python
import imageio.v3 as iio
from PIL import Image
import numpy as np

frames, durations = [], []
for frame_path, duration_ms in frame_list:
    frames.append(np.array(Image.open(frame_path)))
    durations.append(duration_ms)
iio.imwrite("demo.gif", frames, duration=durations, loop=0)
```

## 3. Annotate frames

Apply callouts to specific frames using the `image-annotations` skill's `annotate_image()`. For each frame needing a rectangle, arrow, or label, delegate rather than re-implementing the drawing:

```python
from PIL import Image
from annotate import annotate_image  # from image-annotations/references/annotate.py

def annotate_frame(frame_path, annotations, out_path):
    annotated = annotate_image(Image.open(frame_path), annotations)
    annotated.save(out_path)
```

## 4. Fade-in annotations

```python
def apply_fade(base, layer, alpha):
    return Image.blend(
        base.convert("RGBA"), layer.convert("RGBA"), alpha
    ).convert("RGB")

# 2-frame pop-in at 10fps: 50% then 100%
faded = [apply_fade(base, ann, 0.5), apply_fade(base, ann, 1.0)]
```

At 10fps use 2 fade frames (0.2s total); at 30fps use 3–4. Easing curves look bad at low FPS — simple pop-in is snappier.
