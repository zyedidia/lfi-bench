cmake_minimum_required(VERSION 3.10)
project(xml_benchmark C)

# Tell the linker where to find libxml2
link_directories(${LIBXML2_DIR})
include_directories(../libxml2/include)
include_directories(${LIBXML2_DIR})

# Define executables
add_executable(xml-parse xml-parse.c)

# Link against libxml2
target_link_libraries(xml-parse xml2)
