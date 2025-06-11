#!/bin/bash

sudo cpufreq-set -c 5 -g performance
sudo cpufreq-set -c 5 --min 3000MHz --max 3000MHz

sudo cset shield -c 5 -k on
sudo cset shield -e sudo -- -u "$USER" env "PATH=$PATH" bash
sudo cset shield -c 5 -k off

POLICYINFO=($(cpufreq-info -c 6 -p))
echo "${POLICYINFO[0]}" "${POLICYINFO[1]}" "${POLICYINFO[2]}"
sudo cpufreq-set -c 5 -g ${POLICYINFO[2]}
sudo cpufreq-set -c 5 --min ${POLICYINFO[0]} --max ${POLICYINFO[1]}
