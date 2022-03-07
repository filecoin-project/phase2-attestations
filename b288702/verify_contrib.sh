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

if ! command -v gpg >/dev/null 2>&1
then
    echo "ERROR: 'gpg' needs to be installed."
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
yellow='\u001b[33;1m'
off='\u001b[0m'

function log() {
    echo -e "${magenta}[${script_name}]${off} $1"
}

function error() {
    echo -e "${magenta}[${script_name}] ${red}error:${off} $1"
}

function warn() {
    echo -e "${magenta}[${script_name}] ${yellow}warn:${off} $1"
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
# We use generated large params instead.
if [[ $prev -eq 0 ]]; then
    initial_large="${proof}_poseidon_${sector_size}gib_b288702_0_large"
    if [[ ! -f ${initial_large} ]]; then
        error "${initial_large} is missing. Run: ./generate_initial.sh ${proof} ${sector_size}"
        exit 1
    fi
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

./phase2 verify --check-subgroup-before $file

# The first two contributions of Winning PoSt were not signed
if [[
    ( ${proof} == 'winning' && ${sector_size} -eq 32 && ${contrib} -eq 1 ) ||
    ( ${proof} == 'winning' && ${sector_size} -eq 64 && ${contrib} -eq 1 )
    ]]
then
    warn 'skipping signature verification as there is no signature available for this contribution'
    exit 0
fi

log 'verifying signature with public GPG key'
sig_file="${file}.contrib.sig"
if [[ ! -f ${sig_file} ]]; then
    error "${sig_file} is missing. Run: ./download_prereqs_contrib.sh ${proof} ${sector_size} ${contrib}"
fi

# For some signatures the public keys are not available
if [[
    ( ${proof} == 'sdr' && ${sector_size} -eq 64 && ${contrib} -eq 2 ) ||
    ( ${proof} == 'window' && ${sector_size} -eq 64 && ${contrib} -eq 7 )
    ]]
then
    warn 'skipping signature verification as no public key is available for this signature'
    exit 0
fi

if ! gpg --no-default-keyring --keyring ./keyring.gpg --verify "${sig_file}" > /dev/null 2>&1
then
    error 'signature verification failed'
    exit 1
fi

log "${green}success:${off} verified contribution: ${contrib}"
