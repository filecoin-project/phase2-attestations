#!/usr/bin/env bash

# This script downloads the files needed to verify the final parameters.
#
# Inputs are a proof type and a sector size.
set -e

script_name=$(basename "${0}")

if [ "${#}" -ne 2 ]; then
    echo "Download files needed to verify the final parameters."
    echo ""
    echo "Usage: ${script_name} {update|poseidon} {32|64}"
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

proof="${1}"
sector_size="${2}"

magenta='\u001b[35;1m'
red='\u001b[31;1m'
off='\u001b[0m'

function log() {
    echo -e "${magenta}[${script_name}]${off} ${1}"
}

function error() {
    echo -e "${magenta}[${script_name}] ${red}error:${off} ${1}"
}

if [[ ${proof} != 'update' && ${proof} != 'poseidon' ]]; then
    error "invalid proof: '${proof}'"
    exit 1
fi

if [[ ${sector_size} != '32' && ${sector_size} != '64' ]]; then
    error "invalid sector-size: '${sector_size}'"
    exit 1
fi

# The number of Phase 2 contributions.
if [[ ${proof} == 'update' ]]; then
    n='15'
else
    n='12'
fi

url_base='https://trusted-setup-snapdeals.filecoin.io/phase2/v28'

# Get the file containing checksums of the parameter files.
if [[ ! -f './934fe8c.b2sums' ]]; then
    log "downloading checksums for parameters: 934fe8c.b2sums"
    curl --fail --progress-bar -O "${url_base}/934fe8c.b2sums"
fi
log 'verifying parameters checksums file checksum'
echo "5caa72dda6584b9b11cd7b0789790f48792ce286788e06aa33fd5e43c4b81f9ad1ea5758c8e485ee641dfccc6f81d02433c0aed1516bace9d37718508a5c29be  934fe8c.b2sums" | b2sum -c

# Get the final parameters metadata from the proofs implementation repository.
if [[ ! -f './parameters.json' ]]; then
    log "downloading final parameters metadata: parameters.json"
    curl --fail --progress-bar -O "https://raw.githubusercontent.com/filecoin-project/rust-fil-proofs/de000dd3732471e1cb79b1fdc842d3f9267cea9b/parameters.json"
fi
log 'verifying parameters metadata file checksum'
echo "30699f1a0df507ef300314e584c338027798428d1bbe50f986c63cf0cc496861146c7454d0d119493021bc2c350b5413541decca41b128bbb79755d5e1a4cfb5  parameters.json" | b2sum -c

if [[ ${proof} == 'update' ]]; then
    file_prefix="update_poseidon_${sector_size}gib_934fe8c"
else
    file_prefix="updatep_poseidon_${sector_size}gib_934fe8c"
fi

initial_large="${file_prefix}_0_large"
if [[ ! -f ${initial_large} ]]; then
    log "downloading intital params: ${initial_large}"
    curl --fail --progress-bar -O "${url_base}/${initial_large}"
fi
log 'verifying downloaded initial params checksum'
grep "${initial_large}" 934fe8c.b2sums | b2sum -c

file="${file_prefix}_${n}_small"
if [[ ! -f ${file} ]]; then
    log "downloading final params: ${file}"
    curl --fail --progress-bar -O "${url_base}/${file}"
fi
log 'verifying downloaded final params checksum'
grep "${file}" 934fe8c.b2sums | b2sum -c
