#import "@preview/faux-revtex:0.1.0": acknowledgments, appendix, revtex, ruled-table

#show: revtex.with(
  title: [A placeholder title for the paper: concise, descriptive and informative],
  authors: (
    (
      name: "First Author",
      affiliation: "first",
      email: "first.author@example.org",
      note: [These authors contributed equally.],
    ),
    (
      name: "Second Author",
      affiliation: ("first", "second"),
      alt-affiliation: [Now at Third Laboratory, City, Country.],
    ),
    (
      name: "Third Author",
      affiliation: "second",
      email: "third.author@example.org",
      homepage: "https://example.org",
    ),
  ),
  affiliations: (
    first: [Department of Physics, First University, City, Country],
    second: [Second Institute, City, Country],
  ),
  // `auto` prints today's date, `none` hides the line
  date: auto,
  abstract: [
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Here, we introduce ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. We demonstrate that duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
  ],
  preprint: ("PREPRINT-2026-01",),
  // `reprint: false` for one column (supplements), `line-numbers: true` for review
  reprint: true,
  line-numbers: false,
)

= Introduction
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua @Gisin:07 @Raussendorf:03. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat, and serves as a foundation for duis aute irure dolor @Grover:97.#footnote[Footnotes go to the foot of the page.]

Here, we introduce a placeholder generator (@fig:overview) based on a consectetur adipiscing elit. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum @Nielsen:10.

#figure(
  rect(width: 100%, height: 4cm, fill: luma(230))[a full-width figure],
  scope: "parent",
  caption: [A full-width figure. Captions that fit on one line are centred; longer ones like this are justified, with the last line ragged, sed ut perspiciatis unde omnis iste natus error sit voluptatem.],
) <fig:overview>

= Results <sec:results>
Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. The energy is
$
  E = m c^2 + sum_(n=1)^N p_n^2 / (2 m_n) ,
$ <eq:energy>
where nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit (see @eq:energy and @tab:constants).

#figure(
  ruled-table(
    columns: 3,
    align: (left, center, right),
    table.header[Quantity][Symbol][Value],
    [Speed of light], [$c$], [299792458],
    [Planck constant], [$h$], [6.626],
  ),
  caption: [A ruled table.],
) <tab:constants>

== A subsection
Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.

#figure(
  rect(width: 100%, height: 3cm, fill: luma(230))[a column figure],
  caption: [A column figure.],
) <fig:column>

=== A subsubsection
Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam (@fig:column and @sec:results), nisi ut aliquid ex ea commodi consequatur.

#acknowledgments[
  We thank lorem ipsum for dolor sit amet.
]

#show: appendix

= Derivation <app:derivation>
Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur,
$
  nabla dot bold(upright(E)) = rho / epsilon_0 ,
$ <eq:gauss>
which @eq:gauss and @app:derivation number in the appendix style.

#bibliography("references.bib")
