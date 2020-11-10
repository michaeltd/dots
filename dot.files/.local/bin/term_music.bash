#!/bin/bash
#shellcheck disable=SC2034,SC2155,SC2207
#

#link free (S)cript: (D)ir(N)ame, (B)ase(N)ame.
readonly sdn="$(dirname "$(realpath "${BASH_SOURCE[0]}")")" \
	 sbn="$(basename "$(realpath "${BASH_SOURCE[0]}")")"

log2err() { echo -ne "${sbn}: ${*}\n" >&2; }

main() {
    local -r myusage="\n\tUsage: ${sbn} [genre]\n\n" \
	    uri="file:///mnt/data/Documents/Music"

    local -r pop=(
	"${uri}/mark_king/Level-Best" "${uri}/all_saints" "${uri}/avicii"
	"${uri}/black_eyed_pees" "${uri}/bruno_mars" "${uri}/daft_punk"
	"${uri}/gorillaz"
    )

    local -r rock=(
	"${uri}/bad_co" "${uri}/deep_purple" "${uri}/doobie_brothers"
	"${uri}/frank_zappa" "${uri}/janis_joplin" "${uri}/jethro_tull"
	"${uri}/joe_cocker" "${uri}/led_zeppelin" "${uri}/lenny_kravitz"
	"${uri}/the_who" "${uri}/ten_years_after" "${uri}/sting" "${uri}/santana"
    )

    local -r reggae=(
	"${uri}/ub40" "${uri}/matisyahu" "${uri}/bob_marley"
    )

    local -r rnb=(
	"${uri}/amy_winehouse" "${uri}/blues_brothers"
    )

    local -r jazz=(
	"${uri}/bill_evans" "${uri}/cannonball_adderley" "${uri}/charlie_parker"
	"${uri}/chick_corea" "${uri}/eddie_gomez" "${uri}/getz_meets_mulligan"
	"${uri}/herbie_hancock" "${uri}/john_coltrane" "${uri}/miles_davis"
	"${uri}/ron_carter" "${uri}/sarah_vaughan" "${uri}/stanley_clarke/"
	"${uri}/marcus_miller/" "${uri}/jaco_pastorius/" "${uri}/esperanza_spalding/"
	"${uri}/john_patitucci" "${uri}/victor_wooten" "${uri}/mode_plagal"
    )

    local -r latin=(
	"${uri}/irakere" "${uri}/mambo_kings" "${uri}/paco_de_lucia" "${uri}/tito_puente"
    )

    local -r funk=(
	"${uri}/average_white_band" "${uri}/blood_sweat_and_tears"
	"${uri}/jamiroquai" "${uri}/tower_of_power" "${uri}/chaka_khan"
    )

    local -r classical=(
	"${uri}/carl_orff" "${uri}/nikos_skalkotas" "${uri}/vaggelis"
    )

    local -r ost=(
	"${uri}/ost/bf" "${uri}/ost/cod" "${uri}/ost/ed" "${uri}/ost/halo" "${uri}/ost/titanfall"
    )
    
    local -r genres=( pop[@] rock[@] reggae[@] rnb[@] jazz[@] latin[@] funk[@] classical[@] ost[@] )

    local genre_selection='' selection_type='random' randomnum='' all_artists=()

    if [[ -n "${1}" ]]; then
	if [[ "${genres[*]}" =~ ${1} ]]; then
	    local selection_type="selected"
	    local genre_selection="${1^^}"
	    eval "param_genre=(\"\${$1[@]}\")"
	    local -ar dir_list=( "${param_genre[@]}" )
	else
	    for i in "${genres[@]}"; do
		local gen_alpha+="${i//[![:alpha:]]} "
	    done
	    log2err "${myusage}\t${1} not found.\n\tTry one of: ${gen_alpha}!\n"
	    return 1
	fi
    else
	local randomnum="$(shuf -n 1 -i 0-"$((${#genres[*]}-1))")"
	local genre_selection="${genres[randomnum]^^}"
	local genre_selection="${genre_selection//[![:alpha:]]}"
	local -ar dir_list=( "${!genres[randomnum]}" )
    fi

    # is VLC running?
    local -ar pids=( $(pgrep -U "${USER}" -f vlc) )
    if [[ "${#pids[*]}" -gt "0" ]]; then
	log2err "VLC already playing!\n"
	play -q -n synth .8 sine 4100 fade q 0.1 .3 0.1 repeat 3
	return 1
    else
	for dir in "${dir_list[@]}"; do
	    local all_artists+=( "${dir##*/}" )
	done
	log2err "Playing one of: ${all_artists[*]}, from ${genre_selection} ${selection_type} collection\n"
	cvlc --random "${dir_list[@]}"
    fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "${@}"
