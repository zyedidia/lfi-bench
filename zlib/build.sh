#!/bin/sh

set -ex

cp ./meson.build zlib
cp ./benchmark/*.c zlib

meson setup build-lfi zlib --cross-file ../toolchains/aarch64-lfi.txt -Ddefault_library=static
ninja -C build-lfi

meson setup build-lfi-stores zlib --cross-file ../toolchains/aarch64-lfi-stores.txt -Ddefault_library=static
ninja -C build-lfi-stores

meson setup build-native zlib --cross-file ../toolchains/aarch64-native.txt -Ddefault_library=static
ninja -C build-native
