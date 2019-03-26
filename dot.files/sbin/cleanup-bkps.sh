#!/usr/bin/env bash
#
# de-clutter backups

# Load explicitly for non interactive shells
source /home/paperjam/.bashrc.d/.stdl/time.sh
source /home/paperjam/.bashrc.d/.stdl/string.sh

printf "= $(basename ${BASH_SOURCE[0]}) =\n"

BKPD="/mnt/el/Documents/BKP/LINUX"

FLISTS=( "sys.tar.gz.asc" "usr.tar.gz.asc" "enc.tar.gz.asc" )

if [[ -d "${BKPD}" ]]; then
  cd "${BKPD}"
  for (( x = 0; x < ${#FLISTS[@]}; x++ )); do
    declare -a FILES=( $(ls -t *.${FLISTS[$x]} 2> /dev/null) )
    for (( y = 0; y < ${#FILES[@]}; y++ )); do
      if (( y > 6 )); then
        FN="${FILES[$y]}"
        for PART in $(split "${FN}" .);do
          if epochtodatetime ${PART} &> /dev/null; then
            DP="${PART}"
            break
          fi
        done
        ETDT="$(epochtodatetime ${DP})"
        printf "${bold}${blue}will remove:${reset} %s, created: %s.\n" "${red}${FN}${reset}" "${underline}${green}${ETDT}${reset}${end_underline}"
        printf "${bold}rm -v %s${reset}: " "${red}${FN}${reset}"
        rm -v "${FN}"
      fi
    done
  done
else
  printf "${BKPD} not found\n" >&2
fi
