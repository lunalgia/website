"""
Make the scrollbar's moon (src/components/Rail.astro): a photograph of the
moon, broken, shaded into a waning gibbous, and printed in ultramarine ink as
an ordered dither, like the lily on the home page.

    python3 scripts/moon.py   ->  src/assets/rail/moon-{upper,lower,shard}@{1,2,3}x.png

The source is NASA's LRO mosaic of the near side (public domain,
NASA/GSFC/Arizona State University), kept at src/assets/rail/moon-lro.jpg.
The moon comes out as three layers on one canvas (the upper piece, the lower
piece knocked out of line, a shard), so the rail can push them apart on hover.
Each size is dithered at its own pixels, so the dots stay crisp on any screen.

Needs: numpy, pillow
"""
import math
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "src/assets/rail/moon-lro.jpg"
OUT = ROOT / "src/assets/rail"

CSS = 28  # the moon's size in CSS pixels
INK = (2, 8, 135)  # --ultramarine
WORK = 520  # working resolution for the geometry

# ---- the moon, as a lit sphere ----
src = Image.open(SRC).convert("L")
w, h = src.size
# the disc fills the frame, less a hair of black sky
disc = src.crop((int(w * 0.004), int(h * 0.004), int(w * 0.996), int(h * 0.996))).resize((WORK, WORK), Image.LANCZOS)
lum = np.asarray(disc, dtype=np.float64) / 255

pad = int(WORK * 0.16)  # room around the disc for the pieces to move into
N = WORK + 2 * pad
yy, xx = np.mgrid[0:N, 0:N]
cx = cy = N / 2
R = WORK / 2 - 1
nx, ny = (xx - cx) / R, (yy - cy) / R
inside = nx**2 + ny**2 <= 1

canvas = np.zeros((N, N))
canvas[pad : pad + WORK, pad : pad + WORK] = lum
# light from the upper right: a waning gibbous, the terminator soft and curved
nz = np.sqrt(np.clip(1 - nx**2 - ny**2, 0, 1))
L = np.array([0.62, -0.38, 0.69])
L /= np.linalg.norm(L)
lambert = np.clip(nx * L[0] + ny * L[1] + nz * L[2], 0, 1)
shade = np.clip((lambert - 0.02) / 0.75, 0, 1) ** 0.8
value = canvas * (0.25 + 0.95 * shade) * 1.55
value = np.where(inside, np.clip(value, 0, 1), 0)

# ---- the break ----
# a jagged crack from the upper left to the lower right, wandering a little
rng = np.random.default_rng(7)
crack = [(-1.15, -0.32)]
for t in np.linspace(-0.85, 1.15, 13):
    crack.append((t, -0.32 + 0.55 * (t + 1.15) / 2.3 + rng.uniform(-0.07, 0.07)))
crack_px = [(cx + x * R, cy + y * R) for x, y in crack]


def region(points):
    m = Image.new("L", (N, N), 0)
    ImageDraw.Draw(m).polygon(points, fill=255)
    return np.asarray(m) > 0


lower_mask = region(crack_px + [(N, N), (0, N)])
upper_mask = inside & ~lower_mask
lower_mask = inside & lower_mask
# a hairline gap along the crack, eaten out of both pieces
gap = Image.new("L", (N, N), 0)
ImageDraw.Draw(gap).line(crack_px, fill=255, width=max(3, WORK // 55), joint="curve")
gap = np.asarray(gap) > 0
upper_mask &= ~gap
lower_mask &= ~gap
# a shard breaks off the lower piece's right end, where the crack meets the edge
shard_pts = [(cx + 0.55 * R, cy + 0.40 * R), (cx + 1.0 * R, cy + 0.30 * R), (cx + 0.80 * R, cy + 0.66 * R)]
shard_mask = region(shard_pts) & lower_mask
lower_mask &= ~shard_mask


def moved(a, dx, dy, deg, ox, oy):
    """move a layer: rotate about (ox, oy), then shift (in canvas pixels)"""
    img = Image.fromarray((a * 255).astype(np.uint8))
    img = img.rotate(-deg, resample=Image.BICUBIC, center=(ox, oy), translate=(dx, dy))
    return np.asarray(img, dtype=np.float64) / 255


layers = {
    "upper": value * upper_mask,
    # the lower piece slips down and to the left, turning a little
    "lower": moved(value * lower_mask, -0.05 * R, 0.11 * R, 7, cx, cy),
    # the shard drifts off to the lower right
    "shard": moved(value * shard_mask, 0.13 * R, 0.16 * R, 24, cx + 0.78 * R, cy + 0.45 * R),
}

# ---- print: an ordered dither at each size, in ink ----
B = np.array([[0, 32, 8, 40, 2, 34, 10, 42], [48, 16, 56, 24, 50, 18, 58, 26], [12, 44, 4, 36, 14, 46, 6, 38],
              [60, 28, 52, 20, 62, 30, 54, 22], [3, 35, 11, 43, 1, 33, 9, 41], [51, 19, 59, 27, 49, 17, 57, 25],
              [15, 47, 7, 39, 13, 45, 5, 37], [63, 31, 55, 23, 61, 29, 53, 21]]) / 64 + 1 / 128

size_css = CSS * N / WORK  # the canvas is a little bigger than the moon
for scale in (1, 2, 3):
    px = round(size_css * scale)
    for name, a in layers.items():
        small = np.asarray(Image.fromarray((a * 255).astype(np.uint8)).resize((px, px), Image.LANCZOS), dtype=np.float64) / 255
        # lift the midtones so the maria still print as a scatter of dots
        small = np.clip(small * 1.1, 0, 1) ** 0.85
        th = np.tile(B, (px // 8 + 1, px // 8 + 1))[:px, :px]
        on = small > th
        rgba = np.zeros((px, px, 4), dtype=np.uint8)
        rgba[on] = (*INK, 255)
        Image.fromarray(rgba).save(OUT / f"moon-{name}@{scale}x.png", optimize=True)

print(f"moon: canvas {size_css:.1f} css px, layers {', '.join(layers)} at 1x/2x/3x -> {OUT.relative_to(ROOT)}")
