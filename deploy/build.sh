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

cd "$ROOT"
"$XCODEGEN" generate --quiet

xcodebuild \
  -project KCDBar.xcodeproj \
  -scheme KCDBar \
  -configuration "$CONFIG" \
  -derivedDataPath "$DERIVED" \
  build "$@"

codesign --verify --deep --strict --verbose=2 "$APP"
echo "Built: $APP"
