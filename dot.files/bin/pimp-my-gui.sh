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

# id="$(xprop -root -notype _NET_SUPPORTING_WM_CHECK)"
# id="${id##* }"
# wm="$(xprop -id "$id" -notype -len 100 -f _NET_WM_NAME 8t)"
# wm="${wm/*WM_NAME = }"
# wm="${wm/\"}"
# wm="${wm/\"*}"

# if [[ "${wm}" =~ "wmaker" || "${wm}" =~ "awesome" || "${wm}" =~ "Openbox" || "${wm}" =~ "jwm" || "${wm}" =~ "mwm" ]]; then
#   # echo "compton for transparency" >> ~/"${wm}".txt &
#   printf "\n"
# elif [[ "${wm}" =~ "compiz" || "${wm}" =~ "e16" || "${wm}" =~ "enlightenment" || "${wm}" =~ "xfce4" ]]; then
#   # echo "no need for compton here" >> ~/"${wm}".txt &
#   printf "\n"
# else
#   # echo dunnowhatyouwantfromme >> ~/"${wm}".txt &
#   printf "\n"
# fi

# Per distro setup.
source /etc/os-release
if [[ "${ID}" == "gentoo" ]]; then
  custom_run 9 terminology
  # nice -n 9 conky -c ~/.conky/cronoconky/cronograph_blk/cronorc &> ~/conky.log
  # ${HOME}/.conky/cronoconky/cronograph_blk/crono.sh start &
  # custom_run 9 conky -qdc ~/.conky/minimalism/conkyrc &> /dev/null
  custom_run 9 conky -qdc ~/.conky/LSD_4/.conkyrc

  #!/bin/bash
  # resizes the window to full height and 50% width and moves into upper right corner
  #define the height in px of the top system-bar:
  #TOPMARGIN=128
  #sum in px of all horizontal borders:
  #RIGHTMARGIN=128
  # get width of screen and height of screen
  #SCREEN_WIDTH=$(xwininfo -root | awk '$1=="Width:" {print $2}')
  #SCREEN_HEIGHT=$(xwininfo -root | awk '$1=="Height:" {print $2}')
  # new width and height
  # W=$(( $SCREEN_WIDTH / 2 - $RIGHTMARGIN ))
  # H=$(( $SCREEN_HEIGHT - 2 * $TOPMARGIN ))
  #zenity --entry --ok-label=sure --width=$W --height=$H
  # new width and height
  #W=$(( $SCREEN_WIDTH - $RIGHTMARGIN * 2 ))
  #H=$TOPMARGIN # $(( $SCREEN_HEIGHT - 2 * $TOPMARGIN ))
  # terminology -g 10x7+${W}+${H} -e peaclock &
elif [[ "${ID}" == "devuan" ]]; then
  custom_run 9 xfce4-terminal --disable-server
  custom_run 9 conky -qd
else
  custom_run 9 xterm
  custom_run 9 conky -qd
fi

# Start a Menu
nice -n 9 ${HOME}/bin/tkrm.sh &

# Add some wallpaper variety for your desktop
${HOME}/bin/wallpaper-rotate.sh &

# Run emacs
custom_run 0 emacs --daemon

# Run mpd
custom_run 0 mpd
