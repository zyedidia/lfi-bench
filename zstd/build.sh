#!/bin/sh

set -ex

meson setup build-lfi zstd/build/meson --cross-file ../toolchains/aarch64-lfi.txt -Ddefault_library=static
ninja -C build-lfi

meson setup build-lfi-stores zstd/build/meson --cross-file ../toolchains/aarch64-lfi-stores.txt -Ddefault_library=static
ninja -C build-lfi-stores

meson setup build-native zstd/build/meson --cross-file ../toolchains/aarch64-native.txt -Ddefault_library=static
ninja -C build-native
