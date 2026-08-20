#!/usr/bin/env bash
set -euo pipefail

# Renders deploy/dmg-background.svg into the two-representation TIFF the dmg needs.
# Finder picks the 144dpi image on a Retina display; handing it a 1x PNG looks soft.

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SVG="$ROOT/deploy/dmg-background.svg"
OUT="$ROOT/deploy/dmg-background.tiff"

if ! command -v rsvg-convert >/dev/null 2>&1; then
  echo "rsvg-convert not found — brew install librsvg" >&2
  exit 1
fi

if [ ! -f "$SVG" ]; then
  echo "no source at $SVG" >&2
  exit 1
fi

ONE="$ROOT/deploy/dmg-background.png"
TWO="$ROOT/deploy/dmg-background@2x.png"

rsvg-convert -w 640 -h 420 "$SVG" -o "$ONE"
rsvg-convert -w 1280 -h 840 "$SVG" -o "$TWO"
tiffutil -cathidpicheck "$ONE" "$TWO" -out "$OUT"

echo "Wrote $OUT"
tiffutil -info "$OUT" | grep -E "Image Width|Resolution:"
