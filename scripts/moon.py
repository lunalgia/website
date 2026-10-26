"""
Make the scrollbar's moon (src/components/Rail.astro): a photograph of the
moon, its left part broken off along a jagged line near the middle, the rest
lit from the right and printed in ultramarine ink, its tone kept soft with
only a light grain.

    python3 scripts/moon.py   ->  src/assets/rail/moon@{1,2,3}x.png

The source is NASA's LRO mosaic of the near side (public domain,
NASA/GSFC/Arizona State University), kept at src/assets/rail/moon-lro.jpg.
Each size is made at its own pixels, so the grain stays crisp on any screen.

Needs: numpy, pillow
"""
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "src/assets/rail/moon-lro.jpg"
OUT = ROOT / "src/assets/rail"

CSS = 20  # the whole moon's diameter in CSS pixels (about half of it is left)
INK = (2, 8, 135)  # --ultramarine
WORK = 520  # working resolution for the geometry

# ---- the moon, as a lit sphere ----
src = Image.open(SRC).convert("L")
w, h = src.size
# the disc fills the frame, less a hair of black sky
disc = src.crop((int(w * 0.004), int(h * 0.004), int(w * 0.996), int(h * 0.996))).resize((WORK, WORK), Image.LANCZOS)
lum = np.asarray(disc, dtype=np.float64) / 255

pad = 0
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

# ---- the break: the left part is gone, along a jagged line near the middle ----
rng = np.random.default_rng(11)
ys = np.linspace(-1.05, 1.05, 15)
edge = [(-0.04 + 0.1 * y + rng.uniform(-0.09, 0.09), y) for y in ys]  # leans a little, splinters
edge_px = [(cx + x * R, cy + y * R) for x, y in edge]
keep = Image.new("L", (N, N), 0)
ImageDraw.Draw(keep).polygon(edge_px + [(N, cy + 1.05 * R), (N, cy - 1.05 * R)], fill=255)
keep = (np.asarray(keep) > 0) & inside
moon = value * keep

# crop to what is left
cols = np.nonzero(keep.any(axis=0))[0]
rows = np.nonzero(keep.any(axis=1))[0]
x0, x1, y0, y1 = cols[0], cols[-1] + 1, rows[0], rows[-1] + 1
moon = moon[y0:y1, x0:x1]
mask = keep[y0:y1, x0:x1]

# ---- ink: the tone as the ink's strength, with a light ordered grain ----
B = np.array([[0, 8, 2, 10], [12, 4, 14, 6], [3, 11, 1, 9], [15, 7, 13, 5]]) / 16
LEVELS = 6  # a few steps of ink, so the grain is gentle rather than a dither of dots
scale_css = CSS / WORK
for scale in (1, 2, 3):
    pw = round(moon.shape[1] * scale_css * scale)
    ph = round(moon.shape[0] * scale_css * scale)
    small = np.asarray(Image.fromarray((moon * 255).astype(np.uint8)).resize((pw, ph), Image.LANCZOS), dtype=np.float64) / 255
    inside_small = np.asarray(Image.fromarray(mask.astype(np.uint8) * 255).resize((pw, ph), Image.LANCZOS), dtype=np.float64) / 255
    tone = np.clip(0.18 + 0.82 * small, 0, 1) ** 0.9  # even the darkest maria keep a little ink
    th = np.tile(B, (ph // 4 + 1, pw // 4 + 1))[:ph, :pw]
    q = np.floor(tone * (LEVELS - 1) + th) / (LEVELS - 1)
    alpha = np.clip(q, 0, 1) * inside_small
    rgba = np.zeros((ph, pw, 4), dtype=np.uint8)
    rgba[..., :3] = INK
    rgba[..., 3] = (alpha * 255).round().astype(np.uint8)
    Image.fromarray(rgba).save(OUT / f"moon@{scale}x.png", optimize=True)

w1 = moon.shape[1] * scale_css
h1 = moon.shape[0] * scale_css
print(f"moon: {w1:.1f} x {h1:.1f} css px at 1x/2x/3x -> {OUT.relative_to(ROOT)}")
