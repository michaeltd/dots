#!/bin/bash
#
# ~/sbin/update_mirror.bash
# Update my data

# Full path executables
NICEC=( "$(type -P nice)" "-n" "19" )

RSNCM=( "$(type -P rsync)" "--verbose" "--recursive" "--times" "--delete" "--exclude=*/MSOFT/*" )

ELMNT="/mnt/el/Documents"

DTMNT="/mnt/data/Documents"

echo -ne " -- $(basename "${BASH_SOURCE[0]}") --\n"

if [[ -d "${ELMNT}" && -d "${DTMNT}" ]]; then
    time "${NICEC[@]}" "${RSNCM[@]}" /mnt/el/* /mnt/data/
else
    echo -ne "${ELMNT} or ${DTMNT} not found\n" >&2
    exit 1
fi
