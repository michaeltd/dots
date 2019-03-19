#!/usr/bin/env bash
#
# ~/sbin/update-usr-bkp.sh
# Backup users

# Full path executables
NICEC=$(which nice)
TARCM=$(which tar)
GPG2C=$(which gpg2)

ELDIR="/mnt/el/Documents/BKP/LINUX" BKPXC="/home/paperjam/.bkp.excludes.txt"

ARCHV="${ELDIR}/$(date +%s).$(date +%y%m%d).usr.tar.gz"

printf "= $(basename ${BASH_SOURCE[0]}) =\n"

if [[ -d "${ELDIR}" && -r "${BKPXC}" ]]; then
    "${NICEC}" -n 19 \
    "${TARCM}" --exclude-from="${BKPXC}" -cz /home/paperjam/git/ /home/paperjam/Documents/ | \
    "${GPG2C}" --batch --yes --quiet --recipient "tsouchlarakis@gmail.com" --trust-model always --output "${ARCHV}.asc" --encrypt
else
    printf "${ELDIR} not found or ${BKPXC} not readable." >&2
fi
