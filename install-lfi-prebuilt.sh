#!/bin/bash

# default LFI_ROOT directory to /opt if not set
LFI_ROOT=${LFI_ROOT:-/opt}

if [ -d $LFI_ROOT ]; then
    echo "LFI_ROOT directory '$LFI_ROOT' already exists. Please remove it first."
    exit 1
fi


# Find the directory that must be writable:
if [ -e "$LFI_ROOT" ]; then
    target_dir="$LFI_ROOT"
else
    target_dir="$(dirname -- "$LFI_ROOT")"
fi

# Check if user has write and execute permissions
if [ -w "$target_dir" ] && [ -x "$target_dir" ]; then
    echo "✅ You have permission to install into $LFI_ROOT."
else
    echo "❌ You do NOT have permission to install into $LFI_ROOT, use sudo or change $LFI_ROOT."
    exit 1
fi
# do the install

wget -c https://github.com/lfi-project/lfi-llvm-toolchain/releases/download/v0.9/aarch64-lfi-clang.tar.gz
wget -c https://github.com/lfi-project/lfi-llvm-toolchain/releases/download/v0.9/aarch64-lfi-stores-clang.tar.gz
wget -c https://github.com/lfi-project/lfi-llvm-toolchain/releases/download/v0.9/aarch64-native-clang.tar.gz

tar -xf aarch64-lfi-clang.tar.gz
tar -xf aarch64-lfi-stores-clang.tar.gz
tar -xf aarch64-native-clang.tar.gz

mkdir -p $LFI_ROOT
mv aarch64-lfi-clang $LFI_ROOT
mv aarch64-lfi-stores-clang $LFI_ROOT
mv aarch64-native-clang $LFI_ROOT
