#!/bin/bash
#shellcheck shell=bash disable=SC1008,SC2096,SC2155
#
# Spice for the desktop
#shellcheck source=/dev/null

#link free (S)cript: (D)ir(N)ame, (B)ase(N)ame.
readonly sdn="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# No double sourcing
type -t rcm &>/dev/null || source "${sdn}"/../../.bashrc.d/*functions*.bash

# Music daemon
# rcm 0 mpd

# Run emacs
# rcm 0 emacs --daemon

# Xfce4 themes
rcm 9 xfsettingsd --no-daemon --disable-server --no-desktop --sm-client-disable

# XScreenSaver
rcm 9 xscreensaver -no-splash

# Add some wallpaper variety for your desktop
#rcm 9 "${HOME}/.local/bin/wallpaper_rotate.bash"
srwpi

# Systray volume control
rcm 9 pasystray

# Systray network manager applet || wicd-gtk -t
if type -P nm-applet &>/dev/null; then
    rcm 9 nm-applet
elif type -P wicd-gtk &>/dev/null; then
    rcm 9 wicd-gtk -t
fi

# Per distro setup.
if [[ -r "/etc/os-release" ]]; then 
    source /etc/os-release
    if [[ "${ID}" == "gentoo" ]]; then
	rcm 9 conky -qd
	# rcm 9 electrum daemon start
	# rcm 9 bitcoind -datadir=/mnt/el/.bitcoin -daemon -server
    elif [[ "${ID}" == "devuan" ]]; then
	rcm 9 conky -qd
    elif [[ "${ID}" == "debian" ]]; then
	rcm 9 conky -qd
    else
	rcm 9 conky -qd
    fi
fi
