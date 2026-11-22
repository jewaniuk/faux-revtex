// the appendix, the acknowledgments and ruled tables

#import "common.typ": appendix-state, heading-numbering

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
