#!/bin/bash

# Configuration variables
FREQUENCY=3000  # Frequency in MHz
STARTING_CORE=${1:-4}
NUM_CORES=${2:-4}

# Display usage if -h or --help is passed
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    echo "Usage: $0 [starting_core] [num_cores]"
    echo ""
    echo "Isolates CPU cores for performance benchmarking."
    echo ""
    echo "Arguments:"
    echo "  starting_core  First core to isolate (default: 4)"
    echo "  num_cores      Number of cores to isolate (default: 4)"
    echo ""
    echo "Examples:"
    echo "  $0              # Isolate cores 4-7 (default)"
    echo "  $0 2 4          # Isolate cores 2-5"
    echo "  $0 0 8          # Isolate cores 0-7"
    echo ""
    echo "Current configuration:"
    echo "  Frequency: ${FREQUENCY}MHz (edit script to change)"
    exit 0
fi

# Calculate ending core
ENDING_CORE=$((STARTING_CORE + NUM_CORES - 1))

# Build core list and comma-separated string
CORE_LIST=()
CORES=""
for ((i=STARTING_CORE; i<=ENDING_CORE; i++)); do
    CORE_LIST+=($i)
    if [ -z "$CORES" ]; then
        CORES="$i"
    else
        CORES="$CORES,$i"
    fi
done

# Print configuration
echo "CPU Core Isolation Script"
echo "========================="
echo "Usage: $0 [starting_core] [num_cores]"
echo ""
echo "Current Configuration:"
echo "  Starting core: $STARTING_CORE"
echo "  Number of cores: $NUM_CORES"
echo "  Core range: $STARTING_CORE-$ENDING_CORE"
echo "  CPU Frequency: ${FREQUENCY}MHz"
echo "================================="
echo ""

# Set performance governor and lock frequency for all cores
echo "Setting performance governor and locking frequency to ${FREQUENCY}MHz..."
for core in "${CORE_LIST[@]}"; do
    sudo cpufreq-set -c $core -g performance
    sudo cpufreq-set -c $core --min ${FREQUENCY}MHz --max ${FREQUENCY}MHz
done

# Create shield for all specified cores
echo "Creating CPU shield for cores $CORES..."
sudo cset shield -c $CORES -k on

# Run your benchmark in the shielded environment
echo ""
echo "Entering shielded environment..."
echo "Any process you start will automatically run ONLY on cores $CORES"
echo ""
echo "For additional control, you can use taskset:"
echo "  e.g. taskset -c $STARTING_CORE,$((STARTING_CORE+1)) ./your_benchmark"
echo ""
echo "Type 'exit' when done."
echo ""
sudo cset shield -e sudo -- -u "$USER" env "PATH=$PATH" bash

# After exiting, restore all cores
echo ""
echo "Restoring cores to normal operation..."
sudo cset shield -c $CORES -k off

# Get reference settings from an unshielded core (e.g., core 0)
POLICYINFO=($(cpufreq-info -c 0 -p))
echo "Restoring to: ${POLICYINFO[0]} ${POLICYINFO[1]} ${POLICYINFO[2]}"

# Restore original settings for all cores
for core in "${CORE_LIST[@]}"; do
    sudo cpufreq-set -c $core -g ${POLICYINFO[2]}
    sudo cpufreq-set -c $core --min ${POLICYINFO[0]} --max ${POLICYINFO[1]}
done

echo "All cores restored successfully."
