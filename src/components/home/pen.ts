/**
 * How a hand writes "Lunalgia" in Louise: the pen's path, in board units, in
 * the order it is written. The hero reveals each letter's outline
 * (lunalgia.json) through these strokes, so the word appears the way it would
 * be written rather than drawn left to right.
 *
 * The word is one movement. The L goes in at its hook, up over the top, down
 * the stem, round the teardrop and back along the baseline into the u. Each
 * up-and-down stroke (u, n, i) goes up to its top and back down the same line;
 * the a and the g run up the connector to their knob, come back round over the
 * thick top, round the bowl, up the stem and down again, the g on into its
 * loop; the l goes up its hairline and down through the teardrop. The i is
 * dotted last. Retracing a line reveals nothing new, as with a real pen.
 *
 * `w` is the width of the nib needed to cover the glyph along that stretch
 * (wider where the letter swells). A `retrace` goes back over ink that is
 * already there, so the pen moves through it quicker. The centre lines here were traced by hand;
 * the skeleton "strokes" in lunalgia.json are not used.
 */
type Pt = [number, number]
export interface PenStroke {
  /** which glyph of lunalgia.json it writes */
  letter: number
  w: number
  pts: Pt[]
  retrace?: boolean
  /** a separate touch after the word (the dot of the i): it grows from a point instead of being drawn along */
  lift?: boolean
}

const shift = (pts: Pt[], dx: number): Pt[] => pts.map(([x, y]) => [x + dx, y])

// the a, written twice (the second one 173.82 to the right, and with its tail)
const A: Pt[][] = [
  // up the connector over the top to the knob
  [[980.5, 555.5], [983.7, 548.4], [990, 541], [997, 536], [1003, 534], [1010.7, 533], [1016, 533], [1019.5, 533.5]],
  // back round the thick top, down the left side, round the bowl
  [[1019.5, 533.5], [1010.7, 532.5], [1000, 534], [990, 540], [983.7, 548.4], [978.6, 556.1], [972.1, 563.9], [969.6, 572.9], [970.9, 581.9], [974.7, 585.7], [978.6, 586.1], [986.3, 581.9], [992.1, 576.7]],
  // up the stem
  [[992.1, 576.7], [1004.3, 553.6], [1012.6, 538.8], [1015, 535]],
  // back down the stem (retraced)
  [[1015, 535], [1012.6, 538.8], [1004.3, 553.6], [993.5, 574.5]],
  // round, and out
  [[993.5, 574.5], [992.7, 578], [994, 585.7], [997.9, 586.4], [1003, 584], [1010.7, 576.7], [1020, 565], [1030, 553.6]],
]
const A_W = [9, 16, 9, 9, 9]
const A_RETRACE = [false, false, false, true, false]

export const PEN: PenStroke[] = [
  // L
  { letter: 0, w: 9, pts: [[826.4, 521.5], [836, 519.5], [848.5, 514.5], [865.3, 504.3], [876, 494], [882, 482], [883.2, 474], [880, 468.5], [873, 467], [861.4, 468.5], [848.5, 477.3], [835.7, 490], [822.8, 506.8], [812.5, 522.3], [799.7, 542.8], [789.4, 559.5], [780.4, 569.8], [771.4, 577.5], [767, 581]] },
  { letter: 0, w: 15, pts: [[767, 581], [752, 580], [738, 579.5], [729, 580.5]] },
  { letter: 0, w: 10, pts: [[729, 580.5], [740, 585], [760, 585.5], [780, 585], [797, 584.5], [822.8, 581.7], [842, 572.4], [855.8, 553]] },
  // u
  { letter: 1, w: 9, pts: [[855.8, 553], [869.3, 538.1], [877, 529.1], [880.9, 527.9], [883.4, 531.7], [878.3, 543.3], [869.3, 560], [861.6, 572.9], [860.3, 581.9], [864.1, 586.4], [871.9, 585.7], [879.6, 580.8], [892.4, 557.4], [904, 536.9], [908.5, 527.9]] },
  { letter: 1, w: 9, pts: [[908.5, 527.9], [892.4, 557.4], [880.6, 579.5]], retrace: true },
  { letter: 1, w: 9, pts: [[880.6, 579.5], [880.9, 583.1], [884.7, 585.7], [891.1, 583.8], [904, 570.3], [917.5, 553.6]] },
  // n
  { letter: 2, w: 9, pts: [[917.5, 553.6], [929.7, 539.4], [938.7, 530.4], [942.6, 528.5], [945.8, 531.1], [940, 544.6], [927.1, 566.4], [916.2, 585.1]] },
  { letter: 2, w: 9, pts: [[916.2, 585.1], [927.1, 566.4], [940, 544.6], [945.8, 533]], retrace: true },
  { letter: 2, w: 9, pts: [[945.8, 533], [950.3, 531.1], [956.7, 528.9], [961.9, 531.7], [963.1, 538.1], [952.9, 557.4], [942.6, 574.1], [940.6, 581.9], [945.1, 585.7], [951.6, 585.1], [965.7, 571.6], [978.6, 556.1], [980.5, 555.5]] },
  // a
  ...A.map((pts, i) => ({ letter: 3, w: A_W[i], pts, retrace: A_RETRACE[i] })),
  // l
  { letter: 4, w: 9, pts: [[1031.8, 552.6], [1047.9, 536.1], [1056.9, 522.9], [1066, 509.6], [1075.7, 494.3], [1085.5, 479], [1091, 469.9], [1095.9, 465.8], [1100.8, 468.6], [1102.2, 473.4]] },
  { letter: 4, w: 16, pts: [[1102.2, 473.4], [1095.9, 481.8], [1085.5, 492.9], [1072.9, 506.9], [1060.4, 522.2]] },
  { letter: 4, w: 9, pts: [[1060.4, 522.2], [1049.3, 537.5], [1038.1, 555.6], [1029.7, 569.5], [1027.7, 579.3], [1031.1, 584.9], [1038.1, 585.6], [1047.9, 582.1], [1059, 570.9], [1070.1, 554.2]] },
  // g
  { letter: 5, w: 9, pts: [[1070.1, 554.2], [1075.7, 545.9], [1082.7, 537.5], [1089.6, 532.6], [1098, 529.1], [1103.6, 528], [1108, 529.5], [1110, 532.6]] },
  { letter: 5, w: 18, pts: [[1110, 532.6], [1103.6, 528.5], [1095, 530], [1086, 535], [1078, 542], [1070.1, 554.2], [1061.8, 568.1], [1059, 579.3], [1061.8, 584.2], [1067.4, 585.6], [1074.3, 583.5], [1077.1, 581.8]] },
  { letter: 5, w: 9, pts: [[1077.1, 581.8], [1089.6, 559.8], [1100.8, 540.3], [1104, 535.5]] },
  { letter: 5, w: 9, pts: [[1104, 535.5], [1100.8, 540.3], [1089.6, 559.8], [1077.1, 581.8]], retrace: true },
  { letter: 5, w: 9, pts: [[1077.1, 581.8], [1072.9, 590.4], [1067.4, 600.2], [1060.4, 611.3], [1050.6, 619.7], [1035.3, 621.1], [1022.8, 619], [1016.5, 612], [1022.5, 603], [1040.9, 600.2], [1057.5, 596], [1070.1, 592.5], [1075.7, 590.4], [1089.6, 583.5], [1103.6, 573.7], [1117.5, 554.2]] },
  // i
  { letter: 6, w: 9, pts: [[1117.5, 554.2], [1128.6, 540.3], [1137.7, 530.5], [1140.5, 528]] },
  { letter: 6, w: 9, pts: [[1140.5, 528], [1131.4, 541.7], [1123.1, 555.6], [1116.1, 568.1], [1114, 577.9], [1117.5, 584.9], [1124.5, 586], [1134.2, 580.7], [1145.3, 568.1], [1154.4, 555.6]] },
  // a, and its tail
  ...A.map((pts, i) => ({
    letter: 7,
    w: A_W[i],
    pts: i === A.length - 1 ? [...shift(pts, 173.82), [1207, 550.5] as Pt] : shift(pts, 173.82),
    retrace: A_RETRACE[i],
  })),
  // the dot of the i, once the word is done: a touch of the pen at its centre,
  // the ink spreading out from there (the hero grows the nib, see Hero.astro)
  { letter: 6, w: 12, pts: [[1150.2, 512.4], [1150.25, 512.35]], lift: true },
]

/** a smooth path through the points (Catmull-Rom, as cubic Béziers) */
export const penPath = (pts: Pt[]) => {
  const f = (n: number) => +n.toFixed(2)
  let d = `M${f(pts[0][0])} ${f(pts[0][1])}`
  if (pts.length === 2) return `${d}L${f(pts[1][0])} ${f(pts[1][1])}`
  for (let i = 0; i < pts.length - 1; i++) {
    const p0 = pts[Math.max(i - 1, 0)]
    const [p1, p2] = [pts[i], pts[i + 1]]
    const p3 = pts[Math.min(i + 2, pts.length - 1)]
    const c1 = [p1[0] + (p2[0] - p0[0]) / 6, p1[1] + (p2[1] - p0[1]) / 6]
    const c2 = [p2[0] - (p3[0] - p1[0]) / 6, p2[1] - (p3[1] - p1[1]) / 6]
    d += `C${f(c1[0])} ${f(c1[1])} ${f(c2[0])} ${f(c2[1])} ${f(p2[0])} ${f(p2[1])}`
  }
  return d
}
