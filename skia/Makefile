# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 1
WARMUP ?= 0

TARGET_DIR := skia
SKIA_FLAGS=skia_enable_tools=false skia_enable_skottie=false skia_enable_svg=false skia_enable_fontmgr_fontconfig=false skia_enable_fontmgr_android=false skia_use_fontconfig=false skia_use_freetype=false skia_enable_fontmgr_empty=true skia_enable_gpu=false skia_enable_pdf=false skia_use_harfbuzz=false skia_use_icu=false skia_enable_pdf=false skia_enable_svg=false is_official_build=true skia_use_system_zlib=true skia_use_system_libpng=true

all: bench

$(TARGET_DIR):
	git clone --depth=1 https://github.com/google/skia.git $(TARGET_DIR)
	cd $(TARGET_DIR) && python3 tools/git-sync-deps

build-lfi: $(TARGET_DIR)
	cd $(TARGET_DIR) && \
		PKG_CONFIG_PATH="$(LFI_INSTALL)/lib/pkgconfig:$(LFI_INSTALL)/lib64/pkgconfig" \
		bin/gn gen ../build-lfi --args='target_cpu="arm64" cc="/opt/aarch64-lfi-clang/bin/clang" cxx="/opt/aarch64-lfi-clang/bin/clang++" ar="/opt/aarch64-lfi-clang/bin/llvm-ar" extra_cflags=["-I$(LFI_INSTALL)/include"] extra_ldflags=["-L$(LFI_INSTALL)/lib","-L$(LFI_INSTALL)/lib64","-static-pie"] $(SKIA_FLAGS)' && \
		cd ../build-lfi && ninja

build-lfi-stores: $(TARGET_DIR)
	cd $(TARGET_DIR) && \
		PKG_CONFIG_PATH="$(STORES_INSTALL)/lib/pkgconfig:$(STORES_INSTALL)/lib64/pkgconfig" \
		bin/gn gen ../build-lfi-stores --args='target_cpu="arm64" cc="/opt/aarch64-lfi-stores-clang/bin/clang" cxx="/opt/aarch64-lfi-stores-clang/bin/clang++" ar="/opt/aarch64-lfi-stores-clang/bin/llvm-ar" extra_cflags=["-I$(STORES_INSTALL)/include"] extra_ldflags=["-L$(STORES_INSTALL)/lib","-L$(STORES_INSTALL)/lib64","-static-pie"] $(SKIA_FLAGS)' && \
		cd ../build-lfi-stores && ninja

build-native: $(TARGET_DIR)
	cd $(TARGET_DIR) && \
		PKG_CONFIG_PATH="$(NATIVE_INSTALL)/lib/pkgconfig:$(NATIVE_INSTALL)/lib64/pkgconfig" \
		bin/gn gen ../build-native --args='target_cpu="arm64" cc="/opt/aarch64-native-clang/bin/clang" cxx="/opt/aarch64-native-clang/bin/clang++" ar="/opt/aarch64-native-clang/bin/llvm-ar" extra_cflags=["-I$(NATIVE_INSTALL)/include"] extra_ldflags=["-L$(NATIVE_INSTALL)/lib","-L$(NATIVE_INSTALL)/lib64","-static-pie"] $(SKIA_FLAGS)' && \
		cd ../build-native && ninja

# Build benchmark executables
build-lfi/decode-benchmark: build-lfi decode-benchmark.cpp
	/opt/aarch64-lfi-clang/bin/clang++ -std=c++17 -O2 -static-pie \
		-I$(TARGET_DIR) -I$(LFI_INSTALL)/include \
		-L$(LFI_INSTALL)/lib -L$(LFI_INSTALL)/lib64 -Lbuild-lfi \
		decode-benchmark.cpp -lskia -ljpeg -lwebpdemux -lwebp -lpng -lz -lpthread -ldl -lm \
		-o build-lfi/decode-benchmark

build-lfi-stores/decode-benchmark: build-lfi-stores decode-benchmark.cpp
	/opt/aarch64-lfi-stores-clang/bin/clang++ -std=c++17 -O2 -static-pie \
		-I$(TARGET_DIR) -I$(STORES_INSTALL)/include \
		-L$(STORES_INSTALL)/lib -L$(STORES_INSTALL)/lib64 -Lbuild-lfi-stores \
		decode-benchmark.cpp -lskia -ljpeg -lwebpdemux -lwebp -lpng -lz -lpthread -ldl -lm \
		-o build-lfi-stores/decode-benchmark

build-native/decode-benchmark: build-native decode-benchmark.cpp
	/opt/aarch64-native-clang/bin/clang++ -std=c++17 -O2 -static-pie \
		-I$(TARGET_DIR) -I$(NATIVE_INSTALL)/include \
		-L$(NATIVE_INSTALL)/lib -L$(NATIVE_INSTALL)/lib64 -Lbuild-native \
		decode-benchmark.cpp -lskia -ljpeg -lwebpdemux -lwebp -lpng -lz -lpthread -ldl -lm \
		-o build-native/decode-benchmark

bench: skia-decode-jpg-png.csv

# Image decode benchmark
skia-decode-jpg-png.csv: build-native/decode-benchmark build-lfi/decode-benchmark build-lfi-stores/decode-benchmark
	../hyperfine.py --name skia-decode-jpg-png --cmd "./{BUILD_DIR}/decode-benchmark 10" --targets "$(HYPERFINE_TARGETS)" --run-command-flags="-p" --runs $(RUNS) --warmup $(WARMUP) --setup="cat image.* > /dev/null"

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR)
	rm -f *.csv

.PHONY: all bench clean 
