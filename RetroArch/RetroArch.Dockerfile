ARG DEEPIN_TAG=beige-loong64-v1.2.0


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
        libfreetype-dev \
        libjack-jackd2-dev \
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


# Note for dd: https://github.com/AppImage/AppImageKit/issues/828
RUN cd /usr/local/bin && \
    for i in 'linuxdeploy' 'appimagetool'; do \
        curl -o "$i" -L "https://github.com/loong64/$i/releases/download/continuous/$i-loongarch64.AppImage" && \
        chmod +x "$i" && \
        dd if=/dev/zero bs=1 count=3 seek=8 conv=notrunc of="$i" \
    ; done

