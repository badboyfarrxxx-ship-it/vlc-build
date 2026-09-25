#!/usr/bin/env bash
# Runs inside VLC's Windows build image, with the VLC source as the current folder.
# build.sh -r builds in release mode and runs `make package-win32`, which writes
# win64/vlc-<VERSION>-win64.zip (plus a .7z and an installer we don't publish).
# The ready-made libraries (contribs) come from VLC_PREBUILT_CONTRIBS_URL, set by
# the workflow to the tarball matching the pinned VLC commit; without it, build.sh
# would silently fall back to compiling every library from source.
set -euo pipefail
: "${VLC_PREBUILT_CONTRIBS_URL:?set by the workflow; without it build.sh would compile every library from source}"
# The source is owned by the runner's user, not root; let git work on it anyway.
git config --global --add safe.directory '*'
extras/package/win32/build.sh -a x86_64 -r -p
ls -l win64/vlc-*-win64.zip
