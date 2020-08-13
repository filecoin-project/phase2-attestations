#!/usr/bin/env bash
set -e

proof="$1"
sector_size="$2"

magenta='\u001b[35;1m'
red='\u001b[31;1m'
green='\u001b[32;1m'
off='\u001b[0m'

function log() {
    echo -e "${magenta}[phase2_verify_all.sh]${off} $1"
}

function error() {
    echo -e "${magenta}[phase2_verify_all.sh] ${red}error:${off} $1"
}

if [[ $proof != 'winning' && $proof != 'sdr' && $proof != 'window' ]]; then
    error "invalid proof: '${proof}'"
    exit 1
fi

if [[ $sector_size != '32' && $sector_size != '64' ]]; then
    error "invalid sector-size: '${sector_size}'"
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
fi

# Verify checksum of generated initial params.
log 'verifying initial params checksum'
grep $initial_large b288702.b2sums | b2sum -c

log "${green}success:${off} finished generating initial phase2 parameters"
