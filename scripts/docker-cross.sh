docker run --rm \
    -u $(id -u):$(id -g) \
    -v ./scripts/docker/build-core.sh:/build-core.sh \
    -v ./cores:/cores \
    -v ./libretro-super:/libretro-super \
    -e SCCACHE_GHA_ENABLED="$SCCACHE_GHA_ENABLED" \
    -e ACTIONS_RESULTS_URL="$ACTIONS_RESULTS_URL" \
    -e ACTIONS_RUNTIME_TOKEN="$ACTIONS_RUNTIME_TOKEN" \
    -e ACTIONS_CACHE_SERVICE_V2="$ACTIONS_CACHE_SERVICE_V2" \
    libretro-loongarch-cross \
    bash -c "/build-core.sh $1"
