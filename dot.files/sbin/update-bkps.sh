#!/bin/bash
#
# ~/sbin/update-bkp.sh
# Backup sensitive files, user files, system

# Full path executables, no aliases
declare -a NICEC=( $(which nice) -n 19 ) TARCM=( $(which tar) --create --gzip ) GPG2C=( $(which gpg2) --batch --yes --quiet --recipient "tsouchlarakis@gmail.com" --trust-model always --output )

ELDIR="/mnt/el/Documents/BKP/LINUX" UTB="paperjam" SSIG="= $(basename ${BASH_SOURCE[0]}) ="

declare -a ENC=( "/home/${UTB}/.gnupg/*" "/home/${UTB}/.ssh/*" "/home/${UTB}/.ngrok2/*" "/home/${UTB}/.config/filezilla/*" "/home/${UTB}/.config/hexchat/*" "/home/${UTB}/.putty/*" ) USR=( "/home/${UTB}/git/" "/home/${UTB}/Documents/" ) SYS=( "/boot/grub/themes/" "/boot/grub/grub.cfg" "/etc/" "/usr/share/xsessions/" "/usr/share/WindowMaker/" "/var/www/" ) EXC=( "*/.idea/*" "*/.git/*" "*/.github/*" "*/node_modules/*" "*/atom/*" "*/code/*" "*/vscodium/*" "*/sublime-text-3/*" "*/libreoffice/*" "*/scrap/*" "*/playground/e16/*" ) ARCHV=("enc.tar.gz" "usr.tar.gz" "sys.tar.gz")

for x in "${EXC[@]}"; do
  EXL+=("--exclude=${x}")
done

BKP=( ENC[@] USR[@] SYS[@] )

printf "%s\n" "${SSIG}"

if [[ -d "${ELDIR}" && "${EUID}" -eq "0" ]]; then
  for ((i = 0; i < ${#ARCHV[@]}; i++ )); do
    EP="$(date +%s)" DT="$(date +%y%m%d)";
    if [[ ${ARCHV[$i]} =~ enc ]]; then
      ARCFL="${ELDIR}/${DT}.${EP}.${ARCHV[$i]}"
      time ${NICEC[@]} ${TARCM[@]} --file "${ARCFL}" ${EXL[@]} ${!BKP[$i]}
    else
      ENCFL="${ELDIR}/${DT}.${EP}.${ARCHV[$i]}.asc"
      time ${NICEC[@]} ${TARCM[@]} ${EXL[@]} ${!BKP[$i]} | "${GPG2C[@]}" "${ENCFL}" --encrypt
    fi
  done
else
  printf "%s not found or root access requirements not met\n" "${ELDIR}" >&2
  exit 1
fi
