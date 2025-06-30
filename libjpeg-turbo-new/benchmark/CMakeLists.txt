cmake_minimum_required(VERSION 3.10)
project(jpeg_benchmark CXX)

# Tell the linker where to find libjpeg-turbo
link_directories(${LIBJPEG_DIR})
include_directories(../libjpeg-turbo/src)
include_directories(${LIBJPEG_DIR})

# Define executables
add_executable(decode-benchmark decode-benchmark.cpp)

# Link against libjpeg-turbo
target_link_libraries(decode-benchmark turbojpeg jpeg mimalloc)