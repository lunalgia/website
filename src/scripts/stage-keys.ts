/**
 * Who answers ← and → on the media page. A stage does not have to be centred: whichever
 * has the most of the screen answers, so long as it shows a fair share of it. One owner
 * at a time, so a key never moves two stages at once. A stage holding the focus goes first,
 * until you have scrolled away from it.
 */
const HEADER = 90
const SHARE = 0.3

const seen = (el: Element) => {
  const r = el.getBoundingClientRect()
  return Math.max(0, Math.min(r.bottom, innerHeight) - Math.max(r.top, HEADER))
}

export const holdsKeys = (stage: Element) => {
  const stages = [...document.querySelectorAll('[data-keys]')]
  const fair = (innerHeight - HEADER) * SHARE
  const focused = stages.find((s) => s.contains(document.activeElement) && seen(s) >= fair)
  if (focused) return focused === stage
  const most = stages.reduce((best, s) => (seen(s) > seen(best) ? s : best), stage)
  return most === stage && seen(stage) >= fair
}
