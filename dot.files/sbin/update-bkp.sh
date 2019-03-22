#!/usr/bin/env bash
#
# ~/sbin/update-bkp.sh
# Backup users

# Full path executables, no aliases
NICEC=$(which nice) TARCM=$(which tar) GPG2C=$(which gpg2)

ELDIR="/mnt/el/Documents/BKP/LINUX"

DTPRT="$(date +%s).$(date +%y%m%d)"

UTB="paperjam"

ENC=( "/home/${UTB}/.gnupg/*" "/home/${UTB}/.ssh/*" "/home/${UTB}/.ngrok2/*" "/home/${UTB}/.config/filezilla/*" "/home/${UTB}/.config/hexchat/*" )
USR=( "/home/${UTB}/git/" "/home/${UTB}/Documents/" )
SYS=( "/boot/grub/themes/" "/boot/grub/grub.cfg" "/etc/" "/usr/share/xsessions/" "/usr/share/WindowMaker/" "/var/www/" )
BKP=( ENC[@] USR[@] SYS[@] )

EXC=( "*/.git/*" "*/.github/*" "*/node_modules/*" "*/atom/*" "*/code/*" "*/vscodium/*" "*/sublime-text-3/*" "*/libreoffice/*" "*/scrap/*" )
for x in "${EXC[@]}"; do
  EXL+=("--exclude=${x}")
done

ARCHV=("${ELDIR}/${DTPRT}.enc.tar.gz" "${ELDIR}/${DTPRT}.usr.tar.gz" "${ELDIR}/${DTPRT}.sys.tar.gz")

printf "= $(basename ${BASH_SOURCE[0]}) =\n"

if [[ -d "${ELDIR}" ]]; then
  for ((i = 0; i < ${#ARCHV[@]}; i++ )); do
    "${NICEC}" -n 19 "${TARCM}" -cz ${EXL[@]} ${!BKP[$i]} | \
    "${GPG2C}" --batch --yes --quiet --recipient "tsouchlarakis@gmail.com" --trust-model always --output "${ARCHV[$i]}.asc" --encrypt
  done
else
  printf "${ELDIR} not found" >&2
fi
