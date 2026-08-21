#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
XCODEGEN="${XCODEGEN:-$(command -v xcodegen || echo "$HOME/tools/xcodegen/bin/xcodegen")}"

if [ ! -x "$XCODEGEN" ]; then
  echo "xcodegen not found — brew install xcodegen" >&2
  exit 1
fi

CONFIG="${CONFIG:-Release}"
DERIVED="$ROOT/build"
APP="$DERIVED/Build/Products/$CONFIG/KCDBar.app"

# VERSION is the single source of truth for the marketing version. The build number
# and commit come from git, so a binary always names the tree it was made from.
if [ ! -f "$ROOT/VERSION" ]; then
  echo "no VERSION file at $ROOT/VERSION" >&2
  exit 1
fi

MARKETING=$(tr -d '[:space:]' < "$ROOT/VERSION")
BUILD=$(git -C "$ROOT" rev-list --count HEAD 2>/dev/null || echo 0)
COMMIT=$(git -C "$ROOT" rev-parse --short HEAD 2>/dev/null || echo unknown)

if [ -n "$(git -C "$ROOT" status --porcelain 2>/dev/null)" ]; then
  COMMIT="$COMMIT-dirty"
fi

echo "Version: $MARKETING ($BUILD) $COMMIT"

cd "$ROOT"
"$XCODEGEN" generate --quiet

xcodebuild \
  -project KCDBar.xcodeproj \
  -scheme KCDBar \
  -configuration "$CONFIG" \
  -derivedDataPath "$DERIVED" \
  MARKETING_VERSION="$MARKETING" \
  CURRENT_PROJECT_VERSION="$BUILD" \
  KCDBAR_GIT_COMMIT="$COMMIT" \
  build "$@"

codesign --verify --deep --strict --verbose=2 "$APP"
echo "Built: $APP"
