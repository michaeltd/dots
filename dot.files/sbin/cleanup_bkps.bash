#!/usr/bin/env bash
#
# ~/sbin/cleanup_bkps.bash - de-clutter backups
# This will work for any directory containing *.tar.gz* backups (eg: name.tar.gz, name.tar.gz.pgp)
# that have an epoch date field in their filename seperated by periods(.) (eg: 190326.1553569476.enc.tar.gz.pgp)
#
#shellcheck source=/dev/null
echo -ne " -- $(basename "${BASH_SOURCE[0]}") --\n"

NOTHING2DO=0

# BacKuPs Directory => BKPD,
# BacKuPs to Keep => BKPK (in days),
# BacKuPs Remove => BKPR (1 remove, 0 don't)
BKPD="/mnt/el/Documents/BKP/LINUX" BKPK="14" BKPR="1"

# Source explicitly for non interactive shells.
SRCSPATH="$(dirname $(dirname $(realpath ${BASH_SOURCE[0]})))/.bashrc.d/.stdlib"
declare -ra srcs=( "${SRCSPATH}/time.bash" \
                  "${SRCSPATH}/string.bash" \
                  "${SRCSPATH}/math.bash" )

while [[ -n "${1}" ]]; do
    case "${1}" in
	"-b"|"--bkpdir") shift; BKPD="${1}";;
	"-s"|"--simulate") BKPR="0";;
	"-k"|"--keep") shift; BKPK="${1}";;
	"-d"|"--debug") set -x;;
	*) echo -ne "Usage: $(basename "${BASH_SOURCE[0]}") [-(-b)kpdir /backups/directory/] [-(-s)imulate] [-(-k)eep # (int, days. default: 14)] [-(-d)ebug (default: off)]\n" >&2; exit 1;;
    esac
    shift
done

# No root access or No backups directory
# (( EUID != 0 )) && echo -ne "privileged access requirements not met.\n" >&2 && exit 1
[[ ! -d "${BKPD}" ]] && echo -ne "${BKPD} is not a directory.\n" >&2 && exit 1

if [[ -d "${SRCPATH}" ]]; then
    for src in "${srcs[@]}"; do
	if [[ -r "${src}" ]]; then
	    source "${src}"
	else
	    echo -ne "${src} not readable.\n" >&2
	    exit 1
	fi
    done
else
    echo -ne "${SRCPATH} not found.\n" >&2
    exit 1
fi

#shellcheck disable=SC2207
FILES=( $("$(type -P ls)" "-At1" "${BKPD}"/*.tar.gz* 2> /dev/null) )

for (( x = 0; x < ${#FILES[@]}; x++ )); do
    BFN="$(basename "${FILES[x]}")"
    for PART in $(split "${BFN}" .); do
	if [[ "${PART}" =~ ^[0-9]{10}$ ]]; then
	    FNS[x]="${BFN}"
	    DTS[x]="${PART}"
	fi
    done
done

for (( y = 0; y < ${#FNS[@]}; y++ )); do
    if [[ "$(epochdd "$(max "${DTS[@]}")" "${DTS[y]}")" -ge "${BKPK}" ]]; then
	NOTHING2DO=1
	if [[ "${BKPR}" == "0" ]]; then
	    if [[ "$(lastdayofmonth "@${DTS[y]}")" == "$(date +%d --date="@${DTS[y]}")" ]]; then
		echo "Not running: ${bold}'mkdir -vp ${BKPD}/bkp && cp -v ${BKPD}/${FNS[y]} ${BKPD}/bkp/${FNS[y]}'${reset}"
	    fi
	    echo "Not running: ${bold}'rm -v ${BKPD}/${FNS[y]}'${reset}"
	else
	    if [[ "$(lastdayofmonth "@${DTS[y]}")" == "$(date +%d --date="@${DTS[y]}")" ]]; then
		mkdir -vp "${BKPD}/bkp" && cp -v "${BKPD}/${FNS[y]}" "${BKPD}/bkp/${FNS[y]}"
	    fi
	    rm -v "${BKPD}/${FNS[y]}"
	fi
    fi
 done

[[ "${NOTHING2DO}" ]] && echo "Nothing left to do!" >&2
