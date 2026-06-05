# syntax=docker.io/docker/dockerfile:1

ARG DEBIAN_TAG=sid-20260406
ARG SCCACHE_VERSION=v0.15.0


FROM debian:$DEBIAN_TAG

# dpkg: error processing archive /tmp/apt-dpkg-install-AN2vKz/209-libxcb1_1.17.0-2+b2_amd64.deb (--unpack):
#   trying to overwrite shared '/usr/share/doc/libxcb1/changelog.Debian.gz', which is different from other instances of package libxcb1:amd64
RUN dpkg --add-architecture loong64 && \
    apt-get update && \
    apt-get -o Dpkg::Options::="--force-overwrite" -y --no-install-recommends install \
    ca-certificates \
    git \
    build-essential \
    gcc-loongarch64-linux-gnu \
    g++-loongarch64-linux-gnu \
    binutils-loongarch64-linux-gnu \
    clang \
    llvm \
    lld \
    pkgconf \
    cmake \
    zlib1g-dev:loong64 \
    libegl1-mesa-dev:loong64 \
    libgles2-mesa-dev:loong64 \
    python3 && \
    rm -rf /var/lib/apt/lists/*

ARG SCCACHE_VERSION
ADD --unpack https://github.com/mozilla/sccache/releases/download/$SCCACHE_VERSION/sccache-$SCCACHE_VERSION-x86_64-unknown-linux-musl.tar.gz /usr/local/bin/
RUN mv /usr/local/bin/sccache-*/sccache /usr/local/bin/sccache && \
    rm -rv /usr/local/bin/sccache-* && \
    chmod +x /usr/local/bin/sccache
ENV SCCACHE_DIR=/tmp/sccache

RUN << EOF cat > /usr/loongarch64-linux-gnu/cmake-toolchain.cmake
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR loongarch64)
set(CMAKE_C_COMPILER loongarch64-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER loongarch64-linux-gnu-g++)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
EOF
