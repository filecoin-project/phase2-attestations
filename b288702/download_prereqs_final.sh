#!/usr/bin/env bash

# This script downloads the files needed to verify the final parameters.
#
# Inputs are a proof type and a sector size.
set -e

script_name=$(basename "$0")

if [ "${#}" -ne 2 ]; then
    echo "Download files needed to verify the final parameters."
    echo ""
    echo "Usage: ${script_name} {sdr|window|winning} {32|64}"
    exit 1
fi

if ! command -v b2sum >/dev/null 2>&1
then
    echo "ERROR: 'b2sum' needs to be installed."
    exit 1
fi

if ! command -v curl >/dev/null 2>&1
then
    echo "ERROR: 'curl' needs to be installed."
    exit 1
fi

proof="$1"
sector_size="$2"

magenta='\u001b[35;1m'
red='\u001b[31;1m'
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

# The number of Phase 2 contributions.
if [[ $proof == 'winning' ]]; then
    n='20'
elif [[ $proof == 'window' ]]; then
    n='15'
elif [[ $sector_size == '32' ]]; then
    n='17'
else
    n='16'
fi

url_base='https://trusted-setup.s3.amazonaws.com/phase2-mainnet'

# Get the file containing checksums of the parameter files.
if [[ ! -f './b288702.b2sums' ]]; then
    log "downloading checksums for parameters: b288702.b2sums"
    curl --progress-bar -O "${url_base}/b288702.b2sums"
fi
log 'verifying parameters checksums file checksum'
echo "7931ca92df34bf0b6217692daaf2d92135fceb6caae344b10712ee997717cc612435b0a6e1e61325d5abaa62044b6f6359fd44bbe3dc4e111536bcad43c2e0ec b288702.b2sums" | b2sum -c


initial_large="${proof}_poseidon_${sector_size}gib_b288702_0_large"
if [[ ! -f ${initial_large} ]]; then
    log "downloading intital params: ${initial_large}"
    curl --progress-bar -O "${url_base}/${initial_large}"
fi
log 'verifying downloaded initial params checksum'
grep "$initial_large" b288702.b2sums | b2sum -c

file="${proof}_poseidon_${sector_size}gib_b288702_${n}_small_raw"
if [[ ! -f ${file} ]]; then
    log "downloading final params: ${file}"
    curl --progress-bar -O "${url_base}/${file}"
fi
log 'verifying downloaded final params checksum'
grep "$file" b288702.b2sums | b2sum -c
