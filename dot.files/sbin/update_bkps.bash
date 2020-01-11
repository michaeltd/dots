#!/bin/bash
#
# ~/sbin/update_bkps.bash
# Backup sensitive files, user files, system

declare ELDIR="/mnt/el/Documents/BKP/LINUX" UTB="paperjam"

declare EXC="/home/${UTB}/.bkp.exclude"

# Full path executables, no aliases
declare -a \
        NICEC=( "$(type -P nice)" "-n" "19" ) \
        TARCM=( "$(type -P tar)" "--create" "--gzip" "--exclude-from=${EXC}" "--exclude-backups" "--one-file-system" ) \
        GPG2C=( "$(type -P gpg2)" "--batch" "--yes" "--quiet" "--recipient" \
                  "tsouchlarakis@gmail.com" "--trust-model" "always" "--output" )

#shellcheck disable=SC2034
declare -a \
        ENC=( "/home/${UTB}/.gnupg/." \
                "/home/${UTB}/.ssh/." \
                "/home/${UTB}/.ngrok2/." \
                "/home/${UTB}/.config/filezilla/." \
                "/home/${UTB}/.config/hexchat/." \
                "/home/${UTB}/.putty/." ) \
        USR=( "/home/${UTB}/git/." \
                "/home/${UTB}/Documents/." ) \
        SYS=( "/boot/grub/." \
                "/etc/." \
                "/usr/share/xsessions/." \
                "/usr/share/WindowMaker/." \
                "/var/www/." )

declare -a BKP=( ENC[@] USR[@] SYS[@] ) \
        ARCHV=( "enc.tar.gz" "usr.tar.gz" "sys.tar.gz" )

declare EP="$(date +%s)" DT="$(date +%Y%m%d)" TM="$(date +%H%M%S)" 

echo -ne " -- $(basename "${BASH_SOURCE[0]}") --\n"

if [[ -d "${ELDIR}" && "${EUID}" -eq "0" ]]; then
  for ((i = 0; i < ${#ARCHV[*]}; i++ )); do
    if [[ ${ARCHV[$i]} =~ ^enc.* ]]; then
      ARCFL="${ELDIR}/${HOSTNAME}.${DT}.${TM}.${EP}.${ARCHV[$i]}"
      #shellcheck disable=SC2086
      time "${NICEC[@]}" "${TARCM[@]}" "--file" "${ARCFL}" ${!BKP[$i]}
    else
      ENCFL="${ELDIR}/${HOSTNAME}.${DT}.${TM}.${EP}.${ARCHV[$i]}.pgp"
      #shellcheck disable=SC2086
      time "${NICEC[@]}" "${TARCM[@]}" ${!BKP[$i]} | "${GPG2C[@]}" "${ENCFL}" "--encrypt"
    fi
  done
else
  echo -ne "${ELDIR} not found or root access requirements not met.\n" >&2
  exit 1
fi
