# syntax=docker.io/docker/dockerfile:1

ARG DEBIAN_TAG=sid-20260406

FROM debian:$DEBIAN_TAG

RUN dpkg --add-architecture loong64

# dpkg: error processing archive /tmp/apt-dpkg-install-AN2vKz/209-libxcb1_1.17.0-2+b2_amd64.deb (--unpack):
#   trying to overwrite shared '/usr/share/doc/libxcb1/changelog.Debian.gz', which is different from other instances of package libxcb1:amd64
RUN apt-get update && apt-get -o Dpkg::Options::="--force-overwrite" -y install \
    git \
    build-essential \
    gcc-loongarch64-linux-gnu \
    g++-loongarch64-linux-gnu \
    binutils-aarch64-linux-gnu \
    clang \
    llvm \
    lld \
    pkgconf \
    cmake \
    zlib1g-dev:loong64 \
    libegl1-mesa-dev:loong64 \
    libgles2-mesa-dev:loong64 \
    python3

