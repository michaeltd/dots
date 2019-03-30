#!/usr/bin/env bash
#
# ~/sbin/update-bkp.sh
# Backup users

# Full path executables, no aliases
NICEC=$(which nice) TARCM=$(which tar) GPG2C=$(which gpg2)

ELDIR="/mnt/el/Documents/BKP/LINUX" UTB="paperjam" SSIG="= $(basename ${BASH_SOURCE[0]}) ="

ENC=( "/home/${UTB}/.gnupg/*" "/home/${UTB}/.ssh/*" "/home/${UTB}/.ngrok2/*" "/home/${UTB}/.config/filezilla/*" "/home/${UTB}/.config/hexchat/*" "/home/${UTB}/.putty/*" )
USR=( "/home/${UTB}/git/" "/home/${UTB}/Documents/" )
SYS=( "/boot/grub/themes/" "/boot/grub/grub.cfg" "/etc/" "/usr/share/xsessions/" "/usr/share/WindowMaker/" "/var/www/" )

BKP=( ENC[@] USR[@] SYS[@] )

EXC=( "*/.git/*" "*/.github/*" "*/node_modules/*" "*/atom/*" "*/code/*" "*/vscodium/*" "*/sublime-text-3/*" "*/libreoffice/*" "*/scrap/*" )
for x in "${EXC[@]}"; do
  EXL+=("--exclude=${x}")
done

ARCHV=("enc.tar.gz" "usr.tar.gz" "sys.tar.gz")

printf "${SSIG}\n"

if [[ -d "${ELDIR}" && "${EUID}" -eq "0" ]]; then
    for ((i = 0; i < ${#ARCHV[@]}; i++ )); do
        EP="$(date +%s)" DT="$(date +%y%m%d)"; ENCFL="${ELDIR}/${DT}.${EP}.${ARCHV[$i]}.asc"
        time "${NICEC}" -n 19 "${TARCM}" -cz ${EXL[@]} ${!BKP[$i]} | \
        "${GPG2C}" --batch --yes --quiet --recipient "tsouchlarakis@gmail.com" --trust-model always --output "${ENCFL}" --encrypt
    done
else
    printf "${ELDIR} not found or root access requirements not met\n" >&2
fi
