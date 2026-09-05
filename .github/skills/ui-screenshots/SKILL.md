---
name: ui-screenshots
description: Use when capturing screenshots of a running web app, Electron app, or desktop window during development — full-page, interactive states, before/after pairs, section crops — or assembling them into an annotated animated GIF/video demo. Also use when adding visual callouts — rectangles, arrows, labels, or color highlights — to screenshots, PR images, or diagrams.
---

# UI Screenshots

Capture screenshots of web apps, Electron apps, or desktop windows; annotate them with callouts; assemble frames into animated GIF demos. Router — pick one branch, load only its references.

## When NOT to use

- Need a design review/fix for a running site — use `web-design-reviewer` (it delegates capture here).
- Need a new greenfield UI — use `frontend-design`.
- No running app/window to capture — nothing to screenshot.

## Trigger → branch

| Target | Section | Load |
|---|---|
| Web app (localhost) | Web app path | this file § Web app path |
| Electron app (VS Code, etc.) | `references/desktop-recording.md` § Electron | `references/desktop-recording.md` |
| Desktop window (visible) | `references/desktop-recording.md` § mss+ctypes | `references/desktop-recording.md` |
| Annotate an existing screenshot/diagram | Annotate | `references/annotate.py` |
| Animated GIF demo | `references/gif-assembly.md` | `references/gif-assembly.md` |

> Only load the references for the chosen branch — annotate vs capture vs gif are mutually exclusive.

## Pre-flight

- [ ] Dev server running (web) or target window open (desktop)
- [ ] playwright + Pillow installed (`pip install playwright Pillow -q && playwright install chromium`)
- [ ] (Desktop) mss installed: `pip install mss pillow -q`
- [ ] (Electron) Node.js + `npm install playwright`

## Web app path

### 1 — Capture full page

```python
from playwright.async_api import async_playwright

async def capture(url="http://localhost:3000", out="screenshot-raw.png", width=1400, height=5000):
    async with async_playwright() as p:
        browser = await p.chromium.launch()
        page = await browser.new_page(viewport={"width": width, "height": height})
        await page.goto(url, wait_until="networkidle")
        await page.wait_for_timeout(4000)
        await page.screenshot(path=out, full_page=True)
        await browser.close()
```

Tall viewport (height=5000) + `full_page=True` captures everything. `networkidle` + 4s timeout for async charts.

### 2 — Crop with PIL (not Playwright clip)

```python
from PIL import Image
img = Image.open("screenshot-raw.png")
cropped = img.crop((left, top, right, bottom))
cropped.save("screenshot-final.png")
```

Re-cropping is instant; re-screenshotting is slow. Get one good raw capture, slice it.

### 3 — Interactive states

```python
await page.locator("selector").first.hover()
await page.wait_for_timeout(1000)
await page.screenshot(path="screenshot-hover.png", full_page=True)

## Selected state (no hover): click, move mouse away
await element.click()
await page.mouse.move(300, 300)
await page.screenshot(path="screenshot-selected.png", full_page=True)
```

### 4 — Section crops from one capture

```python
img.crop((0, 200, 920, 900)).save("screenshot-header.png")
img.crop((0, 900, 920, 1600)).save("screenshot-main.png")
```

### Guidelines

1. Capture BEFORE making changes (or `git checkout HEAD~1 -- <files>` to revert, screenshot, restore).
2. Before/after pairs: same viewport width and crop.
3. `device_scale_factor=1` for 1x pixels matching 100% zoom.
4. Charts need 4s+ after networkidle (Plotly, D3).
5. Narrow viewport reveals rendering bugs.

## Annotate

Add visual callouts — rectangles, arrows, labels, highlights — to screenshots and diagrams. Prereq: `pip install Pillow numpy`.

### Color rules

- **Orange (`#FF9F1C`)** — highlights, new features, "look here"
- **Red (`#E63946`)** — only for bugs, errors, or removed things

### Targets

Check image dimensions first (`Image.open(path).size`) — HiDPI screenshots are larger than they appear. For unfamiliar images, run `grid_image()` first to get precise coordinates.

### Approaches

- **Single element** — inline snippet: rounded rect + leader line + label (below)
- **Multiple elements** — `annotate_image()` from `references/annotate.py` (copy alongside your script) for automatic placement
- **Before/after diff** — `diff_images()` from `references/annotate.py` finds changed regions, then annotate
- **GIF demo frames** — `references/gif-assembly.md` § Annotate frames

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

### Verify

- Run with `debug=True` on first annotation of a new image
- Labels close to their targets (short arrows, 25–80px)
- Consistent line thickness (~5px); no overlapping elements
- Confirm rendering in the target platform

## Desktop & Electron → references

- **Desktop windows (visible):** mss + ctypes. Code + setup in `references/desktop-recording.md`.
- **Electron apps (VS Code):** Node.js Playwright Electron API (works minimized). Code + caveats in `references/desktop-recording.md`.

## Animated GIF demos → references

Full procedure (capture → assemble → annotate → fade): `references/gif-assembly.md`. Use imageio (not PIL). Delegate annotation to § Annotate; use `references/annotate.py`'s `diff_images()` to find changed regions between frames. Variable frame timing: 100ms typing, 600–800ms pause, 500ms+ hero. GIF is the only universally supported animated format.

## Completion criteria

- [ ] Branch chosen before capture; only its references loaded
- [ ] Full-page raw captured at correct viewport, recropped via PIL (not re-screenshotted)
- [ ] Before/after pairs use identical viewport + crop; interactive states captured separately
- [ ] Annotations use `#FF9F1C` for highlights / `#E63946` only for bugs, `debug=True` on first run

## Limitations

- Web requires running app or accessible URL.
- Desktop mss requires visible, unobstructed window.
- Electron requires Node.js Playwright.
- Heavy SPAs may need custom wait logic.
