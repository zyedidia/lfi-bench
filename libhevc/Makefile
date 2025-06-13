# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 3
WARMUP ?= 1

TARGET_DIR := libhevc
#each offers different rewriter fails
#CMAKE_FLAGS := -DCMAKE_BUILD_TYPE=Debug
#CMAKE_FLAGS := -DCMAKE_BUILD_TYPE=Release

all: bench

$(TARGET_DIR):
	git clone https://github.com/ittiam-systems/libhevc.git

build-lfi: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) $(CMAKE_FLAGS) -B build-lfi -DCMAKE_TOOLCHAIN_FILE=$(LFI_TOOLCHAIN) --install-prefix $(LFI_INSTALL) -DSYSTEM_PROCESSOR="aarch64" -DSYSTEM_NAME="Linux"
	cmake --build build-lfi -j $(JOBS)

build-lfi-stores: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) $(CMAKE_FLAGS) -B build-lfi-stores -DCMAKE_TOOLCHAIN_FILE=$(STORES_TOOLCHAIN) --install-prefix $(STORES_INSTALL) -DSYSTEM_PROCESSOR="aarch64" -DSYSTEM_NAME="Linux"
	cmake --build build-lfi-stores -j $(JOBS)

build-native: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) $(CMAKE_FLAGS) -B build-native -DCMAKE_TOOLCHAIN_FILE=$(NATIVE_TOOLCHAIN) --install-prefix $(NATIVE_INSTALL)
	cmake --build build-native -j $(JOBS)

install: build-lfi build-lfi-stores build-native
	cmake --install build-lfi
	cmake --install build-lfi-stores
	cmake --install build-native

hevc-benchdata:
	mkdir -p hevc-benchdata
	# Download sample raw video for encoding test (YUV 4:2:0 format)
	wget -O hevc-benchdata/sample_raw.yuv https://github.com/zyedidia/lfi-bench/releases/download/benchdata/sample_352x288_30fps.yuv || \
	dd if=/dev/urandom of=hevc-benchdata/sample_raw.yuv bs=1024 count=304 # 352*288*1.5*30frames/1024 ≈ 304KB for fallback
	# Download sample HEVC file for decoding test
	wget -O hevc-benchdata/sample_encoded.hevc https://github.com/zyedidia/lfi-bench/releases/download/benchdata/sample_352x288.hevc || \
	echo "Warning: Could not download sample HEVC file, encoding test will create one"

bench: hevcenc.csv hevcdec.csv

hevcenc.csv: build-lfi build-lfi-stores build-native hevc-benchdata
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv hevcenc.csv \
		-n 'LFI' 'lfi-run -- build-lfi/hevcenc --input hevc-benchdata/sample_raw.yuv --output /dev/null --src_width 352 --src_height 288 --num_frames_to_encode 30' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/hevcenc --input hevc-benchdata/sample_raw.yuv --output /dev/null --src_width 352 --src_height 288 --num_frames_to_encode 30' \
		-n 'Native' 'build-native/hevcenc --input hevc-benchdata/sample_raw.yuv --output /dev/null --src_width 352 --src_height 288 --num_frames_to_encode 30'

hevcdec.csv: build-lfi build-lfi-stores build-native hevc-benchdata
	# First create a sample HEVC file if we don't have one
	@if [ ! -f hevc-benchdata/sample_encoded.hevc ]; then \
		echo "Creating sample HEVC file for decoding test..."; \
		build-native/hevcenc --input hevc-benchdata/sample_raw.yuv --output hevc-benchdata/sample_encoded.hevc --src_width 352 --src_height 288 --num_frames_to_encode 30; \
	fi
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv hevcdec.csv \
		-n 'LFI' 'lfi-run -- build-lfi/hevcdec --input hevc-benchdata/sample_encoded.hevc --output /dev/null' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/hevcdec --input hevc-benchdata/sample_encoded.hevc --output /dev/null' \
		-n 'Native' 'build-native/hevcdec --input hevc-benchdata/sample_encoded.hevc --output /dev/null'

clean:
	rm -f *.csv
	rm -rf $(BUILD_DIRS) $(TARGET_DIR) hevc-benchdata

.PHONY: all bench clean install
