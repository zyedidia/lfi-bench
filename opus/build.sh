#!/bin/sh

set -ex

LDFLAGS="-static-pie" meson setup build-lfi opus --cross-file ../toolchains/aarch64-lfi.txt -Ddefault_library=static
ninja -C build-lfi

LDFLAGS="-static-pie" meson setup build-lfi-stores opus --cross-file ../toolchains/aarch64-lfi-stores.txt -Ddefault_library=static
ninja -C build-lfi-stores

LDFLAGS="-static-pie" meson setup build-native opus --cross-file ../toolchains/aarch64-native.txt -Ddefault_library=static
ninja -C build-native
