#!/usr/bin/env bash
#
# ~/sbin/update-sys-bkp.sh
# Backup system

# Full path executables
NICEC=$(which nice)
TARCM=$(which tar)
GPG2C=$(which gpg2)

ELDIR="/mnt/el/Documents/BKP/LINUX"

ARCHV="${ELDIR}/$(date +%s).$(date +%y%m%d).sys.tar.gz"

if [[ -d "${ELDIR}" ]]; then
    "${NICEC}" -n 19 \
    "${TARCM}" -cz \
        /boot/grub/themes/ \
        /boot/grub/grub.cfg \
        /etc/ \
        /usr/share/xsessions/ \
        /usr/share/WindowMaker/ \
        /var/www/ | \
    "${GPG2C}" --batch --yes --quiet --recipient "tsouchlarakis@gmail.com" --trust-model always --output "${ARCHV}.asc" --encrypt
fi
