#!/bin/bash
#
# Spice for the desktop
#shellcheck source=/dev/null

# No double sourcing
command -v rcm &>/dev/null || source ~/.bashrc.d/30_functions.bash

# Music daemon
# rcm 0 mpd

# Run emacs
# rcm 0 emacs --daemon

# Xfce4 themes
rcm 9 xfsettingsd --no-daemon --disable-server --no-desktop --sm-client-disable

# XScreenSaver
rcm 9 xscreensaver -no-splash

# Add some wallpaper variety for your desktop
rcm 9 ~/bin/wallpaper_rotate.bash

# Systray volume control
rcm 9 pasystray

# Systray network manager applet || wicd-gtk -t
if command -v nm-applet &>/dev/null; then
    rcm 9 nm-applet
elif command -v wicd-gtk &>/dev/null; then
    rcm 9 wicd-gtk -t
fi

# Per distro setup.
if [[ -r "/etc/os-release" ]]; then 
    source /etc/os-release
    if [[ "${ID}" == "gentoo" ]]; then
	rcm 9 conky -qd
	# rcm 9 electrum daemon start -w ~/.electrum/wallets/default_wallet
    elif [[ "${ID}" == "devuan" ]]; then
	rcm 9 conky -qd
    elif [[ "${ID}" == "debian" ]]; then
	rcm 9 conky -qd
    else
	rcm 9 conky -qd
    fi
fi
