/**
 * The film discs, in three.js (see src/components/media/Discs.astro).
 *
 * Every disc is printed to one template, so the row reads as a set: the art to
 * the edge (covers/<id>.disc.*, or the poster until there is some), the title
 * in Instrument Serif over a soft darkening at its foot, the collection number
 * under it, and the credits round the bottom edge. Round the print, the
 * pressing of a real disc: a clear ridged edge, the mirrored ring, a clear
 * stacking zone and the hub. The back is the silver data side.
 *
 * The row is measured off the reference, slot by slot: each disc's place, turn
 * and the roll of its label come from SLOTS, read in between as it moves, so
 * the whole row flows along one curve. See the notes on the spring below.
 *
 * mount() returns to(pos), flip() and dispose(); the page calls dispose() before
 * the router swaps it out, which frees every texture, geometry and the context.
 */
import LINES from '@/scripts/pen-lines.json'
import {
  ACESFilmicToneMapping,
  BackSide,
  BufferGeometry,
  CanvasTexture,
  CircleGeometry,
  Color,
  CylinderGeometry,
  DoubleSide,
  Group,
  Mesh,
  MeshBasicMaterial,
  MeshPhysicalMaterial,
  Object3D,
  PerspectiveCamera,
  PlaneGeometry,
  PMREMGenerator,
  Raycaster,
  RingGeometry,
  Scene,
  SRGBColorSpace,
  Vector2,
  Vector3,
  WebGLRenderer,
  type Material,
  type Texture,
} from 'three'

export interface DiscItem {
  id: string
  title: string
  by: string
  year: number | ''
  no: string
  /** the poster, upright */
  src: string
  /** the colour picked from the cover, and the ink that reads on it */
  color: string
  ink: string
  /** its genres, as on the rest of the site */
  genres: string
  /** whether src is art made for the disc, rather than the poster */
  art: boolean
}

/** shares of the radius, as on the reference: the hole, the hub, the clear stacking zone, the mirrored ring, where the print ends */
const HOLE = 0.14
const HUB = 0.2
const CLEAR = 0.24
const MIRROR = 0.25
const PRINT = 0.955
const THICK = 0.03
const SIZE = 1024
/**
 * The row, slot by slot, as measured off the reference: what each disc's hole
 * does on screen gives its place and angle. 0 is the disc in front, 1 the next,
 * -1 the one before. [slot, x, y, z, pitch, yaw, roll], the camera at the origin.
 */
const SLOTS: number[][] = [
  [-4, -6.919, -0.607, -6.6, -0.138, 0.45, 0],
  [-3, -6.232, -0.883, -6.284, -0.257, 0.53, -0.047],
  [-2, -4.381, -0.838, -6.178, -0.392, 0.218, 0.01],
  [-1, -2.019, -0.482, -5.151, -0.45, -0.132, 0.103],
  [0, -0.001, 0.054, -3.851, -0.411, -0.533, 0.145],
  [1, 1.852, 0.635, -3.398, -0.224, -0.956, 0.09],
  [2, 2.8, 1.05, -1.4, -0.1, -1.25, 0.1],
]
/** a smooth curve through the slots, whole or in between */
const slotAt = (k: number, o: { x: number; y: number; z: number; pitch: number; yaw: number; roll: number }) => {
  const u = Math.max(0, Math.min(SLOTS.length - 1.0001, k + 4))
  const i = Math.floor(u)
  const t = u - i
  const row = (j: number) => SLOTS[Math.max(0, Math.min(SLOTS.length - 1, j))]
  const [a, b, c, d] = [row(i - 1), row(i), row(i + 1), row(i + 2)]
  const at = (f: number) => 0.5 * (2 * b[f] + (c[f] - a[f]) * t + (2 * a[f] - 5 * b[f] + 4 * c[f] - d[f]) * t * t + (3 * b[f] - a[f] - 3 * c[f] + d[f]) * t * t * t)
  o.x = at(1)
  o.y = at(2)
  o.z = at(3)
  o.pitch = at(4)
  o.yaw = at(5)
  o.roll = at(6)
}
/** the disc in front is a little larger than its slot, and the rest fog toward the page */
const GROW = 0.05
const FOG = 0.3

const loadImage = (src: string) =>
  new Promise<HTMLImageElement | null>((ok) => {
    if (!src) return ok(null)
    const img = new Image()
    img.onload = () => ok(img)
    img.onerror = () => ok(null)
    img.src = src
  })

const disc = (g: CanvasRenderingContext2D, R: number, r: number) => {
  g.beginPath()
  g.arc(R, R, R * r, 0, Math.PI * 2)
}

/**
 * The pressing round the print, the same on both sides, drawn as a real disc
 * is made: at the edge a narrow band of clear polycarbonate with a few faint
 * ridges and a bright lip; inside the print the thin mirrored ring where the
 * metal layer stops; then the clear stacking zone, finely ridged, with its
 * raised stacking ring; then the moulded hub, and the hole.
 */
const pressing = (g: CanvasRenderingContext2D, R: number) => {
  const band = (r0: number, r1: number, fill: string | CanvasGradient) => {
    g.fillStyle = fill
    g.beginPath()
    g.arc(R, R, R * r1, 0, Math.PI * 2)
    g.arc(R, R, R * r0, 0, Math.PI * 2, true)
    g.fill()
  }
  const ring = (r: number, colour: string, width = 1) => {
    g.strokeStyle = colour
    g.lineWidth = width
    disc(g, R, r)
    g.stroke()
  }
  const radial = (r0: number, r1: number, stops: [number, string][]) => {
    const gr = g.createRadialGradient(R, R, R * r0, R, R, R * r1)
    stops.forEach(([at, c]) => gr.addColorStop(at, c))
    return gr
  }
  // the clear edge, faintly ridged, and the bright lip
  g.globalCompositeOperation = 'destination-out'
  band(PRINT, 1, '#000')
  g.globalCompositeOperation = 'source-over'
  band(PRINT, 1, radial(PRINT, 1, [[0, 'rgba(206,210,222,0.55)'], [0.7, 'rgba(236,238,244,0.7)'], [1, 'rgba(150,155,172,0.95)']]))
  for (let k = PRINT + 0.006; k < 0.99; k += 0.008) ring(k, `rgba(255,255,255,${0.18 + 0.12 * Math.sin(k * 900)})`)
  ring(0.997, 'rgba(120,124,140,0.8)', 2)
  // the print stops at the mirrored ring
  g.globalCompositeOperation = 'destination-out'
  disc(g, R, MIRROR)
  g.fill()
  g.globalCompositeOperation = 'source-over'
  band(CLEAR, MIRROR, radial(CLEAR, MIRROR, [[0, '#8d92a4'], [0.35, '#eef0f6'], [0.6, '#b9bdcb'], [1, '#dfe2ea']]))
  ring(MIRROR, 'rgba(30,30,48,0.35)', 1.5)
  // the clear stacking zone: see-through, ridged all the way round, with the raised stacking ring
  band(HUB, CLEAR, 'rgba(198,202,214,0.72)')
  for (let k = HUB + 0.004; k < CLEAR; k += 0.0045) ring(k, k % 0.009 < 0.0045 ? 'rgba(255,255,255,0.3)' : 'rgba(70,74,92,0.16)')
  // the moulded hub, mid grey and solid, ridged, and the hole with its bright lip
  band(HOLE, HUB, radial(HOLE, HUB, [[0, '#d9dce4'], [0.28, '#a7acbb'], [0.75, '#979cac'], [1, '#b3b7c5']]))
  for (const k of [0.158, 0.17, 0.182]) ring(k, 'rgba(255,255,255,0.28)')
  ring(HUB, 'rgba(70,74,92,0.5)', 1.5)
  g.globalCompositeOperation = 'destination-out'
  disc(g, R, HOLE)
  g.fill()
  g.globalCompositeOperation = 'source-over'
  ring(HOLE + 0.002, 'rgba(90,94,112,0.6)', 2)
}

/** a sheet of fine grain, so the print reads as ink on a surface rather than a screen */
let grain: HTMLCanvasElement | null = null
const grainSheet = () => {
  if (grain) return grain
  grain = document.createElement('canvas')
  grain.width = grain.height = 256
  const g = grain.getContext('2d')!
  const px = g.createImageData(256, 256)
  for (let i = 0; i < px.data.length; i += 4) {
    const v = 110 + Math.random() * 36
    px.data[i] = px.data[i + 1] = px.data[i + 2] = v
    px.data[i + 3] = 255
  }
  g.putImageData(px, 0, 0)
  return grain
}

/** letters set round the bottom of the label, reading left to right, upright */
const arcText = (g: CanvasRenderingContext2D, R: number, text: string, radius: number, size: number) => {
  g.font = `400 ${size}px DINdong`
  const track = size * 0.32
  const widths = [...text].map((ch) => g.measureText(ch).width + track)
  const total = widths.reduce((x, y) => x + y, 0)
  let a = Math.PI / 2 + total / (R * radius) / 2
  ;[...text].forEach((ch, i) => {
    const step = widths[i] / (R * radius)
    const mid = a - step / 2
    g.save()
    g.translate(R + Math.cos(mid) * R * radius, R + Math.sin(mid) * R * radius)
    g.rotate(mid - Math.PI / 2)
    g.fillText(ch, 0, 0)
    g.restore()
    a -= step
  })
}

/**
 * The printed side, set as a pressed disc is: the art to the edge, the title
 * over a soft darkening at its foot, the number under it and the credits round
 * the bottom, all small and in white, as lettering printed on the picture.
 */
const label = (it: DiscItem, img: HTMLImageElement | null) => {
  const c = document.createElement('canvas')
  c.width = c.height = SIZE
  const g = c.getContext('2d')!
  const R = SIZE / 2
  g.save()
  disc(g, R, PRINT)
  g.clip()
  g.fillStyle = it.color
  g.fillRect(0, 0, SIZE, SIZE)
  if (img) {
    // art made for the disc fills it from the middle; a poster gives up a square from its upper
    // part, where the picture usually is, until it has art of its own
    const w = img.naturalWidth
    const h = img.naturalHeight
    const side = Math.min(w, h)
    const sx = (w - side) / 2
    const sy = it.art ? (h - side) / 2 : Math.min(h - side, h * 0.08)
    g.drawImage(img, sx, sy, side, side, 0, 0, SIZE, SIZE)
  }
  // a soft darkening toward the foot, for the lettering, and a faint one at the rim
  const foot = g.createLinearGradient(0, SIZE * 0.45, 0, SIZE)
  foot.addColorStop(0, 'rgba(8,8,20,0)')
  foot.addColorStop(1, 'rgba(8,8,20,0.62)')
  g.fillStyle = foot
  g.fillRect(0, 0, SIZE, SIZE)
  const rim = g.createRadialGradient(R, R, R * 0.7, R, R, R)
  rim.addColorStop(0, 'rgba(8,8,20,0)')
  rim.addColorStop(1, 'rgba(8,8,20,0.22)')
  g.fillStyle = rim
  g.fillRect(0, 0, SIZE, SIZE)
  // the title, as large as the disc allows at its height
  g.fillStyle = '#fff'
  g.textAlign = 'center'
  g.textBaseline = 'alphabetic'
  const chord = (y: number) => 2 * Math.sqrt(Math.max(0, (R * PRINT) ** 2 - (y - R) ** 2))
  const ty = SIZE * 0.74
  let fs = SIZE * 0.088
  const fit = () => (g.font = `italic 400 ${fs}px "Instrument Serif"`)
  fit()
  while (g.measureText(it.title).width > chord(ty) * 0.76 && fs > SIZE * 0.035) {
    fs *= 0.94
    fit()
  }
  g.shadowColor = 'rgba(0,0,20,0.35)'
  g.shadowBlur = SIZE * 0.01
  g.fillText(it.title, R, ty)
  g.shadowColor = 'transparent'
  // the number, small and spaced, under it
  g.font = `400 ${SIZE * 0.0155}px DINdong`
  g.globalAlpha = 0.85
  if ('letterSpacing' in g) g.letterSpacing = `${SIZE * 0.005}px`
  g.fillText(`LUNALGIA · ${it.no}${it.year ? ` · ${it.year}` : ''}`, R, ty + SIZE * 0.045)
  if ('letterSpacing' in g) g.letterSpacing = '0px'
  // the credits, round the bottom edge
  g.globalAlpha = 0.68
  arcText(g, R, `DIRECTED BY ${it.by}${it.genres ? ` · ${it.genres}` : ''}`.toUpperCase(), 0.885, SIZE * 0.0128)
  g.globalAlpha = 1
  // grain over the whole print
  g.globalCompositeOperation = 'overlay'
  g.globalAlpha = 0.14
  g.fillStyle = g.createPattern(grainSheet(), 'repeat')!
  g.fillRect(0, 0, SIZE, SIZE)
  g.restore()
  pressing(g, R)
  return c
}

/** the data side: silver, the faint rings of the tracks, and a rainbow in two arms */
const dataSide = () => {
  const c = document.createElement('canvas')
  c.width = c.height = SIZE
  const g = c.getContext('2d')!
  const R = SIZE / 2
  g.save()
  disc(g, R, PRINT)
  g.clip()
  g.fillStyle = '#b4b8c9'
  g.fillRect(0, 0, SIZE, SIZE)
  const bow = g.createConicGradient(0.6, R, R)
  const hues = ['#ff6a8a', '#ffd36a', '#7dffb2', '#6ad8ff', '#a67dff']
  for (const base of [0, 0.5]) {
    bow.addColorStop(base, 'rgba(180,184,201,0)')
    hues.forEach((h, j) => bow.addColorStop(base + 0.06 + j * 0.035, h))
    bow.addColorStop(base + 0.26, 'rgba(180,184,201,0)')
  }
  bow.addColorStop(1, 'rgba(180,184,201,0)')
  g.globalAlpha = 0.5
  g.fillStyle = bow
  g.fillRect(0, 0, SIZE, SIZE)
  g.globalAlpha = 1
  for (let r = R * CLEAR; r < R; r += 2) {
    g.strokeStyle = `rgba(${Math.random() < 0.5 ? '255,255,255' : '120,124,150'},${0.03 + Math.random() * 0.05})`
    g.beginPath()
    g.arc(R, R, r, 0, Math.PI * 2)
    g.stroke()
  }
  g.restore()
  pressing(g, R)
  return c
}

/**
 * A small studio for the discs to reflect: a dark room, so the gloss on the
 * prints shows only its one lamp, a thin strip above to the left.
 */
const studio = () => {
  const room = new Scene()
  room.background = new Color(0x15141f)
  const lamp = (w: number, h: number, power: number, at: [number, number, number]) => {
    const m = new Mesh(new PlaneGeometry(w, h), new MeshBasicMaterial({ color: new Color(power, power, power), side: DoubleSide }))
    m.position.set(...at)
    m.lookAt(0, 0, 0)
    room.add(m)
    return m
  }
  // placed between the slots' reflections: no disc shows it at rest, one catches it while it travels
  lamp(5, 0.35, 2.6, [-5.1, 3, -0.6])
  return room
}

/**
 * The pen's line: thirty drawings traced frame by frame from Ravi Klaassens' A24
 * library, in the disc's own units (radius 1). Each is a few arcs; each arc is
 * its start in degrees, then its radius and width a point every 2 degrees, the
 * radius as differences, both times 10000. Read here into a point every degree.
 */
const penDrawings = (LINES as unknown as [number, number[], number[]][][]).map((arcs) =>
  arcs.flatMap(([from, dr, wide]) => {
    let r = 0
    const rad = dr.map((d) => (r += d) / 10000)
    const at = (v: number[], i: number) => v[Math.max(0, Math.min(v.length - 1, i))]
    const smooth = (v: number[], i: number, t: number) =>
      0.5 * (2 * at(v, i) + (at(v, i + 1) - at(v, i - 1)) * t + (2 * at(v, i - 1) - 5 * at(v, i) + 4 * at(v, i + 1) - at(v, i + 2)) * t * t + (3 * at(v, i) - at(v, i - 1) - 3 * at(v, i + 1) + at(v, i + 2)) * t * t * t)
    const out: [number, number, number, boolean][] = []
    for (let i = 0; i < rad.length; i++) {
      for (const t of i < rad.length - 1 ? [0, 0.5] : [0]) {
        const deg = from + (i + t) * 2
        out.push([(deg * Math.PI) / 180, smooth(rad, i, t), smooth(wide, i, t) / 10000, i === 0 && t === 0])
      }
    }
    return out
  }),
)

export async function mount(stage: HTMLElement, items: DiscItem[], on: { pick: (i: number) => void }) {
  await Promise.all([document.fonts.load('italic 40px "Instrument Serif"'), document.fonts.load('20px DINdong')])
  const images = await Promise.all(items.map((it) => loadImage(it.src)))

  const renderer = new WebGLRenderer({ antialias: true, alpha: true })
  renderer.setPixelRatio(Math.min(devicePixelRatio, 2))
  renderer.outputColorSpace = SRGBColorSpace
  renderer.toneMapping = ACESFilmicToneMapping
  renderer.toneMappingExposure = 1.1
  stage.prepend(renderer.domElement)
  renderer.domElement.setAttribute('aria-hidden', 'true')

  const scene = new Scene()
  const pmrem = new PMREMGenerator(renderer)
  const room = studio()
  const env = pmrem.fromScene(room, 0.015).texture
  scene.environment = env
  // a wide lens close in, as on the reference; size() chooses how far it zooms to frame the row
  const camera = new PerspectiveCamera(43, 1, 0.1, 100)

  const textures: Texture[] = [env]
  const materials: Material[] = []
  const mat = <T extends Material>(m: T) => (materials.push(m), m)

  // shared shapes: every disc is the same size
  const front = new RingGeometry(HOLE, 1, 160, 1)
  const back = new RingGeometry(HOLE, 1, 160, 1)
  back.rotateY(Math.PI)
  const rim = new CylinderGeometry(1, 1, THICK, 160, 1, true)
  rim.rotateX(Math.PI / 2)
  const bore = new CylinderGeometry(HOLE, HOLE, THICK, 48, 1, true)
  bore.rotateX(Math.PI / 2)
  const geometries: BufferGeometry[] = [front, back, rim, bore]

  const dataTex = new CanvasTexture(dataSide())
  dataTex.colorSpace = SRGBColorSpace
  dataTex.anisotropy = renderer.capabilities.getMaxAnisotropy()
  textures.push(dataTex)
  const dataMat = mat(
    new MeshPhysicalMaterial({
      map: dataTex,
      // pale silver of its own, as a disc is in a lit room, with the studio's lamps and the rainbow over it
      emissive: 0x9a9db0,
      emissiveMap: dataTex,
      metalness: 0.45,
      roughness: 0.18,
      envMapIntensity: 1.5,
      iridescence: 1,
      iridescenceIOR: 1.8,
      iridescenceThicknessRange: [180, 820],
      transparent: true,
    }),
  )
  // the edge and the bore of the hole: bright and a little brushed; mostly its own pale colour,
  // since the studio around it is dark and a true mirror would show the dark
  // the hole's inner wall, seen from inside it
  const wall = mat(new MeshPhysicalMaterial({ color: 0xc9ccd8, emissive: 0x7c7f8e, roughness: 0.4, side: BackSide }))
  const silver = mat(new MeshPhysicalMaterial({ color: 0xe4e6ee, emissive: 0x8a8c9c, metalness: 0.35, roughness: 0.3, clearcoat: 0.6, clearcoatRoughness: 0.2 }))

  const hitShape = new CircleGeometry(1, 48)
  geometries.push(hitShape)
  const hitMat = mat(new MeshBasicMaterial({ visible: false }))
  // a soft round shadow in the site's ink, drawn once and shared
  const shadowCanvas = document.createElement('canvas')
  shadowCanvas.width = shadowCanvas.height = 256
  const sg = shadowCanvas.getContext('2d')!
  const fall = sg.createRadialGradient(128, 128, 0, 128, 128, 128)
  fall.addColorStop(0, 'rgba(17,19,90,0.55)')
  fall.addColorStop(0.55, 'rgba(17,19,90,0.32)')
  fall.addColorStop(1, 'rgba(17,19,90,0)')
  sg.fillStyle = fall
  sg.fillRect(0, 0, 256, 256)
  const shadowTex = new CanvasTexture(shadowCanvas)
  shadowTex.colorSpace = SRGBColorSpace
  textures.push(shadowTex)
  const shadowShape = new PlaneGeometry(2.7, 2.7)
  geometries.push(shadowShape)
  // the page's colour, which the discs away from the front fade toward, as things far off do in a print
  const page = new Color(getComputedStyle(stage).getPropertyValue('--bg').trim() || '#a297cb')
  const discs = items.map((it, i) => {
    const tex = new CanvasTexture(label(it, images[i]))
    tex.colorSpace = SRGBColorSpace
    tex.anisotropy = renderer.capabilities.getMaxAnisotropy()
    textures.push(tex)
    // the print shows its own colours, as ink on a lit surface does, whatever the studio's
    // light: mostly from the label itself, a little shading from the lamps, a faint coat on top
    const print = mat(
      new MeshPhysicalMaterial({
        map: tex,
        color: 0x3a3a3a,
        emissive: 0xffffff,
        emissiveMap: tex,
        emissiveIntensity: 0.88,
        transparent: true,
        roughness: 0.6,
        specularIntensity: 0.1,
        clearcoat: 0.25,
        clearcoatRoughness: 0.08,
        envMapIntensity: 0.5,
        toneMapped: false,
      }),
    )
    const face = new Mesh(front, print)
    face.position.z = THICK / 2
    // a veil of the page's colour over the print, thicker the further the disc is from the front
    const fog = new Mesh(front, mat(new MeshBasicMaterial({ color: page, transparent: true, opacity: 0, depthWrite: false, toneMapped: false })))
    fog.position.z = THICK / 2 + 0.002
    const data = new Mesh(back, dataMat)
    data.position.z = -THICK / 2
    // pose: where it sits and how it is turned; turn: over, for the data side, and in from edge-on as the row arrives
    const turn = new Group()
    turn.add(face, fog, data, new Mesh(rim, silver), new Mesh(bore, wall))
    turn.rotation.y = -Math.PI / 2
    // what the pointer finds: the whole disc, hole and all, though it is never drawn
    const target = new Mesh(hitShape, hitMat)
    const pose = new Group()
    pose.add(turn, target)
    pose.userData.i = i
    scene.add(pose)
    // its shadow on the page, seen only when it is in front
    const shade = new Mesh(shadowShape, mat(new MeshBasicMaterial({ map: shadowTex, transparent: true, depthWrite: false, opacity: 0 })))
    shade.renderOrder = -1
    scene.add(shade)
    return { pose, turn, target, fog, shade, flipped: false, spin: 0, held: true, lean: new Vector2(), leanTo: new Vector2() }
  })

  /** where the row is going: a film's index at rest, in between while it is dragged */
  let goal = 0
  /** where the row is, and how fast it is moving, in films */
  let pos = 0
  let vel = 0
  /** the velocity the discs feel, a moment behind the row */
  let lag = 0
  /** the film in front */
  let a = 0

  const at = new Vector3()
  const slot = { x: 0, y: 0, z: 0, pitch: 0, yaw: 0, roll: 0 }
  /** front: how much a disc at slot k is the one in front, 0 to 1 */
  const frontness = (k: number) => {
    const t = Math.max(0, 1 - Math.abs(k))
    return t * t * (3 - 2 * t)
  }

  const p3 = new Vector3()
  /** where a point on a disc lands on the stage, in pixels */
  const onStage = (o: Object3D, x: number, y: number, w: number, h: number): [number, number] => {
    p3.set(x, y, 0).applyMatrix4(o.matrixWorld).project(camera)
    return [((p3.x + 1) / 2) * w, ((1 - p3.y) / 2) * h]
  }

  /**
   * Where the rim of the disc at slot k reaches, as seen by the lens: shares of
   * its focal length, so the framing can be worked out before choosing a lens.
   */
  const ghost = new Object3D()
  const reach = (k: number, grow = 1) => {
    slotAt(k, slot)
    ghost.position.set(slot.x, slot.y, slot.z)
    ghost.rotation.set(slot.pitch, slot.yaw, slot.roll, 'YXZ')
    ghost.scale.setScalar(grow)
    ghost.updateMatrixWorld(true)
    let top = -Infinity
    let bottom = Infinity
    let wide = 0
    for (let j = 0; j < 72; j++) {
      const t = (j / 72) * Math.PI * 2
      p3.set(Math.cos(t), Math.sin(t), 0).applyMatrix4(ghost.matrixWorld)
      const u = p3.x / -p3.z
      const v = p3.y / -p3.z
      top = Math.max(top, v)
      bottom = Math.min(bottom, v)
      wide = Math.max(wide, Math.abs(u))
    }
    return { top, bottom, wide }
  }

  /**
   * The framing: the next disc's top edge and the front disc's foot, with the
   * words under it, fill the stage's height exactly, so nothing is cut by the
   * rule above and the words always fit; on a narrow screen the front disc's
   * width decides instead. The lens only zooms, so the row keeps its proportions.
   */
  const under = stage.querySelector<HTMLElement>('.dk__under')
  let W = 0
  let H = 0
  let centre = 0
  let focal = 1
  /** how far the row has slid aside, in pixels, for the details beside it */
  let aside = 0
  let asideTo = 0
  let asideVel = 0
  const view = () => {
    camera.setViewOffset(W, H, aside, H / 2 - centre, W, H)
    camera.updateMatrixWorld()
    stage.style.setProperty('--shift', `${aside.toFixed(1)}px`)
  }
  const size = () => {
    const w = stage.clientWidth
    const h = stage.clientHeight
    if (!w || !h) return
    renderer.setSize(w, h, false)
    const pad = 10
    const room = (under?.offsetHeight ?? 110) + 14
    // with room round the front disc for the pen
    const front = reach(0, (1 + GROW) * 1.1)
    const next = reach(1)
    const span = next.top - front.bottom
    focal = Math.min((h - room - pad) / span, (w * 0.44) / front.wide, (1130 * h) / 900)
    const slack = h - room - pad - span * focal
    centre = pad + slack * 0.5 + next.top * focal
    W = w
    H = h
    penCanvas.width = w * dpr
    penCanvas.height = h * dpr
    camera.aspect = w / h
    camera.fov = (2 * Math.atan(h / 2 / focal) * 180) / Math.PI
    view()
    // tell the page where the disc in front ends, so the words under it never run into it
    stage.style.setProperty('--below', `${Math.round(centre - front.bottom * focal + 4)}px`)
  }
  const ro = new ResizeObserver(size)
  ro.observe(stage)
  if (under) ro.observe(under)

  /**
   * The pen, on a flat canvas over the scene so the line stays sharp, traced onto
   * the plane of the disc in front so it lies on the disc's tilt. It is stop-motion,
   * as on the reference: a different drawing every tenth of a second, turned to
   * a new place round the disc. Coming, it shows a fifth of the line, then half,
   * then nearly all, then all; leaving, the same in reverse. Its weight swells as
   * it comes and thins back over the next half second. It comes when you hover
   * the disc in front, or step to one with the keys, and leaves when you move
   * away or drag the row.
   */
  const penCanvas = document.createElement('canvas')
  penCanvas.className = 'dk__pen'
  penCanvas.setAttribute('aria-hidden', 'true')
  renderer.domElement.after(penCanvas)
  const penInk = penCanvas.getContext('2d')!
  const dpr = Math.min(devicePixelRatio, 2)
  const penColour = getComputedStyle(stage).getPropertyValue('--ultramarine').trim() || '#020887'
  /** how thin the line is against the trace */
  const THIN = 0.7
  const SHOWN = [0, 0.22, 0.55, 0.9, 1]
  const pen = { on: -1, step: 0, leaving: false, born: 0, keyed: false, stamp: 0, next: 0, line: penDrawings[0], turn: 0, inked: false }
  const penFrame = (now: number, want: boolean) => {
    if (pen.on !== a) {
      pen.on = a
      pen.step = 0
    }
    if (now - pen.stamp >= 100 || (want && pen.step === 0)) {
      pen.stamp = now
      if (want) {
        if (pen.step === 0) pen.born = now
        pen.step = Math.min(SHOWN.length - 1, pen.step + 1)
        pen.leaving = false
      } else if (pen.step > 0) {
        pen.step--
        pen.leaving = true
      }
      // a drawing not just shown, turned anywhere round the disc
      pen.next = (pen.next + 1 + Math.floor(Math.random() * (penDrawings.length - 1))) % penDrawings.length
      pen.line = penDrawings[pen.next]
      pen.turn = Math.random() * Math.PI * 2
    }
    if (pen.step === 0) {
      if (pen.inked) penInk.clearRect(0, 0, penCanvas.width, penCanvas.height)
      pen.inked = false
      return
    }
    penInk.setTransform(dpr, 0, 0, dpr, 0, 0)
    penInk.clearRect(0, 0, W, H)
    pen.inked = true
    const o = discs[a].pose
    const age = (now - pen.born) / 1000
    const weight = 1 + 0.9 * (age < 0.15 ? age / 0.15 : age < 0.3 ? 1 : Math.exp(-(age - 0.3) / 0.22))
    const scale = (focal / -o.position.z) * weight * THIN
    const pts = pen.line
    const count = Math.floor(SHOWN[pen.step] * (pts.length - 1))
    const from = pen.leaving ? pts.length - 1 - count : 0
    penInk.strokeStyle = penColour
    penInk.lineCap = 'round'
    let last: [number, number] | null = null
    for (let j = from; j <= from + count; j++) {
      const [a0, rho, wide, starts] = pts[j]
      const here = onStage(o, Math.cos(a0 + pen.turn) * rho, Math.sin(a0 + pen.turn) * rho, W, H)
      if (last && !starts) {
        penInk.lineWidth = wide * scale
        penInk.beginPath()
        penInk.moveTo(last[0], last[1])
        penInk.lineTo(here[0], here[1])
        penInk.stroke()
      }
      last = here
    }
  }

  const ray = new Raycaster()
  const ptr = new Vector2()
  /** the disc under the pointer, if any */
  let hovered: number | undefined
  /** the pointer over the stage, if it is */
  let mouse: { x: number; y: number } | null = null
  const hit = (x: number, y: number) => {
    const b = renderer.domElement.getBoundingClientRect()
    ptr.set(((x - b.left) / b.width) * 2 - 1, -((y - b.top) / b.height) * 2 + 1)
    ray.setFromCamera(ptr, camera)
    const found = ray.intersectObjects(discs.filter((d) => d.pose.visible).map((d) => d.target))[0]
    return found?.object.parent?.userData.i as number | undefined
  }
  /** only the disc under the pointer leans, tipping as if the pointer were looking at it */
  const aimLean = () => {
    discs.forEach((d) => d.leanTo.set(0, 0))
    hovered = undefined
    if (!mouse) {
      stage.style.cursor = ''
      return
    }
    const i = hit(mouse.x, mouse.y)
    hovered = i
    stage.style.cursor = i != null ? 'pointer' : ''
    if (i == null) return
    const d = discs[i]
    const b = stage.getBoundingClientRect()
    const [cx, cy] = onStage(d.pose, 0, 0, b.width, b.height)
    const [ex, ey] = onStage(d.pose, 1, 0, b.width, b.height)
    const r = Math.hypot(ex - cx, ey - cy) || 1
    d.leanTo.set(Math.max(-1, Math.min(1, (mouse.x - b.left - cx) / r)), Math.max(-1, Math.min(1, (cy - (mouse.y - b.top)) / r)))
  }
  const onMove = (e: PointerEvent) => {
    if (e.pointerType !== 'mouse') return
    mouse = { x: e.clientX, y: e.clientY }
    pen.keyed = false
    aimLean()
  }
  const onLeave = () => {
    mouse = null
    aimLean()
  }
  let down: [number, number] | null = null
  const onDown = (e: PointerEvent) => (down = [e.clientX, e.clientY])
  const onUp = (e: PointerEvent) => {
    // a tap, not the end of a swipe
    if (!down || Math.hypot(e.clientX - down[0], e.clientY - down[1]) > 8) return
    down = null
    const i = hit(e.clientX, e.clientY)
    if (i != null) on.pick(i)
  }
  stage.addEventListener('pointermove', onMove)
  stage.addEventListener('pointerleave', onLeave)
  stage.addEventListener('pointerdown', onDown)
  stage.addEventListener('pointerup', onUp)

  // only draw while the stage is on screen
  let seen = true
  const io = new IntersectionObserver(([e]) => {
    seen = e.isIntersecting
    if (seen && !frame) frame = requestAnimationFrame(tick)
  })
  io.observe(stage)
  // the row arrives once, when it comes into view: each disc turns in from edge-on, from the front outward
  let arrived = 0
  const arrival = new IntersectionObserver(
    ([e]) => {
      if (!e.isIntersecting) return
      arrived = performance.now()
      arrival.disconnect()
    },
    { threshold: 0.3 },
  )
  arrival.observe(stage)

  /**
   * The row moves on one critically damped spring, timed off the reference
   * frame by frame: half way in 0.15s, nine-tenths by 0.3s, at rest by 0.5s, no
   * bounce. Every disc reads its place and angle from where the row is, so they
   * move as one along the curve. The discs also feel the motion a moment late:
   * they swing against it and settle over about 0.4s, after the row has stopped,
   * which is the soft tail on every move. At rest nothing moves at all.
   */
  const OMEGA = 13.5
  const LAG = 0.38
  const SWING = 0.07
  const FLIP = 9
  let frame = 0
  let then = performance.now()
  const tick = (now: number) => {
    frame = 0
    const dt = Math.min(0.05, (now - then) / 1000)
    then = now
    // small fixed steps, so the springs behave the same at any frame rate
    const n = Math.ceil(dt / (1 / 120))
    const h = dt / n
    for (let j = 0; j < n; j++) {
      vel += ((goal - pos) * OMEGA * OMEGA - 2 * OMEGA * vel) * h
      pos += vel * h
      lag += ((vel - lag) * h) / LAG
      discs.forEach((d) => {
        if (d.held) return
        const want = d.flipped ? Math.PI : 0
        d.spin += ((want - d.turn.rotation.y) * FLIP * FLIP - 2 * 0.7 * FLIP * d.spin) * h
        d.turn.rotation.y += d.spin * h
      })
    }
    // what is under a resting pointer changes as the row goes by
    if (Math.abs(vel) > 0.02) aimLean()
    const swing = Math.max(-0.4, Math.min(0.4, lag * SWING))
    discs.forEach((d, i) => {
      if (d.held && arrived && now - arrived > Math.abs(i - a) * 70) d.held = false
      const k = i - pos
      slotAt(k, slot)
      const f = frontness(k)
      d.pose.position.set(slot.x, slot.y, slot.z)
      d.lean.lerp(d.leanTo, 1 - Math.exp(-dt * 7))
      d.pose.rotation.set(slot.pitch + d.lean.y * 0.16, slot.yaw + swing + d.lean.x * 0.1, slot.roll, 'YXZ')
      d.pose.scale.setScalar(1 + GROW * f)
      d.pose.visible = !d.held && k > -4.4 && k < 2.4
      d.pose.updateMatrixWorld()
      // the rest fog toward the page's colour
      ;(d.fog.material as MeshBasicMaterial).opacity = FOG * (1 - f)
      // the shadow sits behind and a little below the disc, as if it were lifted off the page
      d.shade.visible = f > 0.01 && d.pose.visible
      d.shade.position.set(slot.x + 0.1, slot.y - 0.2, slot.z - 0.5)
      d.shade.scale.setScalar(1 + 0.1 * f)
      d.shade.material.opacity = 0.62 * f
    })
    // the row slides aside for the details, and back
    if (aside !== asideTo || Math.abs(asideVel) > 0.01) {
      asideVel += ((asideTo - aside) * 81 - 18 * asideVel) * dt
      aside += asideVel * dt
      if (Math.abs(asideTo - aside) < 0.2 && Math.abs(asideVel) < 1) {
        aside = asideTo
        asideVel = 0
      }
      view()
    }
    renderer.render(scene, camera)
    penFrame(now, (hovered === a || pen.keyed) && Math.abs(goal - a) < 0.02 && !discs[a].held)
    if (seen) frame = requestAnimationFrame(tick)
  }
  size()
  frame = requestAnimationFrame(tick)

  return {
    /** move the row to a position, whole or in between; keyed, the pen goes round the film it lands on */
    to(next: number, keyed = false) {
      if (keyed) pen.keyed = true
      goal = Math.max(-0.35, Math.min(items.length - 1 + 0.35, next))
      const film = Math.max(0, Math.min(items.length - 1, Math.round(goal)))
      if (film !== a) {
        discs[a].flipped = false
        a = film
      }
    },
    flip() {
      discs[a].flipped = !discs[a].flipped
    },
    /** slide the row aside by this many pixels, or back with 0 */
    slide(px: number) {
      asideTo = px
    },
    /** the pointer has gone from the discs, to something over them */
    away: onLeave,
    dispose() {
      cancelAnimationFrame(frame)
      ro.disconnect()
      io.disconnect()
      arrival.disconnect()
      stage.removeEventListener('pointermove', onMove)
      stage.removeEventListener('pointerleave', onLeave)
      stage.removeEventListener('pointerdown', onDown)
      stage.removeEventListener('pointerup', onUp)
      geometries.forEach((g) => g.dispose())
      materials.forEach((m) => m.dispose())
      textures.forEach((x) => x.dispose())
      room.traverse((o) => {
        if (o instanceof Mesh) {
          o.geometry.dispose()
          o.material.dispose()
        }
      })
      pmrem.dispose()
      renderer.dispose()
      renderer.forceContextLoss()
      renderer.domElement.remove()
    },
  }
}
