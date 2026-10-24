/**
 * Turns a raw folder tree (see file-tree.ts) into something readable:
 *
 * - files that belong together are folded into one row, so "Quiz 1.pdf",
 *   "Quiz 1 solutions.pdf", "Quiz 1 grading.pdf" and "Quiz 1 - Lilian.pdf"
 *   become one "Quiz 1" row with links to solutions, grading and my copy;
 * - the same file in two formats (Sheet 1.pdf, Sheet 1.hs) becomes one link
 *   with a small format link beside it;
 * - folders of dated files (board work, photos) become a calendar of days;
 * - Moodle week folders ("03 18 August - 24 August") read as "Week 3".
 */
import type { TreeNode } from '@/lib/file-tree'

export interface Link {
  label: string
  href: string
  ext: string
  /** the same file in other formats, e.g. the .hs beside a .pdf */
  alts: { ext: string; href: string }[]
}

export interface Item {
  kind: 'item'
  title: string
  note?: string
  main: Link
  extra: Link[]
  /** lower-cased text the filter box matches against */
  search: string
}

export interface Day {
  date: Date
  links: { label: string; href: string; ext: string; note?: string }[]
}

export interface Folder {
  kind: 'folder'
  name: string
  label: string
  note?: string
  /** number of files underneath, at any depth */
  files: number
  entries: Entry[]
  /** set when every file in the folder is named by a date */
  months?: { label: string; days: Day[] }[]
  search: string
}

export type Entry = Item | Folder

const extOf = (name: string) => (/\.[^.]+$/.test(name) ? name.split('.').pop()!.toLowerCase() : '')
const stemOf = (name: string) => name.replace(/\.[^.]+$/, '')

/** "Quiz 0 (practice)" → ["Quiz 0", "practice"]; also eats a dangling " - " before the brackets */
function splitParen(s: string): [string, string | undefined] {
  const m = s.match(/^(.*?)\s*(?:[-–]\s*)?\(([^()]*)\)\s*$/)
  return m && m[1] ? [m[1], m[2]] : [s, undefined]
}

const withParen = (s: string, paren?: string) => (paren ? `${s} (${paren})` : s)

const KEYWORD = /^(.+?)\s+(solutions?|answers?|grading(?: scheme)?|marking scheme)$/i

const ROLE_ORDER = (role: string) =>
  /solution|answer/i.test(role) ? 0 : /grading|marking|scheme/i.test(role) ? 1 : /^mine$/.test(role) ? 2 : 3

function roleLabel(role: string) {
  if (/^lilian$/i.test(role.trim())) return 'mine'
  return role.trim().replace(/^\w/, (c) => c.toLowerCase())
}

const natural = (a: string, b: string) => a.localeCompare(b, undefined, { numeric: true, sensitivity: 'base' })

/** Prefer the PDF as the main link; anything else becomes a small format link. */
function linkFrom(label: string, files: TreeNode[]): Link {
  const sorted = [...files].sort((a, b) => (extOf(a.name) === 'pdf' ? -1 : extOf(b.name) === 'pdf' ? 1 : 0))
  const [first, ...rest] = sorted
  return {
    label,
    href: first.href!,
    ext: extOf(first.name),
    alts: rest.map((f) => ({ ext: extOf(f.name), href: f.href! })),
  }
}

function groupFiles(files: TreeNode[]): Item[] {
  const info = files.map((f) => {
    const stem = stemOf(f.name)
    const [bare, paren] = splitParen(stem)
    return { f, stem, bare, paren }
  })
  const keys = new Set(info.map((i) => i.bare))

  type Placed = { f: TreeNode; base: string; role: string | null; note?: string }
  const placed: Placed[] = info.map(({ f, bare, paren }) => {
    // "Quiz 1 - Lilian", "Endsem - Official Solutions", "Tutorial 4 - change of basis exercise"
    const dash = bare.match(/^(.+?)\s+[-–]\s+(.+)$/)
    if (dash) {
      const base = splitParen(dash[1])[0]
      if (keys.has(base) && base !== bare) return { f, base, role: withParen(dash[2], paren) }
    }
    // "Quiz 1 solutions", "Test 1 (2025) solutions"
    const kw = bare.match(KEYWORD)
    if (kw) {
      const base = splitParen(kw[1])[0]
      if (keys.has(base)) return { f, base, role: withParen(kw[2], paren) }
    }
    // "Tutorial 5 (old)" beside "Tutorial 5": the bracket names a variant
    if (paren && info.some((o) => o.f !== f && o.stem === bare)) return { f, base: bare, role: paren }
    return { f, base: bare, role: null, note: paren }
  })

  // "01-functions-and-types" reads better as "01 functions and types"
  const pretty = (t: string) => (/\s/.test(t) ? t : t.replace(/(?<=\w)[-_](?=\w)/g, ' '))
  const byBase = Map.groupBy(placed, (p) => p.base)
  const items: Item[] = []
  for (const [base, members] of byBase) {
    const roles = Map.groupBy(members, (m) => m.role ?? '')
    const primary = roles.get('')
    const others = [...roles].filter(([r]) => r !== '').sort(([a], [b]) => ROLE_ORDER(roleLabel(a)) - ROLE_ORDER(roleLabel(b)) || natural(a, b))
    let main: Link
    let extra: Link[]
    let note = primary?.find((p) => p.note)?.note
    if (primary) {
      main = linkFrom(base, primary.map((p) => p.f))
      extra = others.map(([r, ms]) => linkFrom(roleLabel(r), ms.map((m) => m.f)))
    } else {
      const [[r0, m0], ...rest] = others
      main = linkFrom(base, m0.map((m) => m.f))
      note = roleLabel(r0)
      extra = rest.map(([r, ms]) => linkFrom(roleLabel(r), ms.map((m) => m.f)))
    }
    items.push({
      kind: 'item',
      title: pretty(base),
      note,
      main,
      extra,
      search: [base, note, ...extra.map((e) => e.label)].filter(Boolean).join(' ').toLowerCase(),
    })
  }
  return items.sort((a, b) => natural(a.title, b.title))
}

const DATE = /^(\d{4})-(\d{2})-(\d{2})(?:\s+(.*))?$/
const MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

function calendar(files: TreeNode[]): Folder['months'] {
  const parsed = files.map((f) => {
    const stem = stemOf(f.name)
    const m = stem.match(DATE)
    if (!m) return null
    // "2026-08-20 2 - (insert after 20-3)", "2026-09-08 5 - remarks reorganised after class"
    const rest = (m[4] ?? '').match(/^(\S+)?\s*(?:[-–]\s*)?(.*)$/)!
    const note = rest[2].replace(/^\((.*)\)$/, '$1').trim() || undefined
    return { date: new Date(Date.UTC(+m[1], +m[2] - 1, +m[3])), label: rest[1] ?? '', note, f }
  })
  if (parsed.some((p) => !p)) return undefined
  const ok = parsed as NonNullable<(typeof parsed)[number]>[]
  const days = [...Map.groupBy(ok, (p) => p.date.getTime())]
    .sort(([a], [b]) => a - b)
    .map(([, ps]) => ({
      date: ps[0].date,
      links: ps
        .sort((a, b) => natural(a.label, b.label))
        .map((p) => ({ label: p.label, href: p.f.href!, ext: extOf(p.f.name), note: p.note })),
    }))
  return [...Map.groupBy(days, (d) => `${d.date.getUTCFullYear()}-${d.date.getUTCMonth()}`)].map(([, ds]) => ({
    label: `${MONTHS[ds[0].date.getUTCMonth()]} ${ds[0].date.getUTCFullYear()}`,
    days: ds,
  }))
}

function folderLabel(name: string): { label: string; note?: string } {
  // Moodle exports: "03 18 August - 24 August"
  const week = name.match(/^(\d{1,2})\s+(\d{1,2} \w+)\s+-\s+(\d{1,2} \w+)$/)
  if (week) return { label: `Week ${+week[1]}`, note: `${week[2]} – ${week[3]}` }
  return { label: name }
}

const countFiles = (nodes: TreeNode[]): number =>
  nodes.reduce((n, x) => n + (x.type === 'file' ? 1 : countFiles(x.children ?? [])), 0)

/** Folders named "Past …" (old offerings kept for reference) go to the bottom. */
const isPast = (name: string) => /^past\b/i.test(name)

export function organise(nodes: TreeNode[], opts: { exclude?: string[] } = {}): Entry[] {
  const files = nodes.filter((n) => n.type === 'file' && !opts.exclude?.includes(n.name))
  const dirs = nodes
    .filter((n) => n.type === 'dir' && countFiles(n.children ?? []) > 0)
    .sort((a, b) => Number(isPast(a.name)) - Number(isPast(b.name)) || natural(a.name, b.name))

  const folders: Folder[] = dirs.map((d) => {
    const children = d.children ?? []
    const childFiles = children.filter((c) => c.type === 'file')
    const months = childFiles.length >= 3 ? calendar(childFiles) : undefined
    const entries = organise(months ? children.filter((c) => c.type === 'dir') : children)
    const { label, note } = folderLabel(d.name)
    return {
      kind: 'folder',
      name: d.name,
      label,
      note,
      files: countFiles(children),
      entries,
      months,
      search: [label, note].filter(Boolean).join(' ').toLowerCase(),
    }
  })

  return [...groupFiles(files), ...folders]
}

