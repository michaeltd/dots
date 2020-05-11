#!/usr/bin/env bash
#
# ~/bin/wallpaper_rotate.bash
# Script to go through a directory of background images as wallpapers in a timely fashion
#shellcheck shell=bash

# Font attributes, Colors, bg colors
declare -r reset="$(tput sgr0)" bold="$(tput bold)" dim="$(tput dim)" blink="$(tput blink)" underline="$(tput smul)" end_underline="$(tput rmul)" reverse="$(tput rev)" hidden="$(tput invis)"
declare -r black="$(tput setaf 0)" red="$(tput setaf 1)" green="$(tput setaf 2)" yellow="$(tput setaf 3)" blue="$(tput setaf 4)" magenta="$(tput setaf 5)" cyan="$(tput setaf 6)" white="$(tput setaf 7)" default="$(tput setaf 9)"
declare -r bg_black="$(tput setab 0)" bg_red="$(tput setab 1)" bg_green="$(tput setab 2)" bg_yellow="$(tput setab 3)" bg_blue="$(tput setab 4)" bg_magenta="$(tput setab 5)" bg_cyan="$(tput setab 6)" bg_white="$(tput setab 7)" bg_default="$(tput setab 9)"

#shellcheck disable=SC2034,SC2155
declare -ra WPUSAGE=("\n \
    ${bold}Script to rotate backgrounds in wm's with out such options \n \
    like: openbox, wmaker, mwm, ...etc ${reset}\n\n \
    ${underline}Usage${end_underline}: ${green}${BASH_SOURCE[0]##*/}${reset} & from a terminal or your startup scripts.\n\n \
    Options may be: \n \
    ${green}${BASH_SOURCE[0]##*/}${reset} ${magenta}add${reset} ${yellow}path1${reset} [${yellow}path2${reset} ...] - add director(y/ies) \n \
    ${green}${BASH_SOURCE[0]##*/}${reset} ${magenta}rem${reset} ${yellow}path1${reset} [${yellow}path2${reset} ...] - remove director(y/ies) \n \
    ${green}${BASH_SOURCE[0]##*/}${reset} ${magenta}delay${reset} ${yellow}1440${reset} - set interval (in minutes) \n \
    ${green}${BASH_SOURCE[0]##*/}${reset} ${magenta}replay${reset} [${yellow}3${reset}] - display previous image # \n \
    ${green}${BASH_SOURCE[0]##*/}${reset} ${magenta}help${reset} - this message \n \
    ${green}${BASH_SOURCE[0]##*/}${reset} without options will start rotating images.\n\n")

#shellcheck disable=SC2034,SC2155
declare -ra FEH=( "feh" "--bg-scale" ) WMSETBG=( "wmsetbg" ) FVWM_ROOT=( "fvwm-root" ) \
        FBSETBG=( "fbsetbg" ) BSETBG=( "bsetbg" ) HSETROOT=( "hsetroot" "-fill" ) XSETBG=( "xsetbg" )
declare -a BGSRS=( FEH[@] WMSETBG[@] FVWM_ROOT[@] FBSETBG[@] BSETBG[@] HSETROOT[@] XSETBG[@] ) \
	DIRS=( "${HOME}/Pictures" ) WPS=()
declare WPRC="${HOME}/.$(basename "${BASH_SOURCE[0]//.bash/.rc}")" WPLG="${HOME}/.$(basename "${BASH_SOURCE[0]//.bash/.log}")" \
	BGSR="" WAIT="2m" LS="$(type -P ls)"

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

main() {
    # If options, proccess, else rotate things
    if [[ -n "${1}" ]]; then
	case "${1}" in
	    "add")
		shift
		while [[ -n "${1}" ]]; do
		    if [[ -d "${1}" ]]; then
			DIRS+=( "${1}" )
		    else
			echo -ne "${yellow}Warning:${reset} ${1} is not a directory.\n" >&2
		    fi
		    shift
		done
		# https://stackoverflow.com/questions/525592/find-and-replace-inside-a-text-file-from-a-bash-command
		sv="DIRS" rv="DIRS=( ${DIRS[*]} )"
		sed --follow-symlinks -i "s|^${sv}.*|${rv}|g" "${WPRC}" ;;
	    "rem")
		shift
		while [[ -n "${1}" ]]; do
		    for (( i = 0; i < "${#DIRS[@]}"; i++ )); do
			if [[ "${DIRS[i]}" == "${1}" ]]; then
			    unset 'DIRS[i]'
			fi
		    done
		    shift
		done
		sv="DIRS"
		rv="DIRS=( ${DIRS[*]} )"
		sed --follow-symlinks -i "s|^${sv}.*|${rv}|g" "${WPRC}" ;;
	    "delay")
		shift
		# https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash
		if [[ "${1}" =~ ^[0-9]+$ ]]; then
		    sv="WAIT" rv="WAIT=${1}m"
		    sed --follow-symlinks -i "s|^${sv}.*|${rv}|g" "${WPRC}"
		else
		    echo -ne "${yellow}Warning:${reset} ${1} is not a valid time construct.\nProvide an integer as interval in minutes\n" >&2
		fi ;;
	    "replay")
		shift
		tail -n "${1:-1}" "${WPLG}" |head -n 1|awk '{print $NF}' ;;
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
		    FE="${P:(-4)}"
		    if [[ "${FE,,}" == ".jpg" || "${FE,,}" == ".png" ]]; then
			WPS+=( "${P}" )
		    fi
		done
	    done

	    # limit a random number to upper array bounds as a RundomNumber
	    # let "RN = ${RANDOM} % ${#WPS[@]}"
	    RN=$(shuf -n 1 -i 0-"${#WPS[@]}")
	    
	    # Get path and name of image as a selected WallPaper
	    WP="${WPS[RN]}"

	    # set wallpaper, log, wait
	    "${!BGSRS[BGSR]}" "${WP}" 2>> "${WPLG}" || continue # Skip log and sleep if selected img won't work.
	    
	    printf "%s %s %s\n" "$(date +%y%m%d_%H%M)" "${!BGSRS[BGSR]:0:1}" "${WP}" >> "${WPLG}"
	    sleep "${WAIT}"
	done
    fi
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main ${@}
