#!/usr/bin/env bash
#
# ~/sbin/update-mirror.sh
# Update my data

nicec=$(which nice) # 1. Loose aliases, 2. Check availability
rsncm=$(which rsync)

elmnt="/mnt/el/PStart.xml" # Do we have mount points?
dtmnt="/mnt/data/PStart.xml"

if [[ -f "${elmnt}" && -f "${dtmnt}" && -x "${rsncm}" ]]; then
  printf "# MIRROR # ---------------------------------------------------------------------\n"
  "${nicec}" -n 19 "${rsncm}" --verbose --recursive --times --delete --exclude="*/MSOFT/*" /mnt/el/* /mnt/data/
fi
