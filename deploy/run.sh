#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="${CONFIG:-Release}"
APP="$ROOT/build/Build/Products/$CONFIG/KCDBar.app"

"$ROOT/deploy/build.sh"

pkill -x KCDBar 2>/dev/null || true
open "$APP"
echo "Launched: $APP"
