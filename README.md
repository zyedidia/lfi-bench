# LFI Benchmarks

This repository contains benchmarks for LFI. In order to run the benchmarks,
you should first install an LFI toolchain, and then modify the compiler
definitions in `toolchains` as required. The default configurations assume
you have built the following toolchains and placed them in `/opt`:

* `aarch64-lfi-clang/`
* `aarch64-lfi-stores-clang/`
* `aarch64-native-clang/`

You can find instructions for building these toolchains
[here](https://github.com/zyedidia/lfi-llvm-toolchain).

For running the benchmarks you will also need the `lfi-run` tool from the [LFI
repository](https://github.com/zyedidia/lfi).

Benchmarks and instructions:

* [dav1d](https://github.com/zyedidia/lfi-bench/tree/master/dav1d)
* [opus](https://github.com/zyedidia/lfi-bench/tree/master/opus)
* [coremark](https://github.com/zyedidia/lfi-bench/tree/master/coremark)
* [libvpx](https://github.com/zyedidia/lfi-bench/tree/master/libvpx)
