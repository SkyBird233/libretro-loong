set -e

ALL_CORES=$(yq '.repositories | keys | map(sub("libretro-","")) | join(" ")' lock.repos)

if [ "$#" -eq 0 ]; then
  CORES_TO_BUILD=""
elif [ "${1,,}" = "all" ]; then
  CORES_TO_BUILD="$ALL_CORES"
else
  CORES_TO_BUILD="$*"
fi

echo "Cores to build: $CORES_TO_BUILD"

for core in $CORES_TO_BUILD; do
  echo "::group::$core"
  time scripts/docker-cross.sh "$core"
  echo "::endgroup::"
done
