# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 10
WARMUP ?= 1

TARGET_DIR := libtiff

#libtiff's cmake setup sucks, if you build shared libs it still looks for dynamic dependencies so you have to name libz.a etc. explicitly
CMAKE_FLAGS := -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXE_LINKER_FLAGS="-static-pie" -DCMAKE_FIND_LIBRARY_SUFFIXES=".a" -DZLIB_LIBRARY="$(LFI_INSTALL)/lib/libz.a" -DJPEG_LIBRARY="$(LFI_INSTALL)/lib/libjpeg.a" -Dwebp=OFF

all: bench

$(TARGET_DIR):
	git clone https://gitlab.com/libtiff/libtiff.git

# Override install prefix format and add PREFIX_PATH for libtiff dependencies
CMAKE_INSTALL_PREFIX_LFI = --install-prefix $(LFI_INSTALL) -DCMAKE_PREFIX_PATH=$(LFI_INSTALL)
CMAKE_INSTALL_PREFIX_STORES = --install-prefix $(STORES_INSTALL) -DCMAKE_PREFIX_PATH=$(STORES_INSTALL)
CMAKE_INSTALL_PREFIX_NATIVE = --install-prefix $(NATIVE_INSTALL) -DCMAKE_PREFIX_PATH=$(NATIVE_INSTALL)

# Include common CMake build targets
include ../targets.mk

# Generate test TIFF images
test_uncompressed.tiff:
	# Create a large synthetic image with patterns (more realistic than random data)
	convert -size 4096x4096 gradient:black-white test_base.tiff
	convert test_base.tiff -blur 0x2 -noise 3 test_uncompressed.tiff
	rm test_base.tiff

# Create compressed test files for decoding benchmarks
test_lzw.tiff: test_uncompressed.tiff build-native
	build-native/tools/tiffcp -c lzw test_uncompressed.tiff test_lzw.tiff

test_zip.tiff: test_uncompressed.tiff build-native
	build-native/tools/tiffcp -c zip test_uncompressed.tiff test_zip.tiff

test_packbits.tiff: test_uncompressed.tiff build-native
	build-native/tools/tiffcp -c packbits test_uncompressed.tiff test_packbits.tiff

# Encoding benchmarks - measure compression speed
bench-encode: libtiff-encode-lzw.csv libtiff-encode-packbits.csv

libtiff-encode-lzw.csv: build-native build-lfi build-lfi-stores test_uncompressed.tiff
	mkdir -p ./temp
	cat test_uncompressed.tiff > /dev/null # pull into buffer cache
	@echo "=== LZW Compression Benchmark ==="
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv libtiff-encode-lzw.csv \
		-n 'LFI' 'lfi-run -p -- build-lfi/tools/tiffcp -c lzw test_uncompressed.tiff ./temp/test_lfi_lzw.tiff' \
		-n 'LFI-stores' 'lfi-run -p -- build-lfi-stores/tools/tiffcp -c lzw test_uncompressed.tiff ./temp/test_lfi_stores_lzw.tiff' \
		-n 'Native' 'build-native/tools/tiffcp -c lzw test_uncompressed.tiff ./temp/test_native_lzw.tiff'

libtiff-encode-zip.csv: build-native build-lfi build-lfi-stores test_uncompressed.tiff
	mkdir -p ./temp
	cat test_uncompressed.tiff > /dev/null # pull into buffer cache
	@echo "=== ZIP/Deflate Compression Benchmark ==="
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv libtiff-encode-zip.csv \
		-n 'LFI' 'lfi-run -p -- build-lfi/tools/tiffcp -c zip test_uncompressed.tiff ./temp/test_lfi_zip.tiff' \
		-n 'LFI-stores' 'lfi-run -p -- build-lfi-stores/tools/tiffcp -c zip test_uncompressed.tiff ./temp/test_lfi_stores_zip.tiff' \
		-n 'Native' 'build-native/tools/tiffcp -c zip test_uncompressed.tiff ./temp/test_native_zip.tiff'

libtiff-encode-packbits.csv: build-native build-lfi build-lfi-stores test_uncompressed.tiff
	mkdir -p ./temp
	cat test_uncompressed.tiff > /dev/null # pull into buffer cache
	@echo "=== PackBits Compression Benchmark ==="
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv libtiff-encode-packbits.csv \
		-n 'LFI' 'lfi-run -p -- build-lfi/tools/tiffcp -c packbits test_uncompressed.tiff ./temp/test_lfi_packbits.tiff' \
		-n 'LFI-stores' 'lfi-run -p -- build-lfi-stores/tools/tiffcp -c packbits test_uncompressed.tiff ./temp/test_lfi_stores_packbits.tiff' \
		-n 'Native' 'build-native/tools/tiffcp -c packbits test_uncompressed.tiff ./temp/test_native_packbits.tiff'

# Decoding benchmarks - measure decompression speed
bench-decode: libtiff-decode-lzw.csv libtiff-decode-packbits.csv

libtiff-decode-lzw.csv: build-native build-lfi build-lfi-stores test_lzw.tiff
	mkdir -p ./temp
	cat test_lzw.tiff > /dev/null # pull into buffer cache
	@echo "=== LZW Decompression Benchmark ==="
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv libtiff-decode-lzw.csv \
		-n 'LFI' 'lfi-run -p -- build-lfi/tools/tiffcp test_lzw.tiff ./temp/test_lfi_decoded_lzw.tiff' \
		-n 'LFI-stores' 'lfi-run -p -- build-lfi-stores/tools/tiffcp test_lzw.tiff ./temp/test_lfi_stores_decoded_lzw.tiff' \
		-n 'Native' 'build-native/tools/tiffcp test_lzw.tiff ./temp/test_native_decoded_lzw.tiff'

libtiff-decode-zip.csv: build-native build-lfi build-lfi-stores test_zip.tiff
	mkdir -p ./temp
	cat test_zip.tiff > /dev/null # pull into buffer cache
	@echo "=== ZIP/Deflate Decompression Benchmark ==="
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv libtiff-decode-zip.csv \
		-n 'LFI' 'lfi-run -p -- build-lfi/tools/tiffcp test_zip.tiff ./temp/test_lfi_decoded_zip.tiff' \
		-n 'LFI-stores' 'lfi-run -p -- build-lfi-stores/tools/tiffcp test_zip.tiff ./temp/test_lfi_stores_decoded_zip.tiff' \
		-n 'Native' 'build-native/tools/tiffcp test_zip.tiff ./temp/test_native_decoded_zip.tiff'

libtiff-decode-packbits.csv: build-native build-lfi build-lfi-stores test_packbits.tiff
	mkdir -p ./temp
	cat test_packbits.tiff > /dev/null # pull into buffer cache
	@echo "=== PackBits Decompression Benchmark ==="
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv libtiff-decode-packbits.csv \
		-n 'LFI' 'lfi-run -p -- build-lfi/tools/tiffcp test_packbits.tiff ./temp/test_lfi_decoded_packbits.tiff' \
		-n 'LFI-stores' 'lfi-run -p -- build-lfi-stores/tools/tiffcp test_packbits.tiff ./temp/test_lfi_stores_decoded_packbits.tiff' \
		-n 'Native' 'build-native/tools/tiffcp test_packbits.tiff ./temp/test_native_decoded_packbits.tiff'

# Run both encoding and decoding benchmarks
bench: bench-encode bench-decode

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR) 
	rm -f test_uncompressed.tiff test_lzw.tiff test_zip.tiff test_packbits.tiff test_base.tiff
	rm -f libtiff-*.csv
	rm -rf temp

.PHONY: all bench clean install
