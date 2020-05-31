#!/bin/sh
#
# ~/bin/pimp-my-gui.bash
# Spice for the desktop
#shellcheck source=/dev/null

# No double sourcing
type rcm 2>/dev/null || . ~/.bashrc.d/30_functions.bash

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
# rcm 9 pasystray

# Systray network manager applet
rcm 9 nm-applet

if [ -r "/etc/os-release" ]; then 
    # Per distro setup.
    . /etc/os-release
    if [ "${ID}" = "gentoo" ]; then
	rcm 9 conky -qd
    elif [ "${ID}" = "devuan" ]; then
	rcm 9 conky -qd
    else
	rcm 9 conky -qd
    fi
fi
