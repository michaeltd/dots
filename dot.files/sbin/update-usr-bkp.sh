#!/usr/bin/env bash
#
# ~/sbin/update-usr-bkp.sh
# Backup users

# Full path executables
NICEC=$(which nice)
TARCM=$(which tar)
GPG2C=$(which gpg2)

ELDIR="/mnt/el/Documents/BKP/LINUX"

ARCHV="${ELDIR}/$(date +%s).$(date +%y%m%d).usr.tar.gz"

if [[ -d "${ELDIR}" ]]; then
    "${NICEC}" -n 19 \
    "${TARCM}" \
    --exclude="*/.git/*" \
    --exclude="*/.github/*" \
    --exclude="*/node_modules/*" \
    --exclude="*/Code/*" \
    --exclude="*/Atom/*" \
    --exclude="*/libreoffice/*" \
    -cz \
    /home/paperjam/git/ \
    /home/paperjam/Documents/ | \
    "${GPG2C}" --batch --yes --quiet --recipient "tsouchlarakis@gmail.com" --trust-model always --output "${ARCHV}.asc" --encrypt
fi
