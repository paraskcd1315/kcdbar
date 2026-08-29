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

# KCDBAR-21 — can a third-party bar borrow the Dock's own screen-space reservation?
#
# ANSWERED 15-08-2026: no. A visible, non-auto-hidden Dock reserves nothing on
# macOS 26.6.1. This script is kept only to re-test on a DIFFERENT machine, since
# the finding came from a single configuration.
#
# DANGEROUS — it froze a machine hard enough to need a restart. `Dock.app` owns the
# sole window-server connection for Spaces, and restarting it repeatedly in a loop
# can wedge WindowServer and take the whole UI down with it. Hence:
#   - it refuses to run without RUN_DOCK_EXPERIMENT=1
#   - it defaults to THREE tile sizes, not eleven
#   - it waits 5s after each Dock restart instead of 2
# Do not widen SIZES without a reason, and never run it on a machine mid-work.
#
# Reads the current settings first and restores them at the end, including on failure.

if [ "${RUN_DOCK_EXPERIMENT:-0}" != "1" ]; then
  echo "Refusing to run: this restarts the Dock repeatedly and has frozen a machine."
  echo "The question it answers is already settled (see AppleConventions.md)."
  echo "To re-test on another machine: RUN_DOCK_EXPERIMENT=1 $0"
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MEASURE="$ROOT/deploy/measure-visible-frame.swift"
SIZES="${SIZES:-16 64 128}"

read_key() { defaults read com.apple.dock "$1" 2>/dev/null || echo ""; }

ORIG_AUTOHIDE="$(read_key autohide)"
ORIG_DELAY="$(read_key autohide-delay)"
ORIG_TIME="$(read_key autohide-time-modifier)"
ORIG_ORIENTATION="$(read_key orientation)"
ORIG_TILESIZE="$(read_key tilesize)"
ORIG_MAGNIFICATION="$(read_key magnification)"

restore() {
  echo ""
  echo "restoring original Dock settings"
  [ -n "$ORIG_AUTOHIDE" ] && defaults write com.apple.dock autohide -bool "$([ "$ORIG_AUTOHIDE" = "1" ] && echo true || echo false)"
  [ -n "$ORIG_DELAY" ] && defaults write com.apple.dock autohide-delay -float "$ORIG_DELAY"
  [ -n "$ORIG_TIME" ] && defaults write com.apple.dock autohide-time-modifier -float "$ORIG_TIME"
  [ -n "$ORIG_ORIENTATION" ] && defaults write com.apple.dock orientation -string "$ORIG_ORIENTATION"
  [ -n "$ORIG_TILESIZE" ] && defaults write com.apple.dock tilesize -int "$ORIG_TILESIZE"
  [ -n "$ORIG_MAGNIFICATION" ] && defaults write com.apple.dock magnification -bool "$([ "$ORIG_MAGNIFICATION" = "1" ] && echo true || echo false)"
  killall Dock 2>/dev/null || true
  echo "restored: autohide=$ORIG_AUTOHIDE delay=$ORIG_DELAY orientation=$ORIG_ORIENTATION tilesize=$ORIG_TILESIZE magnification=$ORIG_MAGNIFICATION"
}
trap restore EXIT

echo "original: autohide=$ORIG_AUTOHIDE delay=$ORIG_DELAY time=$ORIG_TIME orientation=$ORIG_ORIENTATION tilesize=$ORIG_TILESIZE magnification=$ORIG_MAGNIFICATION"
echo ""

defaults write com.apple.dock autohide -bool false
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock magnification -bool false
defaults write com.apple.dock orientation -string bottom

for size in $SIZES; do
  defaults write com.apple.dock tilesize -int "$size"
  killall Dock 2>/dev/null || true
  /bin/sleep 5
  insets="$(swift "$MEASURE" 2>/dev/null | awk '/insets/ { printf "%s ", $2 }')"
  echo "tilesize=$size -> ${insets}"
done
