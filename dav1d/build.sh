#!/bin/sh

set -x

git clone https://github.com/zyedidia/dav1d -b lfi

meson setup build-lfi dav1d --cross-file ../toolchains/aarch64-lfi.txt -Ddefault_library=static
ninja -C build-lfi

meson setup build-lfi-stores dav1d --cross-file ../toolchains/aarch64-lfi-stores.txt -Ddefault_library=static
ninja -C build-lfi-stores

meson setup build-native dav1d --cross-file ../toolchains/aarch64-native.txt -Ddefault_library=static
ninja -C build-native
