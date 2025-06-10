RUNS   ?= 1
WARMUP ?= 0

all: bench

coremark:
	git clone https://github.com/zyedidia/coremark -b lfi

build-lfi: coremark
	LDFLAGS="-static-pie" meson setup build-lfi coremark --cross-file ../toolchains/aarch64-lfi.txt -Ddefault_library=static
	ninja -C build-lfi

build-lfi-stores: coremark
	LDFLAGS="-static-pie" meson setup build-lfi-stores coremark --cross-file ../toolchains/aarch64-lfi-stores.txt -Ddefault_library=static
	ninja -C build-lfi-stores

build-native: coremark
	LDFLAGS="-static-pie" meson setup build-native coremark --cross-file ../toolchains/aarch64-native.txt -Ddefault_library=static
	ninja -C build-native

bench: coremark.csv

coremark.csv: build-native build-lfi build-lfi-stores
	hyperfine --export-csv coremark.csv --runs $(RUNS) --warmup $(WARMUP) \
		-n 'LFI' 'lfi-run -- ./build-lfi/coremark 0x0 0x0 0x66 80000 7 1 2000' \
		-n 'LFI-stores' 'lfi-run -- ./build-lfi-stores/coremark 0x0 0x0 0x66 80000 7 1 2000' \
		-n 'Native' './build-native/coremark 0x0 0x0 0x66 80000 7 1 2000'

clean:
	rm -rf build-native build-lfi build-lfi-stores coremark

.PHONY: all bench clean
