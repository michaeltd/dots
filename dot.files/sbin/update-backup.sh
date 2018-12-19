#!/usr/bin/env bash
#
# ~/sbin/update-backup.sh
# Backup all the things

# Full path executables
NICEC=$(which nice)
TARCM=$(which tar)

# Distro - hardware details.
source /etc/os-release
MID=$(cat "/etc/machine-id")

# Dirs
ELDIR="/mnt/el/Documents/bkps/linux"

# Backup/Exclude
INCFL="/home/paperjam/.bkp.includes.txt"
EXCFL="/home/paperjam/.bkp.excludes.txt"

# Archive path/name/ext
ARCHV="${ELDIR}/$(date +%s).$(date +%y%m%d).${MID}.${ID}.${HOSTNAME}.tar.gz"

if [[ -d "${ELDIR}" && -r "${INCFL}" && -r "${EXCFL}" ]]; then
  printf "# BACKUP # ---------------------------------------------------------------------\n"
  "${NICEC}" -n 19 "${TARCM}" --exclude-from="${EXCFL}" -cvzf "${ARCHV}" $(cat ${INCFL})
fi
