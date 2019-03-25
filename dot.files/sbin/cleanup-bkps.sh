#!/usr/bin/env bash
#
# de-clutter backups

# Load explicitly for non interactive shells
source /home/paperjam/.bashrc.d/time.sh
source /home/paperjam/.bashrc.d/string.sh

printf "= $(basename ${BASH_SOURCE[0]}) =\n"

BKPD="/mnt/el/Documents/BKP/LINUX"

FLISTS=( "sys.tar.gz.asc" "usr.tar.gz.asc" "enc.tar.gz.asc" )

if [[ -d "${BKPD}" ]]; then
  cd "${BKPD}"
  for (( x = 0; x < ${#FLISTS[@]}; x++ )); do
    declare -a files=( $(ls -t *.${FLISTS[$x]}) ) # Sorting by mod time "-t", so no LC_LOCALE change required
    for (( y = 0; y < ${#files[@]}; y++ )); do
      if (( y > 6 )); then
        fn="${files[$y]}"
        for part in $(split $fn .);do
          if epochtodatetime ${part}; then
            dp="${part}"
            break
          fi
        done
        # dp="${fn:7:10}"
        etdt="$(epochtodatetime ${dp})"
        printf "${bold}${blue}will remove:${reset} %s, created: %s.\n" "${red}${fn}${reset}" "${underline}${green}${etdt}${reset}${end_underline}"
        printf "${bold}rm -v %s${reset}: " "${red}${fn}${reset}"
        rm -v "${fn}"
      fi
    done
  done
else
  printf "${BKPD} not found\n" >&2
fi
