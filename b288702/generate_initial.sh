#!/usr/bin/env bash

# This script generates the intial parameters.
#
# Inputs are a proof type and a sector size.
set -e

script_name=$(basename "$0")

if [ "${#}" -ne 2 ]; then
    echo "Generate initial parameters."
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

if [[ ! -f './b288702.b2sums' ]]; then
    error 'b288702.b2sums file is missing'
    exit 1
fi

log "generating intial parameters"

if [[ $proof == 'winning' ]]; then
    phase1_file='phase1radix2m19'
    phase1_checksum='4a3b6930739967248fee48dbf43e27ee907ab3780132e21d4c7fe37fcebdc87352f1495795178c27799828db9da3696eb6ef19054404b23ec4994883877d96f8'
else
    phase1_file='phase1radix2m27'
    phase1_checksum='8a5d4e211e3a9817dcdc7d345a25338f261d0b52ab188661dfcb6bada9f2f5ac76925521621d8f87b5b680105973f4b48fb1ec68f65ebf8fdbccbd8d4891e6e9'
fi

if [[ ! -f ${phase1_file} ]]; then
    error "${phase1_file} is missing. Run: ./download_initial_generation_prereqs.sh ${proof} ${sector_size}"
    exit 1
fi
log 'verifying Phase 1 checksum'
echo "${phase1_checksum}  ${phase1_file}" | b2sum -c

# Generate initial Phase 2 params.
initial_large="${proof}_poseidon_${sector_size}gib_b288702_0_large"
if [[ ! -f ${initial_large} ]]; then
    log 'generating initial params'
    ./phase2 new --${proof} --${sector_size}gib

    # Rename initial params file to replace commit hash at time of
    # ceremony start with that of the current release (which should be
    # checked out), so verification will succeed.
    mv ${proof}_poseidon_${sector_size}gib_$(git rev-parse --short=7 HEAD)_0_large $initial_large

    log "${green}success:${off} finished generating initial phase2 parameters"
else
    log 'use previously generated inital params'
fi

# Verify checksum of generated initial params.
log 'verifying initial params checksum'
grep $initial_large b288702.b2sums | b2sum -c
