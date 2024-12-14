#!/bin/sh

set -ex

hyperfine \
    'lfi-run -- build-lfi/compress_file' \
    'lfi-run -- build-lfi-stores/compress_file' \
    'build-native/compress_file'

hyperfine \
    'lfi-run -- build-lfi/decompress_file' \
    'lfi-run -- build-lfi-stores/decompress_file' \
    'build-native/decompress_file'
