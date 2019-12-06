#!/bin/bash
#
# ~/bin/pimp-my-gui.sh
# Spice for the desktop
#shellcheck source=/dev/null

# No double sourcing
[[ ! $(command -v rcm) ]] && source ~/.bashrc.d/functions.sh

# Run emacs
rcm 0 emacs --daemon

# Xfce4 themes
rcm 9 xfsettingsd --no-daemon --disable-server --no-desktop --sm-client-disable

# XScreenSaver
rcm 9 xscreensaver -no-splash

# Add some wallpaper variety for your desktop
rcm 9 ~/bin/wallpaper_rotate.sh

# Per distro setup.
source /etc/os-release
if [ "${ID}" == "gentoo" ]; then
  rcm 9 terminology
  rcm 9 conky -qd
  rcm 9 gtkrm.sh
elif [ "${ID}" == "devuan" ]; then
  rcm 9 xfce4-terminal --disable-server
  rcm 9 conky -qd
else
  rcm 9 xterm
  rcm 9 conky -qd
fi
