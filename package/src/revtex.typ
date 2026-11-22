// the page, text and element styles of revtex4-2 with `aps,pra,superscriptaddress,10pt`

#import "common.typ": appendix-state, equation-number, heading-numbering, heading-patterns, texpt
#import "title.typ": title-block

/// a physics paper that looks like revtex4-2 output.
///
/// use it as `#show: revtex.with(..)` for the whole document, or as
/// `#revtex(..)[..]` once per part (paper, supplement), each starting on a new page
/// with its figure, table, equation, heading and footnote counters reset.
///
/// - title (content): the paper title
/// - authors (array): one dictionary per author with `name` and optionally
///   `affiliation` (a key or an array of keys into `affiliations`), `email`,
///   `homepage`, `note` (content, like `\thanks`) and `alt-affiliation` (content).
///   an author without `affiliation` is printed like `\noaffiliation`
/// - affiliations (dictionary): affiliation text by key. numbered by first appearance
///   in author order
/// - date (auto, none, content): `auto` prints today, `none` hides the line
/// - abstract (content, none): the abstract
/// - preprint (array): preprint numbers, set top right of the first page
/// - journal (str): `pra`, `prb`, `prc`, `prd` or `pre`; these print identically in
///   revtex, the exporter writes it as the class option
/// - reprint (bool): two columns (`reprint`) or one column
/// - line-numbers (bool): number the lines, like the `linenumbers` option
/// - body (content): the paper
#let revtex(
  title: none,
  authors: (),
  affiliations: (:),
  date: auto,
  abstract: none,
  preprint: (),
  journal: "pra",
  reprint: true,
  line-numbers: false,
  body,
) = {
  assert(
    journal in ("pra", "prb", "prc", "prd", "pre"),
    message: "journal must be one of pra, prb, prc, prd, pre",
  )

  // 10 pt computer modern, 11.5 pt between baselines (1.5 pt more than the size at
  // every size revtex uses), first baseline 10 pt below the top like \topskip.
  // set before the page so headers and footnotes get them too
  set text(
    font: "New Computer Modern",
    size: texpt(10),
    top-edge: 1em,
    bottom-edge: "baseline",
    lang: "en",
    overhang: false,
  )
  set par(
    leading: texpt(1.5),
    spacing: texpt(1.5),
    justify: true,
    first-line-indent: texpt(10),
  )
  // us letter, 510 x 672 tex pt text block, left margin 1in - 18.07 tex pt,
  // text top at 1in - 61 + 25 + 16 tex pt
  let top = texpt(72.27 - 61 + 25 + 16)
  set page(
    paper: "us-letter",
    margin: (
      left: 1in - texpt(18.06749),
      right: 8.5in - 1in + texpt(18.06749) - texpt(510),
      top: top,
      bottom: 11in - top - texpt(672),
    ),
    columns: if reprint { 2 } else { 1 },
    // page numbers top left on even pages, top right on odd ones, none on a part's first page
    header: context {
      let n = counter(page).get().first()
      if n > 1 {
        if calc.even(n) { align(left)[#n] } else { align(right)[#n] }
      }
    },
    header-ascent: texpt(16),
    footer: none,
  )
  set columns(gutter: texpt(18))

  set super(typographic: false, size: texpt(7), baseline: texpt(-3.63))
  set par.line(numbering: "1") if line-numbers

  // headings: `I. INTRO` bold caps, `A. Sub` bold, `1. Subsub` italic, all 9 pt and centred
  set heading(numbering: heading-numbering(false), supplement: [Sec.])
  // the first line's top edge is 10 pt like body text, so a heading that starts a column
  // sits on the same baseline as text would (tex's \topskip); lines stay 10.5 pt apart
  show heading: set text(size: texpt(9), weight: "regular", top-edge: texpt(10))
  show heading.where(level: 1): set text(weight: "bold")
  show heading.where(level: 2): set text(weight: "bold")
  show heading.where(level: 3): set text(style: "italic")
  show heading: set par(first-line-indent: 0pt, justify: false, leading: texpt(0.5))
  // revtex indents the paragraph after a heading but not text continuing after an
  // equation. typst indents only paragraphs that follow a paragraph, so the heading
  // ends with an empty one (zero height, adds the 1.5 pt paragraph spacing)
  show heading: it => block(
    width: 100%,
    above: texpt(22.762 + 0.5),
    below: texpt(14.226),
    sticky: true,
    align(center, context {
      let appendix = appendix-state.get()
      if it.numbering != none and it.level <= 3 {
        let n = counter(heading).get()
        let shown = numbering(heading-patterns(appendix).at(it.level - 1), n.last())
        if appendix and it.level == 1 { [Appendix #shown: #it.body] } else {
          [#shown.#h(1em)]
          if it.level == 1 { upper(it.body) } else { it.body }
        }
      } else if it.level == 1 and not appendix { upper(it.body) } else { it.body }
    }),
  ) + par[]

  // equations: `(1)` at the right, `(A1)` in the appendix, referenced as `Eq. (1)`.
  // the number depends on where the equation is, so references rebuild it there
  set math.equation(numbering: n => context "(" + equation-number(here()) + ")", supplement: [Eq.])
  show ref: it => {
    let el = it.element
    if el == none or el.func() != math.equation { return it }
    let supplement = if it.supplement == auto { el.supplement } else { it.supplement }
    link(el.location(), [#supplement~(#equation-number(el.location()))])
  }
  // display spacing like tex: 10 pt above and below, and the line before or after sits
  // 11.5 pt from the display's baseline unless the display is too tall for that, then
  // 1 pt (\lineskip) from its box. tex knows the previous line's depth, typst doesn't,
  // so a typical 1.94 pt (a descender) stands in. the box includes the `(1)` number
  show math.equation.where(block: true): it => context {
    let inline = math.equation(block: false, math.display(it.body))
    let far = 100pt
    let h = measure(text(top-edge: "baseline", bottom-edge: -far, inline)).height - far
    let d = measure(text(top-edge: far, bottom-edge: "baseline", inline)).height - far
    let h = calc.max(h, texpt(7.5))
    let d = calc.max(d, texpt(2.5))
    set block(
      above: calc.max(texpt(10 + 11.5) - h, texpt(10 + 1.94 + 1)),
      below: calc.max(texpt(11.5) - d, texpt(1 + 6.94)),
    )
    it
  }

  // footnotes: 8 pt, a half inch rule 17.5 pt below the text, the first baseline 26 pt
  // below the rule, 9.84 pt between notes (\footnotesep) and the last one 1.35 pt above
  // the bottom of the text block (tex's final strut). marker right aligned in a 1 em box,
  // text indented by 1 em
  set footnote.entry(
    clearance: texpt(17.5),
    separator: line(length: 0.5in, stroke: texpt(0.4)) + v(texpt(25.99 - 8 - 1.5)),
    gap: texpt(9.84 - 8 - 1.35),
    indent: 0pt,
  )
  show footnote.entry: set text(size: texpt(8), top-edge: 1em, bottom-edge: "baseline")
  show footnote.entry: set par(first-line-indent: 0pt, hanging-indent: 1em, leading: texpt(1.5))
  show footnote.entry: it => {
    let numbers = counter(footnote).at(it.note.location())
    let mark = numbering(it.note.numbering, ..numbers)
    par(box(width: 1em, align(right, super(size: texpt(6), baseline: texpt(-2.82), mark) + h(0.4em))) + it.note.body)
    v(texpt(1.35))
  }

  // a part starts on its own page with fresh counters
  pagebreak(weak: true)
  for c in (figure.where(kind: image), figure.where(kind: table), math.equation, heading, footnote) {
    counter(c).update(0)
  }
  counter(page).update(1)
  appendix-state.update(false)

  if title != none { title-block(title, authors, affiliations, date, abstract, preprint) }
  body
}
