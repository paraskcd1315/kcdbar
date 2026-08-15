#!/usr/bin/env bash
set -euo pipefail

# KCDBAR-21 — can a third-party bar borrow the Dock's own screen-space reservation?
#
# macOS reserves screen space for the Dock when it is NOT auto-hidden, and gives a
# third-party window no way to reserve any. This sweeps tilesize to find what
# reserved strip heights are actually obtainable, so we know whether one of them
# can match a usable bar thickness.
#
# Reads the current settings first and restores them at the end, including on failure.

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MEASURE="$ROOT/deploy/measure-visible-frame.swift"
SIZES="${SIZES:-16 24 32 40 48 56 64 80 96 112 128}"

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
  /bin/sleep 2
  insets="$(swift "$MEASURE" 2>/dev/null | awk '/insets/ { printf "%s ", $2 }')"
  echo "tilesize=$size -> ${insets}"
done
