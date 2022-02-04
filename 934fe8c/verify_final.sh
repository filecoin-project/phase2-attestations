#!/usr/bin/env bash

# This script verifies that the final parameters are the same as the final
# contribution.
#
# Inputs are a proof type and a sector size and the contribution to verify.
set -e

script_name=$(basename "$0")

if [ "${#}" -ne 2 ]; then
    echo "Verify that the final parameters match the final contribution."
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

proof="$1"
sector_size="$2"
version='28'

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

# The number of Phase 2 contributions.
if [[ ${proof} == 'update' ]]; then
    n='15'
else
    n='12'
fi

if [[ ! -f './parameters.json' ]]; then
    error 'parameters.json file is missing'
    exit 1
fi

if [[ ${proof} == 'update' ]]; then
    file_prefix="update_poseidon_${sector_size}gib_934fe8c"
else
    file_prefix="updatep_poseidon_${sector_size}gib_934fe8c"
fi

initial_large="${file_prefix}_0_large"
file="${file_prefix}_${n}_small"
final_large=${file/%small/large}

log 'merging final params'
_merge_output="$(./phase2 merge "${file}" "${initial_large}")"

log 'extracting groth16 keys'
split_output="$(./phase2 split-keys "${final_large}")"
vk_file=$(echo -e "$split_output" | grep -o "v${version}-.*\.vk")
params_file=$(echo -e "$split_output" | grep -o "v${version}-.*\.params")
contribs_file=$(echo -e "$split_output" | grep -o "v${version}-.*\.contribs")

# Verify groth keys checksums.
log 'verifying .vk checksum'
vk_digest=$(b2sum "${vk_file}" | head -c 32)
vk_digest_json=$(grep -A 2 "${vk_file}" parameters.json | grep 'digest' | tr -d '[:punct:]' | awk '{print $2}' | head -c 32)

if [[ ${vk_digest} == "${vk_digest_json}" ]]; then
    log "${green}success:${off} .vk digests match"
else
    error '.vk digests do not match'
    exit 1
fi

# Verify that the .vk file is extracted from the trusted setup phase2 file
log 'verifying .vk is a subset of phase2'
vk_size=$(wc --bytes < "${vk_file}")
final_large_vk_digest=$(head --bytes "${vk_size}" "${final_large}" | b2sum | head -c 32)
if [[ ${vk_digest} == "${final_large_vk_digest}" ]]; then
    log "${green}success:${off} .vk is a subset of phase2"
else
    error '.vk is not a subset of phase2'
    exit 1
fi

# Verify .params checksum.
log 'verifying .params checksum'
params_digest=$(b2sum "${params_file}" | head -c 32)
params_digest_json=$(grep -A 2 "${params_file}" parameters.json | grep 'digest' | tr -d '[:punct:]' | awk '{print $2}' | head -c 32)

if [[ ${params_digest} == "${params_digest_json}" ]]; then
    log "${green}success:${off} .params digests match"
else
    error '.params digests do not match'
    exit 1
fi

# Verify that the trusted setup phase2 file can be re-assembled from its parts
log 'verifying .params is a subset of phase2'
combined_digest=$(cat "${params_file}" "${contribs_file}" | b2sum | head --bytes 32)
final_large_digest=$(b2sum "${final_large}" | head --bytes 32)
if [[ ${combined_digest} == "${final_large_digest}" ]]; then
    log "${green}success:${off} .params is a subset of phase2"
else
    error '.params is not a subset of phase2'
    exit 1
fi

log "${green}success:${off} finished verifying phase2 final parameters"
