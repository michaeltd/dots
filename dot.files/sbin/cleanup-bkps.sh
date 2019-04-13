#!/usr/bin/env bash
#
# ~/sbin/cleanup-bkps.sh - de-clutter backups
# This will work for any directory containing *tar.gz* backups (eg: name.tar.gz, name.tar.gz.asc)
# that have an epoch field in their filename seperated by periods(.) (eg: 190326.1553569476.enc.tar.gz.asc)

# Load explicitly for non interactive shells
source /home/paperjam/.bashrc.d/.stdl/time.sh
source /home/paperjam/.bashrc.d/.stdl/string.sh
source /home/paperjam/.bashrc.d/.stdl/math.sh

BKPD="/mnt/el/Documents/BKP/LINUX" BKPK="0" BKPR="0"

printf "= $(basename ${BASH_SOURCE[0]}) =\n"

# No root access
# (( EUID != 0 )) && printf "privileged access requirements not met.\n" >&2 && exit 1
# No backups directory
[[ ! -d "${BKPD}" ]] && printf "${BKPD} is not a directory.\n" >&2 && exit 1

FILES=( $($(which ls) -t1 ${BKPD}/*tar.gz* 2> /dev/null) )
# File loop to gather stats
for (( x = 0; x < ${#FILES[@]}; x++ )); do
    # Name loop to extract dates
    for PART in $(split "${FILES[$x]})" .); do
        # 10 digits field check (epoch)
        if [[ "${PART}" =~ ^[0-9]{10}$ ]]; then
            FNS+=( "$(basename ${FILES[$x]})" )
            EDS+=( "${PART}" )
        fi
    done
done

# File NameS loop to execute on stats
for (( y = 0; y < ${#FNS[@]}; y++ )); do
    if (( $(epochdd $(max ${EDS[@]}) ${EDS[$y]}) >= BKPK )); then
        printf "${bold}${blue}will remove:${reset} %s, created: %s.\n" "${red}${FNS[$y]}${reset}" "${underline}${green}$(date -d @${EDS[$y]} +%Y/%m/%d_%H:%M:%S)${reset}${end_underline}"
        printf "${bold}rm -v %s${reset}: " "${red}${FNS[$y]}${reset}"
        (( BKPR == 0 )) && printf "\n" || rm -v "${BKPD}/${FNS[$y]}"
    fi
done
