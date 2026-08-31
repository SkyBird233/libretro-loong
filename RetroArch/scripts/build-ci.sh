CONTAINER_NAME=retroarch-loongarch

echo 'Fetching sources ...'
mkdir -p sources
scripts/fetch-sources.sh

mkdir -p out

echo 'Building in container ...'
docker run --rm \
    -u $(id -u):$(id -g) \
    -v ./sources:/sources \
    -v ./patches:/patches \
    -v ./out:/out \
    -v ./scripts/build-in-docker.sh:/build-in-docker.sh \
    "$CONTAINER_NAME" \
    bash -c "/build-in-docker.sh"
