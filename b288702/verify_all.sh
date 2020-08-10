#!/usr/bin/env bash

set -e

proof="$1"
sector_size="$2"
version='28'

magenta='\u001b[35;1m'
red='\u001b[31;1m'
green='\u001b[32;1m'
off='\u001b[0m'

function log() {
    echo -e "${magenta}[phase2_verify_all.sh]${off} $1"
}

function error() {
    echo -e "${magenta}[phase2_verify_all.sh] ${red}error:${off} $1"
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

# Generate initial phase2 params.
log 'generating initial params'
./phase2 new --${proof} --${sector_size}gib

initial_large="${proof}_poseidon_${sector_size}gib_b288702_0_large"
mv ${proof}_poseidon_${sector_size}gib_8e7c5a0_0_large $initial_large

# Verify checksum of generated initial params.
log 'verifying initial params checksum'
grep $initial_large b288702.b2sums | b2sum -c

# Verify phase2 contributions.
for i in $(seq 1 $n); do
    log "verifying contribution: ${i}"

    file="${proof}_poseidon_${sector_size}gib_b288702_${i}_small_raw"
    if [[ ! -f ${file} ]]; then
        log "downloading params: ${file}"
        curl --progress-bar -O https://trusted-setup.s3.amazonaws.com/phase2-mainnet/${file}
        log 'verifying downloaded params checksum'
        grep $file b288702.b2sums | b2sum -c
    fi

    contrib="${file}.contrib"
    if [[ ! -f ${contrib} ]]; then
        log "downloading contrib: ${contrib}"
        curl --progress-bar -O https://trusted-setup.s3.amazonaws.com/phase2-mainnet/${contrib}
    fi

    ./phase2 verify $file
    log "${green}success:${off} verified contribution: ${i}"
    [[ $i -gt 1 ]] && rm ${proof}_poseidon_${sector_size}gib_b288702_$((i-1))_small_raw{,.contrib}
done

final_raw="$file"
final_nonraw=$(echo $final_raw | sed 's/_raw$//')
final_large=$(echo $final_nonraw | sed 's/small$/large/')

# Convert phase2 params into Groth16 keys.
log 'reformatting final params'
_convert_output="$(./phase2 convert $final_raw)"

log 'merging final params'
_merge_output="$(./phase2 merge $final_nonraw $initial_large)"

log 'extracting groth16 keys'
split_output="$(./phase2 split-keys $final_large)"
vk_file=$(echo -e "$split_output" | grep -o "v${version}-.*\.vk")
params_file=$(echo -e "$split_output" | grep -o "v${version}-.*\.params")
contribs_file=$(echo -e "$split_output" | grep -o "v${version}-.*\.contribs")

# Verify groth keys checksums.
log 'verifying .vk checksum'
vk_digest=$(b2sum $vk_file | head -c 32)
vk_digest_json=$(grep -A 2 $vk_file filecoin-proofs/parameters.json | grep 'digest' | tr -d '[:punct:]' | awk '{print $2}' | head -c 32)

if [[ $vk_digest == $vk_digest_json ]]; then
    log "${green}success:${off} .vk digests match"
else
    error '.vk digests do not match'
    exit 1
fi

# Verify that the .vk file is extracted from the trusted setup phase2 file
log 'verifying .vk is a subset of phase2'
vk_size=$(wc --bytes < $vk_file)
final_large_vk_digest=$(head --bytes $vk_size $final_large | b2sum | head -c 32)
if [[ $vk_digest == $final_large_vk_digest ]]; then
    log "${green}success:${off} .vk is a subset of phase2"
else
    error '.vk is not a subset of phase2'
    exit 1
fi

# Verify .params checksum.
log 'verifying .params checksum'
params_digest=$(b2sum $params_file | head -c 32)
params_digest_json=$(grep -A 2 $params_file filecoin-proofs/parameters.json | grep 'digest' | tr -d '[:punct:]' | awk '{print $2}' | head -c 32)

if [[ $params_digest == $params_digest_json ]]; then
    log "${green}success:${off} .params digests match"
else
    error '.params digests do not match'
    exit 1
fi

# Verify that the trusted setup phase2 file can be re-assembled from its parts
log 'verifying .params is a subset of phase2'
combined_digest=$(cat $params_file $contribs_file | b2sum | head --bytes 32)
final_large_digest=$(b2sum $final_large | head --bytes 32)
if [[ $combined_digest == $final_large_digest ]]; then
    log "${green}success:${off} .params is a subset of phase2"
else
    error '.params is not a subset of phase2'
    exit 1
fi

log "${green}success:${off} finished verifying phase2 parameters"
