/**
 * Hand-drawn marks on a phrase, after componentry's "annotated text": wrap a
 * short phrase in <span data-annotate="circle">…</span> (in Markdown too) and a
 * slightly irregular stroke draws itself once the phrase scrolls into view.
 *
 *   underline · double · wavy · circle · box · highlight · strike · bracket
 *
 * data-delay="0.4" waits that many seconds first, so a paragraph can stagger
 * its marks. The strokes are seeded by the phrase, so they look the same on
 * every visit, and are redrawn when the phrase changes size. Without JS, or
 * with reduced motion, the marks are simply there (or, without JS, absent).
 */
const NS = 'http://www.w3.org/2000/svg'

/** a small seeded generator, so a phrase always gets the same wobble */
const rng = (key: string) => {
  let h = 2166136261
  for (const c of key) h = Math.imul(h ^ c.charCodeAt(0), 16777619)
  return () => {
    h = Math.imul(h ^ (h >>> 15), 2246822507)
    h = Math.imul(h ^ (h >>> 13), 3266489909)
    return ((h ^= h >>> 16) >>> 0) / 4294967296
  }
}

type Pt = [number, number]
const line = (pts: Pt[]) => pts.map(([x, y], i) => `${i ? 'L' : 'M'}${x.toFixed(1)} ${y.toFixed(1)}`).join('')
/** a stroke from a to b that sags a little, like a hand pulling a pen */
const stroke = (r: () => number, a: Pt, b: Pt, wobble = 1.6) => {
  const mx = (a[0] + b[0]) / 2 + (r() - 0.5) * wobble * 4
  const my = (a[1] + b[1]) / 2 + (r() - 0.5) * wobble * 2
  return `M${a[0].toFixed(1)} ${a[1].toFixed(1)}Q${mx.toFixed(1)} ${my.toFixed(1)} ${b[0].toFixed(1)} ${b[1].toFixed(1)}`
}

/** path data (one or more strokes) for a w × h phrase */
const MARKS: Record<string, (w: number, h: number, r: () => number) => string[]> = {
  underline: (w, h, r) => [stroke(r, [-2, h + 1 + r() * 2], [w + 3, h + r() * 2])],
  double: (w, h, r) => [stroke(r, [-2, h], [w + 2, h - 1 + r() * 2]), stroke(r, [2, h + 5], [w + 4, h + 4 + r() * 2])],
  strike: (w, h, r) => [stroke(r, [-3, h * 0.55 + r() * 2], [w + 3, h * 0.5 + r() * 2])],
  wavy: (w, h, r) => {
    const pts: Pt[] = []
    const period = 9 + r() * 3
    for (let x = -2; x <= w + 2; x += 1.5) pts.push([x, h + 2 + Math.sin((x / period) * Math.PI * 2) * 2.2])
    return [line(pts)]
  },
  highlight: (w, h, r) => [stroke(r, [-4, h * 0.62], [w + 4, h * 0.58 + (r() - 0.5) * 3], 0.6)],
  circle: (w, h, r) => {
    // an ellipse that does not quite close and overshoots its start
    const cx = w / 2
    const cy = h / 2
    const rx = w / 2 + 6
    const ry = h / 2 + 5
    const start = -Math.PI * (0.55 + r() * 0.2)
    const pts: Pt[] = []
    for (let t = 0; t <= 1.08; t += 0.01) {
      const a = start + t * Math.PI * 2
      const k = 1 + (r() - 0.5) * 0.015 + t * 0.06
      pts.push([cx + Math.cos(a) * rx * k, cy + Math.sin(a) * ry * k])
    }
    return [line(pts)]
  },
  box: (w, h, r) => {
    const j = () => (r() - 0.5) * 4
    const p: Pt[] = [[-6 + j(), -4 + j()], [w + 6 + j(), -4 + j()], [w + 6 + j(), h + 4 + j()], [-6 + j(), h + 4 + j()]]
    return [stroke(r, p[0], p[1]), stroke(r, [p[1][0] - 2, p[1][1] - 2], p[2]), stroke(r, p[2], p[3]), stroke(r, p[3], [p[0][0] + 1, p[0][1] - 3])]
  },
  bracket: (w, h) => [`M-4 -3Q-9 -3 -9 3L-9 ${h - 3}Q-9 ${h + 3} -4 ${h + 3}`, `M${w + 4} -3Q${w + 9} -3 ${w + 9} 3L${w + 9} ${h - 3}Q${w + 9} ${h + 3} ${w + 4} ${h + 3}`],
}

const draw = (el: HTMLElement) => {
  const kind = el.dataset.annotate && MARKS[el.dataset.annotate] ? el.dataset.annotate : 'underline'
  const w = el.offsetWidth
  const h = el.offsetHeight
  if (!w || !h) return
  el.querySelector(':scope > .ann')?.remove()
  const svg = document.createElementNS(NS, 'svg')
  svg.setAttribute('class', `ann ann--${kind}`)
  svg.setAttribute('aria-hidden', 'true')
  svg.setAttribute('width', String(w))
  svg.setAttribute('height', String(h))
  svg.setAttribute('viewBox', `0 0 ${w} ${h}`)
  const paths = MARKS[kind](w, h, rng(kind + el.textContent))
  paths.forEach((d, i) => {
    const p = document.createElementNS(NS, 'path')
    p.setAttribute('d', d)
    p.setAttribute('pathLength', '1')
    p.style.setProperty('--n', String(i))
    if (kind === 'highlight') p.style.strokeWidth = `${(h * 0.5).toFixed(1)}px`
    svg.append(p)
  })
  el.append(svg)
}

const init = () => {
  const els = [...document.querySelectorAll<HTMLElement>('[data-annotate]:not([data-annotate-ready])')]
  if (!els.length) return
  const still = matchMedia('(prefers-reduced-motion: reduce)').matches
  const io = new IntersectionObserver(
    (entries) => {
      for (const e of entries) {
        if (!e.isIntersecting) continue
        const el = e.target as HTMLElement
        el.style.setProperty('--delay', `${parseFloat(el.dataset.delay ?? '0') || 0}s`)
        el.classList.add('is-drawn')
        io.unobserve(el)
      }
    },
    { rootMargin: '0px 0px -12% 0px' },
  )
  const ro = new ResizeObserver((entries) => entries.forEach((e) => draw(e.target as HTMLElement)))
  document.fonts.ready.then(() => {
    for (const el of els) {
      el.dataset.annotateReady = ''
      if (still) el.classList.add('is-drawn')
      else io.observe(el)
      ro.observe(el)
    }
  })
  document.addEventListener(
    'astro:before-swap',
    () => {
      io.disconnect()
      ro.disconnect()
    },
    { once: true },
  )
}
document.addEventListener('astro:page-load', init)
