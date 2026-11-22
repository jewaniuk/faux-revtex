// one column (no reprint, as for supplements): two authors, one without an affiliation,
// a heading, a footnote and text. lines end where revtex ends them (backslashes) so the bbox
// check compares geometry, not line breaking
// drift: 0.5
#import "../../package/lib.typ": *

#set linebreak(justify: true)
#show: revtex.with(
  title: [Supplementary material],
  authors: (
    (name: "Ada Lovelace", affiliation: "first"),
    (name: "Alan Turing"),
  ),
  affiliations: (first: [Department of Physics, First University]),
  date: [November 22, 2026],
  reprint: false,
)

= Further results
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore \ magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo \ consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.#footnote[A footnote in one column.]

Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed \ ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, \ eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.

== Details
Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores \ eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, \ consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam \ quaerat voluptatem.
