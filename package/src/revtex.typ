// the page, text and element styles of revtex4-2 with `aps,pra,superscriptaddress,10pt`

#import "common.typ": appendix-state, equation-number, heading-numbering, heading-patterns, texpt
#import "title.typ": title-block

/// the rule revtex draws above the references: 245.5 pt long, thickening from 0.5 pt at
/// the ends to 1.25 pt over the middle quarter. it spans the page in revtex (which balances
/// the columns above it); typst can't, so it sits centred in the column
#let bib-rule = align(center, box(width: texpt(245.5), height: texpt(1.25), {
  for (fraction, thickness) in ((1, 0.5), (0.75, 0.75), (0.5, 1), (0.25, 1.25)) {
    place(center + horizon, line(length: fraction * 100%, stroke: texpt(thickness)))
  }
}))

/// the supplement references use for a figure: captions say `FIG.` and `TABLE`, text says
/// `Fig.` and `Table`. none for any other supplement
#let figure-ref-supplement(supplement) = {
  if supplement == [FIG.] { [Fig.] } else if supplement == [TABLE] { [Table] } else { none }
}

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
  let text-top = texpt(72.27 - 61 + 25 + 16)
  set page(
    paper: "us-letter",
    margin: (
      left: 1in - texpt(18.06749),
      right: 8.5in - 1in + texpt(18.06749) - texpt(510),
      top: text-top,
      bottom: 11in - text-top - texpt(672),
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
  // line numbers: 5 pt, 10 pt from the text (lineno's \tiny and \linenumbersep; lineno
  // uses sans, which typst doesn't bundle). typst puts the right column's on the right
  set par.line(numbering: n => text(size: texpt(5), str(n)), number-clearance: texpt(10)) if line-numbers
  show footnote.entry: set par.line(numbering: none)

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
  // ends with an empty, unnumbered one (zero height, adds the 1.5 pt paragraph spacing)
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
  ) + {
    set par.line(numbering: none)
    par[]
  }

  // equations: `(1)` at the right, `(A1)` in the appendix, referenced as `Eq. (1)`.
  // the number depends on where the equation is, so references rebuild it there
  set math.equation(numbering: n => context "(" + equation-number(here()) + ")", supplement: [Eq.])
  show ref: it => {
    let el = it.element
    if el == none or it.supplement != auto { return it }
    if el.func() == math.equation {
      link(el.location(), [#el.supplement~(#equation-number(el.location()))])
    } else if el.func() == figure and figure-ref-supplement(el.supplement) != none {
      ref(it.target, supplement: figure-ref-supplement(el.supplement))
    } else { it }
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

  // floats: figures and tables float to the top or bottom of the column (revtex's `tbp`),
  // 20 pt from the text (\textfloatsep)
  set figure(placement: auto)
  set place(clearance: texpt(20))
  show figure.where(kind: image): set figure(supplement: [FIG.])
  show figure.where(kind: table): set figure(supplement: [TABLE], numbering: "I")
  show figure.where(kind: table): set figure.caption(position: top)
  // the table body is 9 pt like the caption
  show figure.where(kind: table): set text(size: texpt(9))

  // captions: 9 pt `FIG. 1. Text`, 10 pt below the figure (tex adds a full 10.5 pt line on
  // top), centred when they fit on one line, justified with a ragged last line otherwise
  set figure(gap: texpt(10 + 10.5 - 9))
  show figure.where(kind: table): set figure(gap: texpt(3.2))
  set figure.caption(separator: [. ])
  show figure.caption: set text(size: texpt(9))
  show figure.caption: set par(first-line-indent: 0pt, justify: true)
  // a caption on top (tables) keeps tex's 10 pt skip above it, at the top of the float
  show figure.caption: it => layout(size => {
    let caption = if measure(it).width > size.width { align(left, it) } else { it }
    if it.position == top { pad(top: texpt(10 + 6.25 - 9), caption) } else { caption }
  })

  // references: aps style, `[1, 2]` on the line, no heading but revtex's tapered rule
  // 23.5 pt below the last line of text and 30.1 pt above the first entry's baseline, 9 pt
  set bibliography(style: "american-physics-society", title: none)
  show bibliography: set text(size: texpt(9))
  show bibliography: it => block(above: texpt(23.5 - 0.625), below: texpt(30.1 - 0.625 - 9), bib-rule) + it

  // footnotes: 8 pt, a half inch rule 17.5 pt below the text, the first baseline 26 pt
  // below the rule, 9.84 pt between notes (\footnotesep) and the last one above the bottom
  // of the text block by revtex's measured depth (1.35 pt in two columns, the 2.85 pt
  // strut in one). marker right aligned in a 1 em box, text indented by 1 em
  let footnote-depth = if reprint { texpt(1.35) } else { texpt(2.85) }
  set footnote.entry(
    clearance: texpt(17.5),
    separator: line(length: 0.5in, stroke: texpt(0.4)) + v(texpt(25.99 - 8 - 1.5)),
    gap: texpt(9.84 - 8) - footnote-depth,
    indent: 0pt,
  )
  show footnote.entry: set text(size: texpt(8), top-edge: 1em, bottom-edge: "baseline")
  show footnote.entry: set par(first-line-indent: 0pt, hanging-indent: 1em, leading: texpt(1.5))
  show footnote.entry: it => {
    let numbers = counter(footnote).at(it.note.location())
    let mark = numbering(it.note.numbering, ..numbers)
    par(box(width: 1em, align(right, super(size: texpt(6), baseline: texpt(-2.82), mark) + h(0.4em))) + it.note.body)
    v(footnote-depth)
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
