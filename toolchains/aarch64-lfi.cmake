# Target system
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# Toolchain binaries
set(CMAKE_C_COMPILER /opt/aarch64-lfi-clang/bin/clang)
set(CMAKE_CXX_COMPILER /opt/aarch64-lfi-clang/bin/clang++)
set(CMAKE_ASM_COMPILER /opt/aarch64-lfi-clang/bin/clang)
set(CMAKE_AR /opt/aarch64-lfi-clang/bin/llvm-ar)
set(CMAKE_STRIP /opt/aarch64-lfi-clang/bin/llvm-strip)

# Sysroot for compiler and linker
set(CMAKE_SYSROOT /opt/aarch64-lfi-clang/sysroot)
