#!/bin/bash
#
# ~/sbin/cleanup_bkps.sh - de-clutter backups
#
# This will work for any directory containing *.tar.gz* backups (eg: name.tar.gz, name.tar.gz.pgp)
# that have an epoch date field in their filename seperated by periods(.) (eg: 190326.1553569476.enc.tar.gz.pgp)
#
#shellcheck source=/dev/null

# BacKuPs Directory => BKPD
BKPD="/mnt/el/Documents/BKP/LINUX"

# BacKuPs to Keep => BKPK (in days)
BKPK="14"

# BacKuPs Remove => BKPR (1 remove, 0 don't)
BKPR="1"

# Source explicitly for non interactive shells.
declare -a srcs=( "/home/paperjam/.bashrc.d/.stl/time.bash" \
                    "/home/paperjam/.bashrc.d/.stl/string.bash" \
                    "/home/paperjam/.bashrc.d/.stl/math.bash" )

while [[ -n "${1}" ]]; do
  case "${1}" in
    "-d"|"--directory") shift; BKPD="${1}";;
    "-s"|"--simulate") BKPR="0";;
    "-k"|"--keep") shift; BKPK="${1}";;
    "-b"|"--debug") set -x;;
    *) echo -ne "Usage: $(basename "${BASH_SOURCE[0]}") [-(-d)irectory /backups/directory/] [-(-s)imulate] [-(-k)eep # (int, days. default: 14)] [-(-)de(b)ug (default: off)]\n" >&2; exit 1;;
  esac
  shift
done

# No root access
# (( EUID != 0 )) && printf "privileged access requirements not met.\n" >&2 && exit 1

# No backups directory
[[ ! -d "${BKPD}" ]] && echo -ne "${BKPD} is not a directory.\n" >&2 && exit 1

echo -ne " -- $(basename "${BASH_SOURCE[0]}") --\n"

for src in "${srcs[@]}"; do
    source "${src}"
done

#shellcheck disable=SC2207
FILES=( $("$(type -P ls)" "-At1" "${BKPD}"/*.tar.gz* 2> /dev/null) )

for (( x = 0; x < ${#FILES[@]}; x++ )); do
    BFN="$(basename "${FILES[${x}]}")"
    for PART in $(split "${BFN}" .); do
	if [[ "${PART}" =~ ^[0-9]{10}$ ]]; then
	    FNS[${x}]="${BFN}"
	    DTS[${x}]="${PART}"
	fi
    done
done

for (( y = 0; y < ${#FNS[@]}; y++ )); do
    if (( $(epochdd "$(max "${DTS[@]}")" "${DTS[${y}]}") >= BKPK )); then
	if (( BKPR == 0 )); then
	    echo "BKPR is ${BKPR} so ${bold}'rm -v ${BKPD}/${FNS[${y}]}'${reset} will not run"
	else
	    rm -v "${BKPD}/${FNS[${y}]}"
	fi
    fi
 done
