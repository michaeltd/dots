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

# Networking # Python gui
nice -n 9 wicd-gtk -t &

# Per WM customizations
# WM=$(which wmaker||which openbox-session||which jwm||which mwm||which compiz.sh||which starte16||which enlightenment_start||which xfce4-session||which kodi-standalone)
# xprop -id $(xprop -root -notype | awk '$1=="_NET_SUPPORTING_WM_CHECK:"{print $5}') -notype -f _NET_WM_NAME 8t
# ps -A | egrep -i "gnome|kde|mate|cinnamon|lx|xfce|jwm"
if [[ -n "$(pidof wmaker)" ]]; then
    echo wmaker >> ~/wmaker.txt &
elif [[ -n "$(pidof awesome)" ]]; then
    echo awesome >> ~/awesome.txt &
elif [[ -n "$(pidof openbox)" ]]; then
    echo openbox >> ~/openbox.txt &
elif [[ -n "$(pidof jwm)" ]]; then
    echo jwm >> ~/jwm.txt &
elif [[ -n "$(pidof mwm)" ]]; then
    echo mwm >> ~/mwm.txt &
elif [[ -n "$(pidof compiz)" ]]; then
    echo compiz >> ~/compiz.txt &
elif [[ -n "$(pidof starte16)" ]]; then
    echo e16 >> ~/e16.txt &
elif [[ -n "$(pidof enlightenment)" ]]; then
    echo enlight >> ~/ enlight.txt &
elif [[ -n "$(pidof xfce4)" ]]; then
    echo xfce4 >> ~/xfce4.txt &
else
    echo dunnowhatyouwantfromme >> dunno.txt &
fi

# Start a terminal
# Monitor your box
source /etc/os-release
if [[ "${ID}" == "gentoo" ]]; then
  custom_run 9 terminology
  # nice -n 9 ~/.conky/cronoconky/cronograph_blk/start_crono.sh &
  custom_run 9 conky -c ~/.conky/cronoconky/cronograph_blk/cronorc
  # custom_run 9 conky -c ~/git/dots/conky.configs/alltimeclassics/cronoconky/cronograph_blk/cronorc
elif [[ "${ID}" == "devuan" ]]; then
  custom_run 9 xfce4-terminal --disable-server
  custom_run 9 conky >> /dev/null 2>&1
else
  custom_run 9 xterm
  custom_run 9 conky >> /dev/null 2>&1
fi

# Start a Menu
nice -n 9 ${HOME}/bin/TkRootMenu &

# Add some wallpaper variety for your desktop
${HOME}/bin/wallpaper-rotate.sh &

# Run emacs
custom_run 0 emacs --daemon

export >> "/home/paperjam/pimp-my-gui.export.at.txt" &
