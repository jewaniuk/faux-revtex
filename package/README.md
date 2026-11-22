# faux-revtex

Physics papers that look like revtex4-2 output: `reprint,aps,pra,superscriptaddress,10pt` in two columns, or the same in one column for supplements.

The body is plain typst (`heading`, `figure`, `table`, `cite`, `ref`, `footnote`, `bibliography`), so a paper written with it can be turned into revtex latex for overleaf, arxiv and journals by the [faux-revtex exporter](https://github.com/jewaniuk/faux-revtex).

## usage

```typ
#import "@preview/faux-revtex:0.1.0": acknowledgments, appendix, revtex, ruled-table

#show: revtex.with(
  title: [A placeholder title],
  authors: (
    (name: "First Author", affiliation: "first", email: "first@example.org"),
    (name: "Second Author", affiliation: ("first", "second")),
  ),
  affiliations: (
    first: [Department of Physics, First University],
    second: [Second Institute],
  ),
  abstract: [Lorem ipsum dolor sit amet.],
)

= Introduction
Text with a citation @key, a reference to @fig:one and an equation
$ E = m c^2 $ <eq:energy>
...

#bibliography("references.bib")
```

Start a new project from the template with `typst init @preview/faux-revtex:0.1.0`.

### a paper and its supplement in one file

`revtex` also works on one part at a time. Each part starts on a new page with its own figure, table, equation, heading, footnote and page numbers:

```typ
#revtex(title: [The paper], abstract: [...])[ ... ]
#revtex(title: [Supplementary material], reprint: false)[ ... ]
```

## api

### `revtex`

| argument | default | |
| --- | --- | --- |
| `title` | `none` | the title, content |
| `authors` | `()` | one dictionary per author, see below |
| `affiliations` | `(:)` | affiliation text by key; numbered by first appearance in author order |
| `date` | `auto` | `auto` prints `(Dated: <today>)`, `none` hides the line, content is printed as given |
| `abstract` | `none` | the abstract, content |
| `preprint` | `()` | preprint numbers, top right of the first page (the exporter writes `preprintnumbers`) |
| `journal` | `"pra"` | `pra`, `prb`, `prc`, `prd` or `pre`; they print identically, the exporter writes it as the class option |
| `reprint` | `true` | two columns; `false` for one column |
| `line-numbers` | `false` | number the lines, like the `linenumbers` option |

Author fields:

| field | | revtex |
| --- | --- | --- |
| `name` | the name, a string or content | `\author` |
| `affiliation` | a key or an array of keys into `affiliations`; leave it out for none | `\affiliation`, `\noaffiliation` |
| `email` | an email address | `\email` |
| `homepage` | a url | `\homepage` |
| `note` | content, e.g. "These authors contributed equally." | `\thanks` |
| `alt-affiliation` | content, e.g. "Now at ..." | `\altaffiliation` |

An author's email, homepage and note share one footnote (∗, †, ‡, ...), joined by semicolons as revtex joins them; each alternative affiliation gets its own.

### `appendix`

A show rule: `#show: appendix`. Sections after it are headed `Appendix A: Title`, subsections `1.` and `a.`, and equations number `(A1)`, restarting in each appendix.

### `acknowledgments`

`#acknowledgments[...]` puts the text under an unnumbered `ACKNOWLEDGMENTS` heading.

### `ruled-table`

revtex's `ruledtabular`: double rules above and below, a single rule under the header, the columns spread over the full width with the spare space between them. It takes `table`'s arguments; a leading `table.header` becomes the ruled header.

```typ
#figure(
  ruled-table(
    columns: 3,
    align: (left, center, right),
    table.header[Quantity][Symbol][Value],
    [Speed of light], [$c$], [299792458],
  ),
  caption: [A ruled table.],
) <tab:constants>
```

### styling

Everything is set with typst's own set and show rules, so they can be overridden after `#show: revtex.with(..)` in the usual way, for example `#set figure(supplement: [Figure])`, `#set figure.caption(separator: [ | ])` or `#set bibliography(style: "nature")`. Table numbering (`I`) and captions above tables are show-set rules, so override them the same way: `#show figure.where(kind: table): set figure(numbering: "1")`.

What `revtex` sets:

- us letter, 510 × 672 pt text block in revtex's position, 10 pt new computer modern with 11.5 pt between baselines
- headings `I. INTRODUCTION` (bold caps), `A. Subsection` (bold), `1. Subsubsection` (italic), 9 pt and centred; referenced as `Sec. II A`
- figures `FIG. 1.` and tables `TABLE I.` (caption above), 9 pt captions centred when they fit on a line and justified otherwise; referenced as `Fig. 1` and `Table I`. figures and tables float to the top or bottom of the column
- equations `(1)` at the right, referenced as `Eq. (1)`
- the `american-physics-society` bibliography style with no heading, under revtex's tapered rule
- footnotes at the foot of the page, 8 pt

## how close it is

The test suite in the repository builds the same fixtures with revtex4-2 and with this package and compares word positions. Title block, headings, body text, footnotes, captions, ruled tables, page numbers and the bibliography spacing land within 0.5 pt of revtex. Known differences:

- **line breaking**: tex stretches spaces after punctuation more and hyphenates differently, so lines break in slightly different places
- **floats**: typst places figures and tables more simply, so page counts can differ (check lengths with the latex build)
- **last page**: revtex balances the columns of the last page and above the references, and centres the references' rule across the page; typst can't, so the rule sits in the column
- **display maths**: new computer modern math sets displays up to about 2 pt taller than computer modern
- **small text**: tex uses optical sizes (cmr9, cmbx12), new computer modern scales its 10 pt design, so 9 and 12 pt text runs a little narrower or wider
- **footnotes**: at the foot of the page, as revtex's `nofootinbib` option (the exporter writes it), not in the reference list
- **line numbers**: the right column's numbers are on the right and the title block isn't numbered; the numbers are serif (typst bundles no sans)
- **paragraph indents**: text after a display equation continues the paragraph unindented, even after a blank line; start it with `#h(1em)` if it should be a new paragraph
- **references**: typst's `american-physics-society` style writes `[1,2]` where revtex writes `[1, 2]`

## compared with revtyp

[revtyp](https://typst.app/universe/package/revtyp) mimics the published look of physical review journals. faux-revtex instead mimics what revtex4-2 itself produces, the preprint you upload to arxiv and submit, and pairs with an exporter that writes that revtex source.

## fonts

None to install: it uses new computer modern, which typst bundles.

## license

The package is dual licensed under [MIT](LICENSE) or [Apache-2.0](LICENSE-APACHE), at your option. The template in `template/` is [MIT-0](https://spdx.org/licenses/MIT-0.html), so papers started from it carry no licence terms.
