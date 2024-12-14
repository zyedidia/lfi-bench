set term png
set output "x1.png"
set key samplen 1 spacing 1.1 font ",10"

set datafile separator ","
set style fill solid border -1
set xtics rotate by -45
set xtics scale 0
set yrange [0:30]
set ylabel "Percent increase over native runtime"
set title "LFI-bench - Arm Cortex X1"

plot "lfi.csv" using 2: xtic(1) with histogram title "LFI", \
     "lfi-stores.csv" using 2: xtic(1) with histogram title "LFI-stores"
