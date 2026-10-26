// The CV, as it appears on /work. Edit freely; keep it in step with the PDF
// (public/files/cv.pdf, built from ~/Projects/Typesetting/CV), which stays the
// formal version and is linked from the section.
//
// Each group is a heading with entries: `when` and `what` are required, `where`
// and `note` are optional, and `href` makes the name a link.
export interface CvEntry { when: string; what: string; where?: string; note?: string; href?: string }
export interface CvGroup { heading: string; entries: CvEntry[] }

export const cv: CvGroup[] = [
  {
    heading: 'education',
    entries: [
      { when: '2026 – 2030', what: 'B.S. (Hons.) in Mathematics and Physics', where: 'Chennai Mathematical Institute', note: 'Expected.' },
    ],
  },
  {
    heading: 'programs',
    entries: [
      {
        when: '2026',
        what: 'PRISM India',
        where: 'sophomore student',
        note: 'Hyperbolic geometry and advanced number theory, and a research project on inverted Pascal triangles.',
      },
      {
        when: '2025',
        what: 'PROMYS India',
        where: 'first-year student',
        note: 'Number theory and Galois theory, with an exploration lab on finite differences; one of three first years to study Galois theory.',
      },
    ],
  },
  {
    heading: 'projects',
    entries: [
      {
        when: '2025 – now',
        what: 'AO Guide',
        href: 'https://aoguide.app',
        note: 'A free guide to the Astronomy Olympiads, written and designed with an IOAA gold medallist.',
      },
      {
        when: 'March 2025',
        what: 'Beamline for Schools',
        href: '/files/bl4s.pdf',
        where: 'team leader',
        note: 'Physics Olympiad Co-operation, among the top 50 teams worldwide in the 2024–25 edition of CERN’s competition.',
      },
    ],
  },
  {
    heading: 'awards',
    entries: [
      { when: '2026', what: 'Valedictorian Award', where: 'high school' },
      { when: '2025', what: 'Shortlisted', where: 'Beamline for Schools' },
    ],
  },
  {
    heading: 'skills',
    entries: [
      { when: 'advanced', what: 'Python, LaTeX' },
      { when: 'intermediate', what: 'Affinity Suite, HTML, Linux' },
      { when: 'basic', what: 'Haskell, full-stack web development' },
    ],
  },
  {
    heading: 'languages',
    entries: [
      { when: 'English', what: 'Almost native', where: '~C2' },
      { when: 'Hindi', what: 'Mother tongue' },
    ],
  },
]
