#!/bin/bash

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && \
    "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../../${BASH_SOURCE[0]##*\-}" "@world"
