# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 3
WARMUP ?= 0

TARGET_DIR := libavc

all: bench

$(TARGET_DIR):
	git clone https://github.com/libpag/libavc.git

build-lfi: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-lfi -DCMAKE_TOOLCHAIN_FILE=$(LFI_TOOLCHAIN) -DCMAKE_INSTALL_PREFIX=$(LFI_INSTALL) -DCMAKE_BUILD_TYPE=Release
	cmake --build build-lfi -j $(JOBS)

build-lfi-stores: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-lfi-stores -DCMAKE_TOOLCHAIN_FILE=$(STORES_TOOLCHAIN) -DCMAKE_INSTALL_PREFIX=$(STORES_INSTALL) -DCMAKE_BUILD_TYPE=Release
	cmake --build build-lfi-stores -j $(JOBS)

build-native: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-native -DCMAKE_TOOLCHAIN_FILE=$(NATIVE_TOOLCHAIN) -DCMAKE_INSTALL_PREFIX=$(NATIVE_INSTALL) -DCMAKE_BUILD_TYPE=Release
	cmake --build build-native -j $(JOBS)

install: build-lfi build-lfi-stores build-native
	cmake --install build-lfi
	cmake --install build-lfi-stores
	cmake --install build-native

test.mp4:
	ffmpeg -f lavfi -i testsrc=duration=2:size=640x480:rate=30 -pix_fmt yuv420p -c:v libx264 -profile:v baseline -preset ultrafast test.mp4

# Convert MP4 to raw H.264 bitstream for libavc decoder
test.h264: test.mp4
	# Extract H.264 bitstream from MP4 container for direct decoder testing
	ffmpeg -i test.mp4 -c:v copy -bsf:v h264_mp4toannexb -f h264 test.h264

bench: libavc-decode.csv

# Create decoder config file
test.cfg: test.h264
	@echo "--input test.h264" > test.cfg
	@echo "--save_output 0" >> test.cfg
	@echo "--num_frames -1" >> test.cfg
	@echo "--output /dev/null" >> test.cfg
	@echo "--chroma_format YUV_420P" >> test.cfg
	@echo "--share_display_buf 0" >> test.cfg
	@echo "--num_cores 1" >> test.cfg
	@echo "--loopback 0" >> test.cfg
	@echo "--display 0" >> test.cfg
	@echo "--fps 30" >> test.cfg
	@echo "--arch ARM_NONEON" >> test.cfg
	@echo "--soc GENERIC" >> test.cfg

libavc-decode.csv: build-lfi build-lfi-stores build-native test.h264 test.cfg
	# pull test file into buffer cache
	cat test.h264 > /dev/null
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv libavc-decode.csv \
		-n 'LFI' 'lfi-run -- build-lfi/avcdec test.cfg' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/avcdec test.cfg' \
		-n 'Native' 'build-native/avcdec test.cfg'

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR) test.h264 test_download.mp4 test.cfg
	rm -f *.csv

.PHONY: all bench clean install
