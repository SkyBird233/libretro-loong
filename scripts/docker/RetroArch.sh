export APPIMAGE_EXTRACT_AND_RUN=1

OUTDIR=/out
APPDIR="$OUTDIR"/AppDir
APPIMAGEDIR=/usr/local/bin

mkdir -p "$APPDIR"
mkdir -p "$APPIMAGEDIR"


pushd /sources/RetroArch
./configure --disable-qt --prefix=/usr
make -j"$(nproc)"
make install DESTDIR="$APPDIR"


pushd "$APPIMAGEDIR"
for i in 'linuxdeploy' 'appimagetool'; do
    curl -o "$i" -L "https://github.com/loong64/$i/releases/download/continuous/$i-loongarch64.AppImage"
    chmod +x "$i"

    # https://github.com/AppImage/AppImageKit/issues/828
    dd if=/dev/zero bs=1 count=3 seek=8 conv=notrunc of="$i"
done

pushd $OUTDIR
linuxdeploy --appdir "$APPDIR" \
    --executable "$APPDIR"/usr/bin/retroarch \
    --desktop-file "$APPDIR"/usr/share/applications/com.libretro.RetroArch.desktop \
    --icon-file "$APPDIR"/usr/share/pixmaps/com.libretro.RetroArch.svg

appimagetool AppDir

