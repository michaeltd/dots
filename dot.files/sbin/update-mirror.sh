#!/usr/bin/env bash
#
# ~/sbin/update-mirror.sh
# Update my data

# Full path executables
NICEC=$(which nice) RSNCM=$(which rsync) ELMNT="/mnt/el/Documents" DTMNT="/mnt/data/Documents"

printf "= $(basename ${BASH_SOURCE[0]}) =\n"

if [[ -d "${ELMNT}" && -d "${DTMNT}" ]]; then
    time "${NICEC}" -n 19 "${RSNCM}" --verbose --recursive --times --delete --exclude="*/MSOFT/*" /mnt/el/* /mnt/data/
else
    printf "${ELMNT} or ${DTMNT} not found\n" >&2
fi
