#!/usr/bin/env bash
#
# ~/sbin/cleanup-bkps.sh - de-clutter backups

# Load explicitly for non interactive shells
source /home/paperjam/.bashrc.d/.stdl/time.sh
source /home/paperjam/.bashrc.d/.stdl/string.sh
source /home/paperjam/.bashrc.d/.stdl/math.sh

printf "= $(basename ${BASH_SOURCE[0]}) =\n"

BKPD="/mnt/el/Documents/BKP/LINUX" BKPK="-1"

# No root access
# (( EUID != 0 )) && printf "privileged access requirements not met.\n" >&2 && exit 1
# No backups directory
[[ ! -d "${BKPD}" ]] && printf "${BKPD} is not a directory.\n" >&2 && exit 1

FILES=( $($(which ls) -t1 ${BKPD}/*tar.gz* 2> /dev/null) )

# File loop to gather stats
for (( x = 0; x < ${#FILES[@]}; x++ )); do
    FN=$(basename "${FILES[$x]}")
    FNS+=( "${FN}" )
    # Name loop to extract dates
    for PART in $(split "${FN}" .); do
        # 2 digits year date check
        if [[ "${PART}" =~ ^[0-9]{6}$ ]]; then
            DPS+=( "${PART}" )
        fi
    done
done

# MAX DaTe of backups found
MAXDT=$(max ${DPS[@]})

# File NameS loop to execute on stats
for (( y = 0; y < ${#FNS[@]}; y++ )); do
    FN=${FNS[$y]} DP=${DPS[$y]}
    DD=$(daydiff ${MAXDT} ${DP})
    if (( DD > BKPK )); then
        DT="$(date --date=${DP} +%Y/%m/%d)"
        printf "${bold}${blue}will remove:${reset} %s, created: %s.\n" "${red}${FN}${reset}" "${underline}${green}${DT}${reset}${end_underline}"
        printf "${bold}rm -v %s${reset}: \n" "${red}${FN}${reset}"
        #rm -v "${BKPD}/${FN}"
    fi
done
