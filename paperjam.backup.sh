#!/bin/sh

tar \
    --create \
    --verbose \
    --preserve-permissions \
    --gzip \
    --file /mnt/ELEMENTS/linux/gentoo/"${HOSTNAME}"."${USER}".${1}.`date +%y%m%d%H%M%S`.tar.gz \
    $(cat /home/paperjam/.backup.${1}.txt)
