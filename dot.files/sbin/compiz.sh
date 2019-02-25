#!/usr/bin/env bash
#
# ~/sbin/compiz.sh Compiz startup script.

source /etc/os-release # Distro details.
case "${ID}" in # Start Compiz
  "gentoo") # Gentoo Solution
    # /usr/bin/compiz-manager &
    fusion-icon & ;;
  "devuan") # Devuan solution
    compiz &
    fusion-icon & ;;
  *) # Others
    # emerald --replace &
    # compiz --replace "$@" &
    compiz --replace &
    fusion-icon & ;;
esac

nice -n 9 tint2 & # A nice status bar (before gui as we'll need that tray)
# nice -n 9 tint2 -c ~/.config/tint2/bottom.panel &

# ~/.config/polybar/launch.sh
# polybar example 2> /dev/null &
# polybar -qr topbar 2> /dev/null &
# ~/.config/polybar/launch.sh

pmg="${HOME}/bin/pimp-my-gui.sh"
if [[ -x "${pmg}" ]]; then # If spice ...
  "${pmg}" & # ... spice things up
fi

sleep 999d # Wait
