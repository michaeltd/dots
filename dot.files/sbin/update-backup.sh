#!/usr/bin/env bash
#
# ~/sbin/update-backup.sh
# Backup all the things

# 1. Loose aliases, 2. Check availability
nicec=$(which nice)
tarcm=$(which tar)
# Distro details.
source /etc/os-release
# Dirs
eldir="/mnt/el/Documents/bkps/linux"
# Backup/Exclude
incfl="/home/paperjam/.bkp.includes.txt"
excfl="/home/paperjam/.bkp.excludes.txt"
# Archive path/name/ext
archv="${eldir}/$(date +%s).dell.${ID}.${HOSTNAME}.tar.gz"

if [[ -d "${eldir}" && -r "${incfl}" && -r "${excfl}" && -x "${tarcm}" ]]; then
  printf "# BACKUP # ---------------------------------------------------------------------\n"
  "${nicec}" -n 19 "${tarcm}" --exclude-from="${excfl}" -cvzf "${archv}" $(cat ${incfl})
fi
