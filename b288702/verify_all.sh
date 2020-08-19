#!/usr/bin/env bash

# This script runs a full verifcation of a parameter file.
#
# Inputs are a proof type and a sector size and the contribution to verify.
set -e

script_name=$(basename "$0")

if [ "${#}" -ne 2 ]; then
    echo "Verify that the final parameters match the final contribution."
    echo ""
    echo "Usage: ${script_name} {sdr|window|winning} {32|64}"
    exit 1
fi

proof="$1"
sector_size="$2"

dir=$(dirname "$0")
script_name=$(basename "$0")

magenta='\u001b[35;1m'
red='\u001b[31;1m'
green='\u001b[32;1m'
off='\u001b[0m'

function log() {
    echo -e "${magenta}[${script_name}]${off} $1"
}

function error() {
    echo -e "${magenta}[${script_name}] ${red}error:${off} $1"
}

if [[ $proof != 'winning' && $proof != 'sdr' && $proof != 'window' ]]; then
    error "invalid proof: '${proof}'"
    exit 1
fi

if [[ $sector_size != '32' && $sector_size != '64' ]]; then
    error "invalid sector-size: '${sector_size}'"
    exit 1
fi

# The number of phase2 contributions.
if [[ $proof == 'winning' ]]; then
    n='20'
elif [[ $proof == 'window' ]]; then
    n='15'
elif [[ $sector_size == '32' ]]; then
    n='17'
else
    n='16'
fi

# Verify Phase 2 contributions.
for i in $(seq 1 $n); do
    if [[ $i -eq 1 ]]; then
        $dir/download_initial_generation_prereqs.sh $proof $sector_size
        $dir/generate_initial.sh $proof $sector_size
        $dir/verify_contrib.sh $proof $sector_size $i
    else
        $dir/download_prereqs_contrib.sh $proof $sector_size $i
        $dir/verify_contrib.sh $proof $sector_size $i
    fi
done

$dir/verify_final.sh $proof $sector_size

log "${green}success:${off} finished verifying all phase2 parameters"
