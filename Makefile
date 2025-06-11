MACHINE ?= current

# Default target
all:
	@echo "LFI Benchmark Suite"
	@echo ""
	@echo "Available targets:"
	@echo "  build       - Build all benchmarks for all configurations (LFI, LFI-stores, Native)"
	@echo "  bench       - Run all benchmarks and generate CSV files with results"
	@echo "  consolidate - Consolidate CSV results into summary files"
	@echo "  plot        - Generate plot of results from summary"
	@echo "  clean       - Clean all build artifacts and results"
	@echo "  reset       - Remove CSV files from all benchmark directories"
	@echo ""
	@echo "Common Usage: make build; make bench; make consolidate; make plot"
	@echo ""
	@echo ""
	@echo "Individual build targets:"
	@echo "  build-libs       - Build all dependency libraries"
	@echo "  build-benchmarks - Build all benchmark applications"
	@echo ""
	@echo "Benchmarks: $(BENCH)"

# Dependency-ordered library groups
LIBS_LEVEL_0 = zlib giflib libexpat libxml2
LIBS_LEVEL_1 = libpng
LIBS_LEVEL_2 = libtiff libwebp

# Standalone benchmarks without internal library dependencies
BENCHMARKS = coremark dav1d libjpeg-turbo libvpx opus zstd

# All libraries and benchmarks for CSV processing
BENCH = $(BENCHMARKS) $(LIBS_LEVEL_0) $(LIBS_LEVEL_1) $(LIBS_LEVEL_2)

CSV = $(patsubst %,%/*.csv,$(BENCH))

# Install targets for dependency levels
install-libs-level-0:
	for lib in $(LIBS_LEVEL_0) ; do \
		if [ -d $$lib ] && [ -f $$lib/Makefile ]; then \
			$(MAKE) -C $$lib install || echo "Warning: $$lib install failed"; \
		fi; \
	done

install-libs-level-1: install-libs-level-0
	for lib in $(LIBS_LEVEL_1) ; do \
		if [ -d $$lib ] && [ -f $$lib/Makefile ]; then \
			$(MAKE) -C $$lib install || echo "Warning: $$lib install failed"; \
		fi; \
	done

install-libs-level-2: install-libs-level-1
	for lib in $(LIBS_LEVEL_2) ; do \
		if [ -d $$lib ] && [ -f $$lib/Makefile ]; then \
			$(MAKE) -C $$lib install || echo "Warning: $$lib install failed"; \
		fi; \
	done

build: build-libs build-benchmarks

build-libs: build-libs-level-0 build-libs-level-1 build-libs-level-2

build-libs-level-0:
	for lib in $(LIBS_LEVEL_0) ; do \
		if [ -d $$lib ] && [ -f $$lib/Makefile ]; then \
			$(MAKE) -C $$lib build-lfi build-lfi-stores build-native ; \
		fi; \
	done
	$(MAKE) install-libs-level-0

build-libs-level-1: build-libs-level-0
	for lib in $(LIBS_LEVEL_1) ; do \
		if [ -d $$lib ] && [ -f $$lib/Makefile ]; then \
			$(MAKE) -C $$lib build-lfi build-lfi-stores build-native ; \
		fi; \
	done
	$(MAKE) install-libs-level-1

build-libs-level-2: build-libs-level-1
	for lib in $(LIBS_LEVEL_2) ; do \
		if [ -d $$lib ] && [ -f $$lib/Makefile ]; then \
			$(MAKE) -C $$lib build-lfi build-lfi-stores build-native ; \
		fi; \
	done
	$(MAKE) install-libs-level-2

build-benchmarks: build-libs
	for bench in $(BENCHMARKS) ; do \
		if [ -d $$bench ] && [ -f $$bench/Makefile ]; then \
			$(MAKE) -C $$bench build-lfi build-lfi-stores build-native ; \
		fi; \
	done

bench:
	for bench in $(BENCH) ; do \
		if [ -d $$bench ] && [ -f $$bench/Makefile ]; then \
			$(MAKE) -C $$bench bench ; \
		fi; \
	done

# Pattern rule to build CSV files by calling the appropriate subdirectory
%/*.csv:
	$(MAKE) -C $(dir $@) $(notdir $@)

clean:
	for bench in $(BENCH) ; do \
		$(MAKE) -C $$bench clean ; \
	done

reset:
	for bench in $(BENCH) ; do \
		if [ -d $$bench ]; then \
			rm -f $$bench/*.csv ; \
		fi; \
	done

consolidate:
	mkdir -p results/$(MACHINE)
	go run results/consolidate.go -config LFI $(CSV) > results/$(MACHINE)/lfi.csv
	go run results/consolidate.go -raw -config LFI $(CSV) > results/$(MACHINE)/lfi-raw.csv
	go run results/consolidate.go -config LFI-stores $(CSV) > results/$(MACHINE)/lfi-stores.csv
	go run results/consolidate.go -raw -config LFI-stores $(CSV) > results/$(MACHINE)/lfi-stores-raw.csv
	go run results/consolidate.go -raw -config Native $(CSV) > results/$(MACHINE)/native-raw.csv

plot:
	cd results/$(MACHINE) && gnuplot plot.gp

# Dependency checking functionality
check-deps:
	@echo "Checking library dependencies..."
	@for lib in $(LIBS_LEVEL_0) ; do \
		if [ -d "benchmark-lib/aarch64-native-clang/usr/lib" ] || [ -d "benchmark-lib/aarch64-native-clang/usr/lib64" ]; then \
			echo "✓ Dependencies available for $$lib"; \
		else \
			echo "✗ Missing dependencies for $$lib"; \
		fi; \
	done
	@for lib in $(LIBS_LEVEL_1) $(LIBS_LEVEL_2) ; do \
		if [ -d "benchmark-lib/aarch64-native-clang/usr/lib" ] || [ -d "benchmark-lib/aarch64-native-clang/usr/lib64" ]; then \
			echo "✓ Dependencies available for $$lib"; \
		else \
			echo "✗ Missing dependencies for $$lib"; \
		fi; \
	done

.PHONY: all bench consolidate plot build clean reset check-deps \
	build-libs build-benchmarks \
	build-libs-level-0 build-libs-level-1 build-libs-level-2 \
	install-libs-level-0 install-libs-level-1 install-libs-level-2 \
	build-zlib build-giflib build-libexpat build-libxml2 \
	build-libpng build-libtiff build-libwebp
