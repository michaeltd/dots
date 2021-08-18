#!/usr/bin/env -S bash --norc --noprofile
#shellcheck shell=bash source=/dev/null disable=SC1008,SC2096,SC2155
#
# Spice for the desktop

#link free (S)cript: (D)ir(N)ame, (B)ase(N)ame.
readonly sdn="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# No double sourcing
type -t rcm &>/dev/null || source "${sdn}"/../../.bashrc.d/functions.bash

# Read trough '~/.config/autostart' entries
for i in ~/.config/autostart/*.desktop; do
    cat "${i}" | while read -r line; do
	if [[ "${line}" =~ ^Exec ]]; then
	    declare -a myprog=( ${line##Exec=} )
	    rcm 9 "${myprog[@]}"
	    continue
	fi
    done
done

unames="$(uname -s)"

if [[ "${unames}" == "Gentoo" ]]; then
    rcm 9 conky -qd
    # rcm 9 electrum daemon start
    # rcm 9 bitcoind -datadir=/mnt/el/.bitcoin -daemon -server
elif [[ "${unames}" == "Devuan" ]]; then
    rcm 9 conky -qd
elif [[ "${unames}" == "Debian" ]]; then
    rcm 9 conky -qd
elif [[ "${unames}" == "FreeBSD" ]]; then
    rcm 9 conky -qd
else
    rcm 9 conky -qd
fi

unset unames

# Xfce4 themes
# rcm 9 xfsettingsd --no-daemon --disable-server --no-desktop --sm-client-disable

# XScreenSaver
# rcm 9 xscreensaver -no-splash

# Systray network manager applet || wicd-gtk -t
# if type -P nm-applet &> /dev/null; then
#     rcm 9 nm-applet
# elif type -P wicd-gtk &> /dev/null; then
#     rcm 9 wicd-gtk -t
# fi
