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

## dav1d

Download the sources and benchmark data:

```
./download.sh
```

Build the configurations:

```
./build.sh
```

Execute the benchmark with Hyperfine:

```
./bench.sh
```
