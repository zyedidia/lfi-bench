#!/bin/sh

wget https://github.com/xiph/opus/releases/download/v1.5.2/opus-1.5.2.tar.gz
tar -xf opus-1.5.2.tar.gz
rm -f opus-1.5.2.tar.gz
mv opus-1.5.2 opus
