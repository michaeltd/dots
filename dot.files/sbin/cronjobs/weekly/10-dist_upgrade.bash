#!/bin/bash

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../../${BASH_SOURCE[0]##*\-}" "@security"
fi
