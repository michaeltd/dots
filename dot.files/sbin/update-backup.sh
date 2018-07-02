#!/usr/bin/env bash

nicec=$(which nice) # 1. Loose aliases, 2. Check availability
tarcm=$(which tar)

source /etc/os-release # Distro details.

eldir="/mnt/el/Documents/bkps/linux" # Dirs

incfl="/home/paperjam/.bkp.includes.txt" # Backup/Exclude
excfl="/home/paperjam/.bkp.excludes.txt"

archv="${eldir}/$(date +%s).dell.${ID}.${HOSTNAME}.tar.gz" # Archive path/name

if [[ -d "${eldir}" && -r "${incfl}" && -r "${excfl}" && -x "${tarcm}" ]]; then
  printf "# BACKUP # ---------------------------------------------------------------------\n"
  "${nicec}" -n 19 "${tarcm}" --exclude-from="${excfl}" -cvzf "${archv}" $(cat ${incfl})
fi
