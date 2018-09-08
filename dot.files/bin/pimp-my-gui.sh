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

# Work around conky versions (pre/post 1.9)
#source /etc/os-release

# Monitor your box
custom_run 19 conky -c /home/paperjam/git/lib-bash/conky.configs/conky_configs/min_clock/conkyrc >> /dev/null 2>&1

# XScreenSaver
custom_run 19 xscreensaver -no-splash

# A calendar app
custom_run 19 orage

# Networking # Python gui
nice -n 19 wicd-gtk -t &

# Start a terminal
nice -n 9 terminology &

# Start a terminal
# nice -n 9 xfce4-terminal --disable-server &

# Start a Menu # Python based gui
nice -n 9 ${HOME}/bin/TkRootMenu &

# Add some wallpaper variety for your desktop
"${HOME}/bin/wallpaper-rotate.sh" &
