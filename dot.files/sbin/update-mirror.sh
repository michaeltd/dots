#!/usr/bin/env bash
#
# ~/sbin/update-mirror.sh
# Update my data

# Full path executables
nicec=$(which nice)
rsncm=$(which rsync)

# Mount points.
elmnt="/mnt/el/PStart.xml"
dtmnt="/mnt/data/PStart.xml"

if [[ -f "${elmnt}" && -f "${dtmnt}" ]]; then
    printf "${BASH_SOURCE[0]}\n"
    "${nicec}" -n 19 "${rsncm}" --verbose --recursive --times --delete --exclude="*/MSOFT/*" /mnt/el/* /mnt/data/
fi
