RUNS   ?= 1
WARMUP ?= 0

all: bench

dav1d:
	git clone https://github.com/zyedidia/dav1d -b lfi

dav1d-benchdata:
	wget https://github.com/zyedidia/lfi-bench/releases/download/benchdata/dav1d-benchdata.tar.gz
	tar -xf dav1d-benchdata.tar.gz
	rm -f dav1d-benchdata.tar.gz

build-lfi: dav1d
	meson setup build-lfi dav1d --cross-file ../toolchains/aarch64-lfi.txt -Ddefault_library=static
	ninja -C build-lfi

build-lfi-stores: dav1d
	meson setup build-lfi-stores dav1d --cross-file ../toolchains/aarch64-lfi-stores.txt -Ddefault_library=static
	ninja -C build-lfi-stores

build-native: dav1d
	meson setup build-native dav1d --cross-file ../toolchains/aarch64-native.txt -Ddefault_library=static
	ninja -C build-native

bench: build-native build-lfi build-lfi-stores dav1d-benchdata
	hyperfine --export-csv dav1d.csv --runs $(RUNS) --warmup $(WARMUP) \
		-n 'LFI' 'lfi-run -- build-lfi/tools/dav1d -i dav1d-benchdata/Bosphorus_3840x2160_120fps_420_8bit.ivf -o /dev/null --threads 1' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/tools/dav1d -i dav1d-benchdata/Bosphorus_3840x2160_120fps_420_8bit.ivf -o /dev/null --threads 1' \
		-n 'Native' 'build-native/tools/dav1d -i dav1d-benchdata/Bosphorus_3840x2160_120fps_420_8bit.ivf -o /dev/null --threads 1'

clean:
	rm -rf build-native build-lfi build-lfi-stores dav1d-benchdata dav1d

.PHONY: all bench clean
