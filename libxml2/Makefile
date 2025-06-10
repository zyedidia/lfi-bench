RUNS   ?= 1 
WARMUP ?= 1

JOBS := $(shell nproc)
PARENT_DIR := $(shell dirname $(shell pwd))
LFI_INSTALL := $(PARENT_DIR)/benchmark-lib/aarch64-lfi-clang/usr
STORES_INSTALL := $(PARENT_DIR)/benchmark-lib/aarch64-lfi-stores-clang/usr
NATIVE_INSTALL := $(PARENT_DIR)/benchmark-lib/aarch64-native-clang/usr
CMAKE_FLAGS := -DLIBXML2_WITH_PYTHON=OFF

TARGET_DIR:= libxml2

all: bench

$(TARGET_DIR):
	wget -O libxml2.tar.xz https://download.gnome.org/sources/libxml2/2.14/libxml2-2.14.3.tar.xz
	tar xvf libxml2.tar.xz
	mv libxml2-2.14.3 libxml2
	rm -f libxml2.tar.xz

build-lfi: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-lfi -DCMAKE_TOOLCHAIN_FILE=../../toolchains/aarch64-lfi.cmake --install-prefix $(LFI_INSTALL) $(CMAKE_FLAGS) 
	cmake --build build-lfi -j $(JOBS)

build-lfi-stores: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-lfi-stores -DCMAKE_TOOLCHAIN_FILE=../../toolchains/aarch64-lfi-stores.cmake --install-prefix $(STORES_INSTALL) $(CMAKE_FLAGS)
	cmake --build build-lfi-stores -j $(JOBS)

build-native: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-native -DCMAKE_TOOLCHAIN_FILE=../../toolchains/aarch64-native.cmake --install-prefix $(NATIVE_INSTALL) $(CMAKE_FLAGS)
	cmake --build build-native -j $(JOBS)

install: build-lfi build-lfi-stores build-native
	cmake --install build-lfi
	cmake --install build-lfi-stores
	cmake --install build-native

dbpl.xml:
	wget https://aiweb.cs.washington.edu/research/projects/xmltk/xmldata/data/dblp/dblp.xml.gz
	gzip -d dblp.xml.gz

bench: libxml2.csv

libxml2.csv: build-native build-lfi build-lfi-stores dblp.xml
	hyperfine --runs $(RUNS) --export-csv libxml2.csv \
		-n 'LFI' 'lfi-run -- build-lfi/xmllint --noout dblp.xml' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/xmllint --noout dblp.xml' \
		-n 'Native' 'build-native/xmllint --noout dblp.xml'

clean:
	rm -rf $(TARGET_DIR) build-native build-lfi build-lfi-stores dblp.xml

.PHONY: all bench clean
