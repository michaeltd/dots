#!/usr/bin/env -S bash --norc --noprofile
#shellcheck shell=bash disable=SC1008,SC2096
#

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\t\n'

echo -ne " -- ${BASH_SOURCE[0]##*/} --\n"

# Full path executables
nicec=( "nice" "-n" "19" )

rsncm=( "rsync" "--verbose" "--recursive" "--times" "--delete" "--exclude=*/Videos/*" )

dtmnt="/mnt/data/Documents"

elmnt="/mnt/el/Documents"

if [[ -d "${dtmnt}" && -d "${elmnt}" ]]; then
    time "${nicec[@]}" "${rsncm[@]}" "${dtmnt}"/* "${elmnt}"
else
    echo -ne "${dtmnt} or ${elmnt} not found\n" >&2
    exit 1
fi
