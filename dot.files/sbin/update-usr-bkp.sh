#!/usr/bin/env bash
#
# ~/sbin/update-usr-bkp.sh
# Backup users

# Full path executables
NICEC=$(which nice)
TARCM=$(which tar)
GPG2C=$(which gpg2)

ELDIR="/mnt/el/Documents/BKP/LINUX" BKPXC="${HOME}/.bkp.excludes.txt"

ARCHV="${ELDIR}/$(date +%s).$(date +%y%m%d).usr.tar.gz"

if [[ -d "${ELDIR}" && -r "${BKPXC}" ]]; then
    printf "${BASH_SOURCE[0]}\n"
    "${NICEC}" -n 19 \
    "${TARCM}" --exclude-from="${BKPXC}" -cz /home/paperjam/git/ /home/paperjam/Documents/ | \
    "${GPG2C}" --batch --yes --quiet --recipient "tsouchlarakis@gmail.com" --trust-model always --output "${ARCHV}.asc" --encrypt
fi
