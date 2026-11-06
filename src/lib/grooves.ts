/**
 * The pressing of a record, as shares of its radius and SVG paths for a viewBox
 * of -500 -500 1000 1000. The grooves themselves are a printed pattern (see
 * Crate.astro); here are the clear gaps between tracks, the run-out and the rim.
 */
export const INNER = 262
export const OUTER = 484

const ring = (r: number) => {
  const k = r.toFixed(1)
  return `M${k} 0A${k} ${k} 0 1 0-${k} 0A${k} ${k} 0 1 0 ${k} 0`
}

/**
 * A gap at the end of every track but the last, the bands a little uneven as
 * tracks are. Seeded by the title, so a record is the same on the server and in
 * the browser.
 */
export const trackGaps = (title: string, tracks: number) => {
  let seed = title.length * 7 + tracks
  const shares = Array.from({ length: Math.max(1, tracks) }, () => {
    seed = (seed * 9301 + 49297) % 233280
    return 0.7 + (seed / 233280) * 0.6
  })
  const sum = shares.reduce((x, y) => x + y, 0)
  let at = OUTER
  let d = ''
  for (const share of shares.slice(0, -1)) {
    at -= (share / sum) * (OUTER - INNER)
    d += ring(at)
  }
  return d
}

/** the raised rim at the edge, and the lip of the label */
export const rims = `${ring(498)}${ring(492)}${ring(204)}`

/** the run-out: a clear band between two true circles, so nothing wobbles as the record turns */
const FROM = INNER - 2
const TO = 216
export const runOut = ring(FROM) + ring(TO)
/** the line the matrix number is scratched along, in the middle of the run-out */
const MATRIX = 232
export const matrixLine = `M${MATRIX} 0A${MATRIX} ${MATRIX} 0 1 1-${MATRIX} 0`
