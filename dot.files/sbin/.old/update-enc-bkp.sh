#!/usr/bin/env bash
#
# ~/sbin/update-enc-bkp.sh
# Backup users

# Full path executables
NICEC=$(which nice)
TARCM=$(which tar)
GPG2C=$(which gpg2)

ELDIR="/mnt/el/Documents/BKP/LINUX"

ARCHV="${ELDIR}/$(date +%s).$(date +%y%m%d).enc.tar.gz"

printf "= $(basename ${BASH_SOURCE[0]}) =\n"

if [[ -d "${ELDIR}" ]]; then
    "${NICEC}" -n 19 \
    "${TARCM}" -czf "${ARCHV}"  /home/paperjam/.gnupg/* /home/paperjam/.ssh/* /home/paperjam/.ngrok2/* /home/paperjam/.config/filezilla/* /home/paperjam/.config/hexchat/*

else
    printf "${ELDIR} not found" >&2
fi
