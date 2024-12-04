#!/bin/sh

set -ex

RUNS=${1:-3}
WARMUP=${2:-1}

hyperfine --runs $RUNS --warmup $WARMUP \
    'lfi-run -- ./build-lfi/image_change_quality' \
    'lfi-run -- ./build-lfi-stores/image_change_quality' \
    './build-native/image_change_quality'
