# Target system
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# Sysroot
set(CMAKE_SYSROOT /opt/aarch64-native-clang/sysroot)

# RPATH settings for runtime library search
set(CMAKE_BUILD_RPATH "${CMAKE_SYSROOT}/usr/lib;${CMAKE_SYSROOT}/lib64;${CMAKE_SYSROOT}/lib")
set(CMAKE_INSTALL_RPATH "${CMAKE_SYSROOT}/usr/lib;${CMAKE_SYSROOT}/lib64;${CMAKE_SYSROOT}/lib")
set(CMAKE_SKIP_BUILD_RPATH FALSE)
set(CMAKE_SKIP_INSTALL_RPATH FALSE)

# Toolchain binaries
set(CMAKE_C_COMPILER /opt/aarch64-native-clang/bin/clang)
set(CMAKE_CXX_COMPILER /opt/aarch64-native-clang/bin/clang++)
set(CMAKE_ASM_COMPILER /opt/aarch64-native-clang/bin/clang)
set(CMAKE_AR /opt/aarch64-native-clang/bin/llvm-ar)
set(CMAKE_STRIP /opt/aarch64-native-clang/bin/llvm-strip)

set(APPEND CMAKE_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}")
set(CMAKE_FIND_ROOT_PATH "${CMAKE_INSTALL_PREFIX}")
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
