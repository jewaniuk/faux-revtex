#!/usr/bin/env bash
# compare every fixture's typst build against its revtex build.
#
# for each tests/fixtures/<case>.typ with a <case>.tex: builds both, renders each page
# side by side (<case>-<page>-side.png, latex left) and overlaid (<case>-<page>-overlay.png,
# typst red, latex cyan, both black) into tests/out/. fixtures with a `// drift: <pt>` line
# (float-free ones) also get the word-position check at that tolerance; the script exits
# non-zero if any of those drift.
#
# usage: tests/compare.sh [case ...]
# needs latexmk (texlive with revtex4-2), typst, pdftoppm, imagemagick and uv
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
root=$(dirname "$here")
out=$here/out
mkdir -p "$out"

cases=("$@")
if [ ${#cases[@]} -eq 0 ]; then
  for f in "$here"/fixtures/*.typ; do
    [ -f "${f%.typ}.tex" ] && cases+=("$(basename "${f%.typ}")")
  done
fi

failed=()
for c in "${cases[@]}"; do
  echo "== $c"
  (cd "$here/fixtures" && latexmk -pdf -quiet -interaction=nonstopmode -outdir="$out" "$c.tex" >/dev/null 2>&1) ||
    { echo "latex build failed, see $out/$c.log"; failed+=("$c"); continue; }
  typst compile --root "$root" "$here/fixtures/$c.typ" "$out/$c-typ.pdf"

  rm -f "$out/$c"-[0-9]*.png "$out/$c"-typ-[0-9]*.png
  pdftoppm -r 100 -png "$out/$c.pdf" "$out/$c"
  pdftoppm -r 100 -png "$out/$c-typ.pdf" "$out/$c-typ"
  for tex in "$out/$c"-[0-9]*.png; do
    page=${tex##*-}
    typ=$out/$c-typ-$page
    [ -f "$typ" ] || continue
    magick "$tex" "$typ" +append "$out/$c-${page%.png}-side.png"
    # red channel from latex, green and blue from typst: latex-only ink is cyan, typst-only red
    magick \( "$tex" -colorspace gray \) \( "$typ" -colorspace gray \) \( "$typ" -colorspace gray \) \
      -set colorspace sRGB -combine "$out/$c-${page%.png}-overlay.png"
  done

  tolerance=$(sed -n 's|^// drift: \([0-9.]*\).*|\1|p' "$here/fixtures/$c.typ")
  if [ -n "$tolerance" ]; then
    uv run -q --with pdfminer.six python -I "$here/drift.py" "$out/$c.pdf" "$out/$c-typ.pdf" "$tolerance" ||
      failed+=("$c")
  fi
done

if [ ${#failed[@]} -gt 0 ]; then
  echo "drift or build failure: ${failed[*]}"
  exit 1
fi
