# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 1
WARMUP ?= 0

TARGET_DIR := coremark

all: bench

$(TARGET_DIR):
	git clone https://github.com/zyedidia/coremark -b lfi
	cp CMakeLists.txt $(TARGET_DIR)/CMakeLists.txt

# Set CMake flags for static linking like the meson build
CMAKE_FLAGS := -DCMAKE_EXE_LINKER_FLAGS="-static-pie"

# Include common CMake build targets
include ../targets.mk

bench: coremark.csv

coremark.csv: build-native build-lfi build-lfi-stores
	hyperfine --export-csv coremark.csv --runs $(RUNS) --warmup $(WARMUP) \
		-n 'LFI' 'lfi-run -- ./build-lfi/coremark 0x0 0x0 0x66 20000 7 1 2000' \
		-n 'LFI-stores' 'lfi-run -- ./build-lfi-stores/coremark 0x0 0x0 0x66 20000 7 1 2000' \
		-n 'Native' './build-native/coremark 0x0 0x0 0x66 20000 7 1 2000'

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR)
	rm -f *.csv

.PHONY: all bench clean
