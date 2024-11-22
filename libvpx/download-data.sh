#!/bin/sh

set -ex

wget https://github.com/zyedidia/lfi-bench/releases/download/benchdata/vpx-benchdata.tar.gz
tar -xf vpx-benchdata.tar.gz
rm -f vpx-benchdata.tar.gz
