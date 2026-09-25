# Patches

Every `*.patch` file here is applied to the VLC source before building, in name order.
Number them so the order is clear: `0001-swipe-to-seek.patch`, `0002-...`.

Make one from a VLC checkout at the commit in `VLC_COMMIT`:

    git diff > ../vlc-build/patches/0001-name.patch

If an upgrade breaks a patch, the build stops at "Apply patches" and names it.
Fix the patch against the new commit, then build again.
