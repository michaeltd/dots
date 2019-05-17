#!/bin/sh
#
# ~/bin/pimp-my-gui.sh
# Spice for the desktop

# No double sourcing
[[ ! $(command -v rcm) ]] && source ~/.bashrc.d/functions.sh

# Per distro setup.
source /etc/os-release
if [ "${ID}" == "gentoo" ]; then
  # rcm 9 conky -qdc ~/.conky/shailen.conf
  sleep 2 && rcm 9 conky -qdc ~/.conky/seamod/.conkyrc
elif [ "${ID}" == "devuan" ]; then
  rcm 9 xfce4-terminal --disable-server
  rcm 9 conky -qd
else
  rcm 9 xterm
  rcm 9 conky -qd
fi

# XScreenSaver
rcm 9 xscreensaver -no-splash

# Add some wallpaper variety for your desktop
rcm 9 ~/bin/wallpaper-rotate.sh

# Run emacs
rcm 0 emacs --daemon

# Run mpd
rcm 0 mpd

# Xfce4 themes
rcm 9 xfsettingsd --replace --no-daemon

# Systray volumeicon
#rcm 9 volumeicon

# A calendar app
rcm 9 orage

# Networking Python gui
#rcm 9 wicd-gtk -t

# bashrun
# rcm 9 bashrun --restart

# Start a Menu
#rcm 9 ~/git/pythonRootMenu/TkRootMenu.py
