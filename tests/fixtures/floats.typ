// floats: a column figure, a full-width figure, a ruled table and their references.
// float placement differs from typst (accepted), so this fixture is compared by eye only
#import "../../package/lib.typ": *

#show: revtex.with(
  title: [Figures and tables],
  authors: ((name: "Ada Lovelace", affiliation: "first"),),
  affiliations: (first: [Department of Physics, First University]),
  date: [November 22, 2026],
  abstract: [
    Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.
  ],
)

= Introduction
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua, as @fig:column shows. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
#figure(
  image("column.png", width: 100%),
  caption: [A column figure with a short caption.],
) <fig:column>

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur (@fig:wide and @tab:ruled). Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
#figure(
  image("wide.png", width: 100%),
  scope: "parent",
  caption: [A full-width figure. Its caption is long enough to wrap onto a second line, so it is justified with a ragged last line rather than centred: sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam.],
) <fig:wide>

Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.
#figure(
  ruled-table(
    columns: 3,
    align: (left, center, right),
    table.header[Quantity][Symbol][Value],
    [Speed of light], [$c$], [299792458],
    [Planck constant], [$h$], [6.626],
    [Elementary charge], [$e$], [1.602],
  ),
  caption: [A ruled table.],
) <tab:ruled>

Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur.

Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur. At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident.
