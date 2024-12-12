#!/bin/sh

set -ex

./build-native/programs/zstd -b1 bigfile.txt
lfi-run -- ./build-lfi-stores/programs/zstd -b1 bigfile.txt
lfi-run -- ./build-lfi/programs/zstd -b1 bigfile.txt

