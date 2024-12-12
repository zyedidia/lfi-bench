# Project configuration
project(
  'zlib',
  'c',
  version: '1.3.11',  # Update this to match your zlib version
  default_options: ['warning_level=2', 'buildtype=release']
)

# Compiler options
zlib_c_args = ['-D_LARGEFILE64_SOURCE=1', '-D_FILE_OFFSET_BITS=64']

# Source files for the zlib library
zlib_sources = [
  'adler32.c',
  'compress.c',
  'crc32.c',
  'deflate.c',
  'gzclose.c',
  'gzlib.c',
  'gzread.c',
  'gzwrite.c',
  'inflate.c',
  'infback.c',
  'inftrees.c',
  'inffast.c',
  'trees.c',
  'uncompr.c',
  'zutil.c'
]

# Build the static library
zlib_static = static_library(
  'zlib',
  zlib_sources,
  include_directories: include_directories('.'),
  c_args: zlib_c_args
)

# Build the shared library
zlib_shared = shared_library(
  'zlib',
  zlib_sources,
  include_directories: include_directories('.'),
  c_args: zlib_c_args,
  version: meson.project_version()
)

# Benchmark programs (not installed)
# Build compress_file benchmark
compress_file_exe = executable(
  'compress_file',
  'compress_file.c',
  include_directories: include_directories('.'),
  link_with: zlib_static,  # Link with the locally built zlib library
  install: false           # Do not install
)

# Build decompress_file benchmark
decompress_file_exe = executable(
  'decompress_file',
  'decompress_file.c',
  include_directories: include_directories('.'),
  link_with: zlib_static,  # Link with the locally built zlib library
  install: false           # Do not install
)

# Output summary
message('Building zlib version @0@'.format(meson.project_version()))
