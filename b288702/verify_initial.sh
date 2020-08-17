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

url_base='https://trusted-setup.s3.amazonaws.com/challenge19'

# Phase 1 parameters are needed to create the initial Phase 2 parameters
if [[ $proof == 'winning' ]]; then
    phase1_file='phase1radix2m19'
    phase1_checksum='4a3b6930739967248fee48dbf43e27ee907ab3780132e21d4c7fe37fcebdc87352f1495795178c27799828db9da3696eb6ef19054404b23ec4994883877d96f8'
else
    phase1_file='phase1radix2m27'
    phase1_checksum='8a5d4e211e3a9817dcdc7d345a25338f261d0b52ab188661dfcb6bada9f2f5ac76925521621d8f87b5b680105973f4b48fb1ec68f65ebf8fdbccbd8d4891e6e9'
fi

if [[ ! -f ${phase1_file} ]]; then
    log "downloading Phase 1 parameters: ${phase1_file}"
    curl --progress-bar -O "${url_base}/${phase1_file}"
fi
log 'verifying Phase 1 checksum'
echo "${phase1_checksum} ${phase1_file}" | b2sum -c

# Get the file containing checksums of the parameter files
if [[ ! -f './b288702.b2sums' ]]; then
    log "downloading checksums for parameters: b288702.b2sums"
    curl --progress-bar -O "${url_base}/b288702.b2sums"
fi
log 'verifying parameters checksums file checksum'
echo "7931ca92df34bf0b6217692daaf2d92135fceb6caae344b10712ee997717cc612435b0a6e1e61325d5abaa62044b6f6359fd44bbe3dc4e111536bcad43c2e0ec  b288702.b2sums" | b2sum -c

# Get the keyring that contains all public keys to verify the contribution
# signatures
if [[ ! -f './keyring.gpg' ]]; then
    log "downloading keyring with GPG pulic keys: keyring.gpg"
    curl --progress-bar -O "${url_base}/keyring.gpg"
fi
log 'verifying keyring.gpg checksum'
echo "TODO keyring.gpg" | b2sum -c

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
