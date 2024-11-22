# Opus

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

## Apple M2

Expected results on an Apple M2 with the core frequency pinned to 3.096GHz:

### Encode benchmark

```
Benchmark 1: lfi-run -- ./build-lfi/src/opus_demo -e voip 48000 2 96000 opus-benchdata/music_orig.wav /dev/null
  Time (mean ± σ):     650.4 ms ±   0.1 ms    [User: 645.7 ms, System: 4.7 ms]
  Range (min … max):   650.2 ms … 650.4 ms    5 runs
 
Benchmark 2: lfi-run -- ./build-lfi-stores/src/opus_demo -e voip 48000 2 96000 opus-benchdata/music_orig.wav /dev/null
  Time (mean ± σ):     629.1 ms ±   0.1 ms    [User: 628.3 ms, System: 0.8 ms]
  Range (min … max):   628.9 ms … 629.1 ms    5 runs
 
Benchmark 3: ./build-native/src/opus_demo -e voip 48000 2 96000 opus-benchdata/music_orig.wav /dev/null
  Time (mean ± σ):     620.9 ms ±   0.4 ms    [User: 619.4 ms, System: 1.6 ms]
  Range (min … max):   620.5 ms … 621.5 ms    5 runs
 
Summary
  ./build-native/src/opus_demo -e voip 48000 2 96000 opus-benchdata/music_orig.wav /dev/null ran
    1.01 ± 0.00 times faster than lfi-run -- ./build-lfi-stores/src/opus_demo -e voip 48000 2 96000 opus-benchdata/music_orig.wav /dev/null
    1.05 ± 0.00 times faster than lfi-run -- ./build-lfi/src/opus_demo -e voip 48000 2 96000 opus-benchdata/music_orig.wav /dev/null
```

Summary:

* LFI-full: 4.8% overhead
* LFI-stores: 1.3% overhead

### Decode benchmark

```
Benchmark 1: lfi-run -- ./build-lfi/src/opus_demo -d 48000 2 opus-benchdata/music_orig.opus /dev/null
  Time (mean ± σ):     162.9 ms ±   0.0 ms    [User: 160.7 ms, System: 2.3 ms]
  Range (min … max):   162.8 ms … 162.9 ms    10 runs
 
Benchmark 2: lfi-run -- ./build-lfi-stores/src/opus_demo -d 48000 2 opus-benchdata/music_orig.opus /dev/null
  Time (mean ± σ):     152.9 ms ±   0.0 ms    [User: 153.0 ms, System: 0.0 ms]
  Range (min … max):   152.8 ms … 152.9 ms    10 runs
 
Benchmark 3: ./build-native/src/opus_demo -d 48000 2 opus-benchdata/music_orig.opus /dev/null
  Time (mean ± σ):     148.9 ms ±   0.0 ms    [User: 148.3 ms, System: 0.8 ms]
  Range (min … max):   148.8 ms … 149.0 ms    10 runs
 
Summary
  ./build-native/src/opus_demo -d 48000 2 opus-benchdata/music_orig.opus /dev/null ran
    1.03 ± 0.00 times faster than lfi-run -- ./build-lfi-stores/src/opus_demo -d 48000 2 opus-benchdata/music_orig.opus /dev/null
    1.09 ± 0.00 times faster than lfi-run -- ./build-lfi/src/opus_demo -d 48000 2 opus-benchdata/music_orig.opus /dev/null
```

Summary:

* LFI-full: 9.5% overhead
* LFI-stores: 2.7% overhead
