---
name: ui-screenshots
description: 'Capture screenshots of web apps during development using Playwright and PIL. Supports full-page captures, interactive states, and an iterate-on-crop workflow that avoids slow re-screenshots.'
---

# UI Screenshots

Capture screenshots of web apps and graphical UIs during development to document visual changes.

## When to Use This Skill

Use this skill when you need to:

- Capture the current state of a running web app
- Document a UI before and after a code change
- Screenshot interactive states (tooltips, hovers, selected elements)
- Capture specific sections of a page without re-screenshotting

## Prerequisites

```bash
pip install playwright Pillow -q
playwright install chromium
```

## Core Workflow

### 1. Take a raw full-page screenshot

```python
from playwright.async_api import async_playwright

async def capture(url="http://localhost:3000", out="screenshot-raw.png", width=1400, height=5000):
    async with async_playwright() as p:
        browser = await p.chromium.launch()
        page = await browser.new_page(viewport={"width": width, "height": height})
        await page.goto(url, wait_until="networkidle")
        await page.wait_for_timeout(4000)  # let charts/animations render
        await page.screenshot(path=out, full_page=True)
        await browser.close()
```

- Use a **tall viewport** (height=5000) so the page renders everything without scrolling
- `wait_until="networkidle"` + `wait_for_timeout(4000)` ensures async charts load
- `full_page=True` captures the entire scrollable content

### 2. View the raw image, then crop with PIL

**Do NOT try to get perfect crops via Playwright's `clip` parameter.** It's unreliable with full-page captures.

```python
from PIL import Image

img = Image.open("screenshot-raw.png")
cropped = img.crop((left, top, right, bottom))  # adjust based on what you see
cropped.save("screenshot-final.png")
```

1. Take the raw screenshot
2. View it to see actual pixel positions
3. Crop with PIL based on what you see
4. View the result — if not right, re-crop (instant, no re-screenshot needed)

### 3. Iterate on crop, not on capture

- Re-screenshotting is slow (browser launch + page load + render wait)
- Re-cropping is instant (just PIL)
- Get one good raw capture, then slice it as many ways as needed

### 4. Interactive states

```python
element = page.locator("selector").first
await element.hover()
await page.wait_for_timeout(1000)  # let tooltip appear
await page.screenshot(path="screenshot-hover.png", full_page=True)
```

For "selected" state without hover effect, move the mouse away after clicking:

```python
await element.click()
await page.mouse.move(300, 300)  # move away so hover doesn't show
await page.wait_for_timeout(500)
await page.screenshot(path="screenshot-selected.png", full_page=True)
```

### 5. Section-specific captures

Crop different sections from a single full-page screenshot:

```python
img.crop((0, 200, 920, 900)).save("screenshot-header.png")
img.crop((0, 900, 920, 1600)).save("screenshot-main.png")
```

## Guidelines

1. **Always capture before state BEFORE making any changes** — if you forget, you have to revert code to get a before shot
2. **Before/after pairs must use the same viewport width and crop** — otherwise the comparison is useless
3. **To get a "before" after you already changed code**: use `git checkout HEAD~1 -- <files>` to revert, screenshot, then `git checkout HEAD -- <files>` to restore
4. **For interactive states**: capture before AND after for each state — don't assume the "normal" before covers all cases
5. **Use `device_scale_factor=1`** in Playwright to force 1x pixels so screenshots match what users see at 100% zoom
6. **Charts need extra wait time** — Plotly, D3, etc. render asynchronously; 4s minimum after networkidle
7. **Narrow viewport reveals rendering bugs** — some border/alignment issues only appear at specific widths

## Non-Web App Screenshots

For desktop apps (VS, WPF, WinForms, console apps, terminals) where Playwright can't reach. See [references/desktop-recording.md](references/desktop-recording.md) for `mss` + ctypes capture code and [references/electron-screenshots.md](references/electron-screenshots.md) for Electron app capture via Node.js Playwright.

### Decision tree

| Scenario | Tool | Notes |
|---|---|---|
| Web app (localhost) | Playwright | Proven, full DOM access |
| Electron app (VS Code) | Playwright Electron (Node.js) | Works minimized via CDP |
| Desktop app, visible window | mss + ctypes (find by title) | ~33ms per capture |
| Desktop app, behind windows | Windows Graphics Capture API | Complex setup, Win10 1903+ |
| Quick full-screen | mss | ~68ms |

## Limitations

- Web capture requires a locally running app or accessible URL
- Desktop capture (mss) requires the window to be visible and unobstructed
- Electron capture requires Node.js Playwright (not Python)
- Some SPAs with heavy client-side rendering may need custom wait logic beyond networkidle
