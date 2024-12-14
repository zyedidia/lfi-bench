RUNS   ?= 1
WARMUP ?= 0

LFI        ?= /opt/aarch64-lfi-clang
LFI_STORES ?= /opt/aarch64-lfi-stores-clang
NATIVE     ?= /opt/aarch64-native-clang

all: bench

sqlite-bench:
	git clone https://github.com/ukontainer/sqlite-bench
	cp Makefile.in sqlite-bench/Makefile

build-lfi: sqlite-bench
	mkdir -p build-lfi
	cp -r sqlite-bench build-lfi
	make -C build-lfi/sqlite-bench clean
	CC=$(LFI)/bin/clang make -C build-lfi/sqlite-bench

build-lfi-stores: sqlite-bench
	mkdir -p build-lfi-stores
	cp -r sqlite-bench build-lfi-stores
	make -C build-lfi-stores/sqlite-bench clean
	CC=$(LFI_STORES)/bin/clang make -C build-lfi-stores/sqlite-bench

build-native: sqlite-bench
	mkdir -p build-native
	cp -r sqlite-bench build-native
	make -C build-native/sqlite-bench clean
	CC=$(NATIVE)/bin/clang make -C build-native/sqlite-bench

build: build-lfi build-lfi-stores build-native

bench: build
	hyperfine --export-csv sqlite.csv --runs $(RUNS) --warmup $(WARMUP) \
		-n 'LFI' 'lfi-run -- ./build-lfi/sqlite-bench/sqlite-bench' \
		-n 'LFI-stores' 'lfi-run -- ./build-lfi-stores/sqlite-bench/sqlite-bench' \
		-n 'Native' 'lfi-run -- ./build-native/sqlite-bench/sqlite-bench'

clean:
	rm -rf sqlite-bench build-lfi build-lfi-stores build-native
	rm -f *.db *.db-journal

.PHONY: all build bench clean
