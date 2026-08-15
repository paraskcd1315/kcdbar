#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
XCODEGEN="${XCODEGEN:-$HOME/tools/xcodegen/bin/xcodegen}"
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
