#!/bin/bash
#
# ~/bin/cronjobs.bash
# gather cronjobs for use with a familiar environment (/bin/bash)

usage="Usage: $(basename "${BASH_SOURCE[0]}") [-(-a)larm] | [-(-b)ackup]"

alarm(){
    # 00 08 * * 1-5 cvlc --random file:///mnt/data/Documents/Music/Stanley-Clarke/ file:///mnt/data/Documents/Music/Marcus-Miller/ file:///mnt/data/Documents/Music/Jaco-Pastorius/ file:///mnt/data/Documents/Music/Esperanza-Spalding/ file:///mnt/data/Documents/Music/Mark-King/Level\ Best/
    cvlc --random file:///mnt/data/Documents/Music/Stanley-Clarke/ file:///mnt/data/Documents/Music/Marcus-Miller/ file:///mnt/data/Documents/Music/Jaco-Pastorius/ file:///mnt/data/Documents/Music/Esperanza-Spalding/ file:///mnt/data/Documents/Music/Mark-King/Level\ Best/
}

backup(){
    # 00 19 * * * mkdir -p "/mnt/el/Documents/BKP/LINUX/${USER}" && nice -n 9 tar -cz --exclude-from="${HOME}/.exclude" --exclude-backups --one-file-system /home/${USER}/. |gpg2 --batch --yes --quiet --recipient "tsouchlarakis@gmail.com" --trust-model always --output "/mnt/el/Documents/BKP/LINUX/${USER}/${USER}.tar.gz.pgp" --encrypt
    local bkpt="/mnt/el/Documents/BKP/LINUX/${USER}" bkpd="${HOME}" \
          xcldf="${HOME}/.exclude" rcpnt="tsouchlarakis@gmail.com"
    local outfl="${bkpt}/$(date +%y%m%d%H%M%S).${USER}.tar.gz.pgp" \
          LS="$(type -P ls)"
    # Just in case
    mkdir -p "${bkpt}"
    # Bkp & encrypt things.
    nice -n 9 tar -cz --exclude-from="${xcldf}" \
         --exclude-backups --one-file-system "${bkpd}"/. \
        | gpg2 --batch --yes --quiet --recipient "${rcpnt}" \
               --trust-model always --output "${outfl}" --encrypt
    # Keep two most recent bkps
    IFS=$'\n'
    local -a bkpa=( $("${LS}" -A1c "${bkpt}"/*.pgp) )
    for (( i = 2; i < ${#bkpa[*]} ; i++ ))
    do rm -v "${bkpa[$i]}"
    done
}

if [[ -z "${1}" ]]; then
    echo "${usage}" >&2; exit 1
else
    while [[ -n "${1}" ]]; do
        case "${1}" in
            "-a"|"--alarm") alarm;;
            "-b"|"--backup") backup;;
            *) echo "${usage}" >&2; exit 1;;
        esac
        shift
    done
fi
