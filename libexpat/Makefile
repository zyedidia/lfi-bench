# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 3
WARMUP ?= 1

TARGET_DIR := expat

all: bench

$(TARGET_DIR):
	git clone https://github.com/libexpat/libexpat
	ln -s libexpat/expat expat

# Include common CMake build targets
include ../targets.mk

bench: expat.csv

expat.csv: build-native build-lfi build-lfi-stores
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv expat.csv \
		-n 'LFI' 'lfi-run -- build-lfi/tests/runtests' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/tests/runtests' \
		-n 'Native' 'build-native/tests/runtests'

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR) libexpat
		rm -f *.csv

.PHONY: all bench clean
