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
if [[ "${ID}" == "devuan" ]]; then
  custom_run 9 xfce4-terminal --disable-server
  custom_run 9 conky >> /dev/null 2>&1
else
  # conky -c "${HOME}/git/dots/conky.configs/conky_configs/min_clock/conkyrc" >> /dev/null 2>&1 &
  # conky -c "${HOME}/git/dots/conky.configs/conky-horizontal-minimalist/conkyrc" >> /dev/null 2>&1 &
  # custom_run 19 conky -c "${HOME}/git/dots/conky.configs/old/qlock"
  custom_run 9 terminology &
  # custom_run 9 conky -c "${HOME}/git/dots/conky.configs/conky_configs/min_clock/conkyrc" >> /dev/null 2>&1
  # custom_run 9 conky -c "${HOME}/.conky/cronograph/conkyrc"
  nice -n 9 ~/.conky/cronoconky/cronograph_blk/start_crono.sh &
  #custom_run 0 conky >> /dev/null 2>&1
fi

# Start a Menu
nice -n 9 ${HOME}/bin/TkRootMenu &

# Add some wallpaper variety for your desktop
${HOME}/bin/wallpaper-rotate.sh &
