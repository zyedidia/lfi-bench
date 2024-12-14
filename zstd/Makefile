all: bench

zstd:
	git clone https://github.com/facebook/zstd.git

build-lfi: zstd
	meson setup build-lfi zstd/build/meson --cross-file ../toolchains/aarch64-lfi.txt -Ddefault_library=static
	ninja -C build-lfi

build-lfi-stores: zstd
	meson setup build-lfi-stores zstd/build/meson --cross-file ../toolchains/aarch64-lfi-stores.txt -Ddefault_library=static
	ninja -C build-lfi-stores

build-native: zstd
	meson setup build-native zstd/build/meson --cross-file ../toolchains/aarch64-native.txt -Ddefault_library=static
	ninja -C build-native

bigfile.txt:
	tr -dc "A-Za-z 0-9" < /dev/urandom | fold -w100|head -n 100000 > bigfile.txt

bench: bigfile.txt build-native build-lfi build-lfi-stores
	./build-native/programs/zstd -b1 bigfile.txt
	lfi-run -- ./build-lfi-stores/programs/zstd -b1 bigfile.txt
	lfi-run -- ./build-lfi/programs/zstd -b1 bigfile.txt

clean:
	rm -f bigfile.txt
	rm -rf build-lfi build-lfi-stores build-native zstd

.PHONY: all bench clean
