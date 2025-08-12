# LFI Benchmarks

This repository contains benchmarks for LFI. Each benchmark contains a Makefile
with a `bench` target that can be used to build and run the benchmark.

There is also a top-level Makefile with the following targets: `build`,
`bench`, `consolidate`, `plot`. When using `consolidate` and `plot`, you should
set `MACHINE` to an identifier for your current machine (such as `aarch64/m2`),
so that the data and plot get placed in the appropriate directory in `results`.
Otherwise the generic name `current` will be used.

# Results

* [LFI-bench](./results)
* [SPEC 2017](./spec2017)


# Setup

In order to run the benchmarks, you should first install an LFI toolchain, and
then modify the compiler definitions in `toolchains` as required. 


The default configurations have built the following toolchains and placed them
in your LFI_ROOT directory:

* `aarch64-lfi-clang/`
* `aarch64-lfi-stores-clang/`
* `aarch64-native-clang/`

``

The `install-lfi-prebuilt.sh` script can be used to automatically download
prebuilt versions of these toolchains.

You can find instructions for building these toolchains
[here](https://github.com/zyedidia/lfi-llvm-toolchain).

For running the benchmarks you will also need the `lfi-run` tool from the [LFI
repository](https://github.com/zyedidia/lfi).

By default, LFI_ROOT defaults to /opt, but can be set with an environment
variable.
```
export LFI_ROOT=/path/to/lfi
```


