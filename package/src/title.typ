// the title block: title, authors, affiliations, date, abstract and preprint numbers

#import "common.typ": fn-symbol, texpt

/// a value or an array of values as an array
#let as-array(x) = if type(x) == array { x } else if x == none { () } else { (x,) }

/// affiliation keys in order of first appearance, walking the authors in order
#let affiliation-order(authors) = {
  let order = ()
  for author in authors {
    for key in as-array(author.at("affiliation", default: ())) {
      if key not in order { order.push(key) }
    }
  }
  order
}

/// the title block footnotes in order: per author, email, homepage and note joined by
/// semicolons (as revtex joins them), then each alternative affiliation
#let author-notes(author) = {
  let contact = (author.at("email", default: none), author.at("homepage", default: none))
    .filter(x => x != none)
    .map(x => link(if "@" in x { "mailto:" + x } else { x }, x))
  let joined = contact + as-array(author.at("note", default: none))
  (if joined.len() > 0 { (joined.join("; "),) } else { () }) + as-array(author.at("alt-affiliation", default: none))
}

/// the author line: names, then superscript affiliation numbers and footnote markers.
/// like revtex, names get a comma when there are more than two, and "and" goes before the last
#let author-line(authors, order) = {
  let n = authors.len()
  let sep = [,#h(1em / 6)]
  let note = 0
  for (i, author) in authors.enumerate() {
    author.name
    if n > 2 and i < n - 1 [,]
    let marks = as-array(author.at("affiliation", default: ())).map(key => str(order.position(k => k == key) + 1))
    for _ in author-notes(author) {
      note += 1
      marks.push(fn-symbol(note))
    }
    marks.map(super).join(super(sep))
    if i < n - 1 [ ]
    if i == n - 2 [and ]
  }
}

/// the full-width title block, as a float at the top of the first page
#let title-block(title, authors, affiliations, date, abstract, preprint) = {
  let order = affiliation-order(authors)
  let missing = order.filter(key => key not in affiliations)
  assert(missing.len() == 0, message: "affiliations without an entry: " + missing.join(", "))

  // the body's first baseline sits 31.25 pt below the abstract's last (38.75 below the date
  // without an abstract), less the 10 pt the first line takes above its baseline
  place(top + center, scope: "parent", float: true, clearance: texpt(31.25 - 10 + if abstract == none { 7.5 } else { 0 }), block(width: 100%, {
    if preprint.len() > 0 {
      // revtex sets these at the head baseline, right aligned, one per line (or one line past two)
      let numbers = if preprint.len() > 2 { preprint.join(", ") } else { preprint.join(linebreak()) }
      place(top + right, dy: texpt(-25), text(size: texpt(9), align(right, numbers)))
    }
    set align(center)
    set par(first-line-indent: 0pt, justify: false)
    // each line is a block whose `above` puts its baseline where revtex puts it
    // (blocks end at the last baseline, lines start 1 em above theirs)
    block(above: 0pt, below: 0pt, text(size: texpt(12), weight: "bold", top-edge: texpt(10), title))
    block(above: texpt(24 - 10), below: 0pt, author-line(authors, order))
    set text(size: texpt(9))
    for (i, key) in order.enumerate() {
      let mark = super(size: texpt(6), baseline: texpt(-3.82), str(i + 1))
      block(above: if i == 0 { texpt(14 - 9) } else { texpt(1.5) }, below: 0pt, mark + emph(affiliations.at(key)))
    }
    if date != none {
      let shown = if date == auto {
        datetime.today().display("[month repr:long] [day padding:none], [year]")
      } else { date }
      block(above: texpt(1.5), below: 0pt)[(Dated: #shown)]
    }
    if abstract != none {
      set par(justify: true, first-line-indent: (amount: 1em, all: true))
      block(above: texpt(17 - 9), below: 0pt, width: texpt(400), align(left, par(abstract)))
    }
  }))

  // typst drops footnotes inside parent-scoped floats, so the block above prints its own
  // marks and the entries come from hidden footnotes here, at the start of the body
  place(hide({
    for note in authors.map(author-notes).flatten() { footnote(numbering: fn-symbol, note) }
  }))
  // body footnotes number from 1 after the title block's symbols
  counter(footnote).update(0)
}
