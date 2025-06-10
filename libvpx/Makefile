RUNS   ?= 3
WARMUP ?= 1

LFI        ?= /opt/aarch64-lfi-clang
LFI_STORES ?= /opt/aarch64-lfi-stores-clang
NATIVE     ?= /opt/aarch64-native-clang

all: bench

libvpx:
	git clone https://github.com/webmproject/libvpx

build-lfi: libvpx
	mkdir -p build-lfi
	cd build-lfi && LDFLAGS="-static-pie" CROSS=aarch64-lfi-linux-musl- AR=$(LFI)/bin/llvm-ar CC=$(LFI)/bin/clang CXX=$(LFI)/bin/clang++ ../libvpx/configure
	make -C build-lfi -j8

build-lfi-stores: libvpx
	mkdir -p build-lfi-stores
	cd build-lfi-stores && LDFLAGS="-static-pie" CROSS=aarch64-lfi-linux-musl- AR=$(LFI_STORES)/bin/llvm-ar CC=$(LFI_STORES)/bin/clang CXX=$(LFI_STORES)/bin/clang++ ../libvpx/configure
	make -C build-lfi-stores -j8

build-native: libvpx
	mkdir -p build-native
	cd build-native && LDFLAGS="-static-pie" CROSS=aarch64-unknown-linux-musl- AR=$(NATIVE)/bin/llvm-ar CC=$(NATIVE)/bin/clang CXX=$(NATIVE)/bin/clang++ ../libvpx/configure
	make -C build-native -j8

vpx-benchdata:
	wget https://github.com/zyedidia/lfi-bench/releases/download/benchdata/vpx-benchdata.tar.gz
	tar -xf vpx-benchdata.tar.gz
	rm -f vpx-benchdata.tar.gz

bench: libvpx.csv

libvpx.csv: vpx-benchdata build-native build-lfi build-lfi-stores
	hyperfine --export-csv libvpx.csv --runs $(RUNS) --warmup $(WARMUP) \
		-n 'LFI' 'lfi-run -- ./build-lfi/vpxdec --threads=1 -o /dev/null vpx-benchdata/sample-30s.webm' \
		-n 'LFI-stores' 'lfi-run -- ./build-lfi-stores/vpxdec --threads=1 -o /dev/null vpx-benchdata/sample-30s.webm' \
		-n 'Native' 'lfi-run -- ./build-native/vpxdec --threads=1 -o /dev/null vpx-benchdata/sample-30s.webm'

clean:
	rm -rf vpx-benchdata build-native build-lfi build-lfi-stores libvpx

.PHONY: all bench clean
