#!/usr/bin/env bash

set -e

proof="$1"
sector_size="$2"
version='28'

contrib="$3"

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

if
    [[ $contrib == 'g1-only' ]]; then
    g1=true
fi
