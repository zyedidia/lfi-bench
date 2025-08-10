cmake_minimum_required(VERSION 3.10)
project(coremark C)

# Source files
set(COREMARK_SOURCES
    core_list_join.c
    core_main.c
    core_matrix.c
    core_state.c
    core_util.c
    posix/core_portme.c
)

# Create coremark executable
add_executable(coremark ${COREMARK_SOURCES})

# Include directories
target_include_directories(coremark PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/linux
    ${CMAKE_CURRENT_SOURCE_DIR}/posix
)

# Compile definitions - matching meson build
target_compile_definitions(coremark PRIVATE
    PERFORMANCE_RUN=1
    ITERATIONS=0
    FLAGS_STR=""
)

# Link options - static pie linking
target_link_options(coremark PRIVATE -static-pie)