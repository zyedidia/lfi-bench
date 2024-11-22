#!/bin/sh

RUNS=${1:-1}
WARMUP=${2:-0}

hyperfine --runs $RUNS --warmup $WARMUP \
    'lfi-run -- ./build-lfi/coremark 0x0 0x0 0x66 800000 7 1 2000' \
    'lfi-run -- ./build-lfi-stores/coremark 0x0 0x0 0x66 800000 7 1 2000' \
    './build-native/coremark 0x0 0x0 0x66 800000 7 1 2000'
