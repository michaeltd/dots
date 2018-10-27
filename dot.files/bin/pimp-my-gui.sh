#!/usr/bin/env bash
#
# ~/bin/pimp-my-gui
# Spice for my desktop

# Run things in the background with custom niceness and cli switches in a mutex kind of way
# Usage : custom_run niceness executable command line arguments
function custom_run {
  bin=$(which "${2}")
  pid=$(pidof "${2}")
  if [[ -z "${pid}" && -x "${bin}" ]]; then
    nice -n "${@}" &
  fi
}

# Start an X11 compositor
# custom_run 19 compton

# XScreenSaver
custom_run 9 xscreensaver -no-splash

# A calendar app
custom_run 9 orage

# Networking Python gui
nice -n 9 wicd-gtk -t &

# Per WM customizations
# WM=$(which wmaker||which openbox-session||which jwm||which mwm||which compiz.sh||which starte16||which enlightenment_start||which xfce4-session||which kodi-standalone)
# xprop -id $(xprop -root -notype | awk '$1=="_NET_SUPPORTING_WM_CHECK:"{print $5}') -notype -f _NET_WM_NAME 8t
# ps -A | egrep -i "gnome|kde|mate|cinnamon|lx|xfce|jwm"

id="$(xprop -root -notype _NET_SUPPORTING_WM_CHECK)"
id="${id##* }"
wm="$(xprop -id "$id" -notype -len 100 -f _NET_WM_NAME 8t)"
wm="${wm/*WM_NAME = }"
wm="${wm/\"}"
wm="${wm/\"*}"

if [[ "${wm}" =~ "wmaker" || "${wm}" =~ "awesome" || "${wm}" =~ "Openbox" || "${wm}" =~ "jwm" || "${wm}" =~ "mwm" ]]; then
  # echo "compton for transparency" >> ~/"${wm}".txt &
  printf "\n"
elif [[ "${wm}" =~ "compiz" || "${wm}" =~ "e16" || "${wm}" =~ "enlightenment" || "${wm}" =~ "xfce4" ]]; then
  # echo "no need for compton here" >> ~/"${wm}".txt &
  printf "\n"
else
  # echo dunnowhatyouwantfromme >> ~/"${wm}".txt &
  printf "\n"
fi

# Per distro setup.
source /etc/os-release
if [[ "${ID}" == "gentoo" ]]; then
  custom_run 9 terminology
  custom_run 9 conky -qdc ~/.conky/cronoconky/cronograph_blk/cronorc
elif [[ "${ID}" == "devuan" ]]; then
  custom_run 9 xfce4-terminal --disable-server
  custom_run 9 conky -qd
else
  custom_run 9 xterm
  custom_run 9 conky -qd
fi

# Start a Menu
nice -n 9 ${HOME}/bin/TkRootMenu &

# Add some wallpaper variety for your desktop
${HOME}/bin/wallpaper-rotate.sh &

# Run emacs
custom_run 0 emacs --daemon

# Run mpd
custom_run 0 mpd
