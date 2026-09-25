#!/usr/bin/env bash
# Runs inside VLC's Windows build image, with the VLC source as the current folder.
set -euo pipefail
# The source is owned by the runner's user, not root; let git work on it anyway.
git config --global --add safe.directory '*'
extras/package/win32/build.sh -a x86_64 -r -p
cd win64
if ! command -v zip >/dev/null; then
  apt-get update -qq && apt-get install -y -qq zip
fi
make package-win32-zip
ls -l vlc-*-win64.zip
