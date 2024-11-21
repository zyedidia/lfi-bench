#!/bin/sh
#
# Usage: bench.sh RUNS? WARMUP_RUNS?
# WARMUP_RUNS default: 0
# RUNS default: 1

RUNS=${1:-1}
WARMUP=${2:-0}

hyperfine --runs $RUNS --warmup $WARMUP \
    'lfi-run -- build-lfi/tools/dav1d -i dav1d-benchdata/Bosphorus_3840x2160_120fps_420_8bit.ivf -o /dev/null --threads 1' \
    'lfi-run -- build-lfi-stores/tools/dav1d -i dav1d-benchdata/Bosphorus_3840x2160_120fps_420_8bit.ivf -o /dev/null --threads 1' \
    'build-native/tools/dav1d -i dav1d-benchdata/Bosphorus_3840x2160_120fps_420_8bit.ivf -o /dev/null --threads 1'
