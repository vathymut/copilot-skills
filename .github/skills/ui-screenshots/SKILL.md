---
name: ui-screenshots
description: Use when capturing screenshots of a running web app, Electron app, or desktop window during development — full-page, interactive states, before/after pairs, section crops — or assembling them into an annotated animated GIF/video demo.
---

# UI Screenshots

Capture screenshots of web apps, Electron apps, or desktop windows. Also assembles frames into annotated animated GIF demos.

## Trigger → branch

| Target | Section |
|---|---|
| Web app (localhost) | Web app path |
| Electron app (VS Code, etc.) | `references/desktop-recording.md` § Electron |
| Desktop window (visible) | `references/desktop-recording.md` § mss+ctypes |
| Animated GIF demo | `references/gif-assembly.md` |

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

# Selected state (no hover): click, move mouse away
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

## Desktop & Electron → references

- **Desktop windows (visible):** mss + ctypes. Code + setup in `references/desktop-recording.md`.
- **Electron apps (VS Code):** Node.js Playwright Electron API (works minimized). Code + caveats in `references/desktop-recording.md`.

## Animated GIF demos → references

Full procedure (capture → assemble → annotate → fade): `references/gif-assembly.md`. Use imageio (not PIL). Delegate annotation to `image-annotations`. Variable frame timing: 100ms typing, 600–800ms pause, 500ms+ hero. GIF is the only universally supported animated format.

## Limitations

- Web requires running app or accessible URL.
- Desktop mss requires visible, unobstructed window.
- Electron requires Node.js Playwright.
- Heavy SPAs may need custom wait logic.
