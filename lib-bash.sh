#!/bin/bash

function helloWorld {
  echo -n "Give me a Name:"
  read name
  echo "Hello ${name}"
}

function accuWeather {

  URL='http://www.accuweather.com/en/gr/athens/182536/weather-forecast/182536' 

  wget -q -O- "$URL" | awk -F\' '/acm_RecentLocationsCarousel\.push/{print $2": "$16", "$12"°" }'| head -1

}

function wttr {

  if [ -z "$1" ]; then
    curl wttr.in/Athens
  else
    curl wttr.in/"$1"
  fi

}

function mtleb {
  # https://wiki.gentoo.org/wiki/Project:Proxy_Maintainers/
  fgrep -l maintainer-needed /usr/portage/*/*/metadata.xml |cut -d/ -f4-5 |fgrep -x -f <(EIX_LIMIT=0 eix -I --only-names)
}

function runCmd {
  
  DIALOG=${1-"Xdialog"}

  TMPFILE="/tmp/input.box.txt"

  $DIALOG --title "Command Input" \
        --default-button "ok" \
  	--inputbox "Enter command to continue" \
  	10 40 \
  	command 2> $TMPFILE

  RETVAL=$? #Exit code

  USRINPUT=$(cat ${TMPFILE})

  $USRINPUT

}

function keepParamAlive {
# Take a parameter and respawn it periodicaly if it crashes. check interval is second param seconds
  while [ true ]; do       # Endless loop.
    pid=`pgrep -x ${1}`    # Get a pid.
    if [[ -z $pid ]]; then # If there is no proc associated with it,
      ${1} &               # Start Param to background.
    else                   # else, 
      sleep ${2-"60"}      # wait 2nd parameters seconds
    fi
  done
}

function lol {
# Pipe furtune or second param throu cowsay and lolcat for some color magic
# requires fortune cowsay lolcat
  file=${1-"tux"}

  if [[ -z "${2}" ]]; then
    cmmnd="fortune"
  else
    cmmnd="echo -e ${2}"
  fi
  $cmmnd |cowsay -f $file |lolcat
}

# For use with WindowMaker
# Replace "${APPS}" list with your desired applets.
function startApps {
                                           # Fill a list with the applets you need
  APPS="wmfire wmclockmon wmsystray wmMatrix wmbinclock wmbutton wmifinfo wmnd wmmon wmcpuload wmsysmon wmmemload wmacpi wmtime wmcalc wmSpaceWeather wmudmount wmmp3"
  for APP in $APPS ; do
    killall $APP                           # WM restarts do happen you know ...
    $APP &
  done
}

# For use with WindowMaker
# Run this to update your Root menu to reflect themes or apps changes
function regenMenu {
					   # Backup Root menu
  cp ~/GNUstep/Defaults/WMRootMenu ~/GNUstep/Defaults/`date +%y%m%d%H%M%S`WMRootMenu
                                           # Write new menu
  wmgenmenu > ~/GNUstep/Defaults/WMRootMenu

}

# Script to give one comand to extract any kind of file
# from https://www.facebook.com/TekNinjakevin
function deflateThat {
  if [[ -r "${1}" ]] ; then
    case "${1}" in
      *.7z.7za) 7z "${1}" ;;
      *.tar.bz2) tar xjf "${1}" ;;
      *.tar.gz) tar xzf "${1}" ;;
      *.tar.Z) tar xzf "${1}" ;;
      *.tar.z) tar xzf "${1}" ;;
      *.tar.xz) tar Jxf "${1}" ;;
      *.bz2) bunzip2 "${1}" ;;
      *.rar) unrar x "${1}" ;;
      *.gz) gunzip "${1}" ;;
      *.jar) unzip "${1}" ;;
      *.tar) tar xf "${1}" ;;
      *.tbz2) tar xjf "${1}" ;;
      *.tgz) tar xzf "${1}" ;;
      *.zip) unzip "${1}" ;;
      *.Z) uncompress "${1}" ;;
      *) echo "'${1}' cannot be extracted." ;;
    esac
  else
    echo "'${1}' is not readable."
  fi
}

function showUptime {
  echo -ne "${green}$HOSTNAME ${green}uptime is ${green} \t ";uptime | awk /'up/ {print $3,$4,$5,$6,$7,$8,$9,$10}'
}

# Call that to logout
function logMeOut {
  kill -15 -1
}

# Take a screenshot imagemagic
function imageMagicScreenShot {
# Requires Imagemagic Viewnior
  PI=${1-"2"}
  FN="/home/${USER}/Pictures/imagemagic-`date +%y%m%d%H%M%S`.png"
  import -pause $PI -window root $FN
  viewnior $FN
}
