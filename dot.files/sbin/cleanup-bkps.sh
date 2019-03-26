#!/usr/bin/env bash
#
# de-clutter backups

# Load explicitly for non interactive shells
source /home/paperjam/.bashrc.d/.stdl/time.sh
source /home/paperjam/.bashrc.d/.stdl/string.sh
source /home/paperjam/.bashrc.d/.stdl/math.sh

printf "= $(basename ${BASH_SOURCE[0]}) =\n"

BKPD="/mnt/el/Documents/BKP/LINUX"

BKPK="-1"

if [[ -d "${BKPD}" ]]; then
    FILES=( $(ls -t ${BKPD}/*tar.gz* 2> /dev/null) )
    if [[ -n ${FILES[0]} ]]; then # Check empty list
        for (( x = 0; x < ${#FILES[@]}; x++ )); do # File loop
            FN=$(basename "${FILES[$x]}"); FNS+=( "${FN}" )
            for PART in $(split "${FN}" .); do # Name loop
                if [[ "${PART}" =~ ^[0-9]+$ ]]; then
                    if [[ "${PART}" =~ ^[0-9]{10}$ ]]; then
                        EPS+=( "${PART}" )
                    elif [[ "${PART}" =~ ^[0-9]{6}$ ]]; then
                        DPS+=( "${PART}" )
                    fi
                fi
            done
        done

        MAXDT=$(max ${DPS[@]}) MINDT=$(min ${DPS[@]}); MAXDD=$(daydiff ${MAXDT} ${MINDT})

        if (( MAXDD > BKPK )); then
            for (( y = 0; y < ${#FNS[@]}; y++ )); do
                FN=${FNS[$y]} DP=${DPS[$y]} EP=${EPS[$y]}; DD=$(daydiff ${MAXDT} ${DP})

                if (( DD > BKPK )); then
                    DT="$(date --date=${DP} +%Y/%m/%d)"
                    printf "${bold}${blue}will remove:${reset} %s, created: %s.\n" "${red}${FN}${reset}" "${underline}${green}${DT}${reset}${end_underline}"
                    printf "${bold}rm -v %s${reset}: \n" "${red}${FN}${reset}"
                    #rm -v "${BKPD}/${FN}"
                fi
            done
        fi
    fi
else
    printf "${BKPD} not found\n" >&2
fi
