# Lua Benchmarks

This directory provides scripts for benchmarking the performance of the Lua interpreter compiled for LFI.

## Summary

On the M2 (aarch64), we have the following overheads:

![m2 plot](./results/aarch64/m2/m2.png)

* LFI geomean: 10.1%
* LFI-stores geomean: 6.1%
