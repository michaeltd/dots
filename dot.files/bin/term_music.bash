#!/usr/bin/env bash

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\t\n'

#link free (S)cript: (D)ir(N)ame, (B)ase(N)ame.
#shellcheck disable=SC2155,SC2034
readonly sdn="$(dirname "$(realpath "${BASH_SOURCE[0]}")")" \
	 sbn="$(basename "$(realpath "${BASH_SOURCE[0]}")")"
readonly sne="${sbn%.*}"

term_music() {

    #shellcheck disable=SC2155
    local -r usage="\n\tUsage: ${BASH_SOURCE[0]##*/} [genre]\n"

    #shellcheck disable=SC2034
    local -ar pop=( "file:///mnt/data/Documents/Music/All-Saints" "file:///mnt/data/Documents/Music/AVICII" "file:///mnt/data/Documents/Music/Black-Eyed-Pees" "file:///mnt/data/Documents/Music/Bruno-Mars" "file:///mnt/data/Documents/Music/Daft-Punk" "file:///mnt/data/Documents/Music/GORILLAZ" ) \
	  rock=( "file:///mnt/data/Documents/Music/Bad-Company" "file:///mnt/data/Documents/Music/Deep-Purple" "file:///mnt/data/Documents/Music/Doobie-Brothers" "file:///mnt/data/Documents/Music/FRANK-ZAPPA" "file:///mnt/data/Documents/Music/Janis-Joplin" "file:///mnt/data/Documents/Music/Jethro-Tull"  "file:///mnt/data/Documents/Music/Joe-Cocker" "file:///mnt/data/Documents/Music/Led-Zeppelin"  "file:///mnt/data/Documents/Music/Lenny-Kravitz"  "file:///mnt/data/Documents/Music/The-Who" "file:///mnt/data/Documents/Music/Ten-Years-After" "file:///mnt/data/Documents/Music/Sting" "file:///mnt/data/Documents/Music/Santana" ) \
	  reggae=( "file:///mnt/data/Documents/Music/UB40" "file:///mnt/data/Documents/Music/Matisyahu" "file:///mnt/data/Documents/Music/Bob-Marley" ) \
	  rnb=( "file:///mnt/data/Documents/Music/Amy-Winehouse" "file:///mnt/data/Documents/Music/Blues-Brothers" ) \
	  jazz=( "file:///mnt/data/Documents/Music/Bill-Evans" "file:///mnt/data/Documents/Music/CANNONBALL-ADDERLEY" "file:///mnt/data/Documents/Music/Charlie-Parker" "file:///mnt/data/Documents/Music/Chick-Corea"  "file:///mnt/data/Documents/Music/EDDIE-GOMEZ" "file:///mnt/data/Documents/Music/Getz-Meets-Mulligan"  "file:///mnt/data/Documents/Music/HERBIE-HANCOCK"  "file:///mnt/data/Documents/Music/John-Coltrane" 	 "file:///mnt/data/Documents/Music/Miles_Davis" "file:///mnt/data/Documents/Music/RON-CARTER" "file:///mnt/data/Documents/Music/Sarah-Vaughan" "file:///mnt/data/Documents/Music/Stanley-Clarke/"  "file:///mnt/data/Documents/Music/Marcus-Miller/"  "file:///mnt/data/Documents/Music/Jaco-Pastorius/"  "file:///mnt/data/Documents/Music/Esperanza-Spalding/"  "file:///mnt/data/Documents/Music/Mark-King/Level-Best"  "file:///mnt/data/Documents/Music/JOHN-PATITUCCI"  "file:///mnt/data/Documents/Music/VICTOR-WOOTEN" ) \
	  latin=( "file:///mnt/data/Documents/Music/IRAKERE" "file:///mnt/data/Documents/Music/MAMBO-KINGS" "file:///mnt/data/Documents/Music/PACO-DE-LUCIA" "file:///mnt/data/Documents/Music/Tito-Puente" ) \
	  funk=( "file:///mnt/data/Documents/Music/Average-White-Band" "file:///mnt/data/Documents/Music/Blood-Sweat-And-Tears" "file:///mnt/data/Documents/Music/Jamiroquai" "file:///mnt/data/Documents/Music/Tower-Of-Power" "file:///mnt/data/Documents/Music/Chaka-Khan" ) \
	  classical=( "file:///mnt/data/Documents/Music/Carl-Orff" "file:///mnt/data/Documents/Music/NIKOS-SKALKOTAS" "file:///mnt/data/Documents/Music/Vaggelis" ) \
	  ost=( "file:///mnt/data/Documents/Music/OST-BF" "file:///mnt/data/Documents/Music/OST-COD" "file:///mnt/data/Documents/Music/OST-ED" "file:///mnt/data/Documents/Music/OST-HALO" "file:///mnt/data/Documents/Music/OST-TITANFALL" )

    local -ar genres=( pop[@] rock[@] reggae[@] rnb[@] jazz[@] latin[@] funk[@] classical[@] ost[@] )

    if [[ -n "${*}" ]]; then
	if [[ "${genres[*]}" =~ ${1} ]]; then
	    eval "param_genre=(\"\${$1[@]}\")"
	    local -ar dir_list=( "${param_genre[@]}" )
	else
	    for i in "${genres[@]}"; do
		local gen_alpha+="${i//[![:alpha:]]} "
	    done
	    echo -ne "${usage}" >&2
	    echo -ne "\n\t${1} not found.\n\tTry one of: ${gen_alpha}!\n" >&2
	    exit 1
	fi
    else
	local -ar dir_list=( "${!genres[$(shuf -n 1 -i 0-"${#genres[*]}")]}" )
    fi
    cvlc --random "${dir_list[@]}"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && "${sne}" "${@}"
