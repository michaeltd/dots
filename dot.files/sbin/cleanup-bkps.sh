#!/usr/bin/env bash
#
# ~/sbin/cleanup-bkps.sh - de-clutter backups

# Load explicitly for non interactive shells
source /home/paperjam/.bashrc.d/.stdl/time.sh
source /home/paperjam/.bashrc.d/.stdl/string.sh
source /home/paperjam/.bashrc.d/.stdl/math.sh

printf "= $(basename ${BASH_SOURCE[0]}) =\n"

BKPD="/mnt/el/Documents/BKP/LINUX" BKPK="-1"

# (( EUID != 0 )) && printf "privileged access requirements not met.\n" >&2 && exit 1
[[ ! -d "${BKPD}" ]] && printf "${BKPD} is not a directory.\n" >&2 && exit 1

FILES=( $(ls -t ${BKPD}/*tar.gz* 2> /dev/null) )
for (( x = 0; x < ${#FILES[@]}; x++ )); do # File loop to gather stats
    FN=$(basename "${FILES[$x]}")
    FNS+=( "${FN}" )
    for PART in $(split "${FN}" .); do # Name loop
        if [[ "${PART}" =~ ^[0-9]{6}$ ]]; then # 2 digits year date check
            DPS+=( "${PART}" )
        fi
    done
done
MAXDT=$(max ${DPS[@]})
for (( y = 0; y < ${#FNS[@]}; y++ )); do # File NameS loop to execute on stats
    FN=${FNS[$y]} DP=${DPS[$y]}
    DD=$(daydiff ${MAXDT} ${DP})
    if (( DD > BKPK )); then
        DT="$(date --date=${DP} +%Y/%m/%d)"
        printf "${bold}${blue}will remove:${reset} %s, created: %s.\n" "${red}${FN}${reset}" "${underline}${green}${DT}${reset}${end_underline}"
        printf "${bold}rm -v %s${reset}: \n" "${red}${FN}${reset}"
        #rm -v "${BKPD}/${FN}"
    fi
done
