set -e

for core in $(yq '.repositories | keys | map(sub("libretro-","")) | join(" ")' lock.repos); do
  echo "::group::$core"
  time scripts/docker-cross.sh "$core"
  echo "::endgroup::"
done
