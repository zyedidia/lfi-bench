package main

import (
	"encoding/csv"
	"flag"
	"fmt"
	"io"
	"log"
	"math"
	"os"
	"path/filepath"
	"strconv"
	"strings"
)

type Benchmark struct {
	Name   string
	Mean   float64
	StdDev float64
	Min    float64
	Max    float64
}

func parseFloat(s string) float64 {
	f, err := strconv.ParseFloat(s, 64)
	if err != nil {
		log.Fatal(err)
	}
	return f
}

func readCSV(path string) [][]string {
	f, err := os.Open(path)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	r := csv.NewReader(f)
	records, err := r.ReadAll()
	if err != nil {
		log.Fatal(err)
	}

	return records
}

func calcRaw(bench string, benches map[string][]Benchmark, w io.Writer) {
	config := benches[bench]
	for _, b := range config {
		fmt.Fprintf(w, "%s,%.5f\n", b.Name, b.Mean)
	}
}

func calcOverhead(bench string, benches map[string][]Benchmark, w io.Writer) {
	config := benches[bench]
	native := benches["Native"]

	nativeMap := make(map[string]float64)
	for _, nb := range native {
		nativeMap[nb.Name] = nb.Mean
	}

	geomean := 1.0
	n := 0
	for _, b := range config {
		nativeMean, exists := nativeMap[b.Name]
		if !exists {
			log.Printf("Warning: No Native benchmark found for %s", b.Name)
			continue
		}
		overhead := (b.Mean - nativeMean) / nativeMean
		fmt.Fprintf(w, "%s,%.3f\n", b.Name, overhead*100)
		geomean *= (1 + overhead)
		n++
	}

	// Also warn about missing benchmarks in the opposite direction
	configMap := make(map[string]bool)
	for _, b := range config {
		configMap[b.Name] = true
	}
	for _, nb := range native {
		if !configMap[nb.Name] {
			log.Printf("Warning: No %s benchmark found for %s", bench, nb.Name)
		}
	}

	if n > 0 {
		geomean = math.Pow(geomean, 1.0/float64(n)) - 1
		fmt.Fprintf(w, "geomean,%.3f\n", geomean*100)
	}
}

func main() {
	config := flag.String("config", "LFI", "Configuration to consolidate (LFI,LFI-stores)")
	raw := flag.Bool("raw", false, "Dump raw runtimes instead of relative overheads")

	flag.Parse()
	args := flag.Args()

	benches := make(map[string][]Benchmark)

	for _, a := range args {
		records := readCSV(a)
		for _, r := range records {
			if r[0] == "command" {
				continue
			}
			benches[r[0]] = append(benches[r[0]], Benchmark{
				Name:   strings.TrimSuffix(filepath.Base(a), filepath.Ext(a)),
				Mean:   parseFloat(r[1]),
				StdDev: parseFloat(r[2]),
				Min:    parseFloat(r[6]),
				Max:    parseFloat(r[7]),
			})
		}
	}

	if !*raw {
		calcOverhead(*config, benches, os.Stdout)
	} else {
		calcRaw(*config, benches, os.Stdout)
	}
}
