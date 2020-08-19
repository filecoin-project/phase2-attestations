#!/usr/bin/env bash

# This script verifies a contributions.
#
# Inputs are a proof type and a sector size and the contribution to verify.
set -e

script_name=$(basename "$0")

if [ "${#}" -ne 3 ]; then
    echo "Verify a contribution."
    echo "The 'contribution' parameter is a numeric value."
    echo ""
    echo "Usage: ${script_name} {sdr|window|winning} {32|64} [contribution]"
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
contrib="$3"

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

if [[ -z $contrib || $contrib -lt 1 || $contrib  -gt $n ]]; then
    error "invalid contrib: ${contrib}"
    exit 1
fi

if [[ ! -f './b288702.b2sums' ]]; then
    error 'b288702.b2sums file is missing'
    exit 1
fi

# Verify Phase 2 contributions.
log "verifying contribution: ${contrib}"

prev=$((contrib - 1))
prev_file="${proof}_poseidon_${sector_size}gib_b288702_${prev}_small_raw"

# We should never download parameters for the first contribution (index 0).
# We generate large params instead.
if [[ $prev -eq 0 ]]; then
    if [[ $proof == 'winning' ]]; then
        phase1_file='phase1radix2m19'
        phase1_checksum='4a3b6930739967248fee48dbf43e27ee907ab3780132e21d4c7fe37fcebdc87352f1495795178c27799828db9da3696eb6ef19054404b23ec4994883877d96f8'
    else
        phase1_file='phase1radix2m27'
        phase1_checksum='8a5d4e211e3a9817dcdc7d345a25338f261d0b52ab188661dfcb6bada9f2f5ac76925521621d8f87b5b680105973f4b48fb1ec68f65ebf8fdbccbd8d4891e6e9'
    fi

    if [[ ! -f ${phase1_file} ]]; then
        error "${phase1_file} is missing. Run: ./download_prereqs_contrib.sh ${proof} ${sector_size} ${contrib}"
        exit 1
    fi
    log 'verifying Phase 1 checksum'
    echo "${phase1_checksum} ${phase1_file}" | b2sum -c

    # Generate initial phase2 params.
    initial_large="${proof}_poseidon_${sector_size}gib_b288702_0_large"
    if [[ ! -f ${initial_large} ]]; then
        log 'generating initial params'
        ./phase2 new --${proof} --${sector_size}gib

        # Rename initial params file to replace commit hash at time of
        # ceremony start with that of the current release (which should be
        # checked out), so verification will succeed.
        mv ${proof}_poseidon_${sector_size}gib_$(git rev-parse --short=7 HEAD)_0_large $initial_large
    else
        log 'use previously generated inital params'
    fi

    # Verify checksum of generated initial params.
    log 'verifying initial params checksum'
    grep $initial_large b288702.b2sums | b2sum -c
else
    if [[ ! -f ${prev_file} ]]; then
        error "${prev_file} is missing. Run: ./download_prereqs_contrib.sh ${proof} ${sector_size} ${contrib}"
        exit 1
    fi
    # Verify checksum even if file was present, in case of incomplete download
    # or corruption. This is especially relevant if another process might have
    # initiated a download now in process.
    log 'verifying downloaded params checksum'
    grep $prev_file b288702.b2sums | b2sum -c
fi

file="${proof}_poseidon_${sector_size}gib_b288702_${contrib}_small_raw"
if [[ ! -f ${file} ]]; then
    error "${file} is missing. Run: ./download_prereqs_contrib.sh ${proof} ${sector_size} ${contrib}"
    exit 1
fi
log 'verifying downloaded params checksum'
grep $file b288702.b2sums | b2sum -c

contrib_file="${file}.contrib"
if [[ ! -f ${contrib_file} ]]; then
    error "${contrib_file} is missing. Run: ./download_prereqs_contrib.sh ${proof} ${sector_size} ${contrib}"
fi

./phase2 verify $file
log "${green}success:${off} verified contribution: ${contrib}"
