# Desktop Screen Recording

Capture desktop apps, terminals, or anything outside a browser using `mss`.

## Basic mss recording

```python
import mss
from PIL import Image
import time

def record_gif(output_path, region=None, duration=5, fps=8):
    """Record screen region to GIF. region = {left, top, width, height} or None for full screen."""
    with mss.mss() as sct:
        if region is None:
            region = sct.monitors[1]  # primary monitor

        frames = []
        t_end = time.time() + duration
        while time.time() < t_end:
            t0 = time.time()
            shot = sct.grab(region)
            frames.append(Image.frombytes('RGB', shot.size, shot.rgb))
            time.sleep(max(0, 1 / fps - (time.time() - t0)))

    frames[0].save(output_path, save_all=True, append_images=frames[1:],
                   duration=int(1000 / fps), loop=0, optimize=True)
    return len(frames)

record_gif('demo.gif', region={'left': 0, 'top': 0, 'width': 800, 'height': 500}, duration=3)
```

Tested: 3s at 8fps → 24 frames, ~31KB. Keep fps ≤ 10 for reasonable file sizes.

**Note:** `PIL.save(save_all=True)` works for simple recordings but merges visually similar frames. For annotated GIFs with fade effects, use `imageio.v3.imwrite` instead.

## Combining with window capture

```python
# Find window rect, then record it as a GIF
import ctypes
from ctypes import c_int, Structure, byref, windll

class RECT(Structure):
    _fields_ = [('left', c_int), ('top', c_int), ('right', c_int), ('bottom', c_int)]

hwnd = find_window('My App')[0][0]
rect = RECT()
windll.user32.GetWindowRect(hwnd, byref(rect))
region = {'left': rect.left, 'top': rect.top,
          'width': rect.right - rect.left, 'height': rect.bottom - rect.top}
record_gif('app-demo.gif', region=region, duration=5, fps=8)
```
