/**
 * The annex: the media page's fork. One flat item shape for the stack (books),
 * the crate (records) and the programme (films), built from the same entries
 * as the shelves.
 */
import { getImage } from 'astro:assets'
import { coverOf, factsOf, getMedia, inkFor, linksOf, paragraphs, paragraphsHtml, spineOf, words, type MediaKind } from '@/lib/media'

export interface AnnexItem {
  id: string
  title: string
  short?: string
  by: string
  year?: number
  rating?: number
  favourite: boolean
  liked: boolean
  img?: string
  /** a small cover, for hover previews */
  thumb?: string
  color: string
  ink: string
  facts: [string, string][]
  links: [string, string][]
  tags: string[]
  excerpt: string[]
  words: number
  href?: string
  /** books: page count; films: minutes */
  size?: number
  /** the cover's width over its height */
  ratio: number
  /** every fact, by name, for index columns: { starring: '…', runtime: '106 min' } */
  meta: Record<string, string>
  /** the review's opening sentence, plain text */
  first?: string
}

export async function annexItems(kind: MediaKind): Promise<AnnexItem[]> {
  const entries = await getMedia(kind)
  return Promise.all(
    entries.map(async (e) => {
      const d = e.data
      const src = coverOf(e, kind)
      const [img, thumb] = src
        ? await Promise.all([
            getImage({ src, width: 700, format: 'webp', quality: 82 }),
            getImage({ src, width: 360, format: 'webp', quality: 78 }),
          ])
        : [null, null]
      const color = await spineOf(e, kind)
      const size = parseInt(String(d.meta?.pages ?? d.meta?.runtime ?? ''), 10)
      return {
        id: e.id,
        title: d.title,
        short: d.short,
        by: d.by,
        year: d.year,
        rating: d.rating,
        favourite: d.favourite,
        liked: d.liked,
        img: img?.src,
        thumb: thumb?.src,
        color,
        ink: inkFor(color),
        facts: factsOf(e).slice(0, 4),
        links: linksOf(e).slice(0, 3),
        tags: [...(d.genres ?? []), ...(d.tags ?? [])].slice(0, 3),
        excerpt: paragraphsHtml(e.body).slice(0, 2),
        words: words(e.body),
        href: paragraphs(e.body).length ? `/media/${kind}/${e.id}` : undefined,
        size: Number.isFinite(size) ? size : undefined,
        ratio: src ? src.width / src.height : 2 / 3,
        meta: Object.fromEntries(Object.entries(d.meta ?? {}).map(([k, v]) => [k, String(v)])),
        first: paragraphs(e.body)[0]?.match(/^.+?[.!?](?=\s|$)/)?.[0] ?? paragraphs(e.body)[0],
      }
    }),
  )
}

/** "Phil Lord and Christopher Miller" → "Lord & Miller" */
export const surname = (s: string) =>
  s
    .split(/\s+(?:and|&)\s+/)
    .filter((p) => p.trim().includes(' '))
    .map((p) => p.trim().split(/\s+/).at(-1))
    .join(' & ') || s.trim().split(/\s+/).at(-1)

export const pad = (n: number, w = 2) => String(n).padStart(w, '0')
