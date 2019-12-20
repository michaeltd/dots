#!/bin/bash
#
# ~/sbin/cleanup_bkps.sh - de-clutter backups
#
# This will work for any directory containing *tar.gz* backups
# (eg: name.tar.gz, name.tar.gz.asc)
# that have a YYMMDD formated date field in their filename seperated by periods(.)
# (eg: 190326.1553569476.enc.tar.gz.asc)

# BacKuPs Directory => BKPD
BKPD="/mnt/el/Documents/BKP/LINUX"

# BacKuPs to Keep => BKPK (in days)
BKPK="14"

# BacKuPs Remove => BKPR (1 remove, 0 don't)
BKPR="1"

# Load explicitly for non interactive shells.
# source /home/paperjam/.bashrc.d/.stl/time.sh # for datedd()
# source /home/paperjam/.bashrc.d/.stl/string.sh # for split()
# source /home/paperjam/.bashrc.d/.stl/math.sh # for max()
declare -a srcs=( "/home/paperjam/.bashrc.d/.stl/time.bash" \
                    "/home/paperjam/.bashrc.d/.stl/string.bash" \
                    "/home/paperjam/.bashrc.d/.stl/math.bash" )

while [[ -n "${1}" ]]; do
  case "${1}" in
    "--directory") shift; BKPD="${1}";;
    "--simulate") BKPR="0";;
    "--keep") shift; BKPK="${1}";;
    "--debug") set -x;;
    *) echo -ne "Usage: $(basename "${BASH_SOURCE[0]}") [--directory /backups/directory/] [--simulate] [--keep # (int, days. default: 14)] [--debug (default: off)]\n" >&2; exit 1;;
  esac
  shift
done

# No root access
# (( EUID != 0 )) && printf "privileged access requirements not met.\n" >&2 && exit 1

# No backups directory
[[ ! -d "${BKPD}" ]] && echo -ne "${BKPD} is not a directory.\n" >&2 && exit 1

echo -ne " -- $(basename "${BASH_SOURCE[0]}") --\n"

for src in "${srcs[@]}"; do
  #shellcheck source=/dev/null
  source "${src}"
done

#shellcheck disable=SC2207
FILES=( $("$(type -P ls)" "-t1" "${BKPD}"/*tar.gz* 2> /dev/null) )

# File loop to gather stats
for (( x = 0; x < ${#FILES[@]}; x++ )); do
  BFN="$(basename "${FILES[${x}]}")"
  # Name loop to extract dates
  for PART in $(split "${BFN}" .); do
    # 6 digits field check (six digit dates eg: 190508)
    if [[ "${PART}" =~ ^[0-9]{6}$ ]]; then
      FNS[${x}]="${BFN}"
      DTS[${x}]="${PART}"
    fi
  done
 done

 # File NameS loop to execute on stats
 for (( y = 0; y < ${#FNS[@]}; y++ )); do
   if (( $(datedd "$(max "${DTS[@]}")" "${DTS[${y}]}") >= BKPK )); then
     #shellcheck disable=SC2154
     # echo -ne "${bold}${blue}will remove:${reset} ${red}${FNS[${y}]}${reset}, created: ${underline}${green}$(date -d "${DTS[${y}]}" +%Y/%m/%d)${reset}${end_underline}.\n"
     # echo -ne "${bold}rm -v ${red}${FNS[${y}]}${reset}${reset}: "
     if (( BKPR == 0 )); then
       echo "BKPR is ${BKPR} so \'rm -v ${BKPD}/${FNS[${y}]}\' will not run"
     else
       rm -v "${BKPD}/${FNS[${y}]}"
     fi
   fi
 done
