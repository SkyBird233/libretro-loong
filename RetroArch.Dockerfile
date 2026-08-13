ARG DEEPIN_TAG=beige-loong64-v1.2.0
ARG RETROARCH_VERSION=v1.22.2


FROM linuxdeepin/deepin:$DEEPIN_TAG

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        ca-certificates \
        curl \
        git \
        build-essential \
        pkgconf \
        gcc-loongarch64-linux-gnu \
        g++-loongarch64-linux-gnu \
        binutils-loongarch64-linux-gnu \
        \
        glslang-dev \
        libspirv-cross-c-shared-dev \
        libvulkan-dev \
        \
        libavcodec-dev \
        libavdevice-dev \
        libavformat-dev \
        libavutil-dev \
        libswscale-dev \
        libass-dev \
        \
        libfreetype-dev \
        libjack-jackd2-dev \
        libpipewire-0.3-dev \
        libpulse-dev \
        libsdl2-dev \
        libx11-xcb-dev \
        \
        libsystemd-dev \
        libudev-dev \
        libusb-1.0-0-dev \
        libv4l-dev \
        \
        qt6-base-dev \
        wayland-protocols \
        \
        file \
        appstream \
        gpg \
        && \
    rm -rf /var/lib/apt/lists/*

ARG RETROARCH_VERSION
RUN mkdir /sources
RUN cd /sources && git clone --branch=$RETROARCH_VERSION --single-branch --depth 1 https://github.com/libretro/RetroArch.git
