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

# Start a terminal
# Monitor your box
source /etc/os-release
if [[ "${ID}" == "gentoo" ]]; then
  custom_run 9 terminology
  nice -n 9 ~/.conky/cronoconky/cronograph_blk/start_crono.sh &
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
custom_run 9 emacs --daemon
