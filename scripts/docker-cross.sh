docker run --rm \
    -u $(id -u):$(id -g) \
    -v ./scripts/docker/build-core.sh:/build-core.sh \
    -v ./cores:/cores \
    -v ./libretro-super:/libretro-super \
    libretro-loongarch-cross \
    bash -c "/build-core.sh $1"
