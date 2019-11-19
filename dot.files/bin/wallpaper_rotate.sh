#!/bin/bash
#
# ~/bin/wallpaper-rotate.sh
# Script to go through a directory of background images as wallpapers in a timely fashion

declare -a WPUSAGE="\n \
    ${bold}Script to rotate backgrounds in wm's with out such options \n \
    like: openbox, wmaker, mwm, ...etc ${reset}\n\n \
    ${underline}Usage${end_underline}: ${blue}$(basename ${BASH_SOURCE[0]})${reset} & from a terminal or your startup scripts.\n\n \
    Options may be: \n \
    ${blue}$(basename ${BASH_SOURCE[0]})${reset} ${magenta}add${reset} ${yellow}path1${reset} [${yellow}path2${reset} ...] - add director(y/ies) \n \
    ${blue}$(basename ${BASH_SOURCE[0]})${reset} ${magenta}rem${reset} ${yellow}path1${reset} [${yellow}path2${reset} ...] - remove director(y/ies) \n \
    ${blue}$(basename ${BASH_SOURCE[0]})${reset} ${magenta}delay${reset} ${yellow}1440${reset} - set interval (in minutes) \n \
    ${blue}$(basename ${BASH_SOURCE[0]})${reset} ${magenta}replay${reset} [${yellow}3${reset}] - display previous image # \n \
    ${blue}$(basename ${BASH_SOURCE[0]})${reset} ${magenta}help${reset} - this message \n \
    ${blue}$(basename ${BASH_SOURCE[0]})${reset} without options will start rotating images.\n\n"

declare -a FEH=( "feh" "--bg-scale" ) WMSETBG=( "wmsetbg" ) FVWM_ROOT=( "fvwm-root" ) \
        FBSETBG=( "fbsetbg" ) BSETBG=( "bsetbg" ) HSETROOT=( "hsetroot" "-fill" ) XSETBG=( "xsetbg" )

declare -a BGSRS=( FEH[@] WMSETBG[@] FVWM_ROOT[@] FBSETBG[@] BSETBG[@] HSETROOT[@] XSETBG[@] )

declare WPRC="${HOME}/.$(basename ${BASH_SOURCE[0]}).rc" WPLG="${HOME}/.$(basename ${BASH_SOURCE[0]}).log"

declare BGSR="" WAIT="2m" LS=$(which ls 2> /dev/null)

declare -a DIRS=( "${HOME}/Pictures" ) WPS=()

# bash version info check
if (( "${BASH_VERSINFO[0]}" < 4 )); then
  printf "${red}Error:${reset} For this to work properly you'll need bash major version greater than 4.\n" >&2
  exit 1
fi

# Find a setter
for (( x = 0; x < "${#BGSRS[@]}"; x++ )); do
  if [[ -n $(which "${!BGSRS[$x]:0:1}" 2> /dev/null) ]]; then
    BGSR="${x}"
    break # Break on first match.
  fi
done

# Quit on no setter
if [[ -z "${BGSR}" ]]; then
  printf "%s\n" "${WPUSAGE}"
  printf "\n\n ${red}Error:${reset} No valid wallpaper setter found. Install \"${bold}feh${reset}\" and try again.\n" >&2
  exit 1
fi

# If there's no readable settings file, write it...
if [[ ! -r "${WPRC}" ]]; then
  printf "WAIT=${WAIT}\nDIRS=( ${DIRS[@]} )\n" > "${WPRC}"
fi

# and read it.
source "${WPRC}"

# If options, proccess, else rotate things
if [[ -n "${1}" ]]; then
  case "${1}" in
    "add")
      shift
      while [[ -n "${1}" ]]; do
        if [[ -d "${1}" ]]; then
          DIRS+=( "${1}" )
        else
          printf "${yellow}Warning:${reset} %s is not a directory.\n" "${1}" >&2
        fi
        shift
      done
      # https://stackoverflow.com/questions/525592/find-and-replace-inside-a-text-file-from-a-bash-command
      sv="DIRS" rv="DIRS=( ${DIRS[@]} )"
      sed --follow-symlinks -i "s|^${sv}.*|${rv}|g" "${WPRC}" ;;
    "rem")
      shift
      while [[ -n "${1}" ]]; do
        for (( i = 0; i < "${#DIRS[@]}"; i++ )); do
          if [[ "${DIRS[${i}]}" == "${1}" ]]; then
            unset 'DIRS[i]'
          fi
        done
        shift
      done
      sv="DIRS"
      rv="DIRS=( ${DIRS[@]} )"
      sed --follow-symlinks -i "s|^${sv}.*|${rv}|g" "${WPRC}" ;;
    "delay")
      shift
      # https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash
      if [[ "${1}" =~ ^[0-9]+$ ]]; then
        sv="WAIT" rv="WAIT=${1}m"
        sed --follow-symlinks -i "s|^${sv}.*|${rv}|g" "${WPRC}"
      else
        printf "${yellow}Warning:${reset} %s is not a valid time construct.\nProvide an integer as interval in minutes\n" "${1}" >&2
      fi ;;
    "replay")
      shift
      tail -n ${1:-1} "${WPLG}" |head -n 1|awk '{print $NF}' ;;
    *)
      printf "${WPUSAGE}" ;;
  esac
else

  # Reset log
  printf '' > "${WPLG}"

  while :; do

    # re-read rc (to pick up config updates).
    source "${WPRC}"

    # fill a WallPaperS list
    for D in "${DIRS[@]}"; do
      for P in $("${LS}" -1 "${D}"); do
        FN="${D}/${P}" FE="${P:(-4)}"
        if [[ -f "${FN}" ]] && [[ "${FE,,}" == ".jpg" || "${FE,,}" == ".png" ]]; then
          WPS+=( "${FN}" )
        fi
      done
    done

    # limit a random number to upper array bounds as a RundomNumber
    # let "RN = ${RANDOM} % ${#WPS[@]}"
    RN=$(shuf -n 1 -i 0-"${#WPS[@]}")

    # Get path and name of image as a selected WallPaper
    WP="${WPS[$RN]}"

    # set wallpaper, log, wait
    "${!BGSRS[$BGSR]}" "${WP}"

    # Skip log and sleep if selected img won't work.
    (( ${?} != 0 )) && continue

    printf "%s %s %s\n" "$(date +%y%m%d-%H%M%S)" "${!BGSRS[$BGSR]:0:1}" "${WP}" >> "${WPLG}"
    sleep "${WAIT}"
  done
fi
