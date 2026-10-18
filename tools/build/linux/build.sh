#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"
build_dir="$PWD"
work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT

mkdir -p "$work_dir/AppDir"
cp -r AppRun snekkyd.desktop icon.png usr "$work_dir/AppDir/"
cp -r ../../../public/. "$work_dir/AppDir/usr/bin/"
chmod +x "$work_dir/AppDir/AppRun" "$work_dir/AppDir/usr/bin/scapp"

curl --fail --location --retry 3 \
  https://github.com/AppImage/AppImageKit/releases/download/12/appimagetool-x86_64.AppImage \
  --output "$work_dir/appimagetool.AppImage"
chmod +x "$work_dir/appimagetool.AppImage"

# Extract the packaging tool so CI does not need a FUSE mount.
cd "$work_dir"
./appimagetool.AppImage --appimage-extract > /dev/null
ARCH=x86_64 ./squashfs-root/AppRun "$work_dir/AppDir" \
  "$build_dir/Snekky_Decompiler-x86_64.AppImage"
