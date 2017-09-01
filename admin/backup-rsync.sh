#!/bin/env /bin/bash

MAIL=paperjam@localhost

eldir="/mnt/el/linux/gentoo/"
dtdir="/mnt/DATA/linux/gentoo/"
bulst="/home/paperjam/.backup.txt"
tarlg="/var/log/tar.$(date +%y%m%d.%H%M%S).log"
rslog="/var/log/rsync.$(date +%y%m%d.%H%M%S).log"
archv="/mnt/el/linux/gentoo/${HOSTNAME}.${USER}.$(date +%y%m%d.%H%M%S).tar.gz"
fparv="/mnt/el/Documents/Videos/full.pj.$(date +%y%m%d.%H%M%S).tar.gz"
homdr="/home/paperjam/"

if [[ -d "${eldir}" && -r "${bulst}" ]]; then

  /bin/tar --exclude="*/opt/*" --exclude="*/node_modules/*" --exclude="*/ImapMail/*" -cvzf "${archv}" $(cat ${bulst}) >> "${tarlg}"

  #/bin/tar --exclude="*/opt/*" --exclude="*/node_modules/*" --exclude="*/ImapMail/*" -cvzf "${fparv}" "${homdr}" >> "${tarlg}"

fi

if [[ -d "${eldir}" && -d "${dtdir}" ]]; then

  /usr/bin/rsync --verbose --recursive --times --delete --exclude="*/Videos/*" /mnt/ELEMENTS/* /mnt/DATA/ >> "${rslog}"

fi
