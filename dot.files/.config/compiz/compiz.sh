#!/bin/sh
#
# ~/sbin/compiz.sh Compiz startup script.

# No double sourcing
[[ ! $(command -v rcm) ]] && source ~/.bashrc.d/functions.sh

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
    # compiz-manager --replace &
    compiz --replace "$@" &
    fusion-icon & ;;
esac

# ~/.config/polybar/launch.sh
# polybar example 2> /dev/null &
# polybar -qr topbar 2> /dev/null &
# ~/.config/polybar/launch.sh

rcm 9 tint2 -c ~/.config/tint2/panel
# nice -n 9 tint2 -c ~/.config/tint2/taskbar

PMG="${HOME}/bin/pimp-my-gui.sh"
if [ -x "${PMG}" ]; then # If spice ...
  "${PMG}" & # ... spice things up
fi

sleep 999d # Wait
