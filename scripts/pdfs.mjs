#!/usr/bin/env node
/**
 * PDFs of the writing, so readers download a file instead of meeting the
 * browser's print dialog (Firefox's in particular lays the pages out its own way).
 *
 * Builds the site, serves dist/, and has Chromium print every piece with the
 * site's own print styles (src/styles/article.css, @media print), twice:
 *   public/pdfs/writing/<id>.pdf          on white, for paper
 *   public/pdfs/writing/<id>-colour.pdf   in the site's lavender, for reading on screen
 *
 *   npm run pdfs                  build, then make every PDF
 *   npm run pdfs -- --no-build    use the dist/ that is already there
 *   npm run pdfs -- --only author only the pieces whose id contains "author"
 *
 * Commit the PDFs with the site, and rerun after editing a piece: the pages read
 * the files that exist when the site is built, and a piece without PDFs shows no links.
 * First time: `npx playwright install chromium`.
 */
import { spawnSync } from 'node:child_process'
import fs from 'node:fs/promises'
import http from 'node:http'
import path from 'node:path'
import { chromium } from 'playwright'

const ROOT = path.resolve(path.dirname(new URL(import.meta.url).pathname), '..')
const DIST = path.join(ROOT, 'dist')
const OUT = path.join(ROOT, 'public/pdfs/writing')

const args = process.argv.slice(2)
const onlyAt = args.indexOf('--only')
const only = onlyAt === -1 ? null : args[onlyAt + 1]

if (!args.includes('--no-build')) {
  const r = spawnSync('npm', ['run', 'build', '--silent'], { cwd: ROOT, stdio: 'inherit' })
  if (r.status !== 0) process.exit(r.status ?? 1)
}

// ---------- which pieces: every built page under dist/writing/<id>/ ----------

async function pages(dir, rel = '') {
  const out = []
  for (const e of await fs.readdir(dir, { withFileTypes: true })) {
    if (!e.isDirectory()) continue
    const id = rel ? `${rel}/${e.name}` : e.name
    const sub = path.join(dir, e.name)
    const html = await fs.readFile(path.join(sub, 'index.html'), 'utf8').catch(() => '')
    if (html.includes('class="ax"')) out.push(id) // a piece, not a list or a redirect
    out.push(...(await pages(sub, id)))
  }
  return out
}
const ids = (await pages(path.join(DIST, 'writing'))).filter((id) => !only || id.includes(only))
if (ids.length === 0) {
  console.log('no pieces to print')
  process.exit(0)
}

// ---------- a small static server over dist/ ----------

const TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css',
  '.js': 'text/javascript',
  '.mjs': 'text/javascript',
  '.json': 'application/json',
  '.svg': 'image/svg+xml',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.webp': 'image/webp',
  '.avif': 'image/avif',
  '.gif': 'image/gif',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.ttf': 'font/ttf',
  '.otf': 'font/otf',
}
const server = http.createServer(async (req, res) => {
  let p = decodeURIComponent(new URL(req.url, 'http://x').pathname)
  if (p.endsWith('/')) p += 'index.html'
  const file = path.join(DIST, path.normalize(p))
  if (!file.startsWith(DIST)) return res.writeHead(403).end()
  try {
    const body = await fs.readFile(file).catch(() => fs.readFile(path.join(file, 'index.html')))
    res.writeHead(200, { 'content-type': TYPES[path.extname(file)] ?? 'text/html; charset=utf-8' }).end(body)
  } catch {
    res.writeHead(404).end()
  }
})
await new Promise((r) => server.listen(0, '127.0.0.1', r))
const base = `http://127.0.0.1:${server.address().port}`

// ---------- print ----------

const browser = await chromium.launch()
const page = await browser.newPage()
await fs.mkdir(OUT, { recursive: true })

for (const id of ids) {
  for (const [mode, suffix] of [
    ['white', ''],
    ['colour', '-colour'],
  ]) {
    await page.goto(`${base}/writing/${id}/`, { waitUntil: 'networkidle' })
    await page.emulateMedia({ media: 'print' })
    // what the browser's print events did for the old PRINT buttons (src/scripts/article.ts)
    await page.evaluate(async (mode) => {
      const imgs = [...document.querySelectorAll('.ax__text img')]
      imgs.forEach((img) => (img.loading = 'eager'))
      await Promise.all(imgs.map((img) => img.decode().catch(() => {})))
      document.querySelectorAll('.ax__text details').forEach((d) => (d.open = true))
      document.documentElement.dataset.print = mode
      document.dispatchEvent(new Event('lunalgia:print'))
      await document.fonts.ready
    }, mode)
    await page.waitForLoadState('networkidle')
    const file = path.join(OUT, `${id}${suffix}.pdf`)
    await fs.mkdir(path.dirname(file), { recursive: true })
    await page.pdf({ path: file, preferCSSPageSize: true, printBackground: true, tagged: true, outline: true })
    console.log(path.relative(ROOT, file))
  }
}

await browser.close()
server.close()
