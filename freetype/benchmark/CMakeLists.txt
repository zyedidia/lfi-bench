cmake_minimum_required(VERSION 3.10)
project(freetype_benchmark C)

# Tell the linker where to find libfreetype.a and dependencies
link_directories(${LIB_DIR})
include_directories(${LIB_DIR}/include ../freetype/include)

# Add dependency library paths from install prefix
if(DEFINED CMAKE_INSTALL_PREFIX)
    link_directories(${CMAKE_INSTALL_PREFIX}/lib ${CMAKE_INSTALL_PREFIX}/lib64)
    include_directories(${CMAKE_INSTALL_PREFIX}/include)
endif()

# Define executable
add_executable(benchmark benchmark.c)

# Force static linking
set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
set(BUILD_SHARED_LIBS OFF)

# Link against the static freetype and its dependencies
target_link_libraries(benchmark 
    -static-pie
    freetype 
    z 
    png
)