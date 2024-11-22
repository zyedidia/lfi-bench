# dav1d

Download and build source code:

```
./download-source.sh
./build.sh
```

Download the benchmark data:

```
./download-data.sh
```

Execute the benchmark with Hyperfine:

```
./bench.sh
```

# Results

Expected results on an Apple M2 with the core frequency pinned to 3.096GHz:

```
Benchmark 1: lfi-run -- build-lfi/tools/dav1d -i dav1d-benchdata/Bosphorus_3840x2160_120fps_420_8bit.ivf -o /dev/null --threads 1
  Time (mean ± σ):      9.872 s ±  0.006 s    [User: 9.855 s, System: 0.016 s]
  Range (min … max):    9.868 s …  9.876 s    2 runs
 
Benchmark 2: lfi-run -- build-lfi-stores/tools/dav1d -i dav1d-benchdata/Bosphorus_3840x2160_120fps_420_8bit.ivf -o /dev/null --threads 1
  Time (mean ± σ):      9.591 s ±  0.004 s    [User: 9.574 s, System: 0.017 s]
  Range (min … max):    9.588 s …  9.593 s    2 runs
 
Benchmark 3: build-native/tools/dav1d -i dav1d-benchdata/Bosphorus_3840x2160_120fps_420_8bit.ivf -o /dev/null --threads 1
  Time (mean ± σ):      9.487 s ±  0.035 s    [User: 9.467 s, System: 0.020 s]
  Range (min … max):    9.462 s …  9.512 s    2 runs
 
Summary
  build-native/tools/dav1d -i dav1d-benchdata/Bosphorus_3840x2160_120fps_420_8bit.ivf -o /dev/null --threads 1 ran
    1.01 ± 0.00 times faster than lfi-run -- build-lfi-stores/tools/dav1d -i dav1d-benchdata/Bosphorus_3840x2160_120fps_420_8bit.ivf -o /dev/null --threads 1
    1.04 ± 0.00 times faster than lfi-run -- build-lfi/tools/dav1d -i dav1d-benchdata/Bosphorus_3840x2160_120fps_420_8bit.ivf -o /dev/null --threads 1
```
