#!/bin/sh

set -x

git clone https://github.com/zyedidia/dav1d -b lfi

wget https://github.com/zyedidia/lfi-bench/releases/download/benchdata/dav1d-benchdata.tar.gz
tar -xf dav1d-benchdata.tar.gz
rm -f dav1d-benchdata.tar.gz
