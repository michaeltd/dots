#!/bin/bash

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    bash_file="${BASH_SOURCE[0]##*/}"
    bash_file="${bash_file:3}"
    "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../../${bash_file}" "@security"
fi
