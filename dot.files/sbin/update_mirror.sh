#!/bin/bash
#
# ~/sbin/update_mirror.sh
# Update my data

# Full path executables
NICEC="$(command -v nice)"

RSNCM="$(command -v rsync)"

ELMNT="/mnt/el/Documents"

DTMNT="/mnt/data/Documents"

echo -ne " -- $(basename "${BASH_SOURCE[0]}") --\n"

if [[ -d "${ELMNT}" && -d "${DTMNT}" ]]; then
  time "${NICEC}" -n 19 "${RSNCM}" --verbose --recursive --times --delete --exclude="*/MSOFT/*" /mnt/el/* /mnt/data/
else
  echo -ne "${ELMNT} or ${DTMNT} not found\n" >&2
  exit 1
fi
