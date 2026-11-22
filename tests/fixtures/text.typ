// text: headings at three levels, equations, a footnote, acknowledgments and an appendix.
// lines end where revtex ends them (backslashes) so the bbox check compares geometry, not line breaking.
// drift: 2.5 (new computer modern math sets displays up to 2 pt taller than computer modern)
#import "../../package/lib.typ": *

#set linebreak(justify: true)
#show: revtex.with(
  title: [Headings, equations and an appendix],
  authors: ((name: "Ada Lovelace", affiliation: "first"),),
  affiliations: (first: [Department of Physics, First University]),
  date: [November 22, 2026],
  abstract: [Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut \ labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris \ nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit \ esse cillum dolore eu fugiat nulla pariatur.],
)

= Introduction
Excepteur sint occaecat cupidatat non proident, sunt \ in culpa qui officia deserunt mollit anim id est laborum. \ Sed ut perspiciatis unde omnis iste natus error sit volup-\ tatem accusantium doloremque laudantium, totam rem \ aperiam, eaque ipsa quae ab illo inventore veritatis et \ quasi architecto beatae vitae dicta sunt explicabo.

Nemo enim ipsam voluptatem quia voluptas sit asper-\ natur aut odit aut fugit, sed quia consequuntur magni do-\ lores eos qui ratione voluptatem sequi nesciunt. Neque \ porro quisquam est, qui dolorem ipsum quia dolor sit \ amet, consectetur, adipisci velit, sed quia non numquam \ eius modi tempora incidunt ut labore et dolore magnam \ aliquam quaerat voluptatem.#footnote[A footnote at the foot of the page, long enough to need a second \ line of text.]

= Theory <sec:theory>
Ut enim ad minima veniam, quis nostrum exercita-\ tionem ullam corporis suscipit laboriosam, nisi ut aliq-\ uid ex ea commodi consequatur. Quis autem vel eum \ iure reprehenderit qui in ea voluptate velit esse quam \ nihil molestiae consequatur, vel illum qui dolorem eum \ fugiat quo voluptas nulla pariatur.
$
  E = m c^2 + sum_(n=1)^N p_n^2 / (2 m_n) .
$ <eq:energy>
At vero eos et accusamus et iusto odio dignissimos \ ducimus qui blanditiis praesentium voluptatum deleniti \ atque corrupti quos dolores et quas molestias excepturi \ sint occaecati cupiditate non provident, similique sunt in \ culpa qui officia deserunt mollitia animi, id est laborum \ et dolorum fuga.

== A subsection
Et harum quidem rerum facilis est et expedita distinc-\ tio. Nam libero tempore, cum soluta nobis est eligendi \ optio cumque nihil impedit quo minus id quod maxime \ placeat facere possimus, omnis voluptas assumenda est, \ omnis dolor repellendus.

See @eq:energy and @sec:theory.

=== A subsubsection
Temporibus autem quibusdam et aut officiis debitis aut \ rerum necessitatibus saepe eveniet ut et voluptates repu-\ diandae sint et molestiae non recusandae. Itaque earum \ rerum hic tenetur a sapiente delectus, ut aut reiciendis \ voluptatibus maiores alias consequatur aut perferendis \ doloribus asperiores repellat.

Praeterea libero tempore, cum soluta nobis est eligendi \ optio cumque nihil impedit quo minus id quod maxime \ placeat facere possimus. Omnis voluptas assumenda est, \ omnis dolor repellendus, temporibus autem quibusdam et \ aut officiis debitis aut rerum necessitatibus saepe eveniet.

#acknowledgments[
  We thank the referees for their comments.
]

#show: appendix

= Derivation <app:derivation>
Totam rem aperiam, eaque ipsa quae ab illo inven-\ tore veritatis et quasi architecto beatae vitae dicta sunt \ explicabo. Nihil enim ipsam voluptatem quia voluptas \ sit aspernatur aut odit aut fugit, sed quia consequuntur \ magni dolores eos qui ratione voluptatem.
$
  nabla dot bold(upright(E)) = rho / epsilon_0 .
$ <eq:gauss>
See @eq:gauss and @app:derivation.

== A subsection of the appendix
Denique porro quisquam est, qui dolorem ipsum quia \ dolor sit amet, consectetur, adipisci velit. Ita enim ad \ minima veniam, quis nostrum exercitationem ullam cor-\ poris suscipit laboriosam, nisi ut aliquid ex ea commodi \ consequatur, quis autem vel eum iure reprehenderit.
