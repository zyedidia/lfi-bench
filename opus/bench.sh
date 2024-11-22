#!/bin/sh

RUNS=${1:-5}
WARMUP=${2:-2}

echo "ENCODE BENCHMARK"

hyperfine --runs $RUNS --warmup $WARMUP \
    'lfi-run -- ./build-lfi/src/opus_demo -e voip 48000 2 96000 opus-benchdata/music_orig.wav /dev/null' \
    'lfi-run -- ./build-lfi-stores/src/opus_demo -e voip 48000 2 96000 opus-benchdata/music_orig.wav /dev/null' \
    './build-native/src/opus_demo -e voip 48000 2 96000 opus-benchdata/music_orig.wav /dev/null'

RUNS=${3:-10}
WARMUP=${4:-2}

echo "DECODE BENCHMARK"

hyperfine --runs $RUNS --warmup $WARMUP \
    'lfi-run -- ./build-lfi/src/opus_demo -d 48000 2 opus-benchdata/music_orig.opus /dev/null' \
    'lfi-run -- ./build-lfi-stores/src/opus_demo -d 48000 2 opus-benchdata/music_orig.opus /dev/null' \
    './build-native/src/opus_demo -d 48000 2 opus-benchdata/music_orig.opus /dev/null'
