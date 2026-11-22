// title block: three authors, shared and multiple affiliations, emails, a note,
// an alternative affiliation, a homepage, preprint numbers and a fixed date.
// lines end where revtex ends them (backslashes) so the bbox check compares geometry, not line breaking
// drift: 0.5
#import "../../package/lib.typ": *

#set linebreak(justify: true)
#show: revtex.with(
  title: [A placeholder title that is long enough to wrap onto a second line of the title block],
  authors: (
    (
      name: "Ada Lovelace",
      affiliation: "first",
      email: "ada@example.org",
      note: [These authors contributed equally.],
    ),
    (
      name: "Charles Babbage",
      affiliation: ("first", "second"),
      alt-affiliation: [Now at Third Laboratory, Third City.],
    ),
    (
      name: "Emmy Noether",
      affiliation: "second",
      email: "emmy@example.org",
      homepage: "https://example.org",
    ),
  ),
  affiliations: (
    first: [Department of Physics, First University, Kingston, Ontario, Canada],
    second: [Second Institute, Second City, Country],
  ),
  date: [November 22, 2026],
  preprint: ("QNL-2026-01", "arXiv:2611.00001"),
  abstract: [
    Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudan-\ tium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae \ dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, \ sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.
  ],
)

= Introduction
Lorem ipsum dolor sit amet, consectetur adipiscing \ elit, sed do eiusmod tempor incididunt ut labore et dolore \ magna aliqua. Ut enim ad minim veniam, quis nostrud \ exercitation ullamco laboris nisi ut aliquip ex ea com-\ modo consequat.

Duis aute irure dolor in reprehenderit in voluptate velit \ esse cillum dolore eu fugiat nulla pariatur. Excepteur sint \ occaecat cupidatat non proident, sunt in culpa qui officia \ deserunt mollit anim id est laborum.
