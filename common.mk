# common.mk - Shared configuration for all LFI benchmarks

# Build configuration (benchmark-specific RUNS/WARMUP stay in individual Makefiles)
JOBS := $(shell nproc)

#how many threads to use in benchmarks
THREADS := 1

# Directory structure
PARENT_DIR := $(shell dirname $(shell pwd))
BENCH_LIB := $(PARENT_DIR)/benchmark-lib

# Install directories
LFI_INSTALL := $(BENCH_LIB)/aarch64-lfi-clang/usr
STORES_INSTALL := $(BENCH_LIB)/aarch64-lfi-stores-clang/usr
NATIVE_INSTALL := $(BENCH_LIB)/aarch64-native-clang/usr

# Toolchain paths
TOOLCHAIN_DIR := $(PARENT_DIR)/toolchains
LFI_TOOLCHAIN := $(TOOLCHAIN_DIR)/aarch64-lfi.cmake
STORES_TOOLCHAIN := $(TOOLCHAIN_DIR)/aarch64-lfi-stores.cmake
NATIVE_TOOLCHAIN := $(TOOLCHAIN_DIR)/aarch64-native.cmake
LFI_MESON := $(TOOLCHAIN_DIR)/aarch64-lfi.txt
STORES_MESON := $(TOOLCHAIN_DIR)/aarch64-lfi-stores.txt
NATIVE_MESON := $(TOOLCHAIN_DIR)/aarch64-native.txt

# Standard build directories
BUILD_DIRS = build-lfi build-lfi-stores build-native

# Default target - should be overridden in individual Makefiles
.DEFAULT_GOAL := help

help:
	@echo "Available targets depend on the specific benchmark"
	@echo "Common targets: bench, clean, reset"

reset:
	rm *.csv

.PHONY: help reset
