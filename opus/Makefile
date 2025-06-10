RUNS   ?= 5
WARMUP ?= 2

all: bench

opus:
	wget https://github.com/xiph/opus/releases/download/v1.5.2/opus-1.5.2.tar.gz
	tar -xf opus-1.5.2.tar.gz
	rm -f opus-1.5.2.tar.gz
	mv opus-1.5.2 opus

opus-benchdata:
	wget https://github.com/zyedidia/lfi-bench/releases/download/benchdata/opus-benchdata.tar.gz
	tar -xf opus-benchdata.tar.gz
	rm -f opus-benchdata.tar.gz

build-lfi: opus
	LDFLAGS="-static-pie" meson setup build-lfi opus --cross-file ../toolchains/aarch64-lfi.txt -Ddefault_library=static
	ninja -C build-lfi

build-lfi-stores: opus
	LDFLAGS="-static-pie" meson setup build-lfi-stores opus --cross-file ../toolchains/aarch64-lfi-stores.txt -Ddefault_library=static
	ninja -C build-lfi-stores

build-native: opus
	LDFLAGS="-static-pie" meson setup build-native opus --cross-file ../toolchains/aarch64-native.txt -Ddefault_library=static
	ninja -C build-native

bench: opus-encode.csv opus-decode.csv

opus-encode.csv: opus-benchdata build-native build-lfi build-lfi-stores
	hyperfine --export-csv opus-encode.csv --runs $(RUNS) --warmup $(WARMUP) \
		-n 'LFI' 'lfi-run -- ./build-lfi/src/opus_demo -e voip 48000 2 96000 opus-benchdata/music_orig.wav /dev/null' \
		-n 'LFI-stores' 'lfi-run -- ./build-lfi-stores/src/opus_demo -e voip 48000 2 96000 opus-benchdata/music_orig.wav /dev/null' \
		-n 'Native' './build-native/src/opus_demo -e voip 48000 2 96000 opus-benchdata/music_orig.wav /dev/null'

opus-decode.csv: opus-benchdata build-native build-lfi build-lfi-stores
	hyperfine --export-csv opus-decode.csv --runs $(RUNS) --warmup $(WARMUP) \
		-n 'LFI' 'lfi-run -- ./build-lfi/src/opus_demo -d 48000 2 opus-benchdata/music_orig.opus /dev/null' \
		-n 'LFI-stores' 'lfi-run -- ./build-lfi-stores/src/opus_demo -d 48000 2 opus-benchdata/music_orig.opus /dev/null' \
		-n 'Native' './build-native/src/opus_demo -d 48000 2 opus-benchdata/music_orig.opus /dev/null'

clean:
	rm -rf opus opus-benchdata build-lfi build-lfi-stores build-native

.PHONY: all bench clean
