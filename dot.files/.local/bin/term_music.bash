#!/usr/bin/env -S bash --norc --noprofile
#shellcheck shell=bash disable=SC1008,SC2096

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\t\n'

#link free (S)cript: (D)ir(N)ame, (B)ase(N)ame.
#shellcheck disable=SC2155,SC2034
readonly sdn="$(dirname "$(realpath "${BASH_SOURCE[0]}")")" \
	 sbn="$(basename "$(realpath "${BASH_SOURCE[0]}")")"

term_music() {
    #shellcheck disable=SC2155
    local -r myusage="\n\tUsage: ${BASH_SOURCE[0]##*/} [genre]\n\n"

    #shellcheck disable=SC2034
    local -ar pop=( "file:///mnt/data/Documents/Music/all_saints" "file:///mnt/data/Documents/Music/avicii" "file:///mnt/data/Documents/Music/black_eyed_pees" "file:///mnt/data/Documents/Music/bruno_mars" "file:///mnt/data/Documents/Music/daft_punk" "file:///mnt/data/Documents/Music/gorillaz" ) \
	  rock=( "file:///mnt/data/Documents/Music/bad_co" "file:///mnt/data/Documents/Music/deep_purple" "file:///mnt/data/Documents/Music/doobie_brothers" "file:///mnt/data/Documents/Music/frank_zappa" "file:///mnt/data/Documents/Music/janis_joplin" "file:///mnt/data/Documents/Music/jethro_tull" "file:///mnt/data/Documents/Music/joe_cocker" "file:///mnt/data/Documents/Music/led_zeppelin" "file:///mnt/data/Documents/Music/lenny_kravitz" "file:///mnt/data/Documents/Music/the_who" "file:///mnt/data/Documents/Music/ten_years_after" "file:///mnt/data/Documents/Music/sting" "file:///mnt/data/Documents/Music/santana" ) \
	  reggae=( "file:///mnt/data/Documents/Music/ub40" "file:///mnt/data/Documents/Music/matisyahu" "file:///mnt/data/Documents/Music/bob_marley" ) \
	  rnb=( "file:///mnt/data/Documents/Music/amy_winehouse" "file:///mnt/data/Documents/Music/blues_brothers" ) \
	  jazz=( "file:///mnt/data/Documents/Music/bill_evans" "file:///mnt/data/Documents/Music/cannonball_adderley" "file:///mnt/data/Documents/Music/charlie_parker" "file:///mnt/data/Documents/Music/chick_corea" "file:///mnt/data/Documents/Music/eddie_gomez" "file:///mnt/data/Documents/Music/getz_meets_mulligan" "file:///mnt/data/Documents/Music/herbie_hancock" "file:///mnt/data/Documents/Music/john_coltrane" "file:///mnt/data/Documents/Music/miles_davis" "file:///mnt/data/Documents/Music/ron_carter" "file:///mnt/data/Documents/Music/sarah_vaughan" "file:///mnt/data/Documents/Music/stanley_clarke/" "file:///mnt/data/Documents/Music/marcus_miller/" "file:///mnt/data/Documents/Music/jaco_pastorius/" "file:///mnt/data/Documents/Music/esperanza_spalding/" "file:///mnt/data/Documents/Music/mark_king/Level-Best" "file:///mnt/data/Documents/Music/john_patitucci" "file:///mnt/data/Documents/Music/victor_wooten" ) \
	  latin=( "file:///mnt/data/Documents/Music/irakere" "file:///mnt/data/Documents/Music/mambo_kings" "file:///mnt/data/Documents/Music/paco_de_lucia" "file:///mnt/data/Documents/Music/tito_puente" ) \
	  funk=( "file:///mnt/data/Documents/Music/average_white_band" "file:///mnt/data/Documents/Music/blood_sweat_and_tears" "file:///mnt/data/Documents/Music/jamiroquai" "file:///mnt/data/Documents/Music/tower_of_power" "file:///mnt/data/Documents/Music/chaka_khan" ) \
	  classical=( "file:///mnt/data/Documents/Music/carl_orff" "file:///mnt/data/Documents/Music/nikos_skalkotas" "file:///mnt/data/Documents/Music/vaggelis" ) \
	  ost=( "file:///mnt/data/Documents/Music/ost/bf" "file:///mnt/data/Documents/Music/ost/cod" "file:///mnt/data/Documents/Music/ost/ed" "file:///mnt/data/Documents/Music/ost/halo" "file:///mnt/data/Documents/Music/ost/titanfall" )

    local -ar genres=( pop[@] rock[@] reggae[@] rnb[@] jazz[@] latin[@] funk[@] classical[@] ost[@] )

    if [[ -n "${*}" ]]; then
	if [[ "${genres[*]}" =~ ${1} ]]; then
	    eval "param_genre=(\"\${$1[@]}\")"
	    local -ar dir_list=( "${param_genre[@]}" )
	else
	    for i in "${genres[@]}"; do
		local gen_alpha+="${i//[![:alpha:]]} "
	    done
	    echo -ne "${myusage}" >&2
	    echo -ne "\n\t${1} not found.\n\tTry one of: ${gen_alpha}!\n\n" >&2
	    return 1
	fi
    else
	local -ar dir_list=( "${!genres[$(shuf -n 1 -i 0-"${#genres[*]}")]}" )
    fi

    # is VLC running?
    #shellcheck disable=SC2207
    local -ar pids=( $(pgrep -U "${USER}" -f vlc) )
    if [[ "${#pids[*]}" -gt "0" ]]; then
	echo -ne "VLC already started!\n" >&2
	play -q -n synth .8 sine 4100 fade q 0.1 .3 0.1 repeat 3
	return 1
    else
	cvlc --random "${dir_list[@]}"
    fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && "${sbn%.*}" "${@}"
