// Credits, shown at the bottom of /about. Edit freely.
//
// Each group is a heading with entries: `what` is required; `by`, `note`,
// `license` and `href` are optional. An entry with `todo` is kept here but not
// shown on the page, for things whose source still needs finding out.
export interface Credit { what: string; by?: string; note?: string; license?: string; href?: string; todo?: string }
export interface CreditGroup { heading: string; entries: Credit[] }

export const credits: CreditGroup[] = [
  {
    heading: 'inspiration',
    entries: [
      { what: 'henry.codes', by: 'Henry Desroches', href: 'https://henry.codes', note: 'The framed title cards, the letter on the home page, labels sitting on hairline frames, and the writing kept as a garden.' },
      { what: 'gwern.net', by: 'Gwern Branwen', href: 'https://gwern.net', note: 'Link previews that open on hover, and sidenotes.' },
      { what: 'Complete Shelf', href: 'https://play.mint.gg/complete-shelf', note: 'The shelves of books, records and films on the media page.' },
      { what: 'componentry.dev', href: 'https://componentry.dev', note: 'The flipping words, the hand-drawn marks, the line of posters and the picture field’s lens.' },
      { what: 'Vibe pages', note: 'xavicf.com/vibes, guzey.com/vibes and girl.surgery/website_vibes, for the pictures on the bookmarks page.' },
    ],
  },
  {
    heading: 'pictures',
    entries: [
      { what: 'Water Lilies', by: 'Claude Monet', license: 'public domain', href: 'https://commons.wikimedia.org/wiki/File:Monet_w1687.jpg', note: 'W. 1687, the water in the footer and the picture shown when a link to the site is shared.' },
      { what: 'The Cobweb Dance', by: 'Charles Courtney Curran, 1908', license: 'public domain', note: 'Dithered, behind “Hello, I go by Lilian”.' },
      { what: 'The lily', note: 'Dithered from an old print, found in an online library.' },
      { what: 'The moon', by: 'NASA/GSFC/Arizona State University', license: 'public domain', href: 'https://commons.wikimedia.org/wiki/File:Moon_nearside_LRO_5000.jpg', note: 'The Lunar Reconnaissance Orbiter’s near side, broken and dithered for the scrollbar.' },
      { what: 'E. coli', by: 'David S. Goodsell', href: 'https://press.asimov.com', note: 'The cell on the bookmarks page, via Asimov Press.' },
    ],
  },
  {
    heading: 'type',
    entries: [
      { what: 'Instrument Serif', by: 'Rodrigo Fuenzalida and Jordan Egstad (Instrument)', license: 'SIL OFL 1.1', href: 'https://fontsource.org/fonts/instrument-serif', note: 'Display and titles.' },
      { what: 'EB Garamond', by: 'Georg Duffner and Octavio Pardo', license: 'SIL OFL 1.1', href: 'https://fontsource.org/fonts/eb-garamond', note: 'The body text.' },
      { what: 'Louise', by: 'Luna Delabre and Camille Depalle', license: 'SIL OFL 1.1', href: 'https://velvetyne.fr', note: 'From Degheest Types (Velvetyne), a revival of lettering by Ange Degheest: the name, post titles and the footer.' },
      { what: 'DINdong', by: 'Clara Sambot', license: 'Open Inclusifve Fonte License', href: 'https://typotheque.genderfluid.space/DINdong.html', note: 'Labels, numbers and the big page titles; found through uncut.wtf.' },
      { what: 'PP Mori', by: 'Pangram Pangram Foundry', license: 'Pangram Pangram licence', href: 'https://pangrampangram.com', note: 'The small sans on the home page.' },
    ],
  },
  {
    heading: 'code',
    entries: [
      { what: 'Astro', license: 'MIT', href: 'https://astro.build', note: 'The site is built with it.' },
      { what: 'GSAP', by: 'GreenSock', license: 'standard no-charge licence', href: 'https://gsap.com', note: 'The home page’s animation.' },
      { what: 'Lenis', by: 'darkroom.engineering', license: 'MIT', href: 'https://lenis.darkroom.engineering', note: 'Smooth scrolling.' },
      { what: 'Temml', by: 'Ron Kok', license: 'MIT', href: 'https://temml.org', note: 'Mathematics, set as MathML.' },
      { what: 'tex-linebreak', by: 'Robert Knight', license: 'MIT', href: 'https://github.com/robertknight/tex-linebreak', note: 'Knuth–Plass line breaking for justified text.' },
    ],
  },
]
