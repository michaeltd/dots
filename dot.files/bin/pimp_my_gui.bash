#!/usr/bin/env bash
#
# ~/bin/pimp-my-gui.sh
# Spice for the desktop
#shellcheck source=/dev/null

# No double sourcing
[[ ! $(command -v rcm) ]] && source ~/.bashrc.d/functions.bash

# Run emacs
# rcm 0 emacs --daemon

# Xfce4 themes
rcm 9 xfsettingsd --no-daemon --disable-server --no-desktop --sm-client-disable

# XScreenSaver
rcm 9 xscreensaver -no-splash

# Add some wallpaper variety for your desktop
rcm 9 ~/bin/wallpaper_rotate.bash

# rcm 9 gdutils

# Per distro setup.
source /etc/os-release
if [[ "${ID}" == "gentoo" ]]; then
    rcm 9 conky -qd
elif [[ "${ID}" == "devuan" ]]; then
    rcm 9 conky -qd
else
    rcm 9 conky -qd
fi
