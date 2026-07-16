---
name: ui-screenshots
description: Use when capturing screenshots of a running web app, Electron app, or desktop window during development — full-page, interactive states, before/after pairs, section crops — or assembling them into an annotated animated GIF/video demo.
---

# UI Screenshots

Capture screenshots of web apps and graphical UIs during development to document visual changes. Also assembles captured frames into annotated animated GIF demos (formerly the `screen-recording` skill).

## When to Use This Skill

Use this skill when you need to:
- Capture the current state of a running web app
- Document a UI before and after a code change
- Screenshot interactive states (tooltips, hovers, selected elements)
- Capture specific sections of a page without re-screenshotting
- Build an animated GIF demo from stepped frames (PRs, docs, release notes)

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

For desktop apps (VS, WPF, WinForms, console apps, terminals) where Playwright can't reach.

### mss + ctypes (recommended for desktop windows)

Find a window by title via Win32 API, capture its region with `mss`. Tested at ~33ms per capture.

```python
import ctypes
from ctypes import c_int, Structure, byref, windll
import mss
from PIL import Image

user32 = windll.user32

def find_window(title_contains):
    """Find visible windows matching a title substring."""
    results = []
    WNDENUMPROC = ctypes.WINFUNCTYPE(ctypes.c_bool, ctypes.c_void_p, ctypes.c_void_p)
    def cb(hwnd, _):
        if user32.IsWindowVisible(hwnd):
            buf = ctypes.create_unicode_buffer(256)
            user32.GetWindowTextW(hwnd, buf, 256)
            if title_contains.lower() in buf.value.lower():
                results.append((hwnd, buf.value))
        return True
    user32.EnumWindows(WNDENUMPROC(cb), 0)
    return results

def capture_window(title_contains, output_path):
    """Capture a window by title substring."""
    windows = find_window(title_contains)
    if not windows:
        raise ValueError(f"No window matching '{title_contains}'")
    hwnd = windows[0][0]

    class RECT(Structure):
        _fields_ = [('left', c_int), ('top', c_int), ('right', c_int), ('bottom', c_int)]
    rect = RECT()
    user32.GetWindowRect(hwnd, byref(rect))
    w, h = rect.right - rect.left, rect.bottom - rect.top

    with mss.mss() as sct:
        shot = sct.grab({'left': rect.left, 'top': rect.top, 'width': w, 'height': h})
        img = Image.frombytes('RGB', shot.size, shot.rgb)
        img.save(output_path)
        return img

# Usage:
capture_window('Visual Studio Code', 'vscode-capture.png')
```

**Prerequisites:** `pip install mss pillow`
**Limitation:** Window must be visible (not behind other windows or minimized).

### Electron apps (VS Code, etc.)

**Node.js Playwright only** — Python Playwright has no `electron` API. Captures via CDP (Chrome DevTools Protocol), not from the screen — works even while minimized.

```javascript
const { _electron: electron } = require('playwright');
const app = await electron.launch({
    executablePath: 'C:\\Program Files\\Microsoft VS Code\\Code.exe',
    args: ['--new-window', '--disable-extensions', '--user-data-dir=' + tmpDir]
});
const window = await app.firstWindow();
await window.waitForLoadState('domcontentloaded');

// Minimize immediately — captures still work via CDP
await app.evaluate(({ BrowserWindow }) => {
    BrowserWindow.getAllWindows()[0].minimize();
});

await window.screenshot({ path: 'capture.png' }); // works while minimized!
await app.close();
```

**Critical**: `--user-data-dir=<temp>` is required or VS Code hands off to the existing instance and the launched process exits immediately.

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

## Animated GIF demos (from captured frames)

Create animated GIFs that show a feature or workflow in action — with annotations, variable timing, and proper pacing. Useful for PR descriptions, documentation, and release notes.

**Prerequisites:**

```bash
pip install playwright Pillow imageio numpy scipy mss -q
playwright install chromium
```

### 1. Capture frames

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

### 2. Assemble the GIF with imageio

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

### 3. Variable frame timing

Uniform timing feels too fast or too slow. Use variable durations:

| Phase | Duration | Why |
|-------|----------|-----|
| Fast action (typing, clicking) | 100ms | Feels natural, keeps energy |
| Pause after action | 600–800ms | Let the viewer process |
| Hero/final message | 500ms+ | Takeaway needs time to land |

### 4. Annotate frames

Apply callouts to specific frames using the `image-annotations` skill's `annotate_image()`. For each frame needing a rectangle, arrow, or label, delegate rather than re-implementing the drawing:

```python
from PIL import Image
from annotate import annotate_image  # from image-annotations/references/annotate.py

def annotate_frame(frame_path, annotations, out_path):
    annotated = annotate_image(Image.open(frame_path), annotations)
    annotated.save(out_path)
```

### 5. Fade-in annotations

```python
def apply_fade(base, layer, alpha):
    return Image.blend(
        base.convert("RGBA"), layer.convert("RGBA"), alpha
    ).convert("RGB")

# 2-frame pop-in at 10fps: 50% then 100%
faded = [apply_fade(base, ann, 0.5), apply_fade(base, ann, 1.0)]
```

At 10fps use 2 fade frames (0.2s total); at 30fps use 3–4. Easing curves look bad at low FPS — simple pop-in is snappier.

### Guidelines

- **Type → pause → annotate**: no annotation during fast action; pause first, then annotate.
- **Hero message gets the biggest font** (64pt+); 38pt for details.
- **GIF palette does not kill gradients** — 20 distinct alpha steps survive 256 colors.
- **10fps minimum** for typing/interaction.
- Build iteratively: frame sequence → annotations → timing.
- **Test in isolation** before rebuilding the full demo (overlay a frame counter for debugging).

### Format compatibility

| Format | VS Code | GitHub | Browser |
|--------|---------|--------|---------|
| GIF | ✅ animates | ✅ | ✅ |
| WebP | ⚠ static | ✅ | ✅ |
| MP4 | ❌ broken | ⚠ | ✅ |

GIF is the only universally supported animated format.

### References

- `references/cluster-detection.md` — `find_changed_clusters` to auto-locate changed regions for annotation.
- `references/desktop-recording.md` — `mss` capture code and window-recording patterns for non-browser sources.
