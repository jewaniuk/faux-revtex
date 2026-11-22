// citations and the bibliography: one, two and a range of references, a book
#import "../../package/lib.typ": *

#show: revtex.with(
  title: [Citations and references],
  authors: ((name: "Ada Lovelace", affiliation: "first"),),
  affiliations: (first: [Department of Physics, First University]),
  date: [November 22, 2026],
)

= Introduction
One reference @Gisin:07, two @Gisin:07 @Raussendorf:03 and a range @Gisin:07 @Raussendorf:03 @Grover:97. A book @Nielsen:10.

#bibliography("references.bib")
