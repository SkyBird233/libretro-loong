# RetroArch for LoongArch

This directory contains the Docker-based build setup used to package RetroArch as a LoongArch AppImage.

## Build

Docker and the Python package `vcs2l` are required. Run these commands from this directory:

```sh
uv tool install vcs2l
docker build -t retroarch-loongarch .
scripts/build-ci.sh
```

The build fetches the pinned repositories in `lock.repos`, applies the patches in `patches/`, and writes the AppImage and its configuration directory to `out/`.

On a non-LoongArch host, Docker must be configured with LoongArch binary-format emulation.
