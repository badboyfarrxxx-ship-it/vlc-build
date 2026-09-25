# vlc-build

Builds VLC 4 for Windows as a portable zip, on GitHub's servers.

## Build

Actions tab > "Build VLC for Windows" > Run workflow. About an hour.
When it finishes, the zip is on the Releases page.

## Install on the Surface

1. Uninstall the old "VLC 4.0 dev" from Settings > Apps, if it's there.
2. Download the zip from Releases and unzip it anywhere, for example `C:\Apps\VLC 4`.
3. Open the `vlc-4.0.0-dev` folder inside and run `vlc.exe`. If Windows shows "Windows protected your PC",
   click More info > Run anyway (the build isn't signed). The first start is slow while it scans its plugins.

It doesn't touch a normal VLC install or your file types.

## Upgrade VLC

Put a newer commit hash from https://github.com/videolan/vlc/commits/master in `VLC_COMMIT`,
commit, and run a build. If the build stops at "Find VLC's ready-made libraries", VLC hasn't
published libraries for that commit yet; pick a newer commit.

## Add your own changes

See `patches/README.md`.

## Tests

`tests/run-all.sh` tests the scripts. They also run on every push.
