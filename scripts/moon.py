"""
Make the scrollbar's moon (src/components/Rail.astro): a photograph of the
moon, its left part broken off along a crumbly fracture that leaves more of it
at the bottom, a few crumbs come loose beside the break and a few tiny spots
worn through, lit from the right and printed in ultramarine ink, its tone kept
soft with only a light grain.

    python3 scripts/moon.py   ->  src/assets/rail/moon@{1,2,3}x.png

The source is NASA's LRO mosaic of the near side (public domain,
NASA/GSFC/Arizona State University), kept at src/assets/rail/moon-lro.jpg.
Each size is made at its own pixels, so the grain stays crisp on any screen.

Needs: numpy, pillow
"""
import math
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
# light from the upper right, nearly full on, so the broken edge stays crisp
nz = np.sqrt(np.clip(1 - nx**2 - ny**2, 0, 1))
L = np.array([0.42, -0.3, 0.86])
L /= np.linalg.norm(L)
lambert = np.clip(nx * L[0] + ny * L[1] + nz * L[2], 0, 1)
shade = np.clip((lambert - 0.02) / 0.75, 0, 1) ** 0.8
value = canvas * (0.25 + 0.95 * shade) * 1.55
value = np.where(inside, np.clip(value, 0, 1), 0)

# ---- the break ----
# The left part is gone. The fracture runs from just right of the top down to
# the lower left, so more of the moon is left at the bottom; it is crumbly at
# two scales, with a couple of chips taken out.
rng = np.random.default_rng(23)
ys = np.linspace(-1.08, 1.08, 44)
base = 0.16 - 0.22 * (ys + 1.08) - 0.04 * (ys + 1.08) ** 2  # curving out to the lower left
wobble = np.convolve(rng.normal(0, 0.05, ys.size), np.ones(4) / 4, mode="same") + rng.normal(0, 0.018, ys.size)
xs = base + wobble
for k in rng.choice(np.arange(6, ys.size - 6), 2, replace=False):  # chips
    xs[k - 1 : k + 2] += [0.05, 0.11, 0.05]
edge_px = [(cx + x * R, cy + y * R) for x, y in zip(xs, ys)]
keep = Image.new("L", (N, N), 0)
ImageDraw.Draw(keep).polygon(edge_px + [(N, cy + 1.08 * R), (N, cy - 1.08 * R)], fill=255)
keep = (np.asarray(keep) > 0) & inside
alpha = keep.astype(np.float64)

# worn away: tiny holes, mostly near the break, a couple further in; some go
# right through, some only thin the ink
holes = Image.new("L", (N, N), 0)
hd = ImageDraw.Draw(holes)
for i in range(16):
    j = rng.integers(3, ys.size - 3)
    near = i < 12
    dx = rng.uniform(0.04, 0.2) if near else rng.uniform(0.35, 0.75)
    r = R * (rng.uniform(0.018, 0.045) if near else rng.uniform(0.012, 0.025))
    hx, hy = cx + (xs[j] + dx) * R, cy + ys[j] * R
    depth = 255 if rng.random() < 0.6 else 140
    hd.ellipse((hx - r, hy - r * rng.uniform(0.7, 1.2), hx + r, hy + r * rng.uniform(0.7, 1.2)), fill=depth)
alpha *= 1 - np.asarray(holes, dtype=np.float64) / 255

# crumbs: three small bits from the lost side, come loose just beside the edge
crumbs = np.zeros_like(alpha)
lost = inside & ~keep
for j, (off_x, off_y), r in zip(rng.choice(np.arange(10, ys.size - 6), 3, replace=False), [(-0.09, 0.04), (-0.16, 0.08), (-0.07, 0.12)], [0.06, 0.045, 0.035]):
    bx, by = cx + (xs[j] - 0.03) * R, cy + ys[j] * R
    bit = Image.new("L", (N, N), 0)
    pts = [(bx + R * r * math.cos(t) * rng.uniform(0.6, 1.3), by + R * r * math.sin(t) * rng.uniform(0.6, 1.3)) for t in np.linspace(0, 2 * math.pi, 7)[:-1]]
    ImageDraw.Draw(bit).polygon(pts, fill=255)
    bit = (np.asarray(bit) > 0) & lost
    shifted = np.roll(np.roll(bit, int(off_y * R), axis=0), int(off_x * R), axis=1)
    crumbs = np.maximum(crumbs, shifted.astype(np.float64))
    value = np.where(shifted, np.roll(np.roll(value, int(off_y * R), axis=0), int(off_x * R), axis=1), value)
alpha = np.maximum(alpha, crumbs)
moon = value * (alpha > 0)

# crop to what is left
cols = np.nonzero((alpha > 0).any(axis=0))[0]
rows = np.nonzero((alpha > 0).any(axis=1))[0]
x0, x1, y0, y1 = cols[0], cols[-1] + 1, rows[0], rows[-1] + 1
moon = moon[y0:y1, x0:x1]
mask = alpha[y0:y1, x0:x1]

# ---- ink: the tone as the ink's strength, with a light ordered grain ----
B = np.array([[0, 8, 2, 10], [12, 4, 14, 6], [3, 11, 1, 9], [15, 7, 13, 5]]) / 16
LEVELS = 6  # a few steps of ink, so the grain is gentle rather than a dither of dots
scale_css = CSS / WORK
for scale in (1, 2, 3):
    pw = round(moon.shape[1] * scale_css * scale)
    ph = round(moon.shape[0] * scale_css * scale)
    small = np.asarray(Image.fromarray((moon * 255).astype(np.uint8)).resize((pw, ph), Image.LANCZOS), dtype=np.float64) / 255
    inside_small = np.asarray(Image.fromarray((mask * 255).astype(np.uint8)).resize((pw, ph), Image.LANCZOS), dtype=np.float64) / 255
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
