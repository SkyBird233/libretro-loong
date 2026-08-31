export APPIMAGE_EXTRACT_AND_RUN=1
APPIMAGE_NAME=RetroArch-loongarch64

SOURCESDIR=/sources
PATCHESDIR=/patches
OUTDIR=/out
APPDIR="$OUTDIR"/AppDir
CONFIGDIR="$OUTDIR"/"$APPIMAGE_NAME".AppImage.home/.config/retroarch

set -euo pipefail

mkdir -p "$OUTDIR"
mkdir -p "$APPDIR"
mkdir -p "$CONFIGDIR"
rm -rf "$OUTDIR"/*

echo "::group::Patching RetroArch"
cd "$SOURCESDIR"/RetroArch
git apply "$PATCHESDIR"/*
echo "::endgroup::"

echo "::group::Building RetroArch"
cd "$SOURCESDIR"/RetroArch && ./configure --disable-qt --prefix=/usr
make -C "$SOURCESDIR"/RetroArch -j"$(nproc)"
echo "::endgroup::"

echo "::group::Installing RetroArch"
make -C "$SOURCESDIR"/RetroArch DESTDIR="$APPDIR" install
rm -r "$APPDIR"/etc
echo "::endgroup::"

echo "::group::Installing audio filters"
make -C "$SOURCESDIR"/RetroArch/libretro-common/audio/dsp_filters
make -C "$SOURCESDIR"/RetroArch/libretro-common/audio/dsp_filters DESTDIR="$CONFIGDIR" INSTALLDIR="/filters/audio" install
echo "::endgroup::"

echo "::group::Installing video filters"
make -C "$SOURCESDIR"/RetroArch/gfx/video_filters
make -C "$SOURCESDIR"/RetroArch/gfx/video_filters DESTDIR="$CONFIGDIR" INSTALLDIR="/filters/video" install
echo "::endgroup::"

echo "::group::Installing core info"
make -C "$SOURCESDIR"/libretro-core-info DESTDIR="$CONFIGDIR" INSTALLDIR="/cores" install
echo "::endgroup::"

echo "::group::Installing assets"
make -C "$SOURCESDIR"/retroarch-assets DESTDIR="$CONFIGDIR" INSTALLDIR="/assets" install
rm -r "$CONFIGDIR"/assets/{README.md,branding,ctr,fonts,nxrgui,scripts,switch,wallpapers}
echo "::endgroup::"

echo "::group::Installing database"
make -C "$SOURCESDIR"/libretro-database DESTDIR="$CONFIGDIR" INSTALLDIR="/database" install
rm -r "$CONFIGDIR"/database/cht
echo "::endgroup::"

echo "::group::Installing joypad autoconfig"
make -C "$SOURCESDIR"/retroarch-joypad-autoconfig DESTDIR="$CONFIGDIR" INSTALLDIR="/autoconfig" DOC_DIR="/autoconfig-doc" install
rm -r "$CONFIGDIR"/autoconfig-doc
rm -r "$CONFIGDIR"/autoconfig/{android,dinput,mfi,qnx}
echo "::endgroup::"

echo "::group::Installing overlays"
make -C "$SOURCESDIR"/common-overlays DESTDIR="$CONFIGDIR" INSTALLDIR="/overlays" install
echo "::endgroup::"

echo "::group::Installing common shaders"
make -C "$SOURCESDIR"/common-shaders DESTDIR="$CONFIGDIR" INSTALLDIR="/shaders/shaders_cg" install
echo "::endgroup::"

echo "::group::Installing GLSL shaders"
make -C "$SOURCESDIR"/glsl-shaders DESTDIR="$CONFIGDIR" INSTALLDIR="/shaders/shaders_glsl" install
echo "::endgroup::"

echo "::group::Installing Slang shaders"
make -C "$SOURCESDIR"/slang-shaders DESTDIR="$CONFIGDIR" INSTALLDIR="/shaders/shaders_slang" install
echo "::endgroup::"

echo "::group::Generating AppImage"
linuxdeploy --appdir "$APPDIR" \
    --executable "$APPDIR"/usr/bin/retroarch \
    --desktop-file "$APPDIR"/usr/share/applications/com.libretro.RetroArch.desktop \
    --icon-file "$APPDIR"/usr/share/pixmaps/com.libretro.RetroArch.svg

appimagetool "$APPDIR" "$OUTDIR"/"$APPIMAGE_NAME".AppImage
echo "::endgroup::"

