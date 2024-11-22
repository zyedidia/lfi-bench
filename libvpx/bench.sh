#!/bin/sh

set -ex

RUNS=${1:-3}
WARMUP=${2:-1}

hyperfine --runs $RUNS --warmup $WARMUP \
    'lfi-run -- ./build-lfi/vpxdec --threads=1 -o /dev/null vpx-benchdata/sample-30s.webm' \
    'lfi-run -- ./build-lfi-stores/vpxdec --threads=1 -o /dev/null vpx-benchdata/sample-30s.webm' \
    './build-native/vpxdec --threads=1 -o /dev/null vpx-benchdata/sample-30s.webm'
