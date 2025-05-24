cmake_minimum_required(VERSION 3.10)
project(zlib_examples C)

# Tell the linker where to find libz.a
link_directories(${ZLIB_DIR})

# Define executables
add_executable(compress_file compress_file.c)
add_executable(decompress_file decompress_file.c)

# Link both against the static zlib
target_link_libraries(compress_file z)
target_link_libraries(decompress_file z)
