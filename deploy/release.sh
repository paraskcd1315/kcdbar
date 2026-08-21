#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="${CONFIG:-Release}"
APP="$ROOT/build/Build/Products/$CONFIG/KCDBar.app"
OUT="$ROOT/dist"

# dmgbuild rather than create-dmg on purpose. create-dmg drives Finder over
# AppleScript to place the icons, which needs Automation permission and blocks
# forever on the TCC prompt when nobody is at the screen. dmgbuild writes the
# .DS_Store itself, so it needs no Finder and runs unattended.
DMGBUILD="${DMGBUILD:-$(command -v dmgbuild || echo "$HOME/.local/bin/dmgbuild")}"

if [ ! -x "$DMGBUILD" ]; then
  echo "dmgbuild not found — pipx install dmgbuild" >&2
  exit 1
fi

if [ "${SKIP_BUILD:-0}" != "1" ]; then
  "$ROOT/deploy/build.sh"
fi

if [ ! -d "$APP" ]; then
  echo "no build at $APP — run deploy/build.sh first" >&2
  exit 1
fi

MARKETING=$(tr -d '[:space:]' < "$ROOT/VERSION")
COMMIT=$(git -C "$ROOT" rev-parse --short HEAD)

# The artefact names the tree it was cut from, so a downloaded dmg is always
# traceable to a commit without opening it.
NAME="KCDBar-$MARKETING-$COMMIT"
DMG="$OUT/$NAME.dmg"

# A release is cut from a clean tree. A dirty one produces a binary nobody can
# reproduce, and the version string would read "-dirty" while the filename did not.
if [ -n "$(git -C "$ROOT" status --porcelain)" ]; then
  echo "working tree is dirty — commit or stash before cutting a release" >&2
  exit 1
fi

rm -rf "$OUT"
mkdir -p "$OUT"

STAGE=$(mktemp -d)
trap 'rm -rf "$STAGE"' EXIT
ditto "$APP" "$STAGE/KCDBar.app"

# Icon positions match the zones drawn into the background image. Change both together.
# The background is a two-representation TIFF (640x420 @72dpi + 1280x840 @144dpi) built by
# tiffutil -cathidpicheck. A plain 1x PNG renders soft on every Retina display.
BACKGROUND="$ROOT/deploy/dmg-background.tiff"
APP_X=${APP_X:-176}
APP_Y=${APP_Y:-182}
DROP_X=${DROP_X:-464}
DROP_Y=${DROP_Y:-182}

if [ ! -f "$BACKGROUND" ]; then
  echo "no background at $BACKGROUND — run deploy/dmg-background.sh" >&2
  exit 1
fi

codesign --verify --deep --strict "$STAGE/KCDBar.app"

# A version is bound to the commit it was cut from in two places that outlive the
# binary: an annotated tag, and a line in RELEASES.md. The tag is local until the
# release is published, for the same reason the gh command below is not run.
TAG="v$MARKETING"

if git -C "$ROOT" rev-parse "$TAG" >/dev/null 2>&1; then
  TAGGED=$(git -C "$ROOT" rev-list -n 1 "$TAG")
  HEAD_SHA=$(git -C "$ROOT" rev-parse HEAD)

  if [ "$TAGGED" != "$HEAD_SHA" ]; then
    echo "$TAG already points at ${TAGGED:0:7}, not ${HEAD_SHA:0:7} — bump VERSION" >&2
    exit 1
  fi
else
  git -C "$ROOT" tag -a "$TAG" -m "KCDBar $MARKETING"
  echo "tagged $TAG at $COMMIT"
fi

LEDGER="$ROOT/RELEASES.md"

if ! grep -q "| \`$MARKETING\` |" "$LEDGER" 2>/dev/null; then
  printf '| `%s` | `%s` | %s |\n' \
    "$MARKETING" "$COMMIT" "$(git -C "$ROOT" log -1 --format=%cs)" >> "$LEDGER"
  echo "recorded $MARKETING -> $COMMIT in RELEASES.md"
fi

KCDBAR_APP="$STAGE/KCDBar.app" \
KCDBAR_DMG_BACKGROUND="$BACKGROUND" \
KCDBAR_APP_X="$APP_X" \
KCDBAR_APP_Y="$APP_Y" \
KCDBAR_DROP_X="$DROP_X" \
KCDBAR_DROP_Y="$DROP_Y" \
  "$DMGBUILD" -s "$ROOT/deploy/dmg-settings.py" "KCDBar $MARKETING" "$DMG"
shasum -a 256 "$DMG" | tee "$DMG.sha256"

echo
echo "Built $DMG"
echo
echo "This is an ALPHA and it is NOT notarized, so every downloader must go to"
echo "System Settings > Privacy & Security > Open Anyway on first launch."
echo
echo "To publish (needs a token for the paraskcd1315 account — gh here is paras-unimedia):"
echo "  gh release create v$MARKETING \"$DMG\" \"$DMG.sha256\" \\"
echo "    --repo paraskcd1315/kcdbar --prerelease --title \"KCDBar $MARKETING\""
