set -e

CRC32=crc32
SITE_DIR=_site
CORES_DIR=libretro-super/dist/unix
CORES_TARGET_SUBDIR=nightly/linux/loongarch64/latest
CORES_TARGET_DIR="$SITE_DIR"/"$CORES_TARGET_SUBDIR"
INDEX_FILE="$CORES_TARGET_DIR"/.index-extended

mkdir -vp "$SITE_DIR"

mkdir -vp "$CORES_TARGET_DIR"
cp -v lock.repos "$CORES_TARGET_DIR"/

echo "Preparing new cores ..."
> $INDEX_FILE
for f in "$CORES_DIR"/*.so; do
  name="$(basename $f)"
  echo "$(date -Idate) $("$CRC32" "$f") $name.zip" >> $INDEX_FILE
  zip -j "$CORES_TARGET_DIR"/"$name.zip" "$f"
done

echo "Downloading previous cores ..."
CORES_LATEST_URL="https://skybird233.github.io/libretro-loong"
pushd "$CORES_TARGET_DIR"
wget "$CORES_LATEST_URL"/"$CORES_TARGET_SUBDIR"/.index-extended -O .index-extended.old
for core in $(yq '.repositories | keys | map(sub("libretro-","")) | join(" ")' lock.repos); do
  echo "Checking $core ..."
  CORE_FILENAME="$core"_libretro.so.zip
  if [[ ! -f "$CORE_FILENAME" ]]; then
    echo "Downloading $core ..."
    wget "$CORES_LATEST_URL"/"$CORES_TARGET_SUBDIR"/"$CORE_FILENAME"
    grep "$CORE_FILENAME" .index-extended.old >> .index-extended
  fi
done
rm -v .index-extended.old
popd
