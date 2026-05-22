#!/bin/bash

set -e

BASE_DIR="$(pwd)"/libretro-super
PATCH_DIR="$(pwd)"/cores/"$1"/patches

export ARCH=loongarch64
export HOST_CC='loongarch64-linux-gnu'

if [[ -d "$PATCH_DIR" ]]; then
  cd $BASE_DIR/libretro-"$1"
  git apply -v "$PATCH_DIR"/*
fi

cd $BASE_DIR 
./libretro-build.sh "$1"
