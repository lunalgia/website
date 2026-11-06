/**
 * A book drawn in axonometric, as SVG paths for a viewBox of 0 0 733 800: the cover
 * lying flat, its two edges of paper below it, ruled in ink (see Block.astro). Its
 * thickness and its rules come from the page count, so a book is the same on the
 * server and in the browser.
 */
type Point = [number, number]

export const WIDTH = 733
export const HEIGHT = 800
/** the cover's size, and the matrix that lays it down */
export const COVER_W = 432
export const COVER_H = 648

/** the corner the cover hangs from, and its two sides */
const O: Point = [279, 18]
const U: Point = [402, 108]
const V: Point = [-279, 584]
/** the way the thickness runs, and how thick the longest book is */
const DEPTH: Point = [0.55, 0.83]
const THICKEST = { pages: 576, at: 94 }
/** pages to a rule */
const PITCH = 24

const add = (a: Point, ...more: Point[]): Point => more.reduce<Point>((p, q) => [p[0] + q[0], p[1] + q[1]], a)
const times = (a: Point, n: number): Point => [a[0] * n, a[1] * n]
const line = (points: Point[]) => points.map((p, i) => `${i ? 'L' : 'M'}${p[0].toFixed(1)} ${p[1].toFixed(1)}`).join('')

export const coverMatrix = `matrix(${U[0] / COVER_W} ${U[1] / COVER_W} ${V[0] / COVER_H} ${V[1] / COVER_H} ${O[0]} ${O[1]})`

const R = add(O, U)
const L = add(O, V)
const F = add(O, U, V)

/** the outline and rules of a book of so many pages */
export const blockOf = (pages: number) => {
  const thick = (pages / THICKEST.pages) * THICKEST.at
  const W = times(DEPTH, thick)
  const rules = Math.round(pages / PITCH)
  let ruled = ''
  for (let j = 1; j < rules; j++) {
    const off = times(W, j / rules)
    ruled += line([add(R, off), add(F, off), add(L, off)])
  }
  const board = times(DEPTH, 7)
  return {
    /** the paper's two faces, to fill and to click */
    paper: `${line([R, add(R, W), add(F, W), add(L, W), L, F])}Z`,
    rules: ruled,
    outline: `${line([O, R, add(R, W), add(F, W), add(L, W), L, O])}${line([R, F, L])}${line([F, add(F, W)])}`,
    board: line([add(R, board), add(F, board), add(L, board)]),
    ribbon: add(L, times(U, 0.16), times(W, 0.5)),
  }
}

/** half the ribbon's width, and how far its lines run in from the edge */
const HALF = 8
const WEAVE = 0.66
const STEPS = 24

/**
 * The ribbon: out from between the pages at the tail, down over them and onto the page.
 * One even width all the way, cut to a swallowtail, with the weave's two lines along it.
 * `sway` is how far it leans, about -1 to 1.
 */
export const ribbonOf = (p0: Point, sway = 0) => {
  const p1: Point = [p0[0] - 6, p0[1] + 42]
  const p2: Point = [p0[0] - 52 + sway * 34, p0[1] + 66]
  const p3: Point = [p0[0] - 60 - sway * 24, p0[1] + 128]
  const mid: Point[] = []
  const across: Point[] = []
  for (let i = 0; i <= STEPS; i++) {
    const t = i / STEPS
    const m = 1 - t
    const at = (a: 0 | 1) => m * m * m * p0[a] + 3 * m * m * t * p1[a] + 3 * m * t * t * p2[a] + t * t * t * p3[a]
    const slope = (a: 0 | 1) => 3 * m * m * (p1[a] - p0[a]) + 6 * m * t * (p2[a] - p1[a]) + 3 * t * t * (p3[a] - p2[a])
    mid.push([at(0), at(1)])
    const n = Math.hypot(slope(0), slope(1)) || 1
    across.push([-slope(1) / n, slope(0) / n])
  }
  const edge = (f: number) => mid.map((c, i): Point => add(c, times(across[i], HALF * f)))
  const end = mid[STEPS]
  const before = mid[STEPS - 2]
  const back = Math.hypot(end[0] - before[0], end[1] - before[1]) || 1
  const notch = add(end, times([before[0] - end[0], before[1] - end[1]], (HALF * 1.5) / back))
  return {
    ribbon: `${line([...edge(1), notch, ...edge(-1).reverse()])}Z`,
    weave: `${line(edge(WEAVE).slice(0, STEPS - 1))}${line(edge(-WEAVE).slice(0, STEPS - 1))}`,
  }
}
