#!/bin/sh
#
# /usr/local/bin/compiz.sh Compiz startup script.

# No double sourcing
[[ ! $(command -v rcm) ]] && source ~/.bashrc.d/functions.sh

source /etc/os-release # Distro details.
case "${ID}" in # Start Compiz
  "gentoo") # Gentoo Solution
    #/usr/bin/compiz-manager & ;;
    fusion-icon -f & ;;
  "devuan") # Devuan solution
    compiz --replace "${@}" & ;;
  *) # Others
    # emerald --replace &
    # compiz-manager --replace &
    compiz --replace "${@}" & ;;
esac

# ~/.config/polybar/launch.sh
# polybar example 2> /dev/null &
# polybar -qr topbar 2> /dev/null &
# ~/.config/polybar/launch.sh

# rcm 0 compiz-boxmenu-daemon

rcm 9 tint2 -c ~/.config/tint2/panel

#nice -n 9 tint2 -c ~/.config/tint2/taskbar &

# rcm 9 wicd-gtk -t

# rcm 9 pasystray -m 100

PMG="${HOME}/bin/pimp_my_gui.bash"
if [ -x "${PMG}" ]; then # If spice ...
  "${PMG}" & # ... spice things up
fi

sleep 999d # Wait
