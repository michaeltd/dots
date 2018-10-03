#!/usr/bin/env bash
#
# ~/sbin/compiz.sh
# Compiz startup script

source /etc/os-release # Distro details.

case "${ID}" in # Start Compiz
  gentoo) # Gentoo Solution
    /usr/bin/compiz-manager & ;;
  devuan) # Devuan solution
    compiz &
    fusion-icon & ;;
  *) # Others
    # emerald --replace &
    # compiz --replace "$@" &
    compiz --replace &
    fusion-icon & ;;
esac

tint2 & # A nice status bar (before gui as we'll need that tray)

pmg="${HOME}/bin/pimp-my-gui.sh"
if [[ -x "${pmg}" ]]; then # If spice ...
  "${pmg}" & # ... spice things up
fi

sleep 999d # Wait
