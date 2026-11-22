// lengths, markers, numbering and state shared by the other files

/// a tex point (1/72.27 in) as a typst length. revtex sizes are in tex points,
/// typst points are 1/72 in, so every number from the class goes through here
#let texpt(x) = x * 72 / 72.27 * 1pt

/// title block footnote markers as revtex prints them: ∗ † ‡ § ¶, then doubled, tripled
#let fn-symbol(n) = {
  // text in the math font (like revtex's \ensuremath) so superscript placement applies
  let symbols = ("∗", "†", "‡", "§", "¶")
  let i = calc.rem(n - 1, symbols.len())
  let times = calc.quo(n - 1, symbols.len()) + 1
  text(font: "New Computer Modern Math", symbols.at(i) * times)
}

/// whether the headings that follow belong to the appendix
#let appendix-state = state("faux-revtex-appendix", false)

/// heading number patterns per level, in the body and in the appendix
#let heading-patterns(appendix) = if appendix { ("A", "1", "a") } else { ("I", "A", "1") }

/// heading numbers as references print them, e.g. `II A 1` (revtex joins levels with a thin space)
#let heading-numbering(appendix) = (..n) => {
  n.pos().zip(heading-patterns(appendix)).map(((k, p)) => numbering(p, k)).join(h(1em / 6))
}

/// the number of an equation at a location: `1`, or `A1` in the appendix
#let equation-number(location) = {
  let n = counter(math.equation).at(location).first()
  if appendix-state.at(location) { numbering("A", counter(heading).at(location).first()) + str(n) } else { str(n) }
}
