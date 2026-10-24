#!/usr/bin/env node
/**
 * Copy ~/Uni into public/uni, which the course pages read (src/lib/file-tree.ts).
 *
 *   npm run uni            copy what is new or changed, remove what was removed
 *   npm run uni -- -n      dry run: only print what would happen
 *   UNI_SRC=/path npm run uni    use another source folder
 *
 * What it does besides copying:
 *
 * - A folder named "Past - …" inside a course (e.g. Math/Year 1/Sem 1/Algebra 1/Past - 2022 course)
 *   is old material, so it goes to public/uni/Past Material/Sem N/<course>/ as its own offering
 *   and shows under "Earlier years", instead of also appearing among the course's own materials.
 *   "Past - 2022 course" becomes "2022 Fall - Course page archive"; a folder already named in the
 *   Past Material style ("Past - 2022 Fall - Prof. X (source)") keeps that name.
 *   The course name comes from the `past:` field of the course's file in src/content/academics.
 * - Never published: Books/ (copyrighted textbooks), _to_delete/, Syncthing and git folders,
 *   lock and temp files, LaTeX build files, and anything of 25 MiB or more (Cloudflare Pages'
 *   per-file limit). Large files are listed at the end.
 * - Removing: a file in public/uni is deleted only if this script put it there (it is listed in
 *   scripts/uni-manifest.json) or it is a stale copy of a file whose path exists in ~/Uni. Files that
 *   exist only on the site, never in ~/Uni, are kept and listed, so nothing added by hand is lost.
 */
import fs from 'node:fs/promises'
import os from 'node:os'
import path from 'node:path'

const ROOT = path.resolve(path.dirname(new URL(import.meta.url).pathname), '..')
const SRC = path.resolve((process.env.UNI_SRC ?? '~/Uni').replace(/^~(?=\/|$)/, os.homedir()))
const DEST = path.join(ROOT, 'public', 'uni')
const MANIFEST = path.join(ROOT, 'scripts', 'uni-manifest.json')
const DRY = process.argv.includes('-n') || process.argv.includes('--dry-run')
const LIMIT = 25 * 1024 * 1024 // Cloudflare Pages: each file must be under 25 MiB

const SKIP_DIRS = new Set(['Books', '_to_delete', '.git', '.stfolder', '.stversions', 'node_modules', '__pycache__'])
const SKIP_FILE = [
  /^\./, // dotfiles, including .~lock.*# from LibreOffice
  /~$/,
  /\.(swp|tmp|part|crdownload)$/i,
  /\.(aux|log|out|toc|synctex\.gz|fls|fdb_latexmk|bbl|blg|nav|snm|bcf|run\.xml)$/i,
  /^(Thumbs\.db|desktop\.ini)$/i,
]

const rel = (p) => p.split(path.sep).join('/')

// ---------- course folder → past-material name, from the course pages' front matter ----------
async function pastNames() {
  const dir = path.join(ROOT, 'src', 'content', 'academics')
  const map = new Map()
  for (const f of await fs.readdir(dir).catch(() => [])) {
    if (!/\.mdx?$/.test(f)) continue
    const text = await fs.readFile(path.join(dir, f), 'utf8')
    const fm = text.match(/^---\n([\s\S]*?)\n---/)?.[1] ?? ''
    const field = (k) => fm.match(new RegExp(`^${k}:\\s*['"]?(.+?)['"]?\\s*(?:#.*)?$`, 'm'))?.[1]
    const folder = field('folder')
    if (folder) map.set(folder, field('past'))
  }
  return map
}

/**
 * "Math/Year 1/Sem 1/Algebra 1/Past - 2022 course/x.pdf"
 *   → "Past Material/Sem 1/Algebra 1/2022 Fall - Course page archive/x.pdf"
 */
function remap(p, names) {
  const m = p.match(/^([^/]+)\/Year (\d+)\/Sem (\d+)\/([^/]+)\/Past\s*-\s*([^/]+)\/(.+)$/i)
  if (!m) return p
  const [, subject, year, sem, course, rest, tail] = m
  const n = (+year - 1) * 2 + +sem
  const season = +sem % 2 === 1 ? 'Fall' : 'Spring'
  const name = names.get(`${subject}/Year ${year}/Sem ${sem}/${course}`) ?? course
  let label
  if (/^\d{4}\s+(Fall|Spring)\s+-\s+.+/.test(rest)) label = rest
  else {
    const y = rest.match(/\d{4}/)?.[0] ?? 'Undated'
    label = `${y} ${season} - Course page archive`
  }
  return `Past Material/Sem ${n}/${name}/${label}/${tail}`
}

// ---------- walk the source ----------
const plan = new Map() // dest relative path → source absolute path
const tooBig = []
const clashes = []

async function walk(dir, names) {
  for (const e of await fs.readdir(dir, { withFileTypes: true })) {
    const full = path.join(dir, e.name)
    if (e.isDirectory()) {
      if (!SKIP_DIRS.has(e.name)) await walk(full, names)
      continue
    }
    if (!e.isFile() || SKIP_FILE.some((r) => r.test(e.name))) continue
    const s = await fs.stat(full)
    const from = rel(path.relative(SRC, full))
    if (s.size >= LIMIT) {
      tooBig.push(`${(s.size / 2 ** 20).toFixed(1)} MiB  ${from}`)
      continue
    }
    const to = remap(from, names)
    if (plan.has(to)) clashes.push(`${from} and ${rel(path.relative(SRC, plan.get(to)))} both go to ${to}`)
    else plan.set(to, full)
  }
}

async function listDest(dir, out = []) {
  for (const e of await fs.readdir(dir, { withFileTypes: true }).catch(() => [])) {
    const full = path.join(dir, e.name)
    if (e.isDirectory()) await listDest(full, out)
    else if (e.isFile()) out.push(rel(path.relative(DEST, full)))
  }
  return out
}

async function exists(p) {
  return !!(await fs.stat(p).catch(() => null))
}

async function pruneEmpty(dir) {
  for (const e of await fs.readdir(dir, { withFileTypes: true }).catch(() => [])) {
    if (e.isDirectory()) await pruneEmpty(path.join(dir, e.name))
  }
  if (dir !== DEST && (await fs.readdir(dir)).length === 0) await fs.rmdir(dir)
}

// ---------- run ----------
if (!(await exists(SRC))) {
  console.log(`uni: no ${SRC} on this computer; keeping public/uni as it is`)
  process.exit(0)
}
await walk(SRC, await pastNames())

const manifest = new Set(JSON.parse(await fs.readFile(MANIFEST, 'utf8').catch(() => '[]')))
const current = await listDest(DEST)
const copied = []
const updated = []
for (const [to, from] of plan) {
  const out = path.join(DEST, to)
  const s = await fs.stat(from)
  const d = await fs.stat(out).catch(() => null)
  if (d && d.size === s.size && Math.abs(d.mtimeMs - s.mtimeMs) < 2000) continue
  ;(d ? updated : copied).push(to)
  if (DRY) continue
  await fs.mkdir(path.dirname(out), { recursive: true })
  await fs.copyFile(from, out)
  await fs.utimes(out, s.atime, s.mtime)
}

const names = await pastNames()
const removed = []
const siteOnly = []
for (const p of current) {
  if (plan.has(p)) continue
  // ours to remove: copied by this script before, a stale copy of a path that exists in ~/Uni,
  // or anything in a course's "Past - …" folder, a place this script never writes to
  if (manifest.has(p) || remap(p, names) !== p || (await exists(path.join(SRC, p)))) {
    removed.push(p)
    if (!DRY) await fs.rm(path.join(DEST, p))
  } else siteOnly.push(p)
}
if (!DRY) {
  await pruneEmpty(DEST)
  await fs.writeFile(MANIFEST, JSON.stringify([...plan.keys()].sort(), null, 1) + '\n')
}

// ---------- report ----------
const show = (title, list, mark) => {
  if (!list.length) return
  console.log(`\n${title} (${list.length})`)
  for (const x of list.slice(0, 40)) console.log(`  ${mark} ${x}`)
  if (list.length > 40) console.log(`  … and ${list.length - 40} more`)
}
console.log(`uni: ${SRC} → public/uni${DRY ? '  (dry run, nothing written)' : ''}`)
show('new', copied, '+')
show('updated', updated, '~')
show('removed', removed, '-')
show('kept, only on the site (not in ~/Uni)', siteOnly, '?')
show('left out, 25 MiB or more', tooBig, '!')
show('two sources for one path (the first was kept)', clashes, '!')
const total = plan.size + siteOnly.length
console.log(`\n${total} files in public/uni${total > 15000 ? ' (Cloudflare Pages allows 20,000 for the whole site)' : ''}`)
if (!copied.length && !updated.length && !removed.length) console.log('nothing to do')
