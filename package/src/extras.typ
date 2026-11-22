// the appendix, the acknowledgments and ruled tables

#import "common.typ": appendix-state, heading-numbering, texpt

/// starts the appendix, as a show rule: `#show: appendix`.
///
/// sections after it are headed `Appendix A: Title`, subsections `1.` and `a.`,
/// and equations number `(A1)`, restarting in every appendix
///
/// - body (content): the rest of the document
#let appendix(body) = {
  appendix-state.update(true)
  counter(heading).update(0)
  set heading(numbering: heading-numbering(true), supplement: [Appendix])
  show heading.where(level: 1): it => counter(math.equation).update(0) + it
  body
}

/// the acknowledgments, under an unnumbered `ACKNOWLEDGMENTS` heading
///
/// - body (content): the acknowledgments
#let acknowledgments(body) = {
  heading(numbering: none, outlined: false)[Acknowledgments]
  body
}

/// a table with revtex's `ruledtabular` look: double rules above and below, a single rule
/// under the header, columns spread over the full width with the spare space between them.
/// takes the arguments of `table`; a leading `table.header` becomes the ruled header
///
/// - columns (int, array): the table's columns, as for `table`
/// - ..args (arguments): cells and other `table` arguments
#let ruled-table(columns: 1, ..args) = {
  let rule = line(length: 100%, stroke: texpt(0.4))
  let cells = args.pos()
  if cells.len() > 0 and cells.first().func() == table.header {
    cells = cells.first().children + (table.hline(stroke: texpt(0.4)),) + cells.slice(1)
  }
  // measured from revtex: rows 12.85 pt apart, baselines 9.5 pt below a row's top and
  // 3.35 pt above its bottom; the double rules 2 pt apart, the rows 2.35 pt inside them
  set text(top-edge: texpt(9.5), bottom-edge: texpt(-3.35))
  stack(
    rule,
    v(texpt(2)),
    rule,
    v(texpt(2.35)),
    table(
      columns: columns,
      stroke: none,
      inset: (x: texpt(2), y: 0pt),
      column-gutter: 1fr,
      align: center,
      ..args.named(),
      ..cells,
    ),
    v(texpt(1.98)),
    rule,
    v(texpt(2)),
    rule,
  )
}
