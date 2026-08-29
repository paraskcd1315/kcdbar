#!/usr/bin/env bash
# Copyright 2026 Paras Mohandas Khanchandani Chandani
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail

# Installs to a STABLE path. TCC keys a grant to the code's designated requirement
# AND the app it saw it on, so a build run straight out of DerivedData is a
# different app to the privacy database every time the derived path changes.
# Accessibility is granted to /Applications/KCDBar.app and nothing else.

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="${CONFIG:-Release}"
BUILT="$ROOT/build/Build/Products/$CONFIG/KCDBar.app"
TARGET="/Applications/KCDBar.app"

# Builds first, always. Installing a stale build looks identical to a fix that did
# not work, and cost a whole round of "I still see no change".
if [ "${SKIP_BUILD:-0}" != "1" ]; then
  "$ROOT/deploy/build.sh"
fi

if [ ! -d "$BUILT" ]; then
  echo "no build at $BUILT — run deploy/build.sh first" >&2
  exit 1
fi

# The build must be newer than every source it was made from. A failed compile
# leaves the previous binary in place, and installing that reports success while
# shipping the code the user already rejected.
BINARY="$BUILT/Contents/MacOS/KCDBar"
NEWEST=$(find "$ROOT/Sources" "$ROOT/Resources" -type f \
  \( -name "*.swift" -o -name "*.xcstrings" -o -name "*.plist" \) \
  -exec stat -f "%m" {} + | sort -rn | head -1)

if [ "$(stat -f "%m" "$BINARY")" -lt "$NEWEST" ]; then
  echo "the build is older than its sources — the compile did not land" >&2
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

if [ "${LAUNCH:-1}" = "1" ]; then
  open -a "$TARGET"
fi

echo "installed $TARGET  ($CONFIG, built $(stat -f '%Sm' "$TARGET/Contents/MacOS/KCDBar"))"
codesign -d -r- "$TARGET" 2>&1 | grep designated || true
