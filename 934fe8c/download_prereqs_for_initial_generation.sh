#!/usr/bin/env bash

# This script downloads the files needed to verify a the first contribution.
#
# Inputs are a proof type and a sector size.
set -e

script_name=$(basename "${0}")

if [ "${#}" -ne 2 ]; then
    echo "Download files needed to verify the first contribution."
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

url_base='https://trusted-setup-snapdeals.filecoin.io'

# Get the file containing checksums of the parameter files.
if [[ ! -f './934fe8c.b2sums' ]]; then
    log "downloading checksums for parameters: 934fe8c.b2sums"
    curl --fail --progress-bar -O "${url_base}/phase2/v28/934fe8c.b2sums"
fi
log 'verifying parameters checksums file checksum'
echo "5caa72dda6584b9b11cd7b0789790f48792ce286788e06aa33fd5e43c4b81f9ad1ea5758c8e485ee641dfccc6f81d02433c0aed1516bace9d37718508a5c29be  934fe8c.b2sums" | b2sum -c

if [[ ${proof} == 'update' ]]; then
    phase1_file='phase1radix2m27'
    phase1_checksum='8a5d4e211e3a9817dcdc7d345a25338f261d0b52ab188661dfcb6bada9f2f5ac76925521621d8f87b5b680105973f4b48fb1ec68f65ebf8fdbccbd8d4891e6e9'
else
    phase1_file='phase1radix2m25'
    phase1_checksum='f8d00f1fb86b8b379284207966446e129dad109abb3aacb4eef795cacad83d64e94b3b40a635c353cbec45bfb9d3bc8314e13912216630d9975fd3b6485c17d1'
fi

if [[ ! -f ${phase1_file} ]]; then
    log "downloading Phase 1 parameters: ${phase1_file}"
    curl --fail --progress-bar -O "${url_base}/phase1/${phase1_file}"
fi
log 'verifying Phase 1 checksum'
echo "${phase1_checksum} ${phase1_file}" | b2sum -c
