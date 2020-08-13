#!/usr/bin/env bash

set -e

proof="$1"
sector_size="$2"
version='28'
contrib="$3"

echo "proof: $proof; sector_size: $sector_size; contrib: $contrib"

magenta='\u001b[35;1m'
red='\u001b[31;1m'
green='\u001b[32;1m'
off='\u001b[0m'

function log() {
    echo -e "${magenta}[phase2_verify_contrib.sh]${off} $1"
}

function error() {
    echo -e "${magenta}[phase2_verify_contrib.sh] ${red}error:${off} $1"
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

if [[ -z $contrib || $contrib > $n ]]; then
    error "invalid contrib: ${contrib}"
    exit 1
else
    echo "contrib: ${contrib}"
fi

url_base='https://trusted-setup.s3.amazonaws.com/phase2-mainnet'

# Verify phase2 contributions.
log "verifying contribution: ${contrib}"

prev=$((contrib - 1))
prev_file="${proof}_poseidon_${sector_size}gib_b288702_${prev}_small_raw"
if [[ ! -f ${prev_file} ]]; then
    log "downloading params: ${file}"
    curl --progress-bar -O ${url_base}/${prev_file}
fi
# Verify checksum even if file was present, in case of incomplete download or corruption.
# This is especially relevant if another process might have initiated a download now in process.
log 'verifying downloaded params checksum'
grep $prev_file b288702.b2sums | b2sum -c


file="${proof}_poseidon_${sector_size}gib_b288702_${contrib}_small_raw"
if [[ ! -f ${file} ]]; then
    log "downloading params: ${file}"
    curl --progress-bar -O ${url_base}/${file}
fi
log 'verifying downloaded params checksum'
grep $file b288702.b2sums | b2sum -c

contrib="${file}.contrib"
if [[ ! -f ${contrib} ]]; then
    log "downloading contrib: ${contrib}"
    curl --progress-bar -O ${url_base}/${contrib}
fi

./phase2 verify $file
log "${green}success:${off} verified contribution: ${contrib}"
