#!/usr/bin/env -S bash --norc --noprofile
#shellcheck shell=bash disable=SC1008,SC2096

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\t\n'

main() {
    #shellcheck disable=SC2155
    local -r myusage="\n\tUsage: ${BASH_SOURCE[0]##*/} [genre]\n\n" uri="file:///mnt/data/Documents/Music"

    #shellcheck disable=SC2034
    local -ar pop=( "${uri}/all_saints" "${uri}/avicii" "${uri}/black_eyed_pees" "${uri}/bruno_mars" "${uri}/daft_punk" "${uri}/gorillaz" ) \
	  rock=( "${uri}/bad_co" "${uri}/deep_purple" "${uri}/doobie_brothers" "${uri}/frank_zappa" "${uri}/janis_joplin" "${uri}/jethro_tull" "${uri}/joe_cocker" "${uri}/led_zeppelin" "${uri}/lenny_kravitz" "${uri}/the_who" "${uri}/ten_years_after" "${uri}/sting" "${uri}/santana" ) \
	  reggae=( "${uri}/ub40" "${uri}/matisyahu" "${uri}/bob_marley" ) \
	  rnb=( "${uri}/amy_winehouse" "${uri}/blues_brothers" ) \
	  jazz=( "${uri}/bill_evans" "${uri}/cannonball_adderley" "${uri}/charlie_parker" "${uri}/chick_corea" "${uri}/eddie_gomez" "${uri}/getz_meets_mulligan" "${uri}/herbie_hancock" "${uri}/john_coltrane" "${uri}/miles_davis" "${uri}/ron_carter" "${uri}/sarah_vaughan" "${uri}/stanley_clarke/" "${uri}/marcus_miller/" "${uri}/jaco_pastorius/" "${uri}/esperanza_spalding/" "${uri}/mark_king/Level-Best" "${uri}/john_patitucci" "${uri}/victor_wooten" ) \
	  latin=( "${uri}/irakere" "${uri}/mambo_kings" "${uri}/paco_de_lucia" "${uri}/tito_puente" ) \
	  funk=( "${uri}/average_white_band" "${uri}/blood_sweat_and_tears" "${uri}/jamiroquai" "${uri}/tower_of_power" "${uri}/chaka_khan" ) \
	  classical=( "${uri}/carl_orff" "${uri}/nikos_skalkotas" "${uri}/vaggelis" ) \
	  ost=( "${uri}/ost/bf" "${uri}/ost/cod" "${uri}/ost/ed" "${uri}/ost/halo" "${uri}/ost/titanfall" )

    local -ar genres=( pop[@] rock[@] reggae[@] rnb[@] jazz[@] latin[@] funk[@] classical[@] ost[@] )

    log2err() { echo -ne "${*}" >&2; exit 1; }
    
    if [[ -n "${*}" ]]; then
	if [[ "${genres[*]}" =~ ${1} ]]; then
	    eval "param_genre=(\"\${$1[@]}\")"
	    local -ar dir_list=( "${param_genre[@]}" )
	else
	    for i in "${genres[@]}"; do
		local gen_alpha+="${i//[![:alpha:]]} "
	    done
	    log2err "${myusage}\t${1} not found.\n\tTry one of: ${gen_alpha}!\n\n"
	fi
    else
	local -ar dir_list=( "${!genres[$(shuf -n 1 -i 0-"$((${#genres[*]}-1))")]}" )
    fi

    # is VLC running?
    #shellcheck disable=SC2207
    local -ar pids=( $(pgrep -U "${USER}" -f vlc) )
    if [[ "${#pids[*]}" -gt "0" ]]; then
	play -q -n synth .8 sine 4100 fade q 0.1 .3 0.1 repeat 3
	log2err "VLC already started!\n"
    else
	cvlc --random "${dir_list[@]}"
    fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "${@}"
