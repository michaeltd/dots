#!/usr/bin/env /bin/bash
MAIL=paperjam@localhost
# Date stamp
dtstp=$(date +%y%m%d.%H%M%S)
# Utils
nice=$(which nice)
tarcm=$(which tar)
rsncm=$(which rsync)
# Hardware
machn="dell"
# Dirs
mntdr="/mnt"
elmnt="/el"
dtmnt="/data"
locdr="/Documents/bkps/linux"
eldir="${mntdr}${elmnt}${locdr}"
dtdir="${mntdr}${dtmnt}${locdr}"
# Profile
homdr="/home/paperjam"
# Backup/Exclude
bulst="${homdr}/.backup.txt"
excfl="${homdr}/.exclude.txt"
# Logs
tarlg="/var/log/tar.${dtstp}.log"
rslog="/var/log/rsync.${dtstp}.log"
# Archive
archv="${eldir}/${dtstp}.${machn}.${HOSTNAME}.tar.gz"

if [[ -d "${eldir}" && -r "${bulst}" && -r "${excfl}"  && -x "${tarcm}" ]]; then
  "${nice}" -n 15 "${tarcm}" --exclude-from="${excfl}" -cvzf "${archv}" $(cat ${bulst}) >> "${tarlg}" 2>&1
fi

if [[ -d "${eldir}" && -d "${dtdir}" && -x "${rsncm}" ]]; then
  "${nice}" -n 15 "${rsncm}" --verbose --recursive --times --delete --exclude="*/XNXX/*" /mnt/el/* /mnt/data/ >> "${rslog}" 2>&1
fi
