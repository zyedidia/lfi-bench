# Compiler and binary tools
set(CMAKE_C_COMPILER /opt/aarch64-lfi-stores-clang/bin/clang)
set(CMAKE_CXX_COMPILER /opt/aarch64-lfi-stores-clang/bin/clang++)
set(CMAKE_ASM_COMPILER /opt/aarch64-lfi-stores-clang/bin/clang)
set(CMAKE_AR /opt/aarch64-lfi-stores-clang/bin/llvm-ar)
set(CMAKE_STRIP /opt/aarch64-lfi-stores-clang/bin/llvm-strip)

# Target system settings
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# Sysroot
set(CMAKE_SYSROOT /opt/aarch64-lfi-stores-clang/sysroot)

#Include multiple roots for CMake to find libraries/headers
 set(CMAKE_FIND_ROOT_PATH
     ${CMAKE_SYSROOT}
   ../benchmark-lib
 )

 set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY BOTH)
 set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)
