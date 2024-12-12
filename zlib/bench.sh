#!/bin/sh

set -ex

hyperfine 'lfi-run -- build-lfi/compress_file'
hyperfine 'lfi-run -- build-lfi/decompress_file'

hyperfine 'lfi-run -- build-lfi-stores/compress_file'
hyperfine 'lfi-run -- build-lfi-stores/decompress_file'

hyperfine 'build-native/compress_file'
hyperfine 'build-native/decompress_file'
