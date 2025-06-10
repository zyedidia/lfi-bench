RUNS   ?= 3
WARMUP ?= 1

LFI        ?= /opt/aarch64-lfi-clang
LFI_STORES ?= /opt/aarch64-lfi-stores-clang
NATIVE     ?= /opt/aarch64-native-clang

.NOTPARALLEL:

all: bench

libjpeg-turbo-benchmark:
	git clone https://github.com/PLSysSec/libjpeg-turbo-benchmark

build-lfi: libjpeg-turbo-benchmark
	cp Makefile.in libjpeg-turbo-benchmark/benchmark/Makefile
	cd libjpeg-turbo-benchmark/benchmark && \
		RUN=lfi-run CC=$(LFI)/bin/clang CXX=$(LFI)/bin/clang++ make test_bytes.h -B && \
		RUN=lfi-run CC=$(LFI)/bin/clang CXX=$(LFI)/bin/clang++ make ../build_release/image_change_quality
	mkdir -p build-lfi
	cp libjpeg-turbo-benchmark/build_release/image_change_quality build-lfi

build-lfi-stores: libjpeg-turbo-benchmark
	cp Makefile.in libjpeg-turbo-benchmark/benchmark/Makefile
	cd libjpeg-turbo-benchmark/benchmark && \
		RUN=lfi-run CC=$(LFI_STORES)/bin/clang CXX=$(LFI_STORES)/bin/clang++ make test_bytes.h -B && \
		RUN=lfi-run CC=$(LFI_STORES)/bin/clang CXX=$(LFI_STORES)/bin/clang++ make ../build_release/image_change_quality
	mkdir -p build-lfi-stores
	cp libjpeg-turbo-benchmark/build_release/image_change_quality build-lfi-stores

build-native: libjpeg-turbo-benchmark
	cp Makefile.in libjpeg-turbo-benchmark/benchmark/Makefile
	cd libjpeg-turbo-benchmark/benchmark && \
		CC=$(NATIVE)/bin/clang CXX=$(NATIVE)/bin/clang++ make test_bytes.h -B && \
		CC=$(NATIVE)/bin/clang CXX=$(NATIVE)/bin/clang++ make ../build_release/image_change_quality
	mkdir -p build-native
	cp libjpeg-turbo-benchmark/build_release/image_change_quality build-native

bench: libjpeg-turbo.csv

libjpeg-turbo.csv: build-native build-lfi build-lfi-stores
	hyperfine --export-csv libjpeg-turbo.csv --runs $(RUNS) --warmup $(WARMUP) \
		-n 'LFI' 'lfi-run -- ./build-lfi/image_change_quality' \
		-n 'LFI-stores' 'lfi-run -- ./build-lfi-stores/image_change_quality' \
		-n 'Native' './build-native/image_change_quality'

clean:
	rm -rf build-native build-lfi build-lfi-stores libjpeg-turbo-benchmark

.PHONY: all bench clean
