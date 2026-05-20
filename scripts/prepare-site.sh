CRC32=crc32
SITE_DIR=_site
CORES_DIR=libretro-super/dist/unix
CORES_TARGET_DIR="$SITE_DIR"/nightly/linux/loongarch64/latest
INDEX_FILE="$CORES_TARGET_DIR"/.index-extended

mkdir -vp "$SITE_DIR"

mkdir -vp "$CORES_TARGET_DIR"
cp lock.repos "$CORES_TARGET_DIR"/

> $INDEX_FILE
for f in "$CORES_DIR"/*.so; do
  name="$(basename $f)"
  echo "$(date -Idate) $("$CRC32" "$f") $name.zip" >> $INDEX_FILE
  zip -j "$CORES_TARGET_DIR"/"$name.zip" "$f"
done

