#!/usr/bin/env bash
#
# ~/sbin/update-mirror.sh
# Update my data

# Full path executables
nicec=$(which nice)
rsncm=$(which rsync)


elmnt="/mnt/el/PStart.xml"

dtmnt="/mnt/data/PStart.xml"

printf "= $(basename ${BASH_SOURCE[0]}) =\n"

if [[ -f "${elmnt}" && -f "${dtmnt}" ]]; then
    "${nicec}" -n 19 "${rsncm}" --verbose --recursive --times --delete --exclude="*/MSOFT/*" /mnt/el/* /mnt/data/


else
    printf "${elmnt} or ${dtmnt} not found" >&2
fi
