#!/bin/bash

set -e

BASE_DIR="$(pwd)"/libretro-super
CORE_DIR="$(pwd)"/cores/"$1"

export ARCH=loongarch64
export HOST_CC='loongarch64-linux-gnu'

echo "=== Preparing $1 ..."
cd $BASE_DIR/libretro-"$1"
if [[ -f "$CORE_DIR"/prepare.sh ]]; then
  source "$CORE_DIR"/prepare.sh
fi

echo "=== Patching $1 ..."
if [[ -d "$CORE_DIR"/patches ]]; then
  cd $BASE_DIR/libretro-"$1"
  git apply -v "$CORE_DIR"/patches/*
fi

echo "=== Building $1 ..."
cd $BASE_DIR 
./libretro-build.sh "$1"
