#!/bin/bash
#
# ~/sbin/update_mirror.sh
# Update my data

# Full path executables
NICEC=$(which nice)

RSNCM=$(which rsync)

ELMNT="/mnt/el/Documents"

DTMNT="/mnt/data/Documents"

printf " -- %s --\n" "$(basename ${BASH_SOURCE[0]})"

if [[ -d "${ELMNT}" && -d "${DTMNT}" ]]; then
  time "${NICEC}" -n 19 "${RSNCM}" --verbose --recursive --times --delete --exclude="*/MSOFT/*" /mnt/el/* /mnt/data/
else
  printf "${ELMNT} or ${DTMNT} not found\n" >&2
  exit 1
fi
