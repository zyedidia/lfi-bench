#!/bin/sh

set -ex

RUNS=${1:-5}
WARMUP=${2:-2}

hyperfine --runs $RUNS --warmup $WARMUP \
    'lfi-run -- ./build-lfi/vpxdec --threads=1 -o /dev/null vpx-benchdata/elephants-dream.webm' \
    'lfi-run -- ./build-lfi-stores/vpxdec --threads=1 -o /dev/null vpx-benchdata/elephants-dream.webm' \
    './build-native/vpxdec --threads=1 -o /dev/null vpx-benchdata/elephants-dream.webm'
