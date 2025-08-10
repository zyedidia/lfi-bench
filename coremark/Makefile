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

CMAKE_FLAGS := -DCMAKE_EXE_LINKER_FLAGS="-static-pie"

# Include common CMake build targets
include ../targets.mk

bench: coremark.csv

# CPU benchmark
coremark.csv: build-native build-lfi build-lfi-stores
	../hyperfine.py --name coremark --cmd "./{BUILD_DIR}/coremark 0x0 0x0 0x66 20000 7 1 2000" --targets "$(HYPERFINE_TARGETS)" --runs $(RUNS) --warmup $(WARMUP)

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR)
	rm -f *.csv

.PHONY: all bench clean
