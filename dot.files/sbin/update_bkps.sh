#!/bin/bash
#
# ~/sbin/update_bkp.sh
# Backup sensitive files, user files, system

declare ELDIR="/mnt/el/Documents/BKP/LINUX"

declare UTB="paperjam"

# Full path executables, no aliases
declare -a NICEC=( "$(type -P nice)" "-n" "19" ) \
        TARCM=("$(type -P tar)" "--create" "--gzip" ) \
        GPG2C=( "$(type -P gpg2)" "--batch" "--yes" "--quiet" "--recipient" "tsouchlarakis@gmail.com" "--trust-model" "always" "--output" )

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

declare -a BKP=( ENC[@] USR[@] SYS[@] ) ARCHV=( "enc.tar.gz" "usr.tar.gz" "sys.tar.gz" )

declare -a EXC=( "*/.idea/*" "*/.git/*" "*/.github/*" "*/node_modules/*" "*/atom/*" "*/code/*" "*/vscodium/*" "*/sublime-text-3/*" "*/libreoffice/*" "*/scrap/*" "*/playground/e16/*" )

for x in "${EXC[@]}"; do
  EXL+=( "--exclude=${x}" )
done

printf " -- %s --\n" "$(basename "${BASH_SOURCE[0]}")"

if [[ -d "${ELDIR}" && "${EUID}" -eq "0" ]]; then
  for ((i = 0; i < ${#ARCHV[*]}; i++ )); do
    EP="$(date +%s)" DT="$(date +%y%m%d)"

    if [[ ${ARCHV[$i]} =~ enc ]]; then
      ARCFL="${ELDIR}/${DT}.${EP}.${ARCHV[$i]}"
      #shellcheck disable=SC2086
      time "${NICEC[@]}" "${TARCM[@]}" --file "${ARCFL}" "${EXL[@]}" ${!BKP[$i]}
    else
      ENCFL="${ELDIR}/${DT}.${EP}.${ARCHV[$i]}.pgp"
      #shellcheck disable=SC2086
      time "${NICEC[@]}" "${TARCM[@]}" "${EXL[@]}" ${!BKP[$i]} | "${GPG2C[@]}" "${ENCFL}" --encrypt
    fi
  done
else
  echo -ne "${ELDIR} not found or root access requirements not met\n" >&2
  exit 1
fi
