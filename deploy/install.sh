#!/usr/bin/env bash
set -euo pipefail

# Installs to a STABLE path. TCC keys a grant to the code's designated requirement
# AND the app it saw it on, so a build run straight out of DerivedData is a
# different app to the privacy database every time the derived path changes.
# Accessibility is granted to /Applications/KCDBar.app and nothing else.

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="${CONFIG:-Debug}"
BUILT="$ROOT/build/Build/Products/$CONFIG/KCDBar.app"
TARGET="/Applications/KCDBar.app"

if [ ! -d "$BUILT" ]; then
  echo "no build at $BUILT — run deploy/build.sh first" >&2
  exit 1
fi

RUNNING=$(ps -A -o pid=,comm= | awk -v want="$TARGET/Contents/MacOS/KCDBar" '$2 == want { print $1 }')
RUNNING=${RUNNING%%$'\n'*}

if [ -n "$RUNNING" ]; then
  kill "$RUNNING" 2>/dev/null || true
  /bin/sleep 1
fi

rm -rf "$TARGET"
ditto "$BUILT" "$TARGET"

codesign --verify --deep --strict "$TARGET"

echo "installed $TARGET"
codesign -d -r- "$TARGET" 2>&1 | grep designated || true
