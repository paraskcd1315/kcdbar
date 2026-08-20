#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="${CONFIG:-Release}"
APP="$ROOT/build/Build/Products/$CONFIG/KCDBar.app"
OUT="$ROOT/dist"

if ! command -v create-dmg >/dev/null 2>&1; then
  echo "create-dmg not found — brew install create-dmg" >&2
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
BACKGROUND="$ROOT/deploy/dmg-background.png"
WINDOW_WIDTH=640
WINDOW_HEIGHT=420
ICON_SIZE=128
APP_X=${APP_X:-176}
APP_Y=${APP_Y:-182}
DROP_X=${DROP_X:-464}
DROP_Y=${DROP_Y:-182}

ARGS=(
  --volname "KCDBar $MARKETING"
  --window-pos 200 120
  --window-size "$WINDOW_WIDTH" "$WINDOW_HEIGHT"
  --icon-size "$ICON_SIZE"
  --icon "KCDBar.app" "$APP_X" "$APP_Y"
  --app-drop-link "$DROP_X" "$DROP_Y"
  --no-internet-enable
)

if [ -f "$BACKGROUND" ]; then
  ARGS+=(--background "$BACKGROUND")
else
  echo "note: no background at $BACKGROUND — building a plain dmg" >&2
fi

create-dmg "${ARGS[@]}" "$DMG" "$STAGE"

codesign --verify --deep --strict "$STAGE/KCDBar.app"
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
