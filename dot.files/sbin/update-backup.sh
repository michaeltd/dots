#!/usr/bin/env bash
#
# ~/sbin/update-backup.sh
# Backup all the things

# Full path executables
nicec=$(which nice)
tarcm=$(which tar)

# Distro - hardware details.
source /etc/os-release
mid=$(cat "/etc/machine-id")

# Dirs
eldir="/mnt/el/Documents/bkps/linux"

# Backup/Exclude
incfl="/home/paperjam/.bkp.includes.txt"
excfl="/home/paperjam/.bkp.excludes.txt"

# Archive path/name/ext
archv="${eldir}/$(date +%s).${mid}.${ID}.${HOSTNAME}.tar.gz"

if [[ -d "${eldir}" && -r "${incfl}" && -r "${excfl}" ]]; then
  printf "# BACKUP # ---------------------------------------------------------------------\n"
  "${nicec}" -n 19 "${tarcm}" --exclude-from="${excfl}" -cvzf "${archv}" $(cat ${incfl})
fi
