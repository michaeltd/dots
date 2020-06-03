#!/usr/bin/env bash
#
# gather cronjobs for use with a familiar environment (/bin/bash)

#shellcheck disable=SC2155
declare -r usage="\n\tUsage: ${BASH_SOURCE[0]##*/} -(-a)larm ([genre]) | -(-b)ackup\n\n"

alarm() {

    echo -ne " -- ${FUNCNAME[0]} --\n"
    local -ar bass=( "file:///mnt/data/Documents/Music/Stanley-Clarke/" "file:///mnt/data/Documents/Music/Marcus-Miller/" "file:///mnt/data/Documents/Music/Jaco-Pastorius/" "file:///mnt/data/Documents/Music/Esperanza-Spalding/" "file:///mnt/data/Documents/Music/Mark-King/Level-Best" "file:///mnt/data/Documents/Music/JOHN-PATITUCCI" )
    local -ar pop=( "file:///mnt/data/Documents/Music/All\ Saints" "file:///mnt/data/Documents/Music/AVICII" "file:///mnt/data/Documents/Music/Black-Eyed-Pees" "file:///mnt/data/Documents/Music/Bruno-Mars" )
    local -ar rock=( "file:///mnt/data/Documents/Music/Bad-Company" "file:///mnt/data/Documents/Music/Deep-Purple" "file:///mnt/data/Documents/Music/Doobie-Brothers" "file:///mnt/data/Documents/Music/FRANK-ZAPPA" "file:///mnt/data/Documents/Music/Janis-Joplin" "file:///mnt/data/Documents/Music/Jethro-Tull" "file:///mnt/data/Documents/Music/Joe-Cocker" )
    local -ar rnb=( "file:///mnt/data/Documents/Music/Amy-Winehouse" "file:///mnt/data/Documents/Music/Blues-Brothers" )
    local -ar jazz=( "file:///mnt/data/Documents/Music/Bill-Evans" "file:///mnt/data/Documents/Music/CANNONBALL-ADDERLEY" "file:///mnt/data/Documents/Music/EDDIE-GOMEZ" "file:///mnt/data/Documents/Music/Getz-Meets-Mulligan" "file:///mnt/data/Documents/Music/HERBIE-HANCOCK" )
    local -ar funk=( "file:///mnt/data/Documents/Music/Average-White-Band" "file:///mnt/data/Documents/Music/Blood-Sweat-And-Tears" )
    local -ar classical=( "file:///mnt/data/Documents/Music/Carl-Orff" "file:///mnt/data/Documents/Music/NIKOS-SKALKOTAS" )
    local -ar OST=( "file:///mnt/data/Documents/Music/OST-BF" "file:///mnt/data/Documents/Music/OST-COD" "file:///mnt/data/Documents/Music/OST-ED" "file:///mnt/data/Documents/Music/OST-HALO" "file:///mnt/data/Documents/Music/OST-TITANFALL" )

    local -ar genres=( bass[@] pop[@] rock[@] rnb[@] jazz[@] funk[@] classical[@] OST[@] )

    if [[ -n "${1}" ]]; then
	if [[ "${genres[*]}" =~ "${1}" ]]; then
	    eval "param_genre=(\"\${$1[@]}\")"
	    local -ar dir_list=( "${param_genre[@]}" )
	else
	    for i in "${genres[@]}"; do
		local -a gen_alpha+=( "$(printf "%s" "${i//[![:alpha:]]}")" )
	    done
	    echo -ne "\n\t${1} not found.\n\tCheck one of: ${gen_alpha[@]}!\n\n"
	    exit 1
	fi
    else
	local -ar dir_list=( "${!genres[$(shuf -n 1 -i 0-"${#genres[*]}")]}" )
    fi
    cvlc --random "${dir_list[@]}"
}

backup() {
    ~/sbin/update_backups.bash -f ~/".crontabbkps" -t "/mnt/el/Documents/BKP/LINUX/paperjam" -k "tsouchlarakis@gmail.com"
    ~/sbin/update_cleanup.bash -b "/mnt/el/Documents/BKP/LINUX/paperjam" -k 2
}

crontab() {
    if [[ -z "${1}" ]]; then
	echo -ne "${usage}" >&2; exit 1
    else
	case "${1}" in
	    "-a"|"--alarm") alarm "${2}";;
	    "-b"|"--backup") backup;;
	    *) echo -ne "${usage}" >&2; exit 1;;
        esac
    fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && crontab "${@}"
