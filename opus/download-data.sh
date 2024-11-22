#!/bin/sh

set -ex

wget https://github.com/zyedidia/lfi-bench/releases/download/benchdata/opus-benchdata.tar.gz
tar -xf opus-benchdata.tar.gz
rm -f opus-benchdata.tar.gz
