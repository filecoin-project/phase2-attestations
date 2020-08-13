#!/usr/bin/env bash

# This script generates the initial parameters needed for verification.
#
# Inputs are a proof type and a sector size.
set -e

script_name=$(basename "$0")

if [ "${#}" -ne 2 ]; then
    echo "Generate initial parameters for verification."
    echo ""
    echo "Usage: ${script_name} {sdr|window|winning} {32|64}"
    exit 1
fi

if ! command -v b2sum >/dev/null 2>&1
then
    echo "ERROR: 'b2sum' needs to be installed."
    exit 1
fi

if ! command -v ./phase2 >/dev/null 2>&1
then
    echo "ERROR: 'phase2' from rust-fil-proofs needs to be in the current directory."
    exit 1
fi

proof="$1"
sector_size="$2"


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

# Phase1 parameters are needed to create the initial phase2 parameters
if [[ $proof == 'winning' ]]; then
    if [[ ! -f './phase1radix2m19' ]]; then
        error 'phase1radix2m19 file is missing'
        exit 1
    fi
elif [[ ! -f './phase1radix2m27' ]]; then
    error 'phase1radix2m27 file is missing'
    exit 1
fi

if [[ ! -f './b288702.b2sums' ]]; then
    error 'b288702.b2sums file is missing'
    exit 1
fi

# Generate initial phase2 params.
initial_large="${proof}_poseidon_${sector_size}gib_b288702_0_large"
if [[ ! -f ${initial_large} ]]; then
    log 'generating initial params'
    ./phase2 new --${proof} --${sector_size}gib

    # Rename initial params file to replace commit hash at time of ceremony start
    # with that of the current release (which should be checked out), so verification will succeed.
    mv ${proof}_poseidon_${sector_size}gib_$(git rev-parse --short=7 HEAD)_0_large $initial_large
else
    log 'use previously generated inital params'
fi

# Verify checksum of generated initial params.
log 'verifying initial params checksum'
grep $initial_large b288702.b2sums | b2sum -c

log "${green}success:${off} finished generating initial phase2 parameters"
