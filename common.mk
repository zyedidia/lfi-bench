# common.mk - Shared configuration for all LFI benchmarks

# Build configuration (benchmark-specific RUNS/WARMUP stay in individual Makefiles)
JOBS := $(shell nproc)

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

