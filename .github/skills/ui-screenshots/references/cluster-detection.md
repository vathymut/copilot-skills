# Diff-Based Cluster Detection

Find changed regions between two frames to decide what to annotate.

```python
import numpy as np
from scipy import ndimage

def find_changed_clusters(frame_a, frame_b, threshold=30, min_pixels=300, dilate=5):
    """Find bounding boxes of changed regions between two frames."""
    diff = np.abs(frame_b.astype(float) - frame_a.astype(float)).max(axis=2)
    mask = diff > threshold
    dilated = ndimage.binary_dilation(mask, iterations=dilate)
    labeled, n = ndimage.label(dilated)
    clusters = []
    for i in range(1, n + 1):
        ys, xs = np.where(labeled == i)
        if len(ys) < min_pixels:
            continue
        clusters.append((xs.min(), ys.min(), xs.max(), ys.max(), len(ys)))
    return sorted(clusters, key=lambda c: -c[4])  # largest first
```
