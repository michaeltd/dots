#!/usr/bin/env -S bash --norc --noprofile
#
# Script to go through a directory of background images as wallpapers in a timely fashion
#shellcheck shell=bash source=/dev/null disable=SC1008,SC2096,SC2155,SC2034,SC2154

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\t\n'

#link free (S)cript: (D)ir(N)ame, (B)ase(N)ame.
readonly sdn="$(dirname "$(realpath "${BASH_SOURCE[0]}")")" \
	 sbn="$(basename "$(realpath "${BASH_SOURCE[0]}")")"

main() {
    # Font attributes, Colors, bg colors
    local -r reset="$(tput sgr0)" bold="$(tput bold)" dim="$(tput dim)" blink="$(tput blink)" underline="$(tput smul)" end_underline="$(tput rmul)" reverse="$(tput rev)" hidden="$(tput invis)" \
	  black="$(tput setaf 0)" red="$(tput setaf 1)" green="$(tput setaf 2)" yellow="$(tput setaf 3)" blue="$(tput setaf 4)" magenta="$(tput setaf 5)" cyan="$(tput setaf 6)" white="$(tput setaf 7)" default="$(tput setaf 9)" \
	  bg_black="$(tput setab 0)" bg_red="$(tput setab 1)" bg_green="$(tput setab 2)" bg_yellow="$(tput setab 3)" bg_blue="$(tput setab 4)" bg_magenta="$(tput setab 5)" bg_cyan="$(tput setab 6)" bg_white="$(tput setab 7)" bg_default="$(tput setab 9)"

    local -ra wpusage=("\n \
    ${bold}Script to rotate backgrounds in wm's with out such options \n \
    like: openbox, wmaker, mwm, ...etc ${reset}\n\n \
    ${underline}Usage${end_underline}: ${green}${sbn}${reset} & from a terminal or your startup scripts.\n\n \
    Options may be: \n \
    ${green}${sbn}${reset} ${magenta}add${reset} ${yellow}path1${reset} [${yellow}path2${reset} ...] - add director(y/ies) \n \
    ${green}${sbn}${reset} ${magenta}rem${reset} ${yellow}path1${reset} [${yellow}path2${reset} ...] - remove director(y/ies) \n \
    ${green}${sbn}${reset} ${magenta}delay${reset} ${yellow}#${reset} - set interval (min) \n \
    ${green}${sbn}${reset} ${magenta}showimg${reset} [${yellow}#${reset}] - display previous image #num (int) \n \
    ${green}${sbn}${reset} ${magenta}help${reset} - this message\n\n")

    local -ra feh=( "feh" "--bg-scale" ) wmsetbg=( "wmsetbg" ) fvwm_root=( "fvwm-root" ) \
          fbsetbg=( "fbsetbg" ) bsetbg=( "bsetbg" ) hsetroot=( "hsetroot" "-fill" ) xsetbg=( "xsetbg" )
    local -a bgsrs=( feh[@] wmsetbg[@] fvwm_root[@] fbsetbg[@] bsetbg[@] hsetroot[@] xsetbg[@] ) \
	  dirs=( "${HOME}/Pictures" ) wps=()
    local -r wprc="${HOME}/.$(basename "${BASH_SOURCE[0]/%.bash/.rc}")" \
	  wplg="${HOME}/.$(basename "${BASH_SOURCE[0]/%.bash/.log}")"
    local bgsr="" \
	  wait="5"

    # bash version info check
    if (( "${BASH_VERSINFO[0]}" < 4 )); then
	echo -ne "${red}Error:${reset} For this to work you'll need bash major version no less than 4.\n" >&2
	return 1
    fi

    # Find a setter
    for (( x = 0; x < "${#bgsrs[@]}"; x++ )); do
	if type -P "${!bgsrs[x]:0:1}" &> /dev/null; then
	    bgsr="${x}"
	    break # Break on first match.
	fi
    done

    # Quit on no setter
    if [[ -z "${bgsr}" ]]; then
	echo -ne "${wpusage[*]}\n"
	echo -ne "\n\n ${red}Error:${reset} No valid wallpaper setter found. Install \"${bold}feh${reset}\" and try again.\n" >&2
	return 1
    fi

    # If there's no readable settings file, write it...
    if [[ ! -r "${wprc}" ]]; then
	echo -ne "wait=${wait}\ndirs=( ${dirs[*]} )\n" > "${wprc}"
    fi

    # and read it.
    source "${wprc}"

    timestamp() {
	date -u +%y%m%d-%H%M%S
    }

    add() {
	while [[ -n "${*}" ]]; do
	    if [[ -d "${1}" ]]; then
		DIRS+=( "${1}" )
	    else
		echo -ne "${yellow}Warning:${reset} \"${bold}${1}${reset}\" is not a directory.\n" >&2 && return 1
	    fi
	    shift
	done
	echo -ne "wait=${wait}\ndirs=( ${dirs[*]} )\n" > "${wprc}"
    }
    
    rem(){
	while [[ -n "${*}" ]]; do
	    for (( i = 0; i < "${#dirs[@]}"; i++ )); do
		if [[ "${dirs[i]}" == "${1}" ]]; then
		    unset 'dirs[i]'
		fi
	    done
	    shift
	done
	echo -ne "wait=${wait}\ndirs=( ${dirs[*]} )\n" > "${wprc}"
    }

    delay() {
    	wait=${1}
	if [[ "${wait}" =~ ^[0-9]+$ && "${wait}" -gt "0" ]]; then
	    echo -ne "wait=${wait}\ndirs=( ${dirs[*]} )\n" > "${wprc}"
	else
	    echo -ne "${yellow}Warning:${reset} \"${bold}${wait}${reset}\" is not a valid time construct.\nProvide an integer as interval in minutes\n" >&2
	    return 1
	fi
    }

    showimg() {
	tail -n "${1:-1}" "${wplg}"|head -n 1|awk '{print $NF}'
    }

    showlog() {
	if [[ -n "${PAGER}" ]]; then
	    "${PAGER}" "${wplg}"
	else
	    echo -ne "${yellow}Warning:${reset} Set a valid \${PAGER} first.\n" >&2
	    return 1
	fi
    }

    showvars() {
	echo -ne "\tRotate delay is: ${wait}m.\n\tImage directories are:\n"
	for d in "${dirs[@]}"; do
	    echo -ne "\t\t${d}\n"
	done
    }

    trimlog() {
	local -r tempdate="$(date +%y%m%d)"
	sed -i "/^${tempdate}/!d" "${wplg}"
    }

    # If options, proccess, else rotate things
    if [[ -n "${*}" ]]; then
	case "${1}" in
	    "add"|"rem"|"delay"|"showimg"|"showlog"|"showvars"|"trimlog") "${@}";;
	    *) echo -ne "${wpusage[*]}" >&2; return 1;;
	esac
    else
	while :; do
	    # re-read rc (to pick up config updates).
	    source "${wprc}"

	    # fill a WallPaperS list
	    for d in "${dirs[@]}"; do
		for p in "${d}"/*; do
		    local fe="${p:(-4)}"
		    if [[ "${fe,,}" == ".jpg" || "${fe,,}" == ".png" ]]; then
			local -a wps+=( "${p}" )
		    fi
		done
	    done

	    # Get path and name of image as a selected WallPaper
	    local wp="${wps[$(shuf -n 1 -i 0-"$(( ${#wps[*]} - 1 ))")]}"

	    # Set wallpaper, write log, wait
	    "${!bgsrs[bgsr]}" "${wp}" >> "${wplg}" 2>&1

	    echo "$(timestamp) ${!bgsrs[bgsr]} ${wp}" >> "${wplg}"

	    sleep "${wait}m"
	done
    fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "${@}"
