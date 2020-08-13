#!/usr/bin/env bash

set -e

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

$dir/verify_initial.sh $proof $sector_size

# Verify phase2 contributions.
for i in $(seq 1 $n); do
    $dir/verify_contrib.sh $proof $sector_size $i
done

$dir/verify_final.sh $proof $sector_size

log "${green}success:${off} finished verifying all phase2 parameters"
