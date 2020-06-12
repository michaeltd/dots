#!/usr/bin/env -S bash --noprofile --norc
#
# Script to go through a directory of background images as wallpapers in a timely fashion
#shellcheck shell=bash

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\t\n'

wallpaper_rotate() {
    # Font attributes, Colors, bg colors
    #shellcheck disable=SC2034
    local -r reset="$(tput sgr0)" bold="$(tput bold)" dim="$(tput dim)" blink="$(tput blink)" underline="$(tput smul)" end_underline="$(tput rmul)" reverse="$(tput rev)" hidden="$(tput invis)" \
	  black="$(tput setaf 0)" red="$(tput setaf 1)" green="$(tput setaf 2)" yellow="$(tput setaf 3)" blue="$(tput setaf 4)" magenta="$(tput setaf 5)" cyan="$(tput setaf 6)" white="$(tput setaf 7)" default="$(tput setaf 9)" \
	  bg_black="$(tput setab 0)" bg_red="$(tput setab 1)" bg_green="$(tput setab 2)" bg_yellow="$(tput setab 3)" bg_blue="$(tput setab 4)" bg_magenta="$(tput setab 5)" bg_cyan="$(tput setab 6)" bg_white="$(tput setab 7)" bg_default="$(tput setab 9)"

    #shellcheck disable=SC2034,SC2155
    local -ra WPUSAGE=("\n \
    ${bold}Script to rotate backgrounds in wm's with out such options \n \
    like: openbox, wmaker, mwm, ...etc ${reset}\n\n \
    ${underline}Usage${end_underline}: ${green}${BASH_SOURCE[0]##*/}${reset} & from a terminal or your startup scripts.\n\n \
    Options may be: \n \
    ${green}${BASH_SOURCE[0]##*/}${reset} ${magenta}add${reset} ${yellow}path1${reset} [${yellow}path2${reset} ...] - add director(y/ies) \n \
    ${green}${BASH_SOURCE[0]##*/}${reset} ${magenta}rem${reset} ${yellow}path1${reset} [${yellow}path2${reset} ...] - remove director(y/ies) \n \
    ${green}${BASH_SOURCE[0]##*/}${reset} ${magenta}delay${reset} ${yellow}240${reset} - set interval (seconds) \n \
    ${green}${BASH_SOURCE[0]##*/}${reset} ${magenta}replay${reset} [${yellow}3${reset}] - display previous image # \n \
    ${green}${BASH_SOURCE[0]##*/}${reset} ${magenta}help${reset} - this message \n \
    ${green}${BASH_SOURCE[0]##*/}${reset} without options will start rotating images.\n\n")

    #shellcheck disable=SC2034,SC2155
    local -ra FEH=( "feh" "--bg-scale" ) WMSETBG=( "wmsetbg" ) FVWM_ROOT=( "fvwm-root" ) \
          FBSETBG=( "fbsetbg" ) BSETBG=( "bsetbg" ) HSETROOT=( "hsetroot" "-fill" ) XSETBG=( "xsetbg" )
    local -a BGSRS=( FEH[@] WMSETBG[@] FVWM_ROOT[@] FBSETBG[@] BSETBG[@] HSETROOT[@] XSETBG[@] ) \
	  DIRS=( "${HOME}/Pictures" ) WPS=()
    #shellcheck disable=SC2155
    local WPRC="${HOME}/.$(basename "${BASH_SOURCE[0]/%.bash/.rc}")" \
	  WPLG="${HOME}/.$(basename "${BASH_SOURCE[0]/%.bash/.log}")" \
	  BGSR="" \
	  WAIT="2m"

    # bash version info check
    if (( "${BASH_VERSINFO[0]}" < 4 )); then
	#shellcheck disable=SC2154
	echo -ne "${red}Error:${reset} For this to work you'll need bash major version no less than 4.\n" >&2
	exit 1
    fi

    # Find a setter
    for (( x = 0; x < "${#BGSRS[@]}"; x++ )); do
	if [[ -n $(type -P "${!BGSRS[x]:0:1}" 2> /dev/null) ]]; then
	    BGSR="${x}"
	    break # Break on first match.
	fi
    done

    # Quit on no setter
    if [[ -z "${BGSR}" ]]; then
	echo -ne "${WPUSAGE[*]}\n"
	echo -ne "\n\n ${red}Error:${reset} No valid wallpaper setter found. Install \"${bold}feh${reset}\" and try again.\n" >&2
	exit 1
    fi

    # If there's no readable settings file, write it...
    if [[ ! -r "${WPRC}" ]]; then
	echo -ne "WAIT=${WAIT}\nDIRS=( ${DIRS[*]} )\n" > "${WPRC}"
    fi

    # and read it.
    #shellcheck source=/dev/null
    source "${WPRC}"

    # If options, proccess, else rotate things
    if [[ -n "${*}" ]]; then
	case "${1}" in
	    "add")
		shift
		while [[ -n "${*}" ]]; do
		    if [[ -d "${1}" ]]; then
			DIRS+=( "${1}" )
		    else
			echo -ne "${yellow}Warning:${reset} \"${bold}${1}${reset}\" is not a directory.\n" >&2
		    fi
		    shift
		done
		echo -ne "WAIT=${WAIT}\nDIRS=( ${DIRS[*]} )\n" > "${WPRC}";;
	    "rem")
		shift
		while [[ -n "${*}" ]]; do
		    for (( i = 0; i < "${#DIRS[@]}"; i++ )); do
			if [[ "${DIRS[i]}" == "${1}" ]]; then
			    unset 'DIRS[i]'
			fi
		    done
		    shift
		done
		echo -ne "WAIT=${WAIT}\nDIRS=( ${DIRS[*]} )\n" > "${WPRC}";;
	    "delay")
		shift
		WAIT=${1}
		if [[ "${WAIT}" =~ ^[0-9]+$ ]]; then
		    echo -ne "WAIT=${WAIT}\nDIRS=( ${DIRS[*]} )\n" > "${WPRC}"
		else
		    echo -ne "${yellow}Warning:${reset} \"${bold}${WAIT}${reset}\" is not a valid time construct.\nProvide an integer as interval in seconds\n" >&2
		fi ;;
	    "replay")
		shift
		tail -n "${1:-1}" "${WPLG}"|head -n 1|awk '{print $NF}';;
	    "showlog")
		shift
		cat "${WPLG}";;
	    *)
		echo -ne "${WPUSAGE[*]}" ;;
	esac
    else
	# Reset log
	echo '' > "${WPLG}"

	while :; do
	    # re-read rc (to pick up config updates).
	    #shellcheck source=/dev/null
	    source "${WPRC}"

	    # fill a WallPaperS list
	    for D in "${DIRS[@]}"; do
		for P in "${D}"/*; do
		    local FE="${P:(-4)}"
		    if [[ "${FE,,}" == ".jpg" || "${FE,,}" == ".png" ]]; then
			local -a WPS+=( "${P}" )
		    fi
		done
	    done

	    # limit a random number to upper array bounds as a RundomNumber
	    # let "RN = ${RANDOM} % ${#WPS[@]}"
	    #shellcheck disable=SC2155
	    local RN=$(shuf -n 1 -i 0-"${#WPS[@]}")

	    # Get path and name of image as a selected WallPaper
	    local WP="${WPS[RN]}"

	    # set log, set wallpaper, wait
	    printf "%s %s %s\n" "$(date +%y%m%d_%H%M)" "${!BGSRS[BGSR]:0:1}" "${WP}" >> "${WPLG}"

	    "${!BGSRS[BGSR]}" "${WP}" 2>> "${WPLG}"

	    sleep "${WAIT}"
	done
    fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && "$(basename "${BASH_SOURCE[0]%.*}")" "${@}"
