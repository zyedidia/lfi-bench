# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 3
WARMUP ?= 1

CMAKE_FLAGS := -DLIBXML2_WITH_PYTHON=OFF -DCMAKE_BUILD_TYPE=Release
TARGET_DIR := libxml2

all: bench

$(TARGET_DIR):
	wget -O libxml2.tar.xz https://download.gnome.org/sources/libxml2/2.14/libxml2-2.14.3.tar.xz
	tar xvf libxml2.tar.xz
	mv libxml2-2.14.3 libxml2
	wget https://aiweb.cs.washington.edu/research/projects/xmltk/xmldata/data/SwissProt/SwissProt.xml
	rm -f libxml2.tar.xz

# Include common CMake build targets
include ../targets.mk

build-benchmarks: build-lfi build-lfi-stores build-native
	cmake -S benchmark -B build-lfi-bench -DCMAKE_TOOLCHAIN_FILE=$(LFI_TOOLCHAIN) -DLIBXML2_DIR=../build-lfi
	cmake -S benchmark -B build-lfi-stores-bench -DCMAKE_TOOLCHAIN_FILE=$(STORES_TOOLCHAIN) -DLIBXML2_DIR=../build-lfi-stores  
	cmake -S benchmark -B build-native-bench -DCMAKE_TOOLCHAIN_FILE=$(NATIVE_TOOLCHAIN) -DLIBXML2_DIR=../build-native
	cmake --build build-lfi-bench --verbose
	cmake --build build-lfi-stores-bench --verbose
	cmake --build build-native-bench --verbose
	touch $@

bench: libxml2.csv

libxml2.csv: build-benchmarks 
	../hyperfine.py --name libxml2 --cmd "{BUILD_DIR}-bench/xml-parse SwissProt.xml" --targets "$(HYPERFINE_TARGETS)" --run-command-flags="-p" --runs $(RUNS) --warmup $(WARMUP)

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR) SwissProt.xml
	rm -rf build-lfi-bench build-lfi-stores-bench build-native-bench
	rm -f *.csv build-benchmarks

.PHONY: all bench clean
