WARMUP ?= 5

all: bench

zlib:
	git clone https://github.com/madler/zlib.git

build-lfi: zlib
	cp ./meson.build zlib
	cp ./benchmark/*.c zlib
	meson setup build-lfi zlib --cross-file ../toolchains/aarch64-lfi.txt -Ddefault_library=static
	ninja -C build-lfi

build-lfi-stores: zlib
	cp ./meson.build zlib
	cp ./benchmark/*.c zlib
	meson setup build-lfi-stores zlib --cross-file ../toolchains/aarch64-lfi-stores.txt -Ddefault_library=static
	ninja -C build-lfi-stores

build-native: zlib
	cp ./meson.build zlib
	cp ./benchmark/*.c zlib
	meson setup build-native zlib --cross-file ../toolchains/aarch64-native.txt -Ddefault_library=static
	ninja -C build-native

bigfile.txt:
	tr -dc "A-Za-z 0-9" < /dev/urandom | fold -w100|head -n 100000 > bigfile.txt

bench: build-lfi build-lfi-stores build-native bigfile.txt
	hyperfine --warmup $(WARMUP) --export-csv zlib_compress.csv \
		-n 'LFI' 'lfi-run -- build-lfi/compress_file' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/compress_file' \
		-n 'Native' 'build-native/compress_file'
	hyperfine --warmup $(WARMUP) --export-csv zlib_decompress.csv \
		-n 'LFI' 'lfi-run -- build-lfi/decompress_file' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/decompress_file' \
		-n 'Native' 'build-native/decompress_file'

clean:
	rm -f *.csv
	rm -f bigfile.txt bigfile.txt.gz bigfile_decompressed.txt
	rm -rf build-lfi build-lfi-stores build-native zlib

.PHONY: bench clean all
