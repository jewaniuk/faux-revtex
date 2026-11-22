"""compare word baselines of the latex and typst builds of a fixture.

usage: drift.py latex.pdf typst.pdf [tolerance]

matches the two word lists in reading order and prints every matched word whose
baseline moved by more than the tolerance (typst pt, default 0.5) relative to the
word before it, so a local difference is reported once rather than for every line
after it, or, for the first word of a body text line, whose left edge moved. other horizontal positions aren't
checked: tex sets 7, 9 and 12 pt text in their own optical sizes (cmr9, cmbx12), new
computer modern scales its 10 pt design, and tex stretches spaces after punctuation
more. exits 1 on any drift.
"""

import difflib
import sys

from pdfminer.high_level import extract_pages
from pdfminer.layout import LTChar, LTTextContainer, LTTextLine


def lines(element):
    """yield every text line below a layout element."""
    if isinstance(element, LTTextLine):
        yield element
    elif isinstance(element, LTTextContainer) or hasattr(element, "__iter__"):
        for child in element:
            yield from lines(child)


def words(path):
    """return (page, x, y, size, text) for every word, in reading order."""
    found = []
    for page_number, page in enumerate(extract_pages(path), start=1):
        for line in lines(page):
            word = []
            for char in list(line) + [None]:
                if isinstance(char, LTChar) and not char.get_text().isspace():
                    word.append(char)
                    continue
                if word:
                    first = word[0]
                    text = "".join(c.get_text() for c in word)
                    end = word[-1].x1
                    found.append((page_number, first.matrix[4], page.height - first.matrix[5], first.size, text, end))
                    word = []
    # reading order: full-width lines (any word crossing the page middle) count as the
    # left column, then each column top to bottom
    wide = {(w[0], round(w[2], 1)) for w in found if w[1] < 305 < w[5]}
    found.sort(key=lambda w: (w[0], (w[0], round(w[2], 1)) not in wide and w[1] > 305, round(w[2], 1), w[1]))
    # flag the first word of each line
    return [w + (i == 0 or found[i - 1][:3:2] != w[:3:2] or abs(found[i - 1][2] - w[2]) > 0.1,) for i, w in enumerate(found)]


latex, typst = words(sys.argv[1]), words(sys.argv[2])
tolerance = float(sys.argv[3]) if len(sys.argv) > 3 else 0.5
matcher = difflib.SequenceMatcher(None, [w[4] for w in latex], [w[4] for w in typst], autojunk=False)
drift = 0
matched = 0
previous = (0, 0.0)
for block in matcher.get_matching_blocks():
    for i in range(block.size):
        a, b = latex[block.a + i], typst[block.b + i]
        matched += 1
        dx, offset = b[1] - a[1], b[2] - a[2]
        dy = offset - previous[1] if previous[0] == a[0] else offset
        previous = (a[0], offset)
        # body text lines start at a column's left edge (54 or 317 pt) or an indent from it
        at_edge = any(0 <= a[1] - edge < 12 for edge in (54, 317.03))
        starts_body_line = a[6] and at_edge and abs(a[3] - 9.96) < 0.1
        if a[0] != b[0] or abs(dy) > tolerance or (starts_body_line and abs(dx) > tolerance):
            drift += 1
            print(f"p{a[0]}/{b[0]} {a[4]!r:24} latex ({a[1]:7.2f}, {a[2]:7.2f})  dx {dx:+6.2f}  dy {dy:+6.2f}  (total {offset:+6.2f})")
print(f"{matched} of {len(latex)} latex words matched, {drift} drifted past {tolerance} pt")
sys.exit(1 if drift else 0)
