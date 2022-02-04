#!/usr/bin/env bash

# This script generates the intial parameters.
#
# Inputs are a proof type and a sector size.
set -e

script_name=$(basename "${0}")

if [ "${#}" -ne 2 ]; then
    echo "Generate initial parameters."
    echo ""
    echo "Usage: ${script_name} {update|poseidon} {32|64}"
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

proof="${1}"
sector_size="${2}"

magenta='\u001b[35;1m'
red='\u001b[31;1m'
green='\u001b[32;1m'
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

if [[ ! -f './934fe8c.b2sums' ]]; then
    error '934fe8c.b2sums file is missing'
    exit 1
fi

log "generating intial parameters"

if [[ ${proof} == 'update' ]]; then
    phase1_file='phase1radix2m27'
    phase1_checksum='8a5d4e211e3a9817dcdc7d345a25338f261d0b52ab188661dfcb6bada9f2f5ac76925521621d8f87b5b680105973f4b48fb1ec68f65ebf8fdbccbd8d4891e6e9'
else
    phase1_file='phase1radix2m25'
    phase1_checksum='f8d00f1fb86b8b379284207966446e129dad109abb3aacb4eef795cacad83d64e94b3b40a635c353cbec45bfb9d3bc8314e13912216630d9975fd3b6485c17d1'
fi

if [[ ! -f ${phase1_file} ]]; then
    error "${phase1_file} is missing. Run: ./download_initial_generation_prereqs.sh ${proof} ${sector_size}"
    exit 1
fi
log 'verifying Phase 1 checksum'
echo "${phase1_checksum}  ${phase1_file}" | b2sum -c

# Generate initial Phase 2 params.
if [[ ${proof} == 'update' ]]; then
    proof_internal="update"
else
    proof_internal="updatep"
fi
initial_large="${proof_internal}_poseidon_${sector_size}gib_934fe8c_0_large"
if [[ ! -f $initial_large ]]; then
    log "generating initial params for ${proof}"
    ./phase2 new --${proof_internal} "--${sector_size}gib"

    # Rename initial params file to replace commit hash at time of
    # ceremony start with that of the current release (which should be
    # checked out), so verification will succeed.
    mv --no-clobber "${proof_internal}_poseidon_${sector_size}gib_$(git rev-parse --short=7 HEAD)_0_large" "${initial_large}"

    log "${green}success:${off} finished generating initial phase2 parameters for ${proof}"
else
    log "use previously generated inital params for ${proof}"
fi

# Verify checksum of generated initial params.
log 'verifying initial params checksum'
grep "${initial_large}" 934fe8c.b2sums | b2sum -c
