#!/bin/bash

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
  if [ -f "$1" ] ; then
    case "$1" in
      *.7z.7za) 7z "$1" ;;
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz) tar xzf "$1" ;;
      *.tar.Z) tar xzf "$1" ;;
      *.tar.z) tar xzf "$1" ;;
      *.tar.xz) tar Jxf "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.rar) unrar x "$1" ;;
      *.gz) gunzip "$1" ;;
      *.jar) unzip "$1" ;;
      *.tar) tar xf "$1" ;;
      *.tbz2) tar xjf "$1" ;;
      *.tgz) tar xzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.Z) uncompress "$1" ;;
      *) echo "'$1' cannot be extracted." ;;
    esac
  else
    echo "'$1' is not a file."
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
  PI=${1-"2"}
  import -pause ${PI} -window root ~/Pictures/imagemagic-`date +%y%m%d%H%M%S`.png
}
