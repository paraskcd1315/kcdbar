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

# milestone.feature.fix — the first is a milestone release, the second a feature
# release within it, the third a fix release for that feature or an earlier one.
# Rejected here rather than at release time, so a malformed version can never be
# compiled into a binary at all.
if ! printf '%s' "$MARKETING" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo "VERSION is '$MARKETING' — must be milestone.feature.fix, three numbers" >&2
  exit 1
fi
# The fix digit starts at 1: a feature or milestone bump lands as x.y.1, never x.y.0.
if [ "${MARKETING##*.}" = "0" ]; then
  echo "VERSION is '$MARKETING' — the fix digit is never 0, it starts at 1" >&2
  exit 1
fi

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
