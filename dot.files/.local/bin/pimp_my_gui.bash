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

# Per distro startup.
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
    elif [[ "${ID}" == "freebsd" ]]; then
	rcm 9 conky -qd
    else
	rcm 9 conky -qd
    fi
    # Clean up temp sources (source /etc/os-release)
    unset NAME VERSION VERSION_ID ID ANSI_COLOR PRETTY_NAME CPE_NAME HOME_URL BUG_REPORT_URL
fi

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
