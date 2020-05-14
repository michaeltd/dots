#!/bin/bash
#
# ~/sbin/update_mirror.bash
# Update my data

# Unofficial Bash Strict Mode
set -u
IFS=$'\t\n'

echo -ne " -- ${BASH_SOURCE[0]##*/} --\n"

# Full path executables
nicec=( "nice" "-n" "19" )

rsncm=( "rsync" "--verbose" "--recursive" "--times" "--delete" "--exclude=*/MSOFT/*" )

elmnt="/mnt/el/Documents"

dtmnt="/mnt/data/Documents"

if [[ -d "${elmnt}" && -d "${dtmnt}" ]]; then
    time "${nicec[@]}" "${rsncm[@]}" /mnt/el/* /mnt/data/
else
    echo -ne "${elmnt} or ${dtmnt} not found\n" >&2
    exit 1
fi
