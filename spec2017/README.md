# SPEC CPU2017

Since SPEC 2017 is not publicly available, we only publish the results of
benchmarking here. The x86-64 benchmarks are run on an AMD Ryzen 9 7950X and
the Arm64 benchmarks on a Mac Mini M2.

The numbers listed here represent the percent overhead compared to native code
for each benchmark. For example, for full LFI sandboxing on AArch64 we recorded
a geomean 7.275% overhead compared to native code.

Benchmarks were run with LLVM 19.1.4 with LTO enabled.
