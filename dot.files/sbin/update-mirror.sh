#!/usr/bin/env bash
#
# ~/sbin/update-mirror.sh
# Update my data

# Full path executables
NICEC=$(which nice) RSNCM=$(which rsync) ELMNT="/mnt/el/PStart.xml" DTMNT="/mnt/data/PStart.xml"

printf "= $(basename ${BASH_SOURCE[0]}) =\n"

if [[ -f "${ELMNT}" && -f "${DTMNT}" ]]; then
    "${NICEC}" -n 19 "${RSNCM}" --verbose --recursive --times --delete --exclude="*/MSOFT/*" /mnt/el/* /mnt/data/
else
    printf "${ELMNT} or ${DTMNT} not found\n" >&2
fi
